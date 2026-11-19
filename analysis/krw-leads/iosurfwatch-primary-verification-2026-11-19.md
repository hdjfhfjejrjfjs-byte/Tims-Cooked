# `--iosurfwatch` verified on the primary (24A446): same negative as the secondary

Date: 2026-11-19
Devices: iPhone 17 Pro `<primary-device-udid>` (primary, iOS 27.0.1 / 24A446),
iPhone 13 Pro `<secondary-device-udid>` (secondary).
Build/deploy: same isolated carrier build as
`sockfield-primary-verification-2026-11-19.md` (`BUILD_EXIT=0`, bundle
`com.bench27.agxprobe`), installed and launched on both phones.
Raw logs: `analysis/evidence/iosurfwatch-primary-2026-11-19/`.

## Result

Both devices ran the mode to completion with identical verdicts:

```
[*] iosurfhold done rounds=4 testWorstMismatch=0 -> no non-IOSurface reclaimer seen
[*] iosurfwatch rc=0 controlWorst=1 testWorst=0
=== iosurfwatch done ===
```

`controlWorst=1` is the in-run positive control firing (fresh PurpleGfxMem
surfaces demonstrably reclaim the tagged pages), so the zero is a measured
negative rather than an unfired detector. `testWorst=0` across 4 rounds × 48
watch iterations means no generic kernel churn reachable from the app took the
freed IOSurface backing pages.

## What this closes

The previous checkpoint listed `--iosurfwatch` and `--sockfield` as the two modes
not yet verified on the primary. Both are now verified on 24A446 in this session
and both reproduce the secondary's negative:

* the external-object ceiling stands — a physical alias inside IOSurface/GPU's own
  backing object, with no allocator reachable from an unsigned app reclaiming the
  pages except the region allocator itself;
* the socket cross-type collision gives no API-visible field control.

No device cycle beyond these two launches; no source change was needed (the mode
already existed in the installed build). Per the standing rule, further cycles on
either mode need a new static signal.
