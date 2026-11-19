#!/usr/bin/env python3
"""Exact VA of every `and xD, xN, #0xfffffffffffffeff` site in a member.

`kz_mask_sites.py` reports the containing function start and string refs. This
prints the precise site address so a write-up can cite it, and the instruction
window around it so the masked field's base register/offset is visible.

Usage:
    python kz_mask_vas.py 24B119 com.apple.iokit.IOStorageFamily [--ctx 3]
"""
import argparse
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))
import capstone  # noqa: E402
from capstone import CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from capstone.arm64 import ARM64_OP_IMM  # noqa: E402
from kc_member import load_member, v2o, func_of  # noqa: E402

MD = capstone.Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
MD.detail = True
MD.skipdata = True
MASK = 0xFFFFFFFFFFFFFEFF


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("build")
    ap.add_argument("member")
    ap.add_argument("--ctx", type=int, default=3)
    args = ap.parse_args()

    b = load_member(args.build, args.member)
    data, segs = b["data"], b["segs"]
    te = segs.get("__TEXT_EXEC")
    if te is None:
        raise SystemExit("no __TEXT_EXEC")
    te_vm, _, te_fo, te_sz = te
    start, end = te_fo, te_fo + te_sz

    print("# %s %s: sites of `and ...,#0x%x`" % (args.build, args.member, MASK))
    va = te_vm
    off = start
    while off < end:
        ins = next(MD.disasm(data[off:off + 4], va), None)
        if ins is None:
            off += 4
            va += 4
            continue
        hit = (ins.mnemonic == "and" and len(ins.operands) == 3
               and ins.operands[2].type == ARM64_OP_IMM
               and (ins.operands[2].imm & MASK) == MASK)
        if hit:
            f = func_of(b, va)
            lo = max(start, off - 4 * args.ctx)
            print("\n; site %#x  fn %s" % (
                va, ("%#x sz %#x" % (f[0], f[1])) if f else "unknown"))
            for x in MD.disasm(data[lo:off + 8], te_vm + (lo - start)):
                mark = "  <== AND" if x.address == va else ""
                print("  %#018x  %-9s %s%s" % (x.address, x.mnemonic, x.op_str, mark))
        off += 4
        va += 4


if __name__ == "__main__":
    main()
