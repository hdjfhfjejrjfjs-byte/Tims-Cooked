# kz-static-diff — kernelcache static-diff helpers

Small, self-contained arm64 (kernelcache) analysis scripts used to produce
`analysis/krw-leads/upl-iopl-cluster-diff-2026-11-14.md`.

They derive the repository root from `__file__`, so they run from anywhere:

```sh
python kz_funcinfo.py 24A446:0xfffffe000acd4d34   # needs numpy
python annot.py 24A446 0xfffffe000acd4d34 0x4f0 out.s
python kz_side.py a.s b.s          # semantic side-by-side diff
python kz_blocks.py a.s b.s        # change blocks sorted by size
python kz_sum.py a.s b.s           # change blocks with sample text
python kz_adrp_ref.py 24A446 0xfffffe000705dfcd   # code sites referencing a VA
python kz_fn_adrp.py 24A446 com.apple.iokit.IOHIDFamily 0xfffffe000a0d65a4 0x60 \
        0xfffffe00079b0000 0xfffffe00079c3000          # all ADRP+ADD/LDR targets of one function
python kz_member_authscan.py 24A446 com.apple.iokit.IOHIDFamily 0xfffffe000a0fc660 \
        0x200                                           # member-scoped arm64e auth-pointer slots
python kz_ptrrefs.py 24A446 0xfffffe000b347a08    # data slots holding a pointer (numpy)
python kz_calls.py out.s 0xfffffe000acd1e18 0x20f0 24A446 --offsets   # numpy-free call fingerprint
```

`kz_funcinfo.py` and `kz_ptrrefs.py` import `numpy`, which is **not** installed in
the PC Python; use `kz_calls.py` / `kz_chainfind.py` / `annot.py` instead.

```
python kz_nzrange.py 24B119 com.apple.kernel 0xfffffe0007f00c80 0xfffffe0007f01200
python kz_refs_func.py 24B119 0xfffffe0007f00d00 0xfffffe0007f01200
python kz_iomethod_table.py 24A446 com.apple.iokit.IOSurface \
        --find 0xfffffe000a3498f4 --count 60   # dump an IOExternalMethodDispatch2022 table
python kz_slot_table.py 24A446 com.apple.iokit.IOStorageFamily \
        0xfffffe0008375fa8 12 --back 4          # decode a plain arm64e auth-slot array
python kz_mask_sites.py 24B119 com.apple.iokit.IOStorageFamily   # mask sites + containing fn
python kz_mask_vas.py 24B119 com.apple.iokit.IOStorageFamily --ctx 4   # exact site VA + context
python kz_member_strrefs.py 24A446 IOSurface 0xfffffe0007a1fa08  # member-scoped string-ref scan
python kz_adrp_disp.py 24A446 0xfffffe000b7b2000 0x910           # exact adrp+disp census
```

Builds are `24A446` (iOS 27.0.1, target) and `24B119` (iOS 27.2). Requires
`tools/pylibs/capstone` and `tools/opencode-temp/kc_fstarts.py` (both already in-repo).

## Naming a stripped arm64e class from its vtable (recipe)

Slot bodies are shared up the hierarchy, so matching a few entries only says
"same base class". Name the owner from the generated metaclass constructor,
which has one fixed shape:

```
adrp x0, #gMetaClass ; add x0,x0,#off          ; this
adrp x1, #name literal ; add x1,x1,#off        ; "#ClassName"
adrp x2, #super::gMetaClass ; add x2,x2,#off   ; superclass
mov  w3, #sizeof(class)
bl   OSMetaClass::OSMetaClass
pacda(metaclass vptr); str [x0]
```

Then confirm with `getMetaClass` at the vtable's slot 7 returning that same
`gMetaClass`, and with `__LINKINFO`'s `__ZN<size><Class>8DispatchE5IORPC` /
`__ZTV<Class>` strings. Worked examples: `IOUserClient` (`0xb3cf544`, super
`0xb80af58`, size `0xd8`), `OSObject` (`0xb2beb44`, no super, size `0x10`),
`OSUserMetaClass` (`0xb3f09c8`, super = `OSObject`'s `0xb80aeb8`, size `0x58`).

Corollary worth recording: an instance vtable whose slot 12 is a *forwarder*
(`ldr x0,[x0,#0x18]; copy IORPC; blraa target slot 12`) means the changed code
in the callee is **downstream** of that class, not inside it.

## Pitfalls these scripts exist because of

1. **Capstone stores arm64 immediates as signed int64.** Branch and ADRP targets above
   `0x8000000000000000` come out negative; every annotation must mask with
   `& (2**64 - 1)` or all target resolution silently compares against positive literals
   and reports zero hits.
2. **Capstone stops at literal pools.** Kernelcache functions contain embedded literal
   islands, so a plain `md.disasm()` truncates mid-function — it returned 86 instructions
   for a `0x20f0`-byte function. Always set `md.skipdata = True`.
3. **`func_refs`/`adrp_track.py` mis-attribute strings** when the reference pattern is not
   a clean ADRP+ADD (intermediate branch, register reuse). Verify string attribution with
   `kz_adrp_ref.py`, which decodes every ADRP/ADD/LDR pair in `__TEXT*` and reports the
   exact code site.
4. **Main kernel code is in `__TEXT_EXEC`** (`0xfffffe0008498000..0xb4430000` on 27.0.1),
   while kernel format strings are in `__PRELINK_TEXT`. Scanning only `__TEXT` misses
   both.
5. Pass native Windows paths (or `$LOCALAPPDATA/...`) to these scripts: a bare `/tmp/x.s`
   is interpreted differently by git-bash and by native CPython.
6. `kc_fstarts.load_build()` covers only the `com.apple.kernel` entry, so every
   tool built on it (`kz_fn_strings.py`, `kz_vtable.py find/dump/diff`) reports
   "no start" / `KeyError` for kext-member VAs. Use the `kc_member`-based tools
   for a member. Separately, string-VA lists are build-specific: an address
   copied from a 24B119 scan names different bytes in 24A446, and a scan run on
   it returns a clean-looking zero.
7. **Slot indices must be measured from the stored vptr, not the table start.**
   Arm64e tables frequently carry a two-entry header (offset-to-top, typeinfo)
   before the first function, but the object stores a vptr *past* it. A flat
   "slot N = table base + N*8" therefore lands on the wrong entry while looking
   plausible. Recover the stored vptr from the instance constructor
   (`str pacda(...),[x0]`) or from a neighbour whose index you already know,
   then read `(entry - vptr)/8`. Sanity check with the destructors at slots 0/1
   and with a size check against the `OSMetaClass(..., size)` argument.
8. **A BL-site census for a vtable slot is only meaningful with the slot-load
   base traced to a vptr load.** Matching bare `ldr xT,[xN,#imm]` plus `blraa`
   counts object field loads as virtual dispatches (250 hits for offset 0x60,
   most false); requiring `xN` to come from `ldr xN,[xObj]` drops it to the real
   set. `kz_slot12_vtable.py` implements the strict form. `kz_slotctx.py` then
   prints the marshalling window before each real site.
9. **Slot 12 of `IOUserClient`'s instance vtable is `Dispatch(const IORPC rpc)`,
   not `externalMethod`.** The thunk copies a 0x20-byte `struct IORPC` by value
   (`ldp q0,q1,[x1]; stp q0,q1,[sp]`) and the dispatcher reads `rpc.kernelContent`
   (`+0x18`) as an `IORPCMessage *`: `[R]` = msgid compared against four baked
   64-bit IDs, `[R+0x10]` = objectRefs (must be 1 or 2), `[R+8]` = flags.
   `externalMethod` sits at slot 168, and the AppleSmartIOUserClient string
   `externalMethod(uint32_t, IOExternalMethodArgumentsOpaque *)` does not make
   slot 12 that method. The base-class default at the same slot returns
   `kIOReturnUnsupported`; the only `IOUserClient`-descendant override in 24B119
   is `IOUserServer`. See `analysis/krw-leads/bit8-slot12-dispatch-identity-2026-11-17.md`.
10. **Slot bodies shared with a base class do not prove descent from the class
    you are studying.** `OSUserMetaClass` (`0x7ed7490`, 24B119) reuses the same
    slot 2–6 / 8–11 bodies as `IOUserClient`, which reads as "IOUserClient
    subclass"; its registered superclass is actually `OSObject`. Always finish
    with the metaclass constructor's name/super/size triple (recipe above).
11. **`kz_ptr_slots.py` can print nothing at all on success and look like a clean
    zero.** For `0xfffffe000b3ea86c` it produced empty output while a raw
    aligned-quadword scan (`kz_rawslot.py`) found exactly one `__DATA_CONST`
    auth slot at `0xfffffe0007f00d00`. Prefer the raw scan, or always run a
    control target known to have slots before believing an empty result.
12. **Bit-N idiom censuses answer "how many sites", not "which field".**
    `kz_flag_bits.py 24B119 com.apple.kernel 8` returns 304 sites, several of
    them inside `kalloc_type` flag paths (`tst w2,#0x100` at `0xac1f334`). A
    high count means the bit is *common*, so a "private flag" reading needs the
    producer traced, not just the clears enumerated.
13. **Neither build has an `LC_SYMTAB`.** A per-member `nlist` lookup returns
    nothing in both 24A446 and 24B119 (0 members / 0 symbols); `__LINKINFO` is a
    string blob only. Use the OSMetaClass-constructor recipe above for names; do
    not write a tool that assumes `kernelsyms.pkl`-style data exists.
14. **A `__DATA_CONST` window can merge several different arrays.** The region
    around `0xfffffe0007f00d00` (24B119) mixes method descriptors, block-signature
    strings (`"B16@?0^{OSObject=^^?i}8"`), self-pointers and integer fields under
    a nominal `0x28` stride. Grouping by stride alone labels it a vtable and hides
    that no code site references the slot itself. Dump non-zero qwords
    (`kz_nzrange.py`) before naming anything.
15. **`func_of`/`kc_fstarts.load_build` VAs must be full 64-bit.** Passing a bare
    `0xb3fc5cc` instead of `0xfffffe000b3fc5cc` silently reports "no start",
    which reads as "this address is not a function" rather than "wrong argument".
16. **A kext external-method table is `IOExternalMethodDispatch2022`, stride
    `0x28` — not the older `0x18`.** iOS 27 appends `uint8_t allowAsync` and
    `const char *checkEntitlement`; reading with the old stride lands mid-entry
    and invents selectors that look plausible.
17. **Auth-jump-table entries store a file offset, not an address.** An entry
    qword is `(pac_signature << 32) | file_offset_of_target`. Comparing the low
    48 bits against VAs returns zero slots and reads as "unreferenced"; decode
    with `va = __TEXT_EXEC_vm + (lo - __TEXT_EXEC_fo)` (`kz_iomethod_table.py`).
    Cross-check the decoded `IOExternalMethodArguments` offsets against a known
    thunk before trusting them: `scalarInput` +0x20, `structureInput` +0x30,
    `structureOutput` +0x58, `asyncReference` +0x10 on arm64.
19. **A whole-member `difflib` shape diff counts mispaired duplicates as real
    edits.** `kz_shape_diff.py` aligns two builds' full function lists by
    instruction *shape*; members full of copy-paste thunks match each body
    against a duplicate rather than its true counterpart. Measured:
    `IOSkywalkFamily` 108 "real edits" here vs **16** from
    `kz_newfunc_align.py` + `kz_pair_shape_check.py`; `IOStorageFamily` 18 vs
    **2**. Do not rank members with it; cross-check any count with the two-stage
    pipeline first.
20. **An `and ...,#<mask>` census is a site count, not an idiom identity.**
    `com.apple.filesystems.apfs` carries 9 `and ...,#0xfffffffffffffeff` sites in
    *both* 24A446 and 24B119, scattered across unrelated functions and objects.
    Only a repeated identical inserted statement, absent from every counterpart
    (`kz_mask_vas.py`), marks a deliberate change.
21. **`kz_adrp_ref_np.py`'s "ldr at <va>" hits are displacement matches, not
    proven references.** It reports a hit whenever it holds *some* page value for
    the base register and the displacement lines up; when the base register was
    loaded from memory (not the ADRP destination) the target is invented.
    Measured on 24A446 for global `0xfffffe000b7b2910`: 7 reported sites, only
    **5** real (`kz_adrp_disp.py 24A446 0xfffffe000b7b2000 0x910`); the extras
    were `0xb213420` and `0xb23b00c`. Confirm any single consumer with an exact
    ADRP→LDR/ADD back-scan before drawing a reachability conclusion.
    Corollary for writing such a scanner: compute the target from the
    *pre-instruction* register state, then drop every written register, then
    re-apply the one value the instruction produces — the other two orders each
    report zero sites (they erase either an `add xD,xD,#imm` source or the
    ADRP's own destination).
22. **A property key literal can be interned once and read via a global, so no
    code site references the string.** `IOServiceDEXTEntitlements` occurs 7× in
    24A446 (once per member blob, plus the kernel's interner); the only code ref
    to the kernel copy builds an OSSymbol in `0xfffffe000b2ffb28` and stores it at
    `0xfffffe000b7b2910`. Grep for the literal therefore finds declarations, not
    readers — follow the interned global instead.

## Recovering names and fields without a symtab

* `kz_sigmap.py <build> <member> <strings-file>` — Apple kexts embed one
  signature string per virtual method ("virtual IOReturn Foo::bar(...)") and
  each method logs its own, so resolving ADRP+ADD/LDR references to those
  strings yields a symbol -> address map for a stripped arm64e kext. The hit is
  a *reference*: entries whose containing function differs from the named
  function are caller-side and must be re-read.
* `kz_offops.py <build> <member> <hex-offset>...` — every LDR/STR at a given
  field offset with its containing `LC_FUNCTION_STARTS` entry, for "who reads or
  writes this field" once the object type is known.
* `kz_memcensus.py` — index-paired function-size census across all members,
  build A vs B. Cheap ranking only: misalignment after an added/removed
  function inflates it, so verify any candidate with `kc_member_diff.py` /
  `kz_pair_shape_check.py`.

