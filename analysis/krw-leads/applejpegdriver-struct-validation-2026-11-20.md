# AppleJPEGDriver: input-struct -> JpegRequest field map and validation coverage (2026-11-20)

Date: 2026-11-20
Build: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, 24A446, target).
Member: `com.apple.driver.AppleJPEGDriver`.
New tool: `tools/kz-static-diff/kz_structops.py` (member-aware census of the
memory operands a function applies to one source struct pointer).
Raw output: `analysis/evidence/applejpeg-structs-2026-11-20/`.

**No device cycle.** Tailscale is `NoState`, SSH to the build host times out,
and PC usbmux enumerates nothing, so this pass is static reading only. No
vulnerability is claimed. This executes the next step recorded in the previous
checkpoint (`applejpegdriver-symbolmap-2026-11-20.md` §8): compare the three
input structs against the request-validation functions field by field.

---

## 1. Which selectors an unsigned app can actually reach

The ten dispatch wrappers were dumped in full
(`dispatchwrappers.dis`). All of selectors 1–7 have exactly one precondition:
the driver pointer at `[userClient + 0xe0]` is non-NULL. No entitlement string,
no `IOUserClientEntitlements` read, no client flag test.

Selectors 8 and 9 are different — both gate on a single client field:

```
ldr  x0, [x0, #0xe0]        ; driver
cbz  x0, err
ldrb w8, [x1, #0x108]       ; x1 = user client
tbz  w8, #0, err            ; bit 0 of client+0x108 required
```

`client+0x108` is zeroed by the client factory (recorded in the previous
checkpoint), so 8/9 need the entitlement-gated path. **Proven: selectors 1–7
are reachable without any entitlement.**

Wrapper argument marshalling (matches the skill's arm64 field offsets):
`structIn = args->structureInput (+0x30)`, `structOut = args->structureOutput
(+0x58)`, plus `[client+0xf0]` and `[client+0x100]`.

## 2. Input struct -> JpegRequest map (0xda0 generation, selector 7)

Proven by direct reads/stores in `startDecoder2024` (`startdec2024.dis`,
`startdecExt.dis`; `startEncoder`/`startEncoderExt` use the identical low
half):

| input offset | request offset | note |
|---|---|---|
| `+0x00`, `+0x04` | `+0x2ac`, `+0x420` | |
| `+0x08` | `+0x424`, `+0x2b0` | |
| `+0x14`, `+0x18` | `+0x428`, `+0x42c` | width/height pair (q-copy) |
| `+0x20` (byte) | `+0x310/+0x312/+0x314` | three flag bits |
| `+0x24`, `+0x28` | `+0x450`, `+0x454` | dimension pair |
| `+0x2c` | pixel-format selector | branch 1/2/3/4 selects a default plane geometry |
| `+0x30` (8 bytes) | `+0x10` (16-byte q-copy) | source buffer / descriptor |
| `+0x40` | `+0x20` | |
| `+0x48` | `+0x538` | scalar passed as `w2` to the object-create helper |
| `+0x4c` | `+0x444` (via `x27 = req+0x444`) | |
| `+0x54`, `+0x58` | `+0x4ac`, `+0x4b0` | crop/origin pair |
| `+0x5c`…`+0x6c` | `+0x4b4`…`+0x4c4` | four crop pairs |
| `+0x70`, `+0x74` | `+0x498`, `+0x49c` | |
| `+0x78` | `+0x4a8` | |
| `+0x7c` | `+0x4a0` | **length/count**: copy length for the `+0x84` block |
| `+0x80` | `+0x4a4` | compared against a buffer length in `decodeHWRequestSetup` |
| `+0x84`, len `[+0x7c]&~3` | `+0x4d8` | memcpy into the request's stream buffer |
| `+0xc84` | `+0x468` | |
| `+0xcac` | `+0xc4` | |

## 3. Where each length/count is bounded (proven instruction shapes)

* `[struct+0x7c]` — selector 7 path: `cmp w26,#0x1000; b.ls` then a
  divisibility-style test and `cmp w26,#0xc03; b.ls <do the copy>`; otherwise it
  logs and skips the copy. Copy length is `w26 & ~3`, so **≤ 0xc00**, and the
  source window `[+0x84, +0x84+0xc00)` ends at `0xc84` — inside the declared
  `0xda0` struct. The destination capacity is checked afterwards
  (`sub/cmp; b.ge` else `brk #0x800`).
* `[struct+0x7c]` — selector 5 (Ext) path: same shape, bound `0xf7f`
  (`cmp w25,#0xf7f; b.ls`). Length `≤ 0xf7c`; window ends at exactly
  `0x84 + 0xf7c = 0x1000`, i.e. the last byte of the declared `0x1000` struct.
* `[req+0x4a0]` (from `+0x7c`) is re-checked in `decodeRequestValidation`:
  `ldr w8,[x20,#0x4a0]; cmp w8,#0x1000; b.hi <reject>`.
* `[req+0x4a4]` (from `+0x80`) is compared to the result of `0x902feb8` in
  `decodeHWRequestSetup`; the reject path logs
  `"startOfRawBitStream %u >= sourceSurface allocSize %llu"`.
* `[req+0x4b8..0x4c4]` and `[req+0x4ac/0x4b0]` (from `+0x5c…0x6c`, `+0x54/0x58`)
  are checked twice: inline in `decodeRequestValidation` (`>>16` must be zero;
  `0x4bc` must be `< 0x1000`) and again in the helper `0x902eae0`
  (`(0x4b8+0x4c0) > 0x4ac` and `(0x4bc+0x4c4) > 0x4b0` select error codes).
* `[req+0x450]/[req+0x454]` (from `+0x24/+0x28`): `>>13` must be zero in
  `decodeRequestValidation`, i.e. each `< 0x2000`.

## 4. Does any access leave the declared structureInputSize?

`kz_structops.py` over the five start bodies (it seeds `x1`, follows `mov`/`add`
derivations, and records every load/store on a struct-derived base; it
over-approximates, so a within-bounds answer is meaningful):

| selector | entry | declared `structureInputSize` | max offset accessed |
|---|---|---|---|
| 1 | `startDecoder` (`0x900bdf0`) | `0x58` | `0x4c` (`ldur d0,[x19,#0x4c]` → 8 bytes, ends `0x54`) |
| 3 | `startEncoder` (`0x900d090`) | `0x58` | `0x54` |
| 5 | `startDecoderExt` (`0x900c8f4`) | `0x1000` | `0x80` direct; copy window ends at `0x1000` |
| 4 | `startEncoderExt` (`0x900d4a8`) | `0x1000` | `0xdc`; plus fixed 0x40-byte copies from `+0x5c` and `+0x9c` |
| 7 | `startDecoder2024` (`0x900d908`) | `0xda0` | `0xcac` |

No start body reads or writes past its declared `structureInputSize`. Raw:
`maxoffsets.txt`.

## 5. Unresolved: who calls the shared validator?

Both validation thunks (`0x902e298` → `decodeRequestValidation`, and
`0x902ec74` → `decodeHWRequestSetup`/`encodeHWRequestSetup`) are referenced
exactly once each, from `0xfffffe000900c1cc` (size `0x728`), which also reads
`req+0x538` in five places. `kz_blw_scan.py` finds **zero** direct `BL`/`B`/
`BLRAA` sites to `0x900c1cc` anywhere in the image, and a raw qword scan for
the member's fixup encoding (`VA = 0xfffffe0007004000 + low32`) finds no data
reference either. It is therefore reached by an encoding this project's scans
do not cover (or is dead code). Recorded as unresolved; it does not change the
field map above, which was read directly out of the start bodies.

A second, unrelated scan artefact is noted for the record: `kz_blw_scan.py`
reported a site in `com.apple.security.AppleImage4` at `0xfffffe0007519494`
with `sz=0x0` (function-start lookup failed); that is a word-decode artefact,
not a cross-kext call.

## 6. Verdict and next step

* **Proven:** the reachable selectors are exactly 1–7; the three input-struct
  generations are copied into `JpegRequest` field by field as tabulated; every
  field that is used as a length, count or origin is bounded either inline in
  the start body or in the shared validation chain; and no start body accesses
  memory outside its declared `structureInputSize`.
* **Not found:** an unvalidated length/offset, a read past the supplied
  structure, or a field that reaches a memory operation unchecked. This is a
  **bounded negative** for the struct-shape hypothesis in
  `LEAD-ASSESSMENT.md` §12, not a proof that the codec path is bug-free (the
  downstream codec engine and the `0x900c1cc` validator's own logic were not
  audited).
* **Next step (device, when a host enumerates a phone):** the IOSurface notify
  private-connection probe (`--ionotify`, P1→P2→P3) remains the highest-value
  run. Static work should move off AppleJPEGDriver unless a new signal appears;
  if this line is resumed, the open item is naming the caller of `0x900c1cc`.

## Reproduction

```sh
python tools/kz-static-diff/kz_structops.py 24A446 com.apple.driver.AppleJPEGDriver 0xfffffe000900d908 0x6f8
python tools/kz-static-diff/kz_blw_scan.py 24A446 0xfffffe000900c1cc bl,b,blraa
python C:/Users/Volpi/AppData/Local/hermes/cache/scratch/mdis.py 24A446 com.apple.driver.AppleJPEGDriver 0xfffffe000900d908 0x6f8 out.s
```
