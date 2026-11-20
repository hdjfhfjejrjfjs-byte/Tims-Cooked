# BSD socket-family flow-control delta, characterised: PAC re-signing, and no established ingress

Date: 2026-11-20
Builds: 24A446 (iOS 27.0.1, target) vs 24B119 (iOS 27.2)
Device work: **none** — the build host was unreachable (Tailscale `NoState`, SSH to
`100.110.170.78` timed out) and no iPhone enumerated on the PC usbmux endpoint. All
results below are static binary reading.

## Why this lead

The exact function-boundary diff of the kernel member
(`analysis/kernelcache-funcstarts-exact-diff-2026-11-14.md`) left exactly one
uncharacterised real code delta in the BSD socket family: the AF_UNIX / flow-control
neighbourhood `0xb17a000`–`0xb187000`. The handoff recorded it as "real but unrelated"
and it had never been read instruction-by-instruction. It is also one of the few places
where Apple changed code on a surface a sandboxed app can reach with `socket(2)` calls,
so it is worth either promoting or retiring. This note retires it.

## Functions examined

| function | 24A446 | 24B119 | size delta |
|---|---|---|---|
| `fg_insertuipc` | `0xfffffe000b181118` (0xd04) | `0xfffffe000b1d6f1c` (0xd5c) | +0x58 |
| `fg_removeuipc` | `0xfffffe000b185334` (0x56c) | `0xfffffe000b1db1cc` (0x5e4) | +0x78 |
| option-dump neighbour | `0xfffffe000b184854` (0x6e8) | `0xfffffe000b1da6d8` (0x6fc) | +0x14 |

Counterpart identity is not inferred from proximity: each function carries its own
name literal (`fg_insertuipc` at `0xfffffe000b181334` / `0xfffffe000b1d713c`), the
prologues match, and the two build streams align instruction-by-instruction after
register renaming.

## What actually changed

### The delta is a pointer-authentication re-signing discipline, not a new check

In 24A446, `fg_insertuipc` stores an authenticated pointer into the flow-advisory
pointer array using the **source object** as the discriminator:

```
0xfffffe000b1814b4  ldr   x16, [x27]        ; candidate pointer
0xfffffe000b1814b8  cbz   x16, 0xfffffe000b1814c4
0xfffffe000b1814bc  mov   x17, x26          ; x26 = obj | (0xc75 << 48)
0xfffffe000b1814c0  autda x16, x17          ; authenticate only
...
0xfffffe000b1814d8  str   x16, [x8]         ; x8 = &array[i]
```

In 24B119 the same block authenticates identically and then **re-signs with a
destination-derived discriminator** before storing:

```
0xfffffe000b1d730c  ldr   x16, [x26]
0xfffffe000b1d7310  cbz   x16, 0xfffffe000b1d7164
0xfffffe000b1d7314  mov   x17, x8           ; destination slot address
0xfffffe000b1d7318  autda x16, x23          ; x23 = obj | (0xc75 << 48) — same auth
0xfffffe000b1d731c  movk  x17, #0xec98, lsl #48
0xfffffe000b1d7320  pacda x16, x17          ; RE-SIGN against the slot address
0xfffffe000b1d7324  b     0xfffffe000b1d7164 ; -> str x16,[x8]
```

So 27.2 binds each stored pointer to the address of the slot that holds it
(`slot_va | (0xec98 << 48)`), where 27.0.1 stored a pointer signed for the *object*.
That is an anti-substitution hardening of a signed-pointer array — the shape you
change after a cross-list pointer-swap defect, but also a routine PAC key/disciplining
update. `fg_removeuipc` moves the same way (`autda` 0 → 4, `mov` +10, five extra
branches), and the `0xb184854` option handler shows the identical
`movk`/`autda` signature (+0x14).

Mnemonic deltas, `fg_insertuipc`: `pacda` 0→1, `autda` 4→5, `adrp` +5, `ldr` +5,
`mov` +7, `movk` +2, `add` +2, `stp` +1, `str` -1, `ldp` -2, `b` +1, `b.ls` +1,
`b.hi` -1. There is **no added length, bounds, refcount or lifetime predicate**.

### Correction: the assert-predicate string is *not* a build difference

An `annot.py` "top strings" comparison suggests 24A446 asserts `MEXT_REF(m) != 0`
where 24B119 asserts `rfa->minref == rfa->refcnt` on the same two call sites. That is
an artefact. Both literals exist in **both** builds' callee
(`0xfffffe000b15d0c8` / `0xfffffe000b1b2ed4`, both sz `0x4a4`, 671 direct callers).
A full normalised diff of the two callees gives **zero mnemonic delta and zero novel
2-/3-grams** — they are instruction-for-instruction identical. Do not open a lead on
"Apple changed the asserted invariant in the flow-advisory validator"; it did not.

## Ingress census — no established reference path

For `0xfffffe000b181118` and `0xfffffe000b185334` in 24A446, three independent scans
over the whole 301-member fileset:

| scan | scope | result |
|---|---|---|
| `kz_blw_scan.py bl,b,blraa` | every executable segment | **0** direct branch sites |
| `allmember_slot_scan.py` (raw low-32 arm64e slot) | all 301 members, all segments | **0** slots |
| `kz_chainfind.py chainrefs` (format-8 chained fixups) | kernel member | **0** slots |

Controls prove each detector works: the same BL/B scan returns 671 sites for
`0xfffffe000b15d0c8` and 313 for `0xfffffe000ac42a30`; the raw slot scan returns the
known IOStorageFamily `__DATA_CONST` slot at `0xfffffe0008375fa8` for target
`0xfffffe000a3273c4`; `chainrefs` returns 118 slots for `0xfffffe000b26522c`.
Raw log: `analysis/evidence/unix-flowadv-delta-2026-11-20/ingress-census.txt`.

## Verdict

**Bounded negative.** The last unexamined real code delta in the BSD socket family is
a PAC re-signing discipline change plus register-allocation churn, with no new
validation predicate; and neither function has any established ingress from kernel
code, kext code, arm64e pointer tables, or chained-fixup tables. Retire this delta: do
not spend a device cycle on AF_UNIX flow control.

Not established: whether the two functions are genuinely dead code in 24A446 (an
ingress mechanism this tooling cannot see), and whether 27.2's per-slot signing closed
a real substitutability defect. If a future build exposes an app-reachable flow-advisory
API, re-open by checking `rfa->minref == rfa->refcnt` reachability first — the
invariant exists in both builds but its enforcement context was not resolved here.

Related: `analysis/kernelcache-funcstarts-exact-diff-2026-11-14.md` (function
boundaries), `analysis/socket-uaf-*` (the socket-buffer race that motivated the hunt),
`analysis/krw-leads/msum16-checksum-callers-2026-11-14.md` (the other real delta in
this region — 32→64-bit mbuf length arithmetic, remote-only).

## Evidence

`analysis/evidence/unix-flowadv-delta-2026-11-20/` — annotated dumps for both
functions in both builds, the two (identical) assert callees, the option-handler pair,
the ingress census log, and the two numpy-free scan scripts used.
