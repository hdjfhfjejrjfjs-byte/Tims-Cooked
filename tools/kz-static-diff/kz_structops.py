#!/usr/bin/env python3
"""Census the memory operands a function applies to one source structure pointer.

Useful for "which fields of this input struct does the entry point read, and
does any access run past the declared structureInputSize?" questions on a
stripped arm64e kext member.

The tracker seeds x1 (conventionally the input-struct argument), follows
`mov xD, xS` copies and `add xD, xS, #imm` derived pointers, and records every
LDR/STR/LD*/ST* whose base is still struct-derived.  A register written by any
other instruction drops out of the tracked set, except `ldp`/`stp`: a function
epilogue restores x19..x28 and the linear sweep then walks into later blocks,
so invalidating on those would under-report.  The tracker therefore
**over-approximates** -- a displacement may come from a stale derivation.
That is the safe direction for a bounds check: if even the over-approximated
maximum fits inside the declared structure size, the negative is meaningful.
Read any candidate site before believing it.

Numpy-free.  Usage:
    python kz_structops.py <build> <member> <hex-fn-start> <hex-size>
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "opencode-temp"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "pylibs"))
import capstone  # noqa: E402
from capstone.arm64 import ARM64_OP_REG, ARM64_OP_IMM, ARM64_OP_MEM  # noqa: E402
from kc_member import load_member, v2o  # noqa: E402

MD = capstone.Cs(capstone.CS_ARCH_ARM64, capstone.CS_MODE_LITTLE_ENDIAN)
MD.detail = True
MD.skipdata = True

MEMOPS = ("ldr", "ldrb", "ldrh", "ldrsb", "ldrsh", "ldrsw", "ldur",
          "str", "stur", "strb", "strh", "ldp", "stp")


def analyze(build, member, va, sz):
    b = load_member(build, member)
    d = b["data"]
    off = v2o(b, va)
    code = d[off:off + sz]
    deriv = {"x1": ("struct", 0)}
    hits = []
    for ins in MD.disasm(code, va):
        m = ins.mnemonic
        ops = ins.operands
        try:
            _, wregs = ins.regs_access()
            wr = {ins.reg_name(r) for r in wregs}
        except Exception:
            wr = set()
        if m == "mov" and len(ops) == 2 and ops[0].type == ARM64_OP_REG and ops[1].type == ARM64_OP_REG:
            src = ins.reg_name(ops[1].reg)
            dst = ins.reg_name(ops[0].reg)
            if src in deriv:
                deriv[dst] = deriv[src]
            else:
                deriv.pop(dst, None)
            continue
        if m == "add" and len(ops) >= 3 and ops[0].type == ARM64_OP_REG and ops[1].type == ARM64_OP_REG \
                and ops[2].type == ARM64_OP_IMM:
            src = ins.reg_name(ops[1].reg)
            dst = ins.reg_name(ops[0].reg)
            if src in deriv:
                deriv[dst] = (deriv[src][0], deriv[src][1] + ops[2].imm)
            else:
                deriv.pop(dst, None)
            continue
        if m not in ("ldp", "stp"):
            for r in wr:
                deriv.pop(r, None)
        if m in MEMOPS:
            mem = None
            for o in ops:
                if o.type == ARM64_OP_MEM:
                    mem = o.mem
                    break
            if mem is None:
                continue
            base = ins.reg_name(mem.base) if mem.base else None
            if base in deriv:
                bs, bd = deriv[base]
                if bs != "struct":
                    continue
                hits.append((ins.address, m, bd + mem.disp, ins.op_str))
    return hits


def main(argv):
    if len(argv) < 5:
        raise SystemExit(__doc__)
    build, member = argv[1], argv[2]
    va, sz = int(argv[3], 16), int(argv[4], 16)
    hits = analyze(build, member, va, sz)
    print("hits=%d maxdisp=%#x" % (len(hits), max((h[2] for h in hits), default=0)))
    for a, m, t, s in sorted(hits, key=lambda h: h[2]):
        print("%08x %-6s %#6x  %s" % (a, m, t, s))


if __name__ == "__main__":
    main(sys.argv)
