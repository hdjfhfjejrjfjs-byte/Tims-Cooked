# Historical TCP→UDP delivery observations — UAF/reclaim not established

Date: 2026-11-14
Target: iPhone18,1 / t8150 / iOS 27.0.1 (build 24A446) — **17 Pro `<primary-device-udid>`**
Secondary: iPhone14,2 / A16 / iOS 27.0 (build 24A5390f) — **13 Pro `<secondary-device-udid>`**
Bug attribution: CVE-2026-112514 / `uipc_socket2.c` and the proposed 27.2 fix mapping are unverified for this target.
Evidence: `analysis/evidence/crosstype-2026-11-14/sockmix_13pro.log`, `…/sockmix_17pro.log`

> **Correction (2026-11-20):** The 109/4 UDP delivery events are observations, not confirmed cross-type object reclaim or UAF hits. `entered` advances immediately before `sendmsg`; the harness closes the target fd and then allocates UDP sockets without an fd placeholder or numeric-fd check. A late syscall can resolve the reused descriptor to a new UDP socket and produce the same datagram. The `completed-at-close` value in the historical raw logs is the count of `sendmsg` returns recorded before the snapshot. The logs mislabeled it “in flight at close”; it does not prove which syscalls had looked up or pinned an fd.

## What was run

`--sockmix` = precision race (variant E) plus a **cross-type allocation hammer**.

Two changes were made to the carrier for this run:

1. A `SOCK_DGRAM` listener was used as an output observer. The harness did not explicitly call
   `send()` on a datagram reclaimer, but the sender calls `sendmsg` on the target's numeric fd;
   because that fd is closed before reclaimer allocation and is not pinned, a later fd lookup
   can resolve to a newly allocated datagram socket. The listener therefore does not identify
   the kernel object used by the sender.
2. The hammer allocates UDP sockets after the target close. The pre-syscall `entered` counter
   does not prove all senders have resolved the target fd or are executing with a retained
   reference. No descriptor placeholder or fd-number check excludes ordinary reuse.

The TCP side is kept as a control: 48 fresh TCP sockets are connected to the precision
listener afterwards, and any byte they receive beyond the 144-byte contention baseline is
reported separately.

Both devices ran the same build (BUILD_EXIT=0), 2000 iterations each, ~80–96 iterations/s,
and both completed normally (`[+] sockmix: … in 2000 iterations`) — no app crash, no
respring, no reboot.

## Results

| Device | Iterations | UDP delivery events | Datagrams delivered | Bytes delivered |
|---|---|---|---|---|
| 13 Pro (27.0 / 24A5390f) | 2000 | **109** | 335 | 2,744,320 |
| 17 Pro (27.0.1 / 24A446) | 2000 | **4** | 14 | 114,688 |

```
These are preserved historical log labels, not validated UAF/reclaim outcomes.

13 Pro: [!] ITER 5 precision/mix: *** CROSS-TYPE HIT: 5 datagram(s)/40960 byte(s) via a reclaimed dgram socket (hammer alloc=239, in flight at close 1/6) ***
13 Pro: [!] ITER 12 precision/mix: *** CROSS-TYPE HIT: 6 datagram(s)/49152 byte(s) via a reclaimed dgram socket (hammer alloc=256, in flight at close 0/6) ***
13 Pro: [+] sockmix: 109 cross-type datagram hit(s), 109 total stale-write hit(s) in 2000 iterations

17 Pro: [!] ITER 188 precision/mix: *** CROSS-TYPE HIT: 1 datagram(s)/8192 byte(s) via a reclaimed dgram socket (hammer alloc=256, in flight at close 5/6) ***
17 Pro: [!] ITER 956 precision/mix: *** CROSS-TYPE HIT: 6 datagram(s)/49152 byte(s) via a reclaimed dgram socket (hammer alloc=13, in flight at close 0/6) ***
17 Pro: [+] sockmix: 4 cross-type datagram hit(s), 4 total stale-write hit(s) in 2000 iterations
```

### Structure of the effect

Every logged byte count is an exact multiple of **8192**, and the number of datagrams
per event is an exact multiple of 8192-byte units:

* 13 Pro histogram of datagrams per hit: `{1: 34, 2: 17, 3: 11, 4: 18, 5: 12, 6: 17}`
* 17 Pro histogram: `{1: 2, 6: 2}`

8192 bytes is exactly one sender buffer (`sendLen = 8192`), filled with `0x41` bytes. This
payload match is an observation compatible with both a stale-object hypothesis and ordinary
fd reuse; it does not identify which file description `sendmsg` resolved.

On iterations labeled as UDP events, the TCP peers showed `tcpPeerBytes=144`, exactly the
contention baseline. This does not distinguish fd reuse from a stale-object hypothesis; it only
records that the TCP peer oracle did not observe bytes above baseline on those iterations.
The same baseline on other iterations does not identify which file description the sender used.

Neither log contains any `odd errno`, `UAF PROBE`, corruption or panic line.

### Crash-log check

Crash reports were pulled from both devices after the runs (`devicectl device copy from
--domain-type systemCrashLogs`). **No `.panic` file exists on either device, and no crash
report newer than 04:15 was produced** during the run windows. Both phones remained
responsive throughout; no data was touched.

## What the observations do and do not prove

The logs prove that UDP datagrams were observed during the historical run and that the app
completed without a reported panic or reboot. They do **not** prove that a freed `struct
socket` slot was allocated to a UDP object, that the sender used a stale kernel pointer, or
that the result was a UAF. Ordinary fd-number reuse is an alternative explanation. The
sender payload and reclaimer destination were configured by the harness, but that does not
establish which file description the kernel resolved for a given `sendmsg`.

## What this does *not* prove

* It is **not** kernel read/write. No kernel pointer, field offset or object contents were
  controlled; the only values under attacker control are the *payload* and the *destination*.
* No kernel panic, no crash, or observable kernel corruption was reported; the app completed
  normally. No reclaimed object was identified, and the 143 logged UDP events are not confirmed
  collisions.
* Whether the bytes reached the listener through a stale socket object or a reused file
  descriptor is unresolved; no corrupted kernel field was identified.

## How this relates to the earlier cross-zone conclusion

`analysis/socket-uaf-crosszone-2026-11-13.md` concluded that cross-zone reclaim was "ruled
out for this approach": the OOL `mach_msg` spray ran **after** the close, so it competed for
slots too late, and socket-exhaustion page pressure is capped by `RLIMIT_NOFILE`. That
conclusion stands for its own technique.

The earlier report described this as a cross-type reclaim, but source review shows the
sequence does not rule out ordinary fd reuse. The prior cross-zone conclusion is unrelated to
this ambiguity; neither result establishes a socket UAF.

## Next steps

1. Implement a descriptor-pinned replacement with a pre-opened placeholder, keep it open
   through sender completion, and log target/reclaimer fd numbers.
2. Run an unguarded fd-reuse control separately and verify the event detectors distinguish it.
3. Use distinct target and reclaimer peers and add an independent object-identity/corruption
   oracle before interpreting any remaining delivery as UAF or reclaim.
4. Do not run the reverse protocol orientation until that fd-safe design is reviewed and a
   device/build host is available.
