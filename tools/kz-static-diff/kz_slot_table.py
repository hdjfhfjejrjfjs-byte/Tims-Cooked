#!/usr/bin/env python3
"""Dump a run of arm64e auth-slot (jump-table / vtable) qwords and decode them.

`kz_iomethod_table.py` handles the specific `IOExternalMethodDispatch2022`
shape (stride 0x28 with five count fields plus allowAsync/entitlement). Plain
C++ vtables and other arm64e jump tables are just arrays of qwords where the
low 32 bits are a *file offset* into the member's `__TEXT_EXEC` and the high 32
bits carry the PAC signature/diversity. Comparing the low bits against VAs
returns zero hits and reads as "unreferenced"; this decodes them.

Also prints the surrounding raw qwords so a non-auth entry (a data pointer, a
cookie constant, an integer) is not mislabelled as a function slot.

Usage:
    python kz_slot_table.py 24A446 com.apple.iokit.IOStorageFamily \
            0xfffffe0008375fa8 16 [--stride 8] [--back 8]

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
    """Return (segments, textexec_vm, textexec_fo, textexec_size)."""
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("build", choices=sorted(KC))
    ap.add_argument("member")
    ap.add_argument("va", help="first entry VA (hex)")
    ap.add_argument("count", type=int)
    ap.add_argument("--stride", type=lambda s: int(s, 0), default=8)
    ap.add_argument("--back", type=int, default=0,
                    help="extra entries to print before --va")
    args = ap.parse_args()

    data = KC[args.build].read_bytes()
    segs, (te_vm, te_fo, te_sz) = member_segments(data, args.member)
    dc = next((s for s in segs if s[0] == "__DATA_CONST"), None)
    if dc is None:
        raise SystemExit("member has no __DATA_CONST")
    _, dc_vm, _, dc_fo, _ = dc

    def fo2va(lo):
        return te_vm + (lo - te_fo) if te_fo <= lo < te_fo + te_sz else None

    def seg_of(va):
        for name, vm, vsz, fo, fsz in segs:
            if vm <= va < vm + vsz:
                return name
        return "-"

    start = int(args.va, 16) - args.back * args.stride
    print("# %s %s table @ %#x stride %#x (segment %s)"
          % (args.build, args.member, start, args.stride, seg_of(start)))
    print("# idx | entry VM | raw qword | decoded VA | segment")
    for i in range(-args.back, args.count):
        vm = start + i * args.stride
        q = struct.unpack_from("<Q", data, dc_fo + (vm - dc_vm))[0]
        va = fo2va(q & 0xFFFFFFFF) if q >> 32 else None
        tag = ("%#x" % va) if va else ("ptr %#x" % q if q else "0")
        print("%4d | %#x | %#018x | %s | %s"
              % (i, vm, q, tag, seg_of(va) if va else "-"))


if __name__ == "__main__":
    main()
