#!/usr/bin/env python3
"""Find code sites in one kernelcache fileset member that build a given VM address.

`kz_adrp_ref_np.py` scans only the outer MH_FILESET container's LC_SEGMENT_64
table, so it silently misses every kext-member address (members carry their own
absolute file offsets). This variant walks the named member's own segments and
reports every ADRP+ADD / ADRP+LDR pair in its executable segments that targets
the requested VA, bracketed against that member's LC_FUNCTION_STARTS.

Usage:
    python kz_member_strrefs.py <build> <member-name-substring> <va_hex> [<va_hex> ...]

Example:
    python kz_member_strrefs.py 24A446 IOSurface 0xfffffe0007a1fa08

Numpy-free; needs capstone and tools/opencode-temp/kc_iosurface.py.
"""
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve()
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))

import capstone  # noqa: E402
from kc_iosurface import parse_fileset, member_load_commands, member_segments  # noqa: E402

MASK = (1 << 64) - 1


def member_entry(data, name_sub):
    entries, _ = parse_fileset(data)
    for e in entries:
        if name_sub in e["name"]:
            return e
    raise SystemExit(f"no member matching {name_sub!r}")


def func_starts(data, foff):
    out = []
    for cmd, eoff, cmdsize in member_load_commands(data, foff):
        if cmd != 0x26:  # LC_FUNCTION_STARTS
            continue
        dataoff = struct.unpack_from("<I", data, eoff + 8)[0]
        size = struct.unpack_from("<I", data, eoff + 12)[0]
        p, end, addr = dataoff, dataoff + size, 0
        while p < end:
            val = shift = 0
            while True:
                b = data[p]
                p += 1
                val |= (b & 0x7F) << shift
                if not (b & 0x80):
                    break
                shift += 7
            if val == 0:
                break
            addr += val
            out.append(addr)
    return sorted(out)


def exec_segments(segs):
    for nm, (vm, vsz, fo, fsz) in segs.items():
        if fsz and fsz > 0x1000 and ("EXEC" in nm or nm == "__TEXT"):
            yield nm, vm, fo, fsz


def bisect_func(starts, va):
    import bisect
    i = bisect.bisect_right(starts, va) - 1
    if i < 0:
        return None
    s = starts[i]
    nxt = starts[i + 1] if i + 1 < len(starts) else s + 0x4000
    return s, nxt


def main(argv):
    if len(argv) < 4:
        raise SystemExit(__doc__)
    build, name_sub = argv[1], argv[2]
    targets = {int(a, 16) for a in argv[3:]}
    d = (ROOT / "firmware" / build / "kernelcache.release.macho").read_bytes()
    e = member_entry(d, name_sub)
    segs = member_segments(d, e["fileoff"])
    starts = [e["vmaddr"] + s for s in func_starts(d, e["fileoff"])]
    md = capstone.Cs(capstone.CS_ARCH_ARM64, capstone.CS_MODE_LITTLE_ENDIAN)
    md.detail = True
    md.skipdata = True
    print(f"{build} member {e['name']} fileoff={e['fileoff']:#x} funcs={len(starts)}")
    for nm, vm, fo, fsz in exec_segments(segs):
        code = d[fo:fo + fsz]
        page = {}  # page reg -> base page value
        for ins in md.disasm(code, vm):
            m = ins.mnemonic
            try:
                ops = ins.operands
            except capstone.CsError:
                # SKIPDATA pseudo-instruction: no operands. Keep the tracked
                # pages -- clearing them here would silently drop references
                # that appear after a literal pool inside the same function.
                continue
            # compute the target from the pre-instruction state first: an
            # instruction may both read and write the same register
            # (`add xD, xD, #imm`), so invalidating before the lookup would
            # erase a legitimate source.
            tgt = None
            newent = None
            if m == "adrp":
                if len(ops) >= 2:
                    newent = (ins.reg_name(ops[0].reg), ops[1].imm & MASK)
            elif m == "add" and len(ops) >= 3 and ops[1].type == capstone.arm64.ARM64_OP_REG \
                    and ops[2].type == capstone.arm64.ARM64_OP_IMM:
                base = page.get(ins.reg_name(ops[1].reg))
                if base is not None:
                    tgt = (base + ops[2].imm) & MASK
                    newent = (ins.reg_name(ops[0].reg), tgt)
            elif m in ("ldr", "ldur") and len(ops) >= 2 and ops[1].type == capstone.arm64.ARM64_OP_MEM:
                base = page.get(ins.reg_name(ops[1].mem.base))
                if base is not None:
                    tgt = (base + ops[1].mem.disp) & MASK
            if tgt is not None and tgt in targets:
                f = bisect_func(starts, ins.address)
                print(f"  {m} @{ins.address:#x} seg={nm} -> {tgt:#x} in func {f}")
            # now drop every register this instruction writes, then re-apply
            # the value it produces (an ADRP/ADD destination still holds its
            # fresh page/target afterwards)
            try:
                _, written = ins.regs_access()
            except (capstone.CsError, ValueError):
                written = ()
            for r in written:
                page.pop(md.reg_name(r), None)
            if newent is not None:
                page[newent[0]] = newent[1]


if __name__ == "__main__":
    main(sys.argv)
