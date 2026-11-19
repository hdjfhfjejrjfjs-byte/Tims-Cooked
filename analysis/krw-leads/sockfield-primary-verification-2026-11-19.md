# `--sockfield` verified on the primary (24A446): same negative as the secondary

Date: 2026-11-19
Devices: iPhone 17 Pro `<primary-device-udid>` (primary, iOS 27.0.1 / 24A446,
unlocked this session), iPhone 13 Pro `<secondary-device-udid>` (secondary).
Build host: macOS over Tailscale, `xcodebuild` Debug, `BUILD_EXIT=0`.
Raw logs: `analysis/evidence/sockfield-primary-2026-11-19/sockfield-{17pro,13pro}.log`,
counts `.../counts.txt`.

This closes the item left open in the last checkpoint ("remaining
unverified-on-primary modes: `--iosurfwatch`, `--sockfield`") for `--sockfield`.

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

## 2. Result — cross-type collision reproduces on both builds, still no field differential

| device | iterations | cross-type hits | field-diff hits | peer hits |
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

## 3. What this proves, and what it does not

* **Proven:** the cross-type reclaim is real on 24A446 as well as on the secondary —
  a freed TCP socket slot is taken by a `SOCK_DGRAM` object and stale in-flight
  sender bytes are delivered through it as UDP datagrams (11 hits / 3000 iterations
  on the target build). This was previously measured only on the secondary.
* **Proven:** reading every API-visible field of the colliding datagram socket
  (`SO_TYPE`, `SO_ERROR`, `SO_SNDBUF`, `SO_RCVBUF`, `TCP_CONNECTION_INFO`,
  `getsockname`) after the collision shows **no difference** against fresh control
  sockets. The collision therefore gives no *observable* kernel-field control —
  which is what the earlier run concluded on the secondary and is now reproduced on
  the target build.
* **Not established:** a crash-report diff. The Mac has no `pymobiledevice3`
  installed and the usbmux relay script is absent, so `.ips` sets could not be
  pulled this run. Device boot state read `booted` after the run and the console
  log ends cleanly; nothing here evidences or excludes a panic.

## 4. Consequence for the lead ranking

This is a bounded negative for path #1's *conversion* step, consistent with the
standing structural blocker (view-based typed allocation for `struct socket`): the
slot is reused inside the same allocation class, so no foreign field ever becomes
readable/writable through the socket API. Conversion still requires a controlled
reclaim above `kalloc_type`; **do not spend further device cycles on `--sockfield`
variants without a new static signal.**

## Reproduction

```sh
# isolated build (removes the 8 dead ViewController rows only in /tmp/sfbuild)
bash /tmp/sf_build.sh                       # BUILD_EXIT=0
xcrun devicectl device install app --device <udid> \
        /tmp/sfbuild/.dd/Build/Products/Debug-iphoneos/AGXProbe.app
timeout 900 xcrun devicectl device process launch --console --terminate-existing \
        --device <udid> com.bench27.agxprobe --sockfield
```
