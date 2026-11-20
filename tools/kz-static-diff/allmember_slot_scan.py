#!/usr/bin/env python3
"""Whole-fileset raw arm64e pointer-slot scan for one or more target VAs.

Why this exists: `kz_ptr_slots.py` / `kz_rawslot.py` take a single fileset member, and
`kc_fstarts.load_build` exposes only `com.apple.kernel`, so a scan built on either
silently reports zero for a reference that lives in a *different* member's data. This
script walks every `LC_FILESET_ENTRY` member's segments and searches each segment blob
for:

  * the low-32 pattern `(target - __TEXT_vmaddr)`, which is how an arm64e auth slot
    encodes its target on iOS 27 (`DYLD_CHAINED_PTR_64_KERNEL_CACHE` format 8), and
  * the full 64-bit VA (plain/rebase slots).

`__TEXT_vmaddr` is member-local; on the 27.0.1 cache the members share
`0xfffffe000700c000`. Validate against a slot you already know before believing an
empty result -- e.g. `python allmember_slot_scan.py 24A446 0xfffffe000a3273c4`
must report the `com.apple.iokit.IOStorageFamily` `__DATA_CONST` slot at
`0xfffffe0008375fa8`.

Usage:
    python allmember_slot_scan.py <build> <hex-va> [hex-va ...]
"""
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))

from kc_iosurface import parse_fileset, member_segments  # noqa: E402


def main(argv):
    if len(argv) < 3:
        raise SystemExit(__doc__)
    build = argv[1]
    targets = [int(x, 16) for x in argv[2:]]
    path = ROOT / "firmware" / build / "kernelcache.release.macho"
    data = path.read_bytes()
    entries, _ = parse_fileset(data)

    wins = []
    for e in entries:
        try:
            segs = member_segments(data, e["fileoff"])
        except Exception:
            continue
        for nm, (vm, vsz, fo, fsz) in segs.items():
            if fsz == 0 or fsz > len(data):
                continue
            wins.append((e["name"], nm, vm, vsz, fo, fsz))

    ktext = next((vm for name, nm, vm, *_ in wins
                  if name == "com.apple.kernel" and nm == "__TEXT"), None)
    print(f"build={build} members={len(entries)} kernel__TEXT={ktext and hex(ktext)}")

    for t in targets:
        lo = (t - ktext) & 0xFFFFFFFF
        pat_lo = struct.pack("<I", lo)
        pat_va = struct.pack("<Q", t)
        hits = []
        for name, nm, vm, vsz, fo, fsz in wins:
            blob = data[fo:fo + fsz]
            for pat, kind in ((pat_lo, "slot32"), (pat_va, "va64")):
                start = 0
                while True:
                    i = blob.find(pat, start)
                    if i < 0:
                        break
                    hits.append((kind, name, nm, vm + i))
                    start = i + 1
        print(f"\ntarget {t:#x} : {len(hits)} hits")
        for h in hits[:20]:
            print("   ", h)


if __name__ == "__main__":
    main(sys.argv)
