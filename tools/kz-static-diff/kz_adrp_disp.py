#!/usr/bin/env python3
"""Exact census of `adrp <page>` followed by `ldr/add #disp` on that register.

Why this exists (2026-11-19): `kz_adrp_ref_np.py` reports a hit for every
`ldr xT,[xN,#d]` whose displacement equals `target & 0xFFF` **when the scanner
happens to hold a page value for xN** -- but xN is frequently a pointer loaded
from memory, not the ADRP destination, so the reported address is invented.
Measured false positives on 24A446 for global 0xfffffe000b7b2910: three sites
(`0xb213420`, `0xb23b00c`, plus one more) that a strict back-scan shows never
materialise that address; only four sites do.

This tool decodes arm64 ADRP by hand (the encoding is fixed-width, so a linear
word sweep cannot desynchronise on literal pools the way capstone can) and then
looks forward a bounded window for an LDR (unsigned immediate) or ADD (immediate)
that consumes exactly that register with the requested displacement.

Usage:
    python kz_adrp_disp.py <build> <adrp_page_hex> <disp_hex>
    python kz_adrp_disp.py 24A446 0xfffffe000b7b2000 0x910

Numpy-free; needs tools/opencode-temp/kc_fstarts.py.
"""
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve()
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
from kc_fstarts import load_build  # noqa: E402

WINDOW = 16  # instructions scanned forward from the ADRP


def exec_segments(b):
    for nm, (vm, vsz, fo, fsz) in b["segs"].items():
        if "EXEC" in nm and fsz > 0x1000:
            yield nm, vm, fo, fsz


def main(argv):
    if len(argv) < 4:
        raise SystemExit(__doc__)
    build = argv[1]
    page = int(argv[2], 16) & ((1 << 64) - 1)
    disp = int(argv[3], 16)
    b = load_build(build)
    d = b["data"]
    hits = []
    for nm, vm, fo, fsz in exec_segments(b):
        i, end = fo, fo + fsz
        while i < end - 4:
            w = struct.unpack_from("<I", d, i)[0]
            if (w & 0x9F000000) == 0x90000000:  # ADRP
                rd = w & 0x1F
                immlo = (w >> 29) & 3
                immhi = (w >> 5) & 0x7FFFF
                imm = (immhi << 2) | immlo
                if imm & (1 << 20):
                    imm -= (1 << 21)
                tgt = ((vm + (i - fo)) & ~0xFFF) + (imm << 12)
                if (tgt & ((1 << 64) - 1)) == page:
                    for j in range(i + 4, min(i + 4 + WINDOW * 4, end - 4), 4):
                        w2 = struct.unpack_from("<I", d, j)[0]
                        if (w2 & 0xFFC00000) == 0xF9400000:  # LDR Xt,[Xn,#imm]
                            rn = (w2 >> 5) & 0x1F
                            if rn == rd and (((w2 >> 10) & 0xFFF) * 8) == disp:
                                hits.append((vm + (j - fo), nm, "ldr"))
                        elif (w2 & 0xFF800000) == 0x91000000:  # ADD Xd,Xn,#imm
                            rn = (w2 >> 5) & 0x1F
                            if rn == rd and ((w2 >> 10) & 0xFFF) == disp:
                                hits.append((vm + (j - fo), nm, "add"))
            i += 4
    print(f"{build}: adrp->{page:#x} + {disp:#x}: {len(hits)} exact sites")
    for va, nm, kind in hits:
        print(f"   {va:#x} {nm} ({kind})")


if __name__ == "__main__":
    main(sys.argv)
