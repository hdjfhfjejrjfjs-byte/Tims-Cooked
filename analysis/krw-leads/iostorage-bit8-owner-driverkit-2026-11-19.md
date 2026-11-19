# The IOStorageFamily bit-8 wrappers belong to `IOUserBlockStorageDevice` — a DriverKit dext class

Date: 2026-11-19
Builds: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, target) and
`firmware/24B119/kernelcache.release.macho` (iOS 27.2).
Raw output: `analysis/evidence/iostorage-bit8-owner-2026-11-19/`.
Previous state: `analysis/krw-leads/equal-count-member-sweep-iostorage-bit8-2026-11-19.md`
(16 inserted `and #~0x100` sites, owner unnamed).

**No device cycle.** Tailscale `NoState`, SSH to the build host times out, and the
PC-side usbmux endpoint (`127.0.0.1:27015`) enumerates zero devices
(`pymobiledevice3 usbmux list` → `[]`). Everything below is static reading of the
two kernelcaches on the PC, marked proven / inferred / unresolved.

---

## 1. What was open

The previous run proved that `com.apple.iokit.IOStorageFamily` gains **16**
`and x,x,#~0x100` sites between 24A446 and 24B119 — all sixteen the same inserted
statement inside per-cookie validation wrappers — but left three things
unresolved: the owning class, the object behind `[descriptor+0x18]`, and whether
any user-client selector reaches the wrapper family. Its stated next step was to
name the object via the table at `__DATA_CONST 0xfffffe0008375fa8` and walk to an
ingress. That is what this run does.

## 2. Result: the owner is `IOUserBlockStorageDevice`

### 2.1 The changed code sits at vtable slot 12 of one instance vtable (proven)

Chain, measured in both builds:

| step | 24A446 | 24B119 |
|---|---|---|
| mask site (one of 16) | counterpart `0xfffffe000a31f66c` (no clear) | `0xfffffe000a36da00` |
| its only caller (cookie dispatcher) | `0xfffffe000a31f3f4` | `0xfffffe000a36d7b4` |
| dispatcher's only caller (0x30-byte thunk) | `0xfffffe000a31f3c4` | `0xfffffe000a36d784` |
| thunk's auth-pointer slot | `0xfffffe0008375fa8` | `0xfffffe000838c858` |
| stored instance vptr | `0xfffffe0008375f48` | `0xfffffe000838c7f8` |
| slot index of the thunk | `(0x8375fa8-0x8375f48)/8 = 12` | `(0x838c858-0x838c7f8)/8 = 12` |

* `kz_blw_scan.py` gives exactly one direct `BL` at each hop, in
  `com.apple.iokit.IOStorageFamily`, both builds.
* `kz_member_vtable.py find` gives exactly one auth-pointer slot for the thunk,
  in both builds. The raw entry low halves are `0x0331b3c4` (24A446) and
  `0x03369784` (24B119), both with PAC signature `0x80119209` — the same
  discriminator, i.e. the same source-level slot.
* The vptr is read from the **code**, not inferred from a header: the instance
  constructors compute `adrp x16,#0x8375000 ; add x16,x16,#0xf38 ; add
  x16,x16,#0x10` (= `0xfffffe0008375f48`, 24A446) and the 24B119 counterparts
  compute `0xfffffe000838c7f8`. The two qwords before each base are
  `{0, 0}` (offset-to-top 0, typeinfo NULL), so the stored value really is the
  first slot, and slot 12 is `base + 0x60`.
* Both vtables have the destructor pair at slots 0/1
  (`0xa305eb4`/`0xa305ebc` in 24A446; `0xa354274`/`0xa35427c` in 24B119) and
  `getMetaClass` at slot 7 returning the class's own metaclass global
  (`0xb99cfc0` / `0xb9f5bd0`).

### 2.2 The class is named by the generated metaclass constructor (proven)

24A446, `0xfffffe000a307bdc`:

```asm
adrp x0, #0xfffffe000b99c000 ; add x0, x0, #0xfc0      ; this = gMetaClass
adrp x1, #0xfffffe0007a16000 ; add x1, x1, #0x6d2      ; "IOUserBlockStorageDevice"
adrp x2, #0xfffffe000b99d000 ; add x2, x2, #0x10       ; super = gMetaClass(IOBlockStorageDevice)
mov  w3, #0x118                                       ; sizeof(class)
bl   OSMetaClass::OSMetaClass                          ; 0xfffffe000a321794
pacda(metaclass vptr 0xfffffe0008376550) ; str [x0]
```

24B119, `0xfffffe000a355fa0` (identical shape, name literal
`0xfffffe0007a23cc2`, size `0x118`, super `0xb9f5c20`, metaclass object
`0xb9f5bd0`).

Cross-checks that tie the vtable to this name rather than to a neighbour:

* The allocator functions that store the vptr use the **same** metaclass global
  as the constructor's `this`: 24A446 `0xa305f2c`/`0xa305fb0` pass
  `0xb99cfc0` and size `0x118`; 24B119 `0xa3542f0`/`0xa354370` pass
  `0xb9f5bd0` and size `0x118`.
* Slot 7 (`getMetaClass`) of the vtable returns that same global
  (`0xa305f1c` → `0xb99cfc0`; `0xa3542dc` → `0xb9f5bd0`).
* The superclass named by the constructor, `IOBlockStorageDevice`
  (`0xfffffe000a309708`, size `0x90`), is itself an `IOService`-family class,
  consistent with the member's other storage classes.

So: **`IOUserBlockStorageDevice`, instance size `0x118`, a DriverKit block-storage
dext base class.** This is the first *named owner* for any member of the bit-8
cluster beyond the kernel-core `IOUserClient::Dispatch` thunk.

### 2.3 What the inserted statement clears (proven idiom, field identity inferred)

One 24B119 wrapper, `0xfffffe000a36da00`:

```asm
ldp  x10, x22, [x0]          ; arg0 = &copied dispatch argument block
ldp  w9, w8, [x0, #0x10]
ldr  x23, [x0, #0x18]        ; record pointer
ldr  x11, [x23, #8]
and  x11, x11, #0xfffffffffffffeff   ; <-- inserted in 27.2
str  x11, [x23, #8]
ldr  w10, [x10, #0x20] ; cmp #2
ldr  x10, [x23, #0x10] ; cmp #2
cmp  w9, #0x8c ; cmp w8, #0x3c        ; pre-existing size checks
```

The 24A446 counterpart `0xfffffe000a31f66c` is byte-for-byte the same minus the
four-instruction clear. The offset pair is identical to the kernel-core/HID form
already recorded (`ldr xN,[xM,#0x18]; ldr xP,[xN,#8]; and; str`), which that work
read as `IORPCMessage.flags` bit 8. Here the same pair appears in a DriverKit
server-side RPC dispatcher.

*Proven:* the change is one inserted clear of bit 8 of the qword at
`[arg+0x18]+8`, in every one of the 16 wrappers, before the existing checks.
*Inferred, not proven:* that this qword is `IORPCMessage.flags`; the target
build's struct definition was not available and no public header names the
DriverKit server-side block. The identical offset pair and dispatcher shape are
the evidence, not a header.

## 3. The shared `IOUserClient::Dispatch` base implementation changed the same way

The per-class story above is only half of it. The **base** dispatcher that every
`IOUserClient` descendant inherits also gained the clear:

| | 24A446 | 24B119 |
|---|---|---|
| slot-12 thunk | `0xfffffe000b2c8024` (sz `0x2c`) | `0xfffffe000b31e208` (sz `0x2c`) |
| dispatcher | `0xfffffe000b2c8050` (sz `0x298`) | `0xfffffe000b31e234` (sz `0x2ac`) |
| branch-C callee | `0xfffffe000b2c82e8` | `0xfffffe000b31e4e0` |

`kz_fn_sem_diff.py com.apple.kernel 0xb2c8050 0xb31e234 0x298 0x2ac` (raw:
`base_dispatch_sem_diff.txt`) shows exactly four inserted statements, all the
same idiom, all on `[x21,#8]` where `x21 = [arg+0x18]`:

* `0xfffffe000b31e310`, `0xfffffe000b31e3c0`, `0xfffffe000b31e408` — one per
  cookie branch in the dispatcher;
* `0xfffffe000b31e518` — inside the branch-C callee.

Everything else in the diff is register re-allocation, an ADRP page change, and
the resulting instruction shifts. Predicates (`[obj+0x20] == 1/2`,
`[obj+0x10] == 1/2`, size thresholds `0x26c` / `0x104`) are unchanged.

Consequence for reading the cluster: Apple patched **both** the shared base
implementation *and* each per-class override (HID, Skywalk, USB host,
IOStorageFamily, ...). Since ~254 of 260 `IOUserClient` descendants inherit the
base thunk unchanged (earlier census), the base change reaches every classic
user client too — this is **not** a DriverKit-only change.

## 4. Reachability: a dext entitlement gate on the IOStorageFamily half

`IOUserBlockStorageDevice`'s lifecycle path sets a dext entitlement requirement on
its own service. 24A446 function `0xfffffe000a30600c` (references the literal
`"virtual bool IOUserBlockStorageDevice::init(OSDictionary *)"`):

```asm
... call super through the vtable ...
str  xzr, [x19, #0x90]
movi v0.2d, #0 ; stur q0,[x19,#0xe8] ; stur q0,[x19,#0xf8] ; strb wzr,[x19,#0x110]
strb w8,   [x19, #0x113]             ; w8 = 1
autda(vptr) ; ldr x8, [vptr, #0xd0]  ; virtual call, slot 26
x0 = this, x1 = "IOServiceDEXTEntitlements", x2 = "com.apple.developer.driverkit.family.block-storage-device"
```

The property key is `IOServiceDEXTEntitlements` and the value is the family
entitlement `com.apple.developer.driverkit.family.block-storage-device`
(string at `0xfffffe0007a167bd`, referenced from exactly one code site). This is
the DriverKit mechanism by which a dext declares which entitlement a client task
must hold to obtain its user client.

The same pattern is present in every other member that carries a 27.2 mask-site
population — each has exactly one `IOServiceDEXTEntitlements` copy plus a
`com.apple.developer.driverkit.*` value:

| member | dext entitlement string |
|---|---|
| `com.apple.iokit.IOStorageFamily` | `...driverkit.family.block-storage-device` |
| `com.apple.iokit.IOHIDFamily` | `...driverkit.family.hid.eventservice`, `...family.hid.device`, `...transport.hid`, `...builtin` |
| `com.apple.iokit.IOPCIFamily` | `...driverkit.transport.pci`, `...transport.pci.bridge`, `...builtin` |
| `com.apple.iokit.IOSkywalkFamily` | `...driverkit.family.networking` |
| `com.apple.iokit.IOUSBHostFamily` | `...driverkit.transport.usb`, `...builtin` |
| `com.apple.driver.AppleFirmwareKit` | `...driverkit.transport.afk` |

Proven: the property key has exactly one copy per member, and the listed
`com.apple.developer.driverkit.*` value strings are present in each member (raw:
`refscans.txt`). The IOStorageFamily key/value pair is confirmed referenced from
exactly one code site each; for the other members the *value* strings were not
individually reference-checked. Not proven: the kernel-side
consumer that turns `IOServiceDEXTEntitlements` into a refusal — the only
kernel-core reference to the property name is a boot-time constant registration
(`0xfffffe000b300284`), not a check. The enforcement site therefore remains
unlocated; treat "gated" as a strong inference from the property's documented
meaning plus the family-wide correlation, not as a measured denial.

## 5. Verdict

* The IOStorageFamily half of the bit-8 cluster is **attributed**:
  `IOUserBlockStorageDevice` (DriverKit block-storage dext base, size `0x118`),
  vtable slot 12, both builds. Named owner, proven.
* The inserted statement is the same bit-8 clear already seen in the kernel-core
  and HID halves, on the same offset pair, before the pre-existing validation.
* Reachability is a DriverKit dext user-client connection gated by
  `com.apple.developer.driverkit.family.block-storage-device` — **inference**;
  the unsigned carrier cannot hold a `com.apple.developer.driverkit.*` entitlement.
* Not established: the exact struct field cleared, the meaning of flags bit 8,
  the enforcement site, and any app-openable path to this class.

**Bounded reconnaissance, closed for app-carried work unless a device shows this
class published without the entitlement.** No vulnerability claim.

Consequence for the standing cluster reading: the 27.2 mask insertion is **one
change idiom applied at two levels** — the shared `IOUserClient::Dispatch` base
implementation (reaches every classic user client, DriverKit or not) *and* each
per-class override in the dext families. It is not a set of independent per-kext
fixes. For the IOStorageFamily half specifically the ingress is a DriverKit dext
user-client connection gated by
`com.apple.developer.driverkit.family.block-storage-device`; whether the same
gate covers the other members' overrides was not re-checked in this run.

Amendment (same day): an earlier draft of this section said the change was
"DriverKit-only". That was wrong — §3 shows the base implementation changed too,
so the base-clear reaches non-Dext user clients as well.

## 6. Next steps

1. If a device appears, do **not** probe this class directly. Instead re-check
   whether any `com.apple.developer.driverkit.*`-gated service is openable by the
   carrier (the earlier `--opencand` sweep predates this attribution); a refusal
   would confirm the gate dynamically.
2. Static, cheap: locate the kernel consumer of `IOServiceDEXTEntitlements`
   (search each member's copy for a *read* rather than a write; the six setter
   sites are known) to convert the entitlement gate from inference to proof.
3. Return effort to the leads above the type-isolation wall: the VM/VFS
   `iopl_valid_data`/`vm_object_iopl_request` diff, and the external-object
   route. The IOSurface notify private-connection probe (selector 4 → async
   selector `0x11`) is still the preferred device run when hardware returns.

## Reproduction

```sh
python tools/kz-static-diff/kz_slot_table.py 24A446 com.apple.iokit.IOStorageFamily \
        0xfffffe0008375f48 16 --back 4
python tools/kz-static-diff/kz_raw.py 24A446 com.apple.iokit.IOStorageFamily \
        0xfffffe000a307bdc 0x60          # metaclass ctor, "IOUserBlockStorageDevice", 0x118
python tools/kz-static-diff/kz_raw.py 24A446 com.apple.iokit.IOStorageFamily \
        0xfffffe000a30600c 0x120         # sets IOServiceDEXTEntitlements
python tools/kz-static-diff/kz_raw.py 24B119 com.apple.iokit.IOStorageFamily \
        0xfffffe000a36da00 0xf0          # the inserted bit-8 clear
python tools/kz-static-diff/kz_adrp_ref_np.py 24A446 0xfffffe0008375f48   # vptr store sites
python tools/kz-static-diff/kz_fn_sem_diff.py com.apple.kernel \
        0xfffffe000b2c8050 0xfffffe000b31e234 0x298 0x2ac   # base Dispatch: 4 inserted clears
python tools/kz-static-diff/kz_member_strings.py 24A446 <member> driverkit
```
