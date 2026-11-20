# IOPL / frame-bank deposit route: the caller chain above `vm_object_iopl_request` (2026-11-20)

Date: 2026-11-20
Build: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, 24A446, target).
Member: `com.apple.kernel`. Raw output:
`analysis/evidence/iopl-caller-chain-2026-11-20/`.
**No device cycle.** The macOS build host is unreachable this run (Tailscale
`NoState`, SSH to it times out; PC usbmux enumerates nothing), so this pass is
pure static reading.

This executes the open step from
`analysis/krw-leads/vm-sk-deferred-subsystem-2026-11-16.md` §5 item 1: *walk the
three callers of `0xfffffe000ac80474` upward to the first app-facing handle*.
That step is now **done**, and it ends in a hard negative rather than an
ingress path.

---

## 1. The chain as measured

`vm_object_iopl_request` (`0xfffffe000acd1e18`, sz `0x20f0`) has exactly one
caller in 24A446:

```
vm_object_iopl_request  0xacd1e18   <- BL 0xac80644 in func 0xac80474 (sz 0x26c)
```

`0xfffffe000ac80474` (the IOPL/UPL construction + frame-bank deposit builder) has
exactly three direct branches:

| site | containing function | size | that function's own entry mechanism |
|---|---|---:|---|
| `0xfffffe000b343824` | `0xfffffe000b343530` | `0x394` | **vtable slot 23** of `0xfffffe0007ebcc90`; 1 auth slot (`__DATA_CONST 0x7ebcd48`) |
| `0xfffffe000b3459b0` | `0xfffffe000b34568c` | `0x520` | **vtable slot 35** of `0xfffffe0007ebd7b8` and `0xfffffe0007ef4fc8` (3 auth slots) |
| `0xfffffe000b348c68` | `0xfffffe000b3486a4` | `0xa44` | **in-function branch**, not a vtable entry (see §3) |

Every address was verified with `kz_blw_scan.py` (word-level opcode decode) — not
the linear capstone sweep that previously reported "zero callers" for two of
these and had to be retracted.

## 2. The middle link is also a virtual method

`0xfffffe000b34568c`'s only caller is `0xfffffe000b3530cc` (`BL` @ `0xb3530e8`,
function sz `0xa8`), and `0xb3530cc` is itself **slot 0** of the
IOMemoryDescriptor-family vtable at `0xfffffe0007ebd5e0`:

```
[  0] 0xfffffe0007ebd5e0 -> 0xfffffe000b353308     <-- slot 0 (destructor)
[ 27] 0xfffffe0007ebd890 -> 0xfffffe000b348450     prepare()
[ 28] 0xfffffe0007ebd898 -> 0xfffffe000b347a08     complete() -> iopl_valid_data
```

`kz_rawslot.py` finds the slot for `0xb3530cc` at `__DATA_CONST
0xfffffe0007ebd6f8` (index 0 of that table). So the whole upper half of the
route is ordinary C++ virtual dispatch on an IOMemoryDescriptor-derived object,
reached through two more virtual layers below it.

## 3. The third branch is inside a method body, not a separate entry

`0xb348c68` is **not** the start of a function: `LC_FUNCTION_STARTS` resolves it
to `0xfffffe000b3486a4` (sz `0xa44`). It is the 4th instruction of the
`prepare`-family method itself — the page-list build calls the deposit builder
inline. So `0xb3486a4` has **no** independent entry mechanism; it contributes no
new ingress.

Its raw prologue confirms the identity:

```asm
0xfffffe000b348c68  bl   #0xfffffe000ac80474   ; the deposit builder
0xfffffe000b348c6c  mov  x25, x0
0xfffffe000b348c70  cbz  w0, ...
```

and the function carries the diagnostic
`IOMemoryDescriptor 0x%zx prepared read only` (`fnstrings.txt`).

## 4. Where the chain stops — and why that is a negative, not an open question

Above the three virtual entries there is **nothing**:

* `kz_chainfind.py chainrefs` on `0xb3530cc`, `0xb3486a4` and `0xac80474`:
  **0 indirect slots each**.
* `kz_rawslot.py` on the same three: **0 auth slots** (only `0xb34568c` and
  `0xb343530` carry them, which is how they are reached).
* No MIG routine or syscall glue references any of them.

So the deposit/IOPL route is reachable **only** by virtual calls on objects of
four IOMemoryDescriptor-derived dynamic classes — the same family already named
in `analysis/krw-leads/iopl-valid-data-vtable-dispatch-2026-11-16.md` §3
(`IOGuardPageMemoryDescriptor`, `IOGeneralMemoryDescriptor`, `IOSKMemoryBuffer`,
`IOBufferMemoryDescriptor`), whose tables all sit in the same
`0xfffffe0007ebc...`/`0x7ef5...` window.

**What this settles:** the previous checkpoint's caveat — "both inner functions
have zero direct BL/B sites, so this needs vtable resolution" — is resolved. The
inner functions are virtual methods, and the caller above them is a second
virtual layer. There is no free-standing kernel-core wrapper that a user client
could call by selector.

**What it does not settle:** that a sandboxed app can cause one of those four
classes' `prepare()`/`complete()` to run with attacker-chosen arguments. No
user-client selector has been tied to these slots, and the only measured
selector-shaped thing near this family (`kz_iomethod_table.py --find 0xb348450`)
is not a real `IOExternalMethodDispatch2022` row — the walk stops after entry 0
because entry 1 does not decode. Treat that table as **not** an external-method
table; do not read it as a selector surface.

## 5. Verdict

* **Proven:** the caller chain of `vm_object_iopl_request` is now closed end to
  end: three virtual entries, one inline call, zero non-virtual ancestors. The
  open step in `vm-sk-deferred-subsystem-2026-11-16.md` §5 item 1 is **executed**.
* **Consequence for ranking:** this route cannot be driven from a signed
  sandboxed app by any path found in this image. Combined with
  `upl-iopl-cluster-diff-2026-11-14.md` (DoS ceiling, panic-only validators) the
  whole UPL/DART cluster stays **closed**. Do not spend a device cycle on it.
* **Correction carried forward:** `kz_vtable.py find` / `kz_rawslot.py` report
  "0 slots" both when a target is genuinely unreferenced *and* when it is an
  interior instruction rather than a function start. Re-run any zero-slot
  verdict through `LC_FUNCTION_STARTS` first — `0xb348c68` is the worked example.

## Reproduction

```sh
python tools/kz-static-diff/kz_blw_scan.py 24A446 0xfffffe000ac80474 bl,b,blraa
python tools/kz-static-diff/kz_rawslot.py 24A446 com.apple.kernel 0xfffffe000b343530
python tools/kz-static-diff/kz_vtable.py find 24A446 0xfffffe000b343530
python tools/kz-static-diff/kz_chainfind.py chainrefs 24A446 0xfffffe000b3530cc
python -c "import sys;sys.path.insert(0,'tools/opencode-temp');from kc_fstarts import load_build;b=load_build('24A446');print([hex(x) for x in b['starts'] if x<=0xfffffe000b348c68][-1])"
```
