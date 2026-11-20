# AppleJPEGDriver: recovered symbol map, user-client vtable identity, and close path (2026-11-20)

Date: 2026-11-20
Build: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, 24A446, target);
reference `firmware/24B119/kernelcache.release.macho` (iOS 27.2).
Member: `com.apple.driver.AppleJPEGDriver`.
Tools added: `tools/kz-static-diff/kz_sigmap.py`, `kz_offops.py`, `kz_memcensus.py`.
Raw output: `analysis/evidence/applejpeg-symbolmap-2026-11-20/`.

**No device cycle.** The macOS build host is unreachable this run (Tailscale
`NoState`, SSH to it times out; PC usbmux enumerates nothing), so this pass is
pure static reading. Nothing here is a vulnerability claim.

This continues Lead #2 (`analysis/LEAD-ASSESSMENT.md` §12) and closes the open
question recorded in `analysis/reach/JPEG-CODEC-CALLCHAIN-2026-11-08.md`
("the remaining unknown is the user client's own `+0x298` implementation").

---

## 1. New tool: `kz_sigmap.py` — a symbol map for a stripped kext

Apple kexts embed one signature string per virtual method, e.g.

```
virtual IOReturn AppleJPEGDriver::newUserClient(task_t, void *, UInt32, OSDictionary *, IOUserClient **)
```

and each method passes its own signature to the kext logger. Resolving every
ADRP+ADD / ADRP+LDR reference to those strings therefore maps signatures to
addresses with no symtab and no `nlist`. Result for this member:
`analysis/evidence/applejpeg-symbolmap-2026-11-20/sigmap-jpegdriver.txt`
(85 entries).

**Caveat recorded:** the resolved site is a *reference*, not necessarily the
definition. Most entries are self-references (the method logging its own
signature); a few land in a caller instead (`convertToRequestSubSampleMode`,
`assign_codec_gated`, `release_codec_gated`), so an entry whose containing
function differs from the named function must be re-read before use.

Recovered addresses used below (all 24A446, member-local):

| symbol | address |
|---|---|
| `AppleJPEGDriver::newUserClient` | `0xfffffe000900948c` |
| `AppleJPEGDriver::clientClosedGated` | `0xfffffe0009009858` |
| `AppleJPEGDriver::startDecoder` | `0xfffffe000900bdf0` |
| `AppleJPEGDriver::startDecoderExt` | `0xfffffe000900c8f4` |
| `AppleJPEGDriver::startEncoder` | `0xfffffe000900d090` |
| `AppleJPEGDriver::startDecoder2024` | `0xfffffe000900d908` |
| `RequestHandling::decodeRequestValidation` | `0xfffffe000902e2ac` |
| `RequestHandling::encodeRequestValidation` | `0xfffffe000902e80c` |
| `RequestHandling::decodeHWRequestSetup` | `0xfffffe000902ec88` |
| `RequestHandling::encodeHWRequestSetup` | `0xfffffe000902f298` |
| client factory (unnamed) | `0xfffffe00090161a0` |

---

## 2. The user-client object: identity and vtable base (correction)

`JPEG-CODEC-CALLCHAIN-2026-11-08.md` recorded "the `+0x298` slot of the
96-entry table at `0xfffffe00080dbc80`" as unresolved because that slot
decoded outside the kext. That was the wrong base.

Measured identity, all proven:

* Factory `0xfffffe00090161a0` allocates **0x110 bytes** through a typed
  allocator descriptor at `__DATA_CONST 0xfffffe00080e1068`, then stores
  `pacda(0xfffffe00080dd320)` as the instance vptr and zeroes `[obj+0x108]`.
* Vtable slot 7 (`vptr+0x38`) → `0xfffffe0009015b38`, which is
  `adrp/add x0, #0xfffffe000b8d1988; ret` — i.e. `getMetaClass` returns the
  global metaclass `0xfffffe000b8d1988`.
* Two metaclass constructors (`0xfffffe00090159fc`, `0xfffffe0009015b48`)
  pass `x1 = "AppleJPEGDriverUserClient"` (`0xfffffe000752f771`),
  `w3 = 0x110` (size), super metaclass pointer `*(0xfffffe00080e1800)`
  → `0xfffffe000b7b2988` (unresolved name). Three-way agreement with the
  factory's vptr store confirms the class.

So the instance vtable base is **`0xfffffe00080dd320`** (dump:
`vtable-0x80dd320.txt`), not `0x80dbc80`.

Decoding rule used for the arm64e pointer slots in this table (verified against
three independent same-kext anchors — slot 0 `0x9015ad0`, slot 7 `0x9015b38`,
slot 86 `0x9015cd8`): `VA = 0xfffffe0007004000 + low32(qword)`, with the PAC
signature in the high 32 bits. `0xfffffe0007004000` is the kernelcache fixup
base, **not** the member's own `__TEXT` vmaddr (`0xfffffe000752d470`); using
the member value silently produces off-by-`0x8000` garbage that still looks
plausible.

---

## 3. The `+0x298` slot, resolved (Nov-14 open question closed)

`AppleJPEGDriver::clientClosedGated` (`0xfffffe0009009858`) calls the PLT
trampoline `0xfffffe000902fea8`, whose chained-fixup target is
`0xfffffe000b2ffac0` — a wrapper that does `autda vptr; add #0x298; ldr; blraa`
with discriminator `0xc90d` and returns bit 0 of the result.

Vtable slot `+0x298` (index 83, `__DATA_CONST 0xfffffe00080dd5b8`) holds
`0x8011c90d_042f37cc` — high half `0xc90d` matching the wrapper's `blraa`
discriminator exactly, so the identification is proven rather than inferred.
Target:

```
0xfffffe000b2f77cc  bti c
0xfffffe000b2f77d0  ldr w0, [x0, #0x48]
0xfffffe000b2f77d4  ret
```

i.e. **bit 0 of the word at `client+0x48`** is the predicate that gates the
close-time teardown. Full `clientClosedGated` reading (raw:
`clientClosedGated.dis`):

```
if client == NULL -> log-only path
w0 = bit0([client+0x48])            ; via virtual +0x298
if (w0 & 1) goto 0x90098bc          ; skip teardown entirely
  helper 0x900990c: for each non-NULL entry in driver+0xe0..+0xf0,
                   release codec assignment (driver+0x150/+0x158 arrays)
  virtual +0x2f0(client, 0)
0x90098bc: driver->close_count (+0x128)++, log "client close"
```

Unresolved: the semantic *name* of `client+0x48` (privilege/ownership flag) —
not established here, and not needed for the lifetime question below. What is
established is that both the teardown and the `+0x2f0` call are conditional on
it, so any future probe of this path must read that field, not assume the
teardown always runs.

---

## 4. The driver does not retain the user client (bounded negative)

`newUserClient` (`0xfffffe000900948c`, raw `jp_newuc.dis`) full flow:

```
factory 0x90161a0(driver, task, securityID, type, properties) -> client
virtual +0x360(client, driver)            ; tbz fail -> error
virtual +0x2b0(client, driver)            ; tbz fail -> error
0x902fb68(&driver+0x120, 1)               ; open counter
virtual +0x368(client, driver)
0x9016078(client)                         ; client-side cleanup/init
virtual +0x28(client)                     ; release
*handler = client                         ; 0x9009698 -- the ONLY store
```

`kz_offops.py` over the driver fields `+0xd8 / +0xe0 / +0xf0 / +0x100` finds
those fields touched only by `AppleJPEGCoreAnalyzer::checkFrameBufferFormat`
(`0x900f22c`), `AppleJPEGCoreAnalyzer::submitAnalyticData` (`0x9010118`), the
unnamed `0x9015df4`, and the client-object helpers `0x9016078` / `0x90162b4` /
`0x9016358` (raw: `offops-driver-fields.txt`). No path stores the newly
created client into a driver field.

**Consequence:** the Nov-14 hypothesis — "the driver stores the userClient
pointer at `driver+0xe0` and releases it only when `+0x298` returns zero, so
the pointer dangles after `IOServiceClose`" — is **unsupported**. `driver+0xe0`
belongs to a different object: `0x9015df4` stores its own `arg1` there and
retains it, and that function has zero direct `BL` callers (virtual entry), is
not called from `newUserClient`, and gates on the `poweron` /
`ajpegtestapp` entitlements. Its identity is left unresolved; what matters is
that it is not the user client.

This is a bounded negative for the "dangling user client" UAF shape, not a
proof that no other lifetime bug exists in the kext.

---

## 5. Cross-build diff: AppleJPEGDriver is unchanged 24A446 -> 24B119

`kc_member_diff.py com.apple.driver.AppleJPEGDriver`:
**1807 function starts in both builds, index-paired, 0 differences** (no size
changes, no normalized-instruction changes). Note the function *counts* match,
so the index pairing is not misaligned here.

Consequences:

* There is no patch-diff signal in this kext: nothing Apple changed in 27.2,
  so no fix site to localize. Do not spend another cycle on a diff-based hunt
  here.
* The LEAD-ASSESSMENT §12 plan ("reconstruct the three input structs, then look
  for unvalidated length/offset fields") remains the only route, and now has
  exact entry addresses (§1 table) instead of the old `0x900bdf4`-style
  post-`bti c` guesses.

---

## 6. Correction: `vm_sk_deferred` register-fed call site (24B119 only)

`analysis/krw-leads/vm-sk-deferred-subsystem-2026-11-16.md` §2.2 listed the
only non-constant `w3` site as `0xfffffe000b39e0f4`, "origin unresolved", and
concluded the enqueue path looked "effectively unreachable from its direct
callers".

Resolved in 24B119 (raw `b119-defersite-b39e0f4.dis`):

```
0xfffffe000b39e0c0  lsr  w8, w1, #0xb
0xfffffe000b39e0c4  lsr  w9, w1, #5
0xfffffe000b39e0c8  and  w19, w9, #8
0xfffffe000b39e0cc  bfi  w19, w8, #0xc, #1     ; w19 = ((w1>>11)&1)<<12 | ((w1>>5)&1)<<3
...
0xfffffe000b39e0e8  mov  x3, x19
0xfffffe000b39e0f4  bl   0xfffffe000ad53d8c     ; the integrating UPL/pageout helper
```

So **bit 12 is supplied whenever input word `w1` has bit 11 set** — the
deferral enqueue is reachable from this caller, and §2.2's verdict should be
narrowed to "no caller supplies bit 12 as a constant; one computed site can".

Two boundaries on this: it is a 24B119 finding (the target build 24A446 has no
`vm_sk_deferred` subsystem and no `ad53d8c` at all), and it says the new code
is reachable, not that the old code had a bug. Also note the same VA
`0xb39e0f4` is an assertion block inside a *different* function in 24A446 —
a fresh instance of the standing "never carry a VA across builds" pitfall.

---

## 7. Appendix: cheap member census (`kz_memcensus.py`), unverified

Index-paired function-size census over all 301 members, 24A446 vs 24B119
(raw `memcensus.txt`). Top of the ranking:

| member | n | diffs | bytes |
|---|---:|---:|---:|
| `com.apple.iokit.IOSCSIArchitectureModelFamily` | 734 | 226 | 37784 |
| `com.apple.iokit.IOSkywalkFamily` | 2166 | 98 | 524 |
| `com.apple.driver.FairPlayIOKit` | 479 | 70 | 281812 |
| `com.apple.iokit.IOUSBHostFamily` | 1977 | 56 | 488 |
| `com.apple.driver.AppleUSBEthernetHost` | 109 | 31 | 2192 |
| `com.apple.iokit.IOBiometricFamily` | 509 | 28 | 608 |

**Treat as drift until verified.** Index pairing misaligns after any inserted
or removed function, so large counts (the first and third rows, above) are the
expected signature of misalignment, not of change. Known-real rows for
calibration: `IOSurface` (2 diffs / 24 B — matches the recorded notify-flag
fix) and `IOStorageFamily` (17 / 108 — the recorded bit-8 cluster). Any member
taken forward must be re-checked with `kc_member_diff.py` /
`kz_pair_shape_check.py`.

---

## 8. Verdict and next step

* Lead #2 stays **reconnaissance**: identity and close-path questions from
  Nov-08/Nov-14 are now answered, the dangling-client hypothesis is retired,
  and the kext is byte-identical across the two builds. No vulnerability is
  claimed and none is implied.
* Concrete next static step: field-by-field comparison of the three input
  structs (`0x58` / `0x1000` / `0xda0`) against
  `RequestHandling::decodeRequestValidation` (`0x902e2ac`) and
  `decodeHWRequestSetup` (`0x902ec88`) — i.e. which struct fields are copied
  into `JpegRequest` and whether each is range-checked before use as a length,
  count or offset. Entry points are now exact, so this no longer needs the
  old approximate addresses.
* Device work remains gated on the build host returning: the IOSurface notify
  private-connection probe (`--ionotify`, P1→P2→P3) is still the preferred
  first run.
