#!/usr/bin/env python3
"""Exact census of `adrp <page>` + `ldr/add #disp` sites that materialise an address.

Why this exists (2026-11-19): `kz_adrp_ref_np.py` reports a hit for every
`ldr xT,[xN,#d]` whose displacement matches the low bits of the target **when the
scanner holds any page value for xN** -- but xN is frequently a pointer loaded
from memory, not the ADRP destination, so the target is invented. Measured on
24A446 for global `0xfffffe000b7b2910`: the heuristic listed seven sites and
several were not real references.

This tool disassembles with capstone (`skipdata=True`), tracks ADRP page values
per register, and **drops the entry whenever capstone reports that register as
written** (`regs_access`), so an ADRP page cannot leak into an unrelated later
load. It then reports every LDR (unsigned immediate) or ADD (immediate) that
consumes the tracked register with the requested displacement.

Usage:
    python kz_adrp_disp.py <build> <adrp_page_hex> <disp_hex>
    python kz_adrp_disp.py 24A446 0xfffffe000b7b2000 0x910

Numpy-free; needs capstone and tools/opencode-temp/kc_fstarts.py.
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve()
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))

import capstone  # noqa: E402
from capstone import CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN  # noqa: E402
from capstone.arm64 import ARM64_OP_REG, ARM64_OP_IMM, ARM64_OP_MEM  # noqa: E402
from kc_fstarts import load_build  # noqa: E402

MASK = (1 << 64) - 1


def exec_segments(b):
    for nm, (vm, vsz, fo, fsz) in b["segs"].items():
        if "EXEC" in nm and fsz > 0x1000:
            yield nm, vm, fo, fsz


def main(argv):
    if len(argv) < 4:
        raise SystemExit(__doc__)
    build = argv[1]
    page = int(argv[2], 16) & MASK
    disp = int(argv[3], 16)
    b = load_build(build)
    d = b["data"]
    md = capstone.Cs(CS_ARCH_ARM64, CS_MODE_LITTLE_ENDIAN)
    md.detail = True
    md.skipdata = True
    hits = []
    for nm, vm, fo, fsz in exec_segments(b):
        pages = {}
        for ins in md.disasm(d[fo:fo + fsz], vm):
            try:
                ops = ins.operands
            except capstone.CsError:
                # SKIPDATA pseudo-instruction: keep tracked pages so a literal
                # pool inside a function cannot hide later references
                continue
            m = ins.mnemonic
            # compute from the pre-instruction state first (an instruction may
            # read and write the same register, e.g. `add xD, xD, #imm`)
            tgt = None
            newent = None
            if m == "adrp" and len(ops) >= 2 and ops[1].type == ARM64_OP_IMM:
                newent = (ins.reg_name(ops[0].reg), ops[1].imm & MASK)
            elif m == "add" and len(ops) >= 3 and ops[1].type == ARM64_OP_REG \
                    and ops[2].type == ARM64_OP_IMM:
                base = pages.get(ins.reg_name(ops[1].reg))
                if base is not None:
                    tgt = (base + ops[2].imm) & MASK
                    newent = (ins.reg_name(ops[0].reg), tgt)
            elif m in ("ldr", "ldur") and len(ops) >= 2 and ops[1].type == ARM64_OP_MEM:
                base = pages.get(ins.reg_name(ops[1].mem.base))
                if base is not None:
                    tgt = (base + ops[1].mem.disp) & MASK
            if tgt is not None and tgt == page + disp:
                hits.append((ins.address, nm, m))
            try:
                _, written = ins.regs_access()
            except (capstone.CsError, ValueError):
                written = ()
            for r in written:
                pages.pop(md.reg_name(r), None)
            if newent is not None:
                pages[newent[0]] = newent[1]
    print(f"{build}: adrp->{page:#x} + {disp:#x}: {len(hits)} exact sites")
    for va, nm, m in hits:
        print(f"   {va:#x} {nm} ({m})")


if __name__ == "__main__":
    main(sys.argv)
