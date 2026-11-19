# Bit-8 cluster: entry mechanisms resolved (and a scanner correction)

Date: 2026-11-19
Build: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, target).
Tools used: `tools/kz-static-diff/kz_blw_scan.py` (word-level BL/B/BLRAA census),
`kz_rawslot.py`, `kz_vtable.py find`, `kz_member_strrefs.py`, `kz_nzrange.py`,
plus raw capstone dumps (`dis1.py`).
Raw output: `analysis/evidence/bit8-entry-2026-11-19/`.

This executes the previous checkpoint's open static step ("resolve the entry
mechanism of the three consumer functions … to convert 'all in the dext cluster'
into a hard negative"). **No device cycle.** It also corrects a factual error in
the previous checkpoint.

## 1. Correction: two of the three functions *do* have direct callers

`dext-entitlement-consumer-2026-11-19.md` recorded that none of `0xb3a3174`,
`0xb3aedcc`, `0xb3a5fd0` had a direct `BL`/`B` caller. That was produced by a
member-wide linear capstone sweep, which desynchronises on literal pools. The
word-level scan over raw 4-byte words (`kz_blw_scan.py`, opcode-decode of
`0x94000000`/`0x14000000` + `BLRAA`) gives:

| function | direct sites | site | containing function | size |
|---|---|---|---|---|
| `0xfffffe000b3a3174` | **1** | `bl` @ `0xfffffe000b2f4214` | `0xfffffe000b2f3a78` | `0x90c` |
| `0xfffffe000b3aedcc` | 0 | — | — | — |
| `0xfffffe000b3a5fd0` | **1** | tail `b` @ `0xfffffe000b2e53d4` | `0xfffffe000b2e5350` | `0x384` |

Both sites were verified by disassembling around them
(`site_4214.dis`, `site_53d4.dis`):

* `0xb3a3174` is called normally after a global-flag test —
  `ldrb w8,[0xfffffe0007ec7391]; tbnz w8,#7` skips the call when bit 7 of that
  byte is clear. Return value is tested with `tbz w0,#0`.
* `0xb3a5fd0` is entered as an epilogue + tail branch from `0xb2e5350`, after a
  three-link non-null chain check (`ldr x8,[x8,#0x28]` → `ldr x8,[x8]` → `cbz`).

The earlier "no caller anywhere" claim was therefore **wrong**, and any conclusion
resting on it must be re-read. Everything else in the earlier report stands.

## 2. `0xb3aedcc` sits in a named class vtable: `IOProviderPropertyMerger`

A raw aligned-qword scan over every segment finds exactly one data reference to
`0xb3aedcc`: `__DATA_CONST` `0xfffffe0007ef2368` = index **21** of the auth-pointer
table starting at `0xfffffe0007ef22c0` (`kz_vtable.py find`, `rawq.txt`). So it is
reached by C++ virtual dispatch, not by a direct call.

Owner recovered with the OSMetaClass recipe (three-way agreement, no name+size
guess):

* **instance constructors**: `0xfffffe000b3aefd4` (allocates `0x88` through the
  typed allocator view selected by `[0xfffffe0007f0c844] & 0xfffff8`, sets
  `[x0+8]=1`, stores vptr `pacda(0xfffffe0007ef22c0)`), plus the same-shaped
  `0xb3af540` / `0xb3af56c` / `0xb3af6d4` / `0xb3af71c`;
* **`getMetaClass`** (vtable slot 7, entry `0xfffffe0007ef22f8` → `0xb3aef50`)
  returns the global `0xfffffe000b7b28e8`;
* **metaclass constructor** `0xfffffe000b3af4a8` passes `x0 = &0xfffffe000b7b28e8`,
  `x1 = 0xfffffe00070c8c3c` = **`"IOProviderPropertyMerger"`**, super
  `0xfffffe000b7b2e18`, `w3 = 0x88`, calls `OSMetaClass::OSMetaClass`
  (`0xfffffe000b265500`), and stores the metaclass vptr
  `pacda(0xfffffe0007ef2818)`.

Triple agreement (stored instance vptr ↔ `getMetaClass` ↔ allocator/metaclass)
names the owner: **`IOProviderPropertyMerger`**, size `0x88`. `0xb3aedcc` is one of
its virtual methods; its disassembly walks `IOProviderMergeProperties` /
`IOProviderParentMergeProperties` looking up the interned
`IOServiceDEXTEntitlements` symbol (as recorded previously). A second copy of the
metaclass constructor exists at `0xb3af61c` with the identical name literal, super,
size and stored metaclass vptr (`0x7ef2818`) — a duplicate, not a distinct class;
recorded so the two copies are not read as evidence for two classes.

## 3. What the callers look like

* `0xb2e5350` (caller of the entitlement gate) is itself referenced from **37**
  `__DATA_CONST` slots, all carrying the identical entry
  `0x801182cd042e1350` — i.e. one shared handler repeated across many table rows
  (same PAC diversity constant), not 37 distinct vtables
  (`rawq_b2e5350.txt`).
* `0xb2f3a78` (caller of `0xb3a3174`) is called from `0xb2f3168` inside
  `0xfffffe000b2f1ba0` (`0x1c24`), which is called from `0xb2f1908` inside
  `0xfffffe000b2f139c` (`0x804`), which is called from `0xb2f0d1c`
  (5 sites) and `0xb2f7110` (no direct callers — indirect).
* `kz_fn_strings.py` attributes power-management strings to some of these
  functions, but that tool does loose matching (it reported fragments such as
  `'ceWillPowerOff'`, `'icePowerOff'`), so those identities are **not** trusted;
  exact string starts were not re-resolved this pass.

## 4. Verdict

* **Proven:** the entry mechanism of all three consumers is now known — one
  virtual dispatch into `IOProviderPropertyMerger` (a property-merge helper), one
  flag-gated direct call, one tail branch from a widely-shared handler that sits
  on the DriverKit user-client creation path. The previous "no caller" reading is
  retracted.
* **Still not established:** an app-facing ancestor. No MIG routine, syscall entry
  or sandbox-openable user client was found that reaches these functions; the
  property-merge class runs during provider/dext matching, which a sandboxed app
  cannot initiate.
* **Unchanged and decisive:** nothing in any of the three functions reads or
  writes attacker-controlled memory. They read entitlement properties and return a
  Boolean / merge dictionaries. The 27.2 change is four `and #~0x100` clears of a
  reserved flag bit — hardening-shaped, with no memory-safety effect. The bit-8
  cluster stays closed as reconnaissance-only; this pass downgrades the earlier
  "localised rather than inferred" claim to a mechanism-level statement and
  corrects the caller census.

## Reproduction

```sh
python tools/kz-static-diff/kz_blw_scan.py 24A446 0xfffffe000b3a3174 bl,b,blraa
python tools/kz-static-diff/kz_blw_scan.py 24A446 0xfffffe000b3a5fd0 bl,b,blraa
python tools/kz-static-diff/kz_vtable.py   find 24A446 0xfffffe000b3aedcc
python C:/Users/Volpi/AppData/Local/hermes/cache/scratch/dis1.py 0xfffffe000b3af4a8 30
```
