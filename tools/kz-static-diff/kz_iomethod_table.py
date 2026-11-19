#!/usr/bin/env python3
"""Dump an IOExternalMethodDispatch2022 table out of an Apple MH_FILESET kernelcache.

iOS 27 kernelcache kexts use `IOExternalMethodDispatch2022`:

    struct IOExternalMethodDispatch2022 {
        IOExternalMethodAction function;          // +0x00
        uint32_t checkScalarInputCount;           // +0x08
        uint32_t checkStructureInputSize;         // +0x0c
        uint32_t checkScalarOutputCount;          // +0x10
        uint32_t checkStructureOutputSize;        // +0x14
        uint8_t  allowAsync;                      // +0x18
        const char *checkEntitlement;             // +0x20
    };                                            // sizeof == 0x28 on arm64

Table entries are stored in a member's __DATA_CONST as arm64e "auth jump table"
qwords: the low 32 bits are the *file offset* of the target inside the member's
__TEXT_EXEC, the high 32 bits carry the PAC signature/diversity. Plain
low-48-bit address comparisons find nothing, and assuming a 0x18 stride lands
mid-entry, so both traps are easy to hit.

Usage:
    python kz_iomethod_table.py 24A446 com.apple.iokit.IOSurface --find 0xfffffe000a3498f4
    python kz_iomethod_table.py 24A446 com.apple.iokit.IOSurface \
            --base 0xfffffe000837fa10 --count 60

Builds: 24A446 (iOS 27.0.1, target) and 24B119 (iOS 27.2).
No third-party imports; capstone is not needed here.
"""
import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
KC = {
    "24A446": REPO / "firmware" / "24A446" / "kernelcache.release.macho",
    "24B119": REPO / "firmware" / "24B119" / "kernelcache.release.macho",
}
LC_SEGMENT_64 = 0x19
LC_FILESET_ENTRY = 0x80000035


def cstring_at(data, off, limit=512):
    end = data.find(b"\x00", off, off + limit)
    return data[off:end if end >= 0 else off + limit].decode("ascii", "replace")


def member_segments(data, name):
    """Return (segments, textexec_vm, textexec_fo) for a fileset member."""
    magic = struct.unpack_from("<I", data, 0)[0]
    if magic != 0xFEEDFACF:
        raise SystemExit("not a Mach-O 64 file")
    ncmds = struct.unpack_from("<I", data, 16)[0]
    off = 32
    base_vm = base_fo = None
    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", data, off)
        if cmdsize == 0:
            break
        if cmd == LC_FILESET_ENTRY:
            vmaddr, fileoff = struct.unpack_from("<QQ", data, off + 8)
            if cstring_at(data, off + 32) == name:
                base_vm, base_fo = vmaddr, fileoff
                break
        off += cmdsize
    if base_vm is None:
        raise SystemExit("member %r not found" % name)

    _, _, _, _, mncmds, _, _, _ = struct.unpack_from("<IiiIIIII", data, base_fo)
    eoff = base_fo + 32
    segs = []
    te = None
    for _ in range(mncmds):
        cmd, cmdsize = struct.unpack_from("<II", data, eoff)
        if cmdsize == 0:
            break
        if cmd == LC_SEGMENT_64:
            segname = data[eoff + 8:eoff + 24].split(b"\x00", 1)[0].decode()
            vmaddr, vmsize, fileoff, filesize = struct.unpack_from("<QQQQ", data, eoff + 24)
            segs.append((segname, vmaddr, vmsize, fileoff, filesize))
            if segname == "__TEXT_EXEC":
                te = (vmaddr, fileoff, filesize)
        eoff += cmdsize
    if te is None:
        raise SystemExit("member has no __TEXT_EXEC")
    return segs, te


def load_entry(data, dc_fo, dc_vm, entry_vm):
    off = dc_fo + (entry_vm - dc_vm)
    q, a, b, c, d = struct.unpack_from("<QIIII", data, off)
    allow, ent = struct.unpack_from("<IQ", data, off + 0x18)
    return q, (a, b, c, d), allow, ent


def looks_valid(q, counts):
    if q >> 32 == 0:
        return False
    if counts[1] not in (0xFFFFFFFF,) and counts[1] > 0x100000:
        return False
    if counts[3] not in (0xFFFFFFFF,) and counts[3] > 0x100000:
        return False
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("build", choices=sorted(KC))
    ap.add_argument("member")
    ap.add_argument("--find", help="VA of a dispatch thunk; locate the table containing it")
    ap.add_argument("--base", help="table base VA (used with --count)")
    ap.add_argument("--count", type=int, default=64)
    ap.add_argument("--window", type=int, default=64,
                    help="entries to print around a --find hit")
    args = ap.parse_args()

    data = KC[args.build].read_bytes()
    segs, (te_vm, te_fo, te_sz) = member_segments(data, args.member)
    dc = next((s for s in segs if s[0] == "__DATA_CONST"), None)
    if dc is None:
        raise SystemExit("member has no __DATA_CONST")
    _, dc_vm, _, dc_fo, _ = dc

    def fo2va(lo):
        return te_vm + (lo - te_fo) if te_fo <= lo < te_fo + te_sz else None

    base = None
    if args.find:
        want = int(args.find, 16)
        want_fo = te_fo + (want - te_vm)
        hits = []
        for off in range(0, dc[3] - 8, 8):
            q = struct.unpack_from("<Q", data, dc_fo + off)[0]
            if (q & 0xFFFFFFFF) == want_fo:
                hits.append(dc_vm + off)
        if not hits:
            raise SystemExit("no __DATA_CONST slot points at %#x" % want)
        for h in hits:
            print("# slot %#x -> thunk %#x" % (h, want))
        # walk back to the first entry of the run
        slot = hits[0]
        start = slot
        while True:
            prev = start - 0x28
            if prev < dc_vm:
                break
            q, counts, _, _ = load_entry(data, dc_fo, dc_vm, prev)
            if not looks_valid(q, counts) or fo2va(q & 0xFFFFFFFF) is None:
                break
            start = prev
        base = start
        print("# table start %#x (walked back %d entries)" % (base, (slot - base) // 0x28))

    if args.base:
        base = int(args.base, 16)
    if base is None:
        ap.error("need --find or --base")

    print("idx | entry VM | thunk VA | scalarIn | structIn | scalarOut | structOut | async | entitlement")
    i = 0
    while True:
        vm = base + i * 0x28
        if vm + 0x28 > dc_vm + dc[3]:
            break
        q, (a, b, c, d), allow, ent = load_entry(data, dc_fo, dc_vm, vm)
        va = fo2va(q & 0xFFFFFFFF)
        if i >= args.count:
            break
        print("%3d | %#x | %s | %d | %#x | %d | %#x | %d | %s" % (
            i, vm, ("%#x" % va) if va else "-", a, b, c, d, allow,
            ("%#x" % ent) if ent else "-"))
        i += 1
        if not looks_valid(q, (a, b, c, d)) or va is None:
            print("# stop: entry %d does not decode" % i)
            break


if __name__ == "__main__":
    main()
