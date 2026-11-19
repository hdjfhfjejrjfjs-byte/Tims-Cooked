# Equal-function-count member sweep — and the IOStorageFamily half of the bit-8 mask (2026-11-19)

Date: 2026-11-19
Builds: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, target) and
`firmware/24B119/kernelcache.release.macho` (iOS 27.2).
Tools added: `tools/kz-static-diff/kz_slot_table.py`,
`tools/kz-static-diff/kz_mask_vas.py`.
Raw output: `analysis/evidence/member-shape-diff-2026-11-19/`.

**No device cycle.** Tailscale is `NoState` (coordination server unreachable from
this network), SSH to the build host times out, and the PC-side usbmux endpoint
enumerates zero devices, so nothing here was measured on hardware. Everything
below is static reading, marked proven / inferred / unresolved.

---

## 1. What was open

`analysis/krw-leads/iosurface-scalable-memory-region-2026-11-15.md` §Appendix
listed ten fileset members whose `LC_FUNCTION_STARTS` count is unchanged between
builds (`cntΔ = 0`) while their paired function sizes differ, and stated:

> No member in this table has been examined semantically yet; nothing here is a
> vulnerability claim.

That is the cheapest unexamined fix-site frontier, so it was taken first.

## 2. Result of the shape sweep — and why its counts cannot be used for ranking

`kz_shape_diff.py <member>` (instruction **shapes**: mnemonic + register
operands + memory base, every immediate and displacement masked) on all ten
members gave:

| member | funcs A/B | reported real-edits |
|---|---:|---:|
| `com.apple.iokit.IOSCSIArchitectureModelFamily` | 734 / 734 | 4 |
| `com.apple.driver.AppleUSBEthernetHost` | 109 / 109 | 2 |
| `com.apple.driver.DiskImages.UDIFDiskImage` | 191 / 191 | 11 |
| `com.apple.iokit.IOBiometricFamily` | 509 / 509 | 28 |
| `com.apple.iokit.IOStorageFamily` | 563 / 563 | 18 |
| `com.apple.iokit.IOPCIFamily` | 723 / 723 | 17 |
| `com.apple.driver.AppleARMPlatform` | 2238 / 2238 | 19 |
| `com.apple.driver.FairPlayIOKit` | 479 / 479 | 73 |
| `com.apple.iokit.IOUSBHostFamily` | 1977 / 1977 | 59 |
| `com.apple.iokit.IOSkywalkFamily` | 2166 / 2166 | 108 |

**These numbers are not trustworthy, and must not be used to rank anything.**
Re-running the established two-stage pipeline
(`kz_newfunc_align.py` index pairing → `kz_pair_shape_check.py`) on the same
members gives materially different answers:

```
com.apple.iokit.IOSkywalkFamily:   blocks drift=138 real=16     (kz_shape_diff said real=108)
com.apple.iokit.IOStorageFamily:  blocks drift=56  real=2      (kz_shape_diff said real=18)
```

Cause: `kz_shape_diff.py` aligns whole-member function lists with
`difflib.SequenceMatcher` over shape tuples. Members with many near-identical
bodies (Skywalk alone has hundreds of copy-paste thunks) match against a
*duplicate* rather than the true counterpart, and every such mispair is counted
as a shape edit. This is the same failure the project already recorded for
index pairing of `LC_FUNCTION_STARTS` sizes, now demonstrated for shape pairing.
Raw: `skywalk_newfunc.txt`, `skywalk_paircheck.txt`, `stor_newfunc.txt`,
`stor_paircheck.txt`.

Consequence for the frontier: the appendix list stays **unranked**. Nothing in
§2 is evidence that any of these ten members carries a fix.

## 3. The one solid result — IOStorageFamily gains 16 bit-8 mask sites

Independent of the unreliable counter, a direct census settles one member.

`kz_mask_by_member.py` re-run this session (reproduces the published 34 → 477
image-wide growth):

| member | 24A446 | 24B119 | Δ |
|---|---:|---:|---:|
| `com.apple.kernel` | 16 | 169 | +153 |
| `com.apple.iokit.IOSkywalkFamily` | 0 | 107 | +107 |
| `com.apple.iokit.IOUSBHostFamily` | 0 | 48 | +48 |
| `com.apple.iokit.IOHIDFamily` | 0 | 31 | +31 |
| `com.apple.driver.AppleCentauriManager` | 0 | 17 | +17 |
| **`com.apple.iokit.IOStorageFamily`** | **0** | **16** | **+16** |
| `com.apple.driver.AppleARMPlatform` | 0 | 16 | +16 |
| `com.apple.iokit.IOPCIFamily` | 0 | 16 | +16 |
| `com.apple.driver.corecapture` | 0 | 13 | +13 |
| `com.apple.iokit.IOTimeSyncFamily` | 0 | 13 | +13 |
| `com.apple.driver.AppleFirmwareKit` | 0 | 13 | +13 |
| `com.apple.filesystems.apfs` | 9 | 9 | 0 |
| `com.apple.driver.AppleAVE2` | 1 | 1 | 0 |
| `com.apple.filesystems.lifs` | 1 | 1 | 0 |
| `com.apple.AGXG18P` | 1 | 1 | 0 |
| `com.apple.driver.AppleProcessorTrace` | 6 | 6 | 0 |

### 3.1 All 16 sites are one inserted statement (proven)

`kz_mask_vas.py 24B119 com.apple.iokit.IOStorageFamily` prints all 16 sites with
their context. Every one is byte-for-byte the same four-instruction statement,
differing only in register allocation:

```asm
ldr  xA, [arg, #0x18]
ldr  xB, [xA, #8]
and  xB, xB, #0xfffffffffffffeff   ; clear bit 8
str  xB, [xA, #8]
```

Site addresses: `0xfffffe000a36da34`, `0xfffffe000a36db20`,
`0xfffffe000a36dbf8`, `0xfffffe000a36dc8c`, `0xfffffe000a36dd28`, and twelve
more listed in `mask_stor_sites.txt`. Containing functions:
`0xfffffe000a36da00`, `...daec`, `...dbd8`, `...dc6c`, `...dcf8`,
`0xfffffe000a36f078`, `...f120`, `...f1d0`, `...f290`, `...f338`, `...f3e0`,
`...f488`, `...f530`, `...f5d8`, `...f680`, `...f728`.

In 24A446 none of these sixteen wrappers contains any `and #~0x100`; the
counterpart function (`0xfffffe000a31f66c`, `0xfffffe000a31f754`, …) goes
straight from loading the descriptor to validating it. Raw:
`stor_sem.txt`, `stor_sem2.txt`, `stor_A.raw`, `stor_B.raw`.

### 3.2 The wrappers' shape (proven)

Each is a per-selector validation wrapper of the form already described for the
HID/Skywalk families:

* default return baked as `kIOReturnIPCError` (`0xE00002BF`);
* validates `[descriptor+0x10]` and `[descriptor+0x14]` against member-specific
  minimums (e.g. `>= 0x8c` / `>= 0x3c`, another `>= 0x74`);
* validates `[[descriptor+0x00]+0x20] == 2` and `[sub+0x10] == 2`;
* calls through a global slot, then tail-calls an implementation by
  authenticated pointer (`blraa`, discriminator `0xbcad`);
* on success fills an output block with constants (`+4 = 0x3c`, a 16-byte
  constant at `+0x24`, an 8-byte constant at `+0x1c`, zero at `+0x34`).

The 27.2 change inserts the bit-8 clear **before** those validations.

### 3.3 Reachability — unresolved, and one route examined

* The wrapper family is reached from a single 0x30-byte thunk
  `0xfffffe000a31f3c4`, called by exactly one caller
  (`0xfffffe000a31f594`, inside the cookie dispatcher `0xfffffe000a31f3f4`).
* `kz_blw_scan.py 24A446 0xfffffe000a31f66c` → 1 direct `BL`
  (`0xfffffe000a31f594`); `kz_blw_scan.py 24A446 0xfffffe000a31f3f4` → 1 direct
  `BL` (`0xfffffe000a31f3e4`, the thunk).
* `kz_member_authscan.py 24A446 com.apple.iokit.IOStorageFamily
  0xfffffe000a31f3c4` → exactly **one** low-32 auth slot points at the thunk,
  `__DATA_CONST 0xfffffe0008375fa8`.
* That address is the **first entry** of its run: `kz_iomethod_table.py --find`
  walks back 0 entries and entry 1 does not decode as
  `IOExternalMethodDispatch2022`, so this is **not** a 2022 external-method
  table. `kz_slot_table.py` shows the surrounding qwords are a mix of decoded
  code targets and values whose low 32 bits fall outside the member's
  `__TEXT_EXEC`, i.e. a plain pointer array with mixed content.
* **Unresolved:** the owning class, the object that `[descriptor+0x18]` names,
  and whether any user-client selector reaches the thunk. No string is
  referenced from the wrapper or the dispatcher, so there is no naming handle.

### 3.4 Why this is not yet a lead

Two independent reasons, both proven:

1. **The constant is not a fingerprint.** `com.apple.filesystems.apfs` carries 9
   `and #~0x100` sites in **both** builds, scattered across unrelated functions
   (`apfs_pfk_init`, keybag notifications, `apfs_setxattr_internal`,
   xattr-name handling, …) — different objects, different offsets. So the
   pre-existing population of the constant (34 image-wide) is ordinary
   bit-clearing, and only the *systematic insertion pattern* in 3.1 marks the
   IOStorageFamily sites as one deliberate change. Raw: `mask_apfs_A.txt`.
2. **Bit 8's meaning is still unknown**, exactly as recorded for the kernel-core
   and HID halves of the cluster. Clearing a bit in a state word before a
   validation can equally be a security fix, a refactor, or routine
   bookkeeping; nothing here distinguishes them.

Verdict: **bounded reconnaissance.** The mask census now covers the storage
stack, and the IOStorageFamily insertion is the cleanest single-object example
found so far (16 identical statements, one wrapper family, no string drift).
No vulnerability claim, no exploitability claim, no device measurement.

## 4. Next steps

1. Do **not** spend further cycles on `kz_shape_diff.py` counts for ranking;
   fix its alignment (or retire it in favour of
   `kz_newfunc_align.py` + `kz_pair_shape_check.py`). Record the contradiction.
2. To promote the IOStorageFamily site to a lead, name the object behind
   `[descriptor+0x18]`: find the class via the `OSMetaClass` constructor recipe
   from whatever table holds `0xfffffe0008375fa8`, then walk to a user-client
   selector or MIG/syscall ancestor. Only then design a device probe.
3. If a device becomes available first, the higher-value run remains the
   IOSurface notify private-connection probe (previous checkpoint's next step).
4. Secondary: settle whether the `-0x10` uniform shrink in IOBiometricFamily
   (28 blocks) is a source-level removal or recompilation drift; its semantic
   diff is dominated by string-table offsets/lengths, which points to the
   latter, but only one pair (`bio_sem.txt`) was inspected.

## Reproduction

```
python tools/kz-static-diff/kz_shape_diff.py <member>
python tools/kz-static-diff/kz_newfunc_align.py com.apple.iokit.IOSkywalkFamily
python tools/kz-static-diff/kz_pair_shape_check.py com.apple.iokit.IOSkywalkFamily skywalk_newfunc.txt
python tools/kz-static-diff/kz_mask_by_member.py 25
python tools/kz-static-diff/kz_mask_sites.py 24B119 com.apple.iokit.IOStorageFamily
python tools/kz-static-diff/kz_mask_vas.py 24B119 com.apple.iokit.IOStorageFamily --ctx 4
python tools/kz-static-diff/kz_fn_sem_diff.py com.apple.iokit.IOStorageFamily \
        0xfffffe000a31f66c 0xfffffe000a36da00 0xe8 0xec
python tools/kz-static-diff/kz_slot_table.py 24A446 com.apple.iokit.IOStorageFamily \
        0xfffffe0008375fa8 12 --back 4
```
