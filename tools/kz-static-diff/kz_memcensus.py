#!/usr/bin/env python3
"""Fast index-paired function-size census across every fileset member, A vs B.

Ranks members by how many LC_FUNCTION_STARTS entries differ in size when paired
by index.  This is CHEAP RECONNAISSANCE ONLY:

* index pairing silently misaligns as soon as one function was added or removed,
  so a large count can be pure drift;
* size equality says nothing about instruction content.

Cross-check any candidate with kc_member_diff.py / kz_pair_shape_check.py
before recording it as a change.

Usage:
    python kz_memcensus.py            # uses the two builds below
"""
import sys, struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "opencode-temp"))
sys.path.insert(0, str(ROOT / "tools" / "pylibs"))
from kc_iosurface import parse_fileset, member_load_commands, member_segments  # noqa: E402

BUILDS = ("24A446", "24B119")


def starts_of(data, foff):
    segs = member_segments(data, foff)
    out = []
    for cmd, eoff, cmdsize in member_load_commands(data, foff):
        if cmd != 0x26:                     # LC_FUNCTION_STARTS
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
            out.append(segs["__TEXT"][0] + addr)
    return sorted(set(out))


def load(build):
    data = (ROOT / "firmware" / build / "kernelcache.release.macho").read_bytes()
    entries, _ = parse_fileset(data)
    res = {}
    for e in entries:
        try:
            res[e["name"]] = starts_of(data, e["fileoff"])
        except Exception:
            res[e["name"]] = None
    return res


def main():
    A = load(BUILDS[0])
    B = load(BUILDS[1])
    print("members A=%d B=%d" % (len(A), len(B)))
    rows = []
    for name in sorted(set(A) & set(B)):
        a, b = A[name], B[name]
        if not a or not b:
            rows.append((name, -1, -1, -1, 0))
            continue
        if len(a) != len(b):
            rows.append((name, len(a), len(b), -1, 0))
            continue
        diffs = 0
        nbytes = 0
        for i in range(len(a)):
            sa = a[i + 1] - a[i] if i + 1 < len(a) else 0
            sb = b[i + 1] - b[i] if i + 1 < len(b) else 0
            if sa != sb:
                diffs += 1
                nbytes += abs(sa - sb)
        rows.append((name, len(a), len(b), diffs, nbytes))

    print("\n# count-equal members with size diffs (index-paired, UNVERIFIED):")
    for r in sorted(rows, key=lambda x: x[3], reverse=True):
        if r[3] > 0:
            print("  %-52s n=%-5d diffs=%-4d bytes=%d" % r)
    print("\n# members with differing function counts:")
    for r in rows:
        if r[3] == -1:
            print("  %-52s A=%d B=%d" % r[:3])


if __name__ == "__main__":
    main()
