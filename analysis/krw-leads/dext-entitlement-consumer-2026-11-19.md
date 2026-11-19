# `IOServiceDEXTEntitlements` consumers located (and the IOSurface carveout names traced)

Date: 2026-11-19
Builds: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, target);
reference `firmware/24B119/kernelcache.release.macho` (iOS 27.2).
Tools added: `tools/kz-static-diff/kz_member_strrefs.py`,
`tools/kz-static-diff/kz_adrp_disp.py`; fixed the skipdata crash in
`tools/kz-static-diff/kz_fn_adrp.py`.
Raw output: `analysis/evidence/dext-key-consumers-2026-11-19/`,
`analysis/evidence/iosurface-memory-regions-2026-11-19/`.

**No device cycle.** The MacBook is unreachable (Tailscale `NoState`, SSH times
out) and no iPhone enumerates on this host, so nothing here was measured on
hardware. Everything below is static reading, marked proven / inferred /
unresolved. This pass executes the previous checkpoint's open static step
("locate the kernel-side consumer of `IOServiceDEXTEntitlements`") and adds one
bounded secondary observation on the IOSurface memory-region names.

---

## 1. Where the key string lives

`IOServiceDEXTEntitlements` occurs **7 times** in each build, never as code and
never twice in one member:

| build | file offset | member | segment | VA |
|---|---|---|---|---|
| 24A446 | `0xbd311` | `com.apple.kernel` | `__TEXT` | `0xfffffe00070c1311` |
| 24A446 | `0x41eef0` | `com.apple.driver.AppleFirmwareKit` | `__TEXT` | `0xfffffe0007422ef0` |
| 24A446 | `0x9abd31` | `com.apple.iokit.IOHIDFamily` | `__TEXT` | `0xfffffe00079afd31` |
| 24A446 | `0x9f6e09` | `com.apple.iokit.IOPCIFamily` | `__TEXT` | `0xfffffe00079fae09` |
| 24A446 | `0xa0cdf3` | `com.apple.iokit.IOSkywalkFamily` | `__TEXT` | `0xfffffe0007a10df3` |
| 24A446 | `0xa127a3` | `com.apple.iokit.IOStorageFamily` | `__TEXT` | `0xfffffe0007a167a3` |
| 24A446 | `0xad3f29` | `com.apple.iokit.IOUSBHostFamily` | `__TEXT` | `0xfffffe0007ad7f29` |

Each kext copy sits inside that kext's own embedded personality/property blob
(the surrounding bytes are key names such as `…_IVars`, `1121111111111111`,
`%s %s: Failed to init`), i.e. the per-member *declaration* of the property, not
its reader.

**Proven:** the only *code* reference to the kernel copy is a single site,
`0xfffffe000b300284`, inside the function `0xfffffe000b2ffb28` (size `0x114c`).
That function interns roughly ninety standard IOKit property keys into OSSymbol
objects and stores them in a global table based at `0xfffffe000b7b2000`:

| global | key |
|---|---|
| `+0x428` = `0xfffffe000b7b2428` | `IOUserClientEntitlements` |
| **`+0x910` = `0xfffffe000b7b2910`** | **`IOServiceDEXTEntitlements`** |
| `+0x758` = `0xfffffe000b7b2758` | `com.apple.developer.driverkit` |
| `+0x7a0` = `0xfffffe000b7b27a0` | `com.apple.developer.driverkit.userclient-access` |

It also interns `IOProviderClass`, `IONameMatch`, `IOUserServer`,
`com.apple.private.driverkit.driver-access`, `…allow-third-party-userclients`
and ~80 more. Raw: `dext_key_ctx.s`, `dext_key_ref.s`.

So the runtime reader never re-materialises the literal: it loads the interned
symbol. That is why a raw byte search plus a naive ADRP scan is the wrong tool
here and why the previous checkpoint recorded the enforcement site as "not
located".

## 2. Exact consumers — and a scanner false-positive corrected

A strict register-tracking scan (`kz_adrp_disp.py`: decode every `ADRP`, track
its page value per register, drop the entry when capstone reports that register
written, then report an `LDR`/`ADD` consuming it with displacement `0x910`)
finds **exactly five** sites that materialise `0xfffffe000b7b2910`:

| site | containing function | size |
|---|---|---|
| `0xfffffe000b3a31a4` | `0xfffffe000b3a3174` | `0x190` |
| `0xfffffe000b3a31f0` | `0xfffffe000b3a3174` | `0x190` |
| `0xfffffe000b3a6758` | `0xfffffe000b3a5fd0` | `0x928` |
| `0xfffffe000b3aeed4` | `0xfffffe000b3aedcc` | `0x184` |
| `0xfffffe000b3aef04` | `0xfffffe000b3aedcc` | `0x184` |

All three functions sit in the `0xb3axxxx` DriverKit/dext cluster:

* **`0xfffffe000b3a5fd0` is the already-known DriverKit user-client creation
  gate** — its string set is `root`,
  `com.apple.developer.driverkit.administrator`, `IOUserClientCreator`,
  `K_INFO` (`dext_key_ctx.s`). This independently reproduces the earlier record
  and now ties it to the interned key.
* **`0xfffffe000b3aedcc`** walks two dictionaries,
  `IOProviderMergeProperties` and `IOProviderParentMergeProperties`, looking up
  the interned key in each (`dext_c5.s`). It is the dext property-merge path.
* **`0xfffffe000b3a3174`** takes the key as `x1` and calls it through
  `[x1] vtable+0x138`, then calls `0xfffffe000b39f668` with `[this+0xe8]`
  (`dext_c3.s`).

**Corrected:** `kz_adrp_ref_np.py 24A446 0xfffffe000b7b2910` reports **seven**
sites, two of which (`0xb213420`, `0xb23b00c`) do **not** materialise that
address — in those instructions the base register is a value loaded from memory,
not the ADRP destination, so the tool invents the target. The five sites above
are the real ones. Recorded as a pitfall; `kz_adrp_disp.py` is the strict
replacement.

Both scanners had to be built carefully; two opposite failure modes were hit and
are encoded in the tools' comments:

* invalidating a written register **before** computing the target erases the
  source of a legitimate `add xD, xD, #imm` (the read and the write are the same
  register) and reports zero sites;
* invalidating **after** without re-applying the fresh value erases the ADRP's own
  destination and also reports zero.

The working order is: compute from the pre-instruction state, then drop every
written register, then re-apply the one value the instruction produces.

## 3. Reachability — still unresolved, but bounded to the dext cluster

None of `0xb3a3174`, `0xb3aedcc`, `0xb3a5fd0` nor the interner `0xb2ffb28` has a
direct `BL`/`B` caller anywhere in `com.apple.kernel` (member-wide capstone sweep
over `__TEXT_EXEC`). They are entered through virtual dispatch or function
pointers, so no app-facing ancestor is established here.

What did change is the *shape* of the answer: every consumer is a DriverKit/dext
property or user-server routine adjacent to the known
`driverkit.administrator` gate. Combined with the per-member declarations in §1,
the bit-8 cluster's gate is now **localised rather than inferred** — the reader
exists, it is this cluster, and nothing in it is reachable from an unsigned
carrier without a DriverKit entitlement.

**Not established:** that a non-DriverKit user client reuses any of these three
functions; that any of them is reachable from a MIG/syscall entry; that the 27.2
side differs (only 24A446 was scanned for consumers).

## 4. Secondary, bounded: the IOSurface memory-region names

Unrelated lead, recorded because it was measured in the same pass and it speaks
to the external-object ceiling.

`"ScalableMemory"` and `"PurpleGfxMem"` occur adjacently once, in
`com.apple.iokit.IOSurface` `__TEXT` at `0xfffffe0007a1fa08` /
`0xfffffe0007a1fa17` (plus `(unknown)` immediately after). Member-scoped
reference scan (`kz_member_strrefs.py`) finds exactly one reader each:

| function | size | role (from strings) |
|---|---:|---|
| `0xfffffe000a343034` | `0x294` | reads the DeviceTree `vram` property, matches each declared carveout name against `"PurpleGfxMem"`, formats `"%s%u"`, and logs `IOSurface: /vram declares %u carveout(s) but %u resolved; positions are ambiguous, installing none` / `…but none resolved` |
| `0xfffffe000a344e70` | `0x14c` | installs the `ScalableMemory` region; logs `Failed to install %s memory region; checking in anyway` |

**Proven:** both names are consumed by IOSurface's boot-time memory-region /
carveout installers, not by the per-surface create path. `PurpleGfxMem` is
therefore a DeviceTree-declared carveout installed by IOSurface at boot.

**Proven:** neither installer has any direct `BL`/`B` caller and neither appears
in an arm64e auth-pointer slot in `com.apple.iokit.IOSurface` (24A446), so their
entry mechanism is unresolved (indirect/boot-time).

**Inferred (not proven):** this is the mechanism behind the device measurement
that no allocator reachable from an unsigned app reclaims PurpleGfxMem pages
except the PurpleGfxMem region allocator itself — a dedicated carveout is not a
general-purpose pool. Treat as an explanation candidate, not as proof.

## 5. Verdict and next steps

* The `IOServiceDEXTEntitlements` **consumer question is closed**: one interned
  symbol, three reader functions, all in the DriverKit/dext cluster, one of
  which is the known `driverkit.administrator` gate. This does not promote the
  bit-8 cluster to a lead; it confirms the existing entitlement-gate reading
  with exact addresses instead of an inference.
* Tooling: `kz_member_strrefs.py` (member-scoped string-reference scan, closes
  the "annot.py only covers com.apple.kernel" gap), `kz_adrp_disp.py` (exact
  ADRP+displacement census), `kz_fn_adrp.py` no longer dies on SKIPDATA.
* **Next step (static, cheap):** resolve the entry mechanism of the three
  consumer functions (auth-table scan for `0xb3a3174` / `0xb3aedcc` /
  `0xb3a5fd0` across `__DATA_CONST`, and the `__LINKINFO` class strings of the
  `0xb3axxxx` cluster) to convert "all in the dext cluster" into "no
  app-reachable ancestor" — then close the bit-8 cluster outright.
* **Next step (device, when a host enumerates a phone):** unchanged and higher
  value — the IOSurface notify private-connection probe (selector `0x11` ABI is
  settled), then the stale-page race for the memory-entry route.

## Reproduction

```sh
python tools/kz-static-diff/kz_member_strrefs.py 24A446 com.apple.kernel 0xfffffe00070c1311
python tools/kz-static-diff/kz_adrp_disp.py 24A446 0xfffffe000b7b2000 0x910
python tools/opencode-temp/kc_str_refs.py 24A446 com.apple.kernel 0xfffffe000b2ffb28:0x114c
python tools/kz-static-diff/kz_member_dump.py 24A446 com.apple.iokit.IOSurface \
        0xfffffe000a343034 0x294 iosurf_region_a.s
python tools/kz-static-diff/kz_member_dump.py 24A446 com.apple.iokit.IOSurface \
        0xfffffe000a344e70 0x14c iosurf_region_b.s
```
