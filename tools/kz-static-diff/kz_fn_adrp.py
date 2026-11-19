#!/usr/bin/env python3
"""List every absolute address a single function builds with ADRP+ADD / LDR.

Motivation (2026-11-16): naming a stripped C++ class from an arm64e vtable
needs the class-name string reference, but the existing tools only answer
"who references address X" (`kz_adrp_ref_np.py`) over the whole image. To
find *which* strings a candidate vtable method references, we need the
inverse: all addresses a function materialises. `kz_fn_strings.py` cannot
do it because `kc_fstarts.func_of` only indexes the `com.apple.kernel`
fileset entry, so it reports "no start" for every kext-member function — a
false negative that silently reads as "this function references nothing".

Usage:
    python kz_fn_adrp.py <build> <member> <va_hex> <size_hex> [lo_hex hi_hex]

`lo`/`hi` optionally restrict output to a VA window (e.g. the member's own
string region). Without them every ADRP+ADD/LDR target is printed.
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))

import capstone  # noqa: E402
from capstone import CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from kc_member import load_member, v2o  # noqa: E402

MD = capstone.Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
MD.detail = True
MD.skipdata = True

IMM = capstone.arm64.ARM64_OP_IMM
MEM = capstone.arm64.ARM64_OP_MEM
REG = capstone.arm64.ARM64_OP_REG
SP = capstone.arm64.ARM64_REG_SP
WRITERS = {"mov", "movz", "movk", "movn", "orr", "and", "eor", "bic",
           "sub", "subs", "ldr", "ldrb", "ldrh", "ldrsw", "ldp", "ldnp",
           "ldur", "ldursw", "sxtw", "uxtw"}


def u(x):
    return x & ((1 << 64) - 1)


def sx(v, bits):
    return v - (1 << bits) if v & (1 << (bits - 1)) else v


def main(argv):
    if len(argv) < 5:
        raise SystemExit(__doc__)
    bld, member = argv[1], argv[2]
    va, size = int(argv[3], 16), int(argv[4], 16)
    lo = int(argv[5], 16) if len(argv) > 5 else None
    hi = int(argv[6], 16) if len(argv) > 6 else None
    b = load_member(bld, member)
    off = v2o(b, va)
    blob = b["data"][off:off + size]
    pages = {}
    hits = []
    for ins in MD.disasm(blob, va):
        m = ins.mnemonic
        try:
            ops = ins.operands
        except capstone.CsError:
            # SKIPDATA pseudo-instruction: no operands. Without this guard the
            # whole pass dies mid-function and reads as "this function has no
            # references".
            continue
        if m == "adrp":
            # capstone already resolves the ADRP page address into .imm
            pages[ops[0].reg] = u(ops[1].imm)
            continue
        if m == "add" and len(ops) == 3 and ops[2].type == IMM:
            rn = ops[1].reg
            if rn in pages:
                tgt = u(pages[rn] + ops[2].imm)
                hits.append((ins.address, "add", tgt))
                pages[ops[0].reg] = tgt
                continue
        if m in ("ldr", "ldrb", "ldrh", "ldrsw") and len(ops) == 2 and ops[1].type == MEM:
            rn = ops[1].mem.base
            if rn in pages:
                hits.append((ins.address, m, u(pages[rn] + ops[1].mem.disp)))
        if m in WRITERS and ops and ops[0].type == REG and ops[0].reg != SP:
            pages.pop(ops[0].reg, None)
    for site, kind, tgt in hits:
        if lo is not None and not (lo <= tgt <= hi):
            continue
        print(f"{site:#x} {kind:5s} -> {tgt:#x}")


if __name__ == "__main__":
    main(sys.argv)
