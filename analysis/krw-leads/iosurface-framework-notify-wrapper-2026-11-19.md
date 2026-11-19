# IOSurface.framework notify wrapper ABI — recovered from the shared cache

Date: 2026-11-19
Target build: 24A446 (`firmware/24A446/kernelcache.release.macho`), member
`com.apple.iokit.IOSurface`; framework binary
`tools/opencode-temp/f1-iosurface/dsc/IOSurface` (arm64e, from the iOS 27.0.1
dyld shared cache, `__TEXT` vmaddr `0x1c2844000`).
Raw output: `analysis/evidence/iosurface-framework-abi-2026-11-19/framework-wrapper-disasm.txt`.

**No device cycle.** The macOS build host dropped off Tailscale mid-run
(`NoState`, coordination server unreachable) and the carrier build/install
could not be executed. Everything here is binary reading, marked proven or
inferred.

This is the independent second source for
`analysis/krw-leads/iosurface-notify-abi-race-window-2026-11-19.md`: the kext
thunk said what selector `0x11` wants; the framework wrapper shows what the
shipped caller actually passes. They agree.

---

## 1. The two private symbols

| symbol | VA |
|---|---|
| `_IOSurfaceClientSetSurfaceNotify` | `0x1c284a6e8` |
| `_IOSurfaceClientRemoveSurfaceNotify` | `0x1c2851390` |
| `__ioSurfaceConnectInternal` (cached connection getter) | `0x1c28458c4` |
| `__ioSurfaceConnect` | `0x1c284a970` |

`_IOConnectCallMethod` / `_IOConnectCallAsyncMethod` appear in the symbol table
as undefined imports (type `0x1`), so the wrapper really does call the IOKit
MIG routines rather than an inlined copy.

## 2. Setter — proven instruction by instruction

```asm
1c284a6fc  mov  x19, x0              ; x19 = arg0 (the notify mach_port_t)
1c284a71c  stp  x2, xzr, [sp,#0x30]  ; structIn[1] = arg2 , structIn[2] = 0
1c284a720  str  x1, [sp,#0x28]       ; structIn[0] = arg1
1c284a724  stp  x1, x2, [sp,#0x48]   ; reference[1] = arg1 , reference[2] = arg2
1c284a714  stp  q0, q0, [sp,#0x40]  ; reference[0] = 0
1c284a72c  bl   __ioSurfaceConnectInternal(0)   ; -> cached connection
1c284a740  str  x8, [sp]             ; x8 = 0x18 -> inputStructCnt
1c284a744  add  x3, sp, #0x40        ; reference
1c284a748  add  x7, sp, #0x28        ; inputStruct
1c284a74c  mov  w1, #0x11            ; selector 17
1c284a750  mov  x2, x19              ; wake port = arg0
1c284a754  mov  w4, #3               ; referenceCnt = 3
1c284a758  mov  x5, #0               ; scalar input = NULL
1c284a75c  mov  w6, #0               ; scalar input count = 0
1c284a760  bl   _IOConnectCallAsyncMethod
```

Proven shape (matches the kext thunk `0xfffffe000a3498f4` exactly):

* `IOConnectCallAsyncMethod(conn, 0x11, wake, reference={0, arg1, arg2}, 3,
  NULL, 0, structIn={arg1, arg2, 0}, 0x18, NULL, NULL, NULL, NULL)`
* `allowAsync` is required: the kernel reads `args->asyncReference` (`+0x10`)
  and rejects NULL with `0xE00002C2`.
* The node key is `structIn[1]`. With the working on-device argument order
  `set(port, type=1, surfaceID)` the key is the **surface id**, and
  `structIn[0]` is `1`.

## 3. Remover

```asm
1c28513b0  stp  xzr, x0, [sp,#0x10]  ; structIn = {0, arg0, 0}
1c28513c8  mov  w1, #0x12            ; selector 18
1c28513d4  mov  w5, #0x18            ; inputStructCnt
1c28513dc  mov  x7, #0
1c28513e0  bl   _IOConnectCallMethod ; synchronous
```

Key = `structIn[1]` = surface id, matching `removeByKey`'s
`input[1] == node->key && client == node->bound`.

## 4. The framework's connection is process-cached — new fact

`__ioSurfaceConnectInternal` takes its result from a `dispatch_once` token
(`0x1e7070f40`) and a cached return slot (`__iosConnectReturn`,
`0x1e7070ebc`). So **IOSurface.framework never closes the notifier user
client**: it opens one shared port per process and reuses it.

Consequence for reachability: the 27.2 teardown guard can only be exercised by
a process that owns a connection it later closes. That means the app must
`IOServiceOpen("IOSurfaceRoot", type 0)` itself and issue selectors `0x11` /
`0x12` on that port — the public framework entry points are useless for this.
The carrier mode added this run (`--ionotify`,
`carrier/AGXProbe/IOSurfaceRaceProbe.c`) does exactly that; it is written and
synced to the build host but was **not built or run** because the Mac went
unreachable.

## 5. Corrections / confirmations carried forward

* Confirms the earlier ABI note (`iosurface-notify-abi-race-window-2026-11-19.md`
  §3): `structureInput` is `{u64 +0, u64 +8 = key, u64 +0x10}`, only `+8`/`+0x10`
  consumed, async flavour mandatory. The framework additionally supplies a
  **3-element reference array** `{0, arg1, arg2}` whose first word XNU overwrites
  with the wake port.
* Explains the device observation in `IOSurfaceNotifyProbe.c` that
  `set(port, sid, 1)` leaves nothing removable while `set(port, 1, sid)` does:
  the key is `structIn[1]`, i.e. the **second** variadic argument.
* Selector `0x04` (`0xfffffe000a34932c` → `0xfffffe000a34beb0`) is a
  *lookup/attach*: it calls `lookupElement(client, scalarInput[0])`
  (`0xfffffe000a34f8cc`, bounds-checked against `[client+0x110]` over the array
  at `[client+0x108]`) and, on a miss, resolves
  `[client+0x118]` through `0xfffffe000a33c0b0`. Not needed for the panic path:
  `perRequestDispatch` takes `IOLockLock([node->bound + 0xd8])` **before** the
  lookup, so a stale bound pointer faults regardless of whether the client owns
  an element at the notification index.

## 6. Next step

Build `--ionotify` when the build host returns:

1. P1 — `IOServiceOpen("IOSurfaceRoot", type 0)` on our own connection;
   register/remove/register through raw selectors `0x11`/`0x12`; expect
   `0 / 0 / 0` if the ABI above holds on hardware.
2. P2 — register, `IOServiceClose`, reopen, re-register the same key. A
   duplicate (`0xE00002C9`) means the node survived `unlinkByObject` and the new
   client reused the freed address.
3. P3 — bounded close/register race plus an `IOSurfaceLock`/`IOSurfaceUnlock`
   trigger; secondary device only.

Reproduction:

```sh
python "$LOCALAPPDATA/hermes/cache/scratch/dsc_dump.py" \
        _IOSurfaceClientSetSurfaceNotify _IOSurfaceClientRemoveSurfaceNotify \
        __ioSurfaceConnectInternal
```
