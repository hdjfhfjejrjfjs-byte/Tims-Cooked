#!/usr/bin/env python3
"""Scan one fileset member's executable text for LDR/STR at given byte offsets.

Useful for "who reads/writes field +0xe0 of this object" questions when the
object type is already known from context.  Prints the containing
LC_FUNCTION_STARTS entry for every hit.

Usage:
    python kz_offops.py <build> <member> <hex-offset> [<hex-offset> ...]

Example:
    python kz_offops.py 24A446 com.apple.driver.AppleJPEGDriver 0xe0 0xd8
"""
import sys, bisect
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "opencode-temp"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "pylibs"))
from kc_member import load_member  # noqa: E402

FORMS = (
    (0xFFC00000, 0xF9000000, 8, "STR", "x"),
    (0xFFC00000, 0xF9400000, 8, "LDR", "x"),
    (0xFFC00000, 0xB9000000, 4, "STR", "w"),
    (0xFFC00000, 0xB9400000, 4, "LDR", "w"),
)


def main(argv):
    if len(argv) < 4:
        raise SystemExit(__doc__)
    build, member = argv[1], argv[2]
    offs = {int(x, 16) for x in argv[3:]}
    b = load_member(build, member)
    st = b["starts"]
    vm, vsz, fo, fsz = b["segs"]["__TEXT_EXEC"]
    code = b["data"][fo:fo + fsz]

    def func_of(va):
        i = bisect.bisect_right(st, va) - 1
        return st[i] if i >= 0 else None

    for i in range(0, len(code) - 4, 4):
        w = int.from_bytes(code[i:i + 4], "little")
        for mask, base, scale, kind, ty in FORMS:
            if (w & mask) != base:
                continue
            imm = ((w >> 10) & 0xFFF) * scale
            if imm not in offs:
                break
            va = vm + i
            print("%s %s rt=x%d rn=x%d off=0x%x  @0x%x  fn=0x%x" % (
                kind, ty, w & 0x1F, (w >> 5) & 0x1F, imm, va, func_of(va)))
            break


if __name__ == "__main__":
    main(sys.argv)
