#!/usr/bin/env python3
"""Map a kext's own method-signature strings back to the functions that use them.

Apple kernelcache kexts embed one string per virtual method, e.g.
"virtual IOReturn AppleJPEGDriver::newUserClient(task_t, void *, UInt32,
OSDictionary *, IOUserClient **)".  Each such string is referenced from *inside
the method it describes* (passed to the kext's logger), so resolving every
ADRP+ADD / ADRP+LDR reference to those strings yields a symbol -> address map
for a completely stripped arm64e kext, with no symtab and no nlist.

Usage:
    python kz_sigmap.py <build> <member> <strings-file>

<strings-file> is a line-per-string dump: "<hex-va> <text>" (see
tools/opencode-temp/lifetime-triage/cstrings_*.txt).

Numpy-free; needs capstone and tools/opencode-temp/kc_iosurface.py.
"""
import sys, re, bisect
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "opencode-temp"))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "pylibs"))
from kc_member import load_member  # noqa: E402
import capstone                 # noqa: E402


def parse_strings(path):
    out = []
    for line in open(path, encoding="utf-8", errors="replace"):
        m = re.match(r"^(0x[0-9a-fA-F]+)\s?(.*)$", line.rstrip("\n"))
        if not m:
            continue
        txt = m.group(2)
        if "::" in txt and "(" in txt:
            out.append((int(m.group(1), 16), txt))
    return out


def adrp_targets(code, base_va, want):
    """Every ADRP+ADD / ADRP+LDR target in `code`, kept only if in `want`."""
    md = capstone.Cs(capstone.CS_ARCH_ARM64, capstone.CS_MODE_LITTLE_ENDIAN)
    md.skipdata = True
    md.detail = True
    hits = {}
    for ins in md.disasm(code, base_va):
        if ins.mnemonic != "adrp":
            continue
        rd = ins.operands[0].reg
        page = int(ins.operands[1].imm) & (2**64 - 1)
        nxt = None
        # peek the next instruction via a fresh one-shot disasm
        off = ins.address - base_va + 4
        if off + 4 <= len(code):
            nxt = next(md.disasm(code[off:off + 4], ins.address + 4), None)
        if nxt is None:
            continue
        tgt = None
        if nxt.mnemonic == "add" and nxt.operands[1].reg == rd \
                and nxt.operands[2].type == capstone.arm64.ARM64_OP_IMM:
            tgt = page + nxt.operands[2].imm
        elif nxt.mnemonic == "ldr" and nxt.operands[1].type == capstone.arm64.ARM64_OP_MEM \
                and nxt.operands[1].mem.base == rd:
            tgt = page + nxt.operands[1].mem.disp
        if tgt is not None and tgt in want and tgt not in hits:
            hits[tgt] = ins.address
    return hits


def main(argv):
    if len(argv) != 4:
        raise SystemExit(__doc__)
    build, member, sf = argv[1], argv[2], argv[3]
    b = load_member(build, member)
    st = b["starts"]
    entries = parse_strings(sf)
    want = {va for va, _ in entries}
    vm, vsz, fo, fsz = b["segs"]["__TEXT_EXEC"]
    code = b["data"][fo:fo + fsz]
    hits = adrp_targets(code, vm, want)

    def func_of(va):
        i = bisect.bisect_right(st, va) - 1
        return st[i] if i >= 0 else None

    for sva, txt in sorted(entries):
        site = hits.get(sva)
        f = func_of(site) if site else None
        print("0x%x  fn=%s  site=%s  %s" % (
            sva, ("0x%x" % f) if f else "?", ("0x%x" % site) if site else "?", txt))


if __name__ == "__main__":
    main(sys.argv)
