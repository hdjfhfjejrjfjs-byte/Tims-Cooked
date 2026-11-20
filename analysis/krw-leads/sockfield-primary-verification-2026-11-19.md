# `--sockfield` verified on the primary (24A446): same negative as the secondary

Date: 2026-11-19
Devices: iPhone 17 Pro `<primary-device-udid>` (primary, iOS 27.0.1 / 24A446,
unlocked this session), iPhone 13 Pro `<secondary-device-udid>` (secondary).
Build host: macOS over Tailscale, `xcodebuild` Debug, `BUILD_EXIT=0`.
Raw logs: `analysis/evidence/sockfield-primary-2026-11-19/sockfield-{17pro,13pro}.log`,
counts `.../counts.txt`.

This closes the item left open in the last checkpoint ("remaining
unverified-on-primary modes: `--iosurfwatch`, `--sockfield`") for `--sockfield`.

> **Correction (2026-11-20):** The 11/12 logged UDP events are observations, not confirmed cross-type reclaim or UAF. The harness increments `entered` immediately before `sendmsg`, closes the target fd, then allocates reclaimers without an fd placeholder or numeric-fd check. Ordinary descriptor reuse can explain the events. The zero field-differential does not establish a negative on a reclaimed object because the scan did not identify which kernel object backed any descriptor. No new device run was made; see `../../research-updates/2026-11-20-socket-fd-reuse-erratum.md`. The historical “in flight at close” field is the count of `sendmsg` returns recorded before the snapshot, not a count proven to be in flight or past fd lookup.

## 1. Build and deploy

The shared checkout does **not compile** at its current HEAD: `ViewController.swift`
lines 417–424 reference `bench100HIDSelectors` … `bench107KeyStore` on `XPCProbe`,
and those methods exist nowhere in the tree (`grep -r` over `carrier/` finds only
the call sites; `XPCProbe.swift` has 94 `func bench*`, none named 100–107). A clean
build fails with 8 × `value of type 'XPCProbe' has no member 'benchNN…'`. This is
another agent's unfinished edit, so the fix was applied to an **isolated copy**
(`/tmp/sfbuild` on the build host: `AGXProbe/`, `AGXProbe.xcodeproj`, `metal/`
copied, then only those 8 dead UI rows deleted there). The shared tree and the
build host's working copy were not modified.

Source hashes were compared first: `SockUafSpray.c`, `ContentView.swift`,
`AGXProbe-Bridging-Header.h`, `ReachabilityProbe.swift`, `XPCProbe.swift` were
identical between the repo and the build host; `IOSurfaceNotifyProbe.c` differed
(repo carries newer comments) and was synced before the build.

`BUILD_EXIT=0`; the product still contains every flag used by the loop
(`strings AGXProbe.debug.dylib` → `--sockfield --sockmix --sockuaf --iosurfrace
--iosurfreclaim --iosurfwatch --mementry --opencand --hidsel`). `devicectl device
install app` returned 0 on both devices; both had been SpringBoard-locked in
earlier runs and launched fine this time.

## 2. Historical result — UDP delivery events, object identity unresolved

| device | iterations | UDP delivery events | field-diff hits | peer hits |
|---|---|---|---|---|
| 17 Pro (24A446, primary) | 3000 | **11** | **0** | 0 |
| 13 Pro (secondary) | 3000 | **12** | **0** | 0 |

Completion markers present on both (`[+] sockfield: … in 3000 iterations`,
`=== sockfield done ===`), no app termination mid-run. Representative primary
hits:

```
[!] ITER 1   sockfield: *** CROSS-TYPE HIT: 5 datagram(s)/40960 byte(s) (hammer=89,  in flight at close 0/6) ***
[!] ITER 62  sockfield: *** CROSS-TYPE HIT: 2 datagram(s)/16384 byte(s) (hammer=94,  in flight at close 4/6) ***
[!] ITER 375 sockfield: *** CROSS-TYPE HIT: 4 datagram(s)/32768 byte(s) (hammer=236, in flight at close 0/6) ***
[!] ITER 2443 sockfield: *** CROSS-TYPE HIT: 1 datagram(s)/8192 byte(s) (hammer=5,   in flight at close 3/6) ***
```

The per-iteration fingerprint control is healthy
(`control n=16 type=2 sndbuf=9216 rcvbuf=786896 tcpinfo=-1`, i.e. all 16 fresh
never-raced datagram sockets agree), so "0 field-diff" is a measured negative, not
an unfired detector.

## 3. What the historical observations show and do not show

* **Observed:** the historical run logged 11 UDP delivery events on 17 Pro and 12 on 13 Pro,
  and queried API-visible socket options on hammer descriptors; the compared option values
  fell within the control ranges.
* **Not proven:** that a freed TCP socket slot was taken by a UDP object, that a stale kernel
  pointer was used, or that any queried descriptor backed a reclaimed object. The harness
  leaves ordinary numeric fd reuse possible, so the delivery and zero-differential results do
  not establish UAF or a negative on the reclaimed object's fields.
* **Not established:** a crash-report diff. The Mac has no `pymobiledevice3`
  installed and the usbmux relay script is absent, so `.ips` sets could not be
  pulled this run. Device boot state read `booted` after the run and the console
  log ends cleanly; nothing here evidences or excludes a panic.

## 4. Consequence for the lead ranking

This is not a validated negative for path #1's conversion step because the harness did not
identify a reclaimed object. **Do not spend further device cycles on the old `--sockfield`
variant without an fd-pinned design, an unguarded reuse control, and an independent object
identity oracle.**

## Reproduction

```sh
# isolated build (removes the 8 dead ViewController rows only in /tmp/sfbuild)
bash /tmp/sf_build.sh                       # BUILD_EXIT=0
xcrun devicectl device install app --device <udid> \
        /tmp/sfbuild/.dd/Build/Products/Debug-iphoneos/AGXProbe.app
timeout 900 xcrun devicectl device process launch --console --terminate-existing \
        --device <udid> com.bench27.agxprobe --sockfield
```
