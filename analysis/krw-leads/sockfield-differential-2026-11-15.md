# Post-event socket-option scan — historical bounded observation

Date: 2026-11-15
Device: secondary iPhone14,2 (iOS 27.0, 24A5390f). Primary iPhone18,1 (24A446)
remains SpringBoard-Locked (`unlockedSinceBoot: true` but `devicectl launch`
still refused), so it is not measured.
Carrier mode: `--sockfield` (`runSockFieldMode()` in
`carrier/AGXProbe/ContentView.swift`, `sockuaf_field_probe()` in
`carrier/AGXProbe/SockUafSpray.c`).
Raw log: `analysis/evidence/sockfield-2026-11-15/sockfield-13pro.log`.

> **Correction (2026-11-20):** The recorded UDP events do not establish that any hammer fd refers to a reclaimed socket. The trigger closes the target fd and allocates reclaimer sockets without preventing numeric fd reuse; `entered` advances before `sendmsg`. The option scan therefore cannot be interpreted as a negative measurement on a reclaimed object. See `../../research-updates/2026-11-20-socket-fd-reuse-erratum.md`. The historical “in flight at close” value is the number of `sendmsg` returns recorded by the userspace counter before its snapshot; it does not establish fd lookup timing.

## Question

The earlier `--sockmix` report interpreted UDP delivery as a reclaimed-socket event.
That inference is withdrawn: ordinary fd reuse can produce the same delivery, and the
test does not identify which kernel object backed the sender's fd. The remaining question
is only what the post-event option scan measured across the descriptors it queried; it did
not establish the identity of a reclaimed object.

## Method

Per iteration:

1. one target TCP socket connected to a loopback listener;
2. six sender threads gate-spawned into `sendmsg` (8×1 KiB iovecs, 8192-byte
   buffer), then close lands while they may still be in-kernel (precision race);
3. **in-window hammer**: `socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)` + `connect()`
   to the oracle port, in a tight loop while senders may still be inside their
   syscall, up to 256 allocations — the same hammer that wins the slot in
   `--sockmix`;
4. 48 fresh TCP sockets connected to the precision peer listener (control);
5. drain the UDP oracle (a datagram here is the positive collision detector);
6. **field diff**: fingerprint each hammer fd via `SO_TYPE`, `SO_ERROR`,
   `SO_SNDBUF`, `SO_RCVBUF`, `TCP_CONNECTION_INFO` (tcpinfo), and
   `getsockname` (family/port/addr); compare against a 16-sample control set of
   freshly created, never-raced dgram sockets built by the probe itself. A field
   whose value differs from *every* control sample is flagged.

The control is built by the same code path on the same device, so baseline drift
(allocator-dependent buffer sizes) cannot masquerade as a difference.

## Result

```
[+] sockfield: 5 cross-type hit(s), 0 field-diff hit(s), 0 peer hit(s) in 3000 iterations
```

| iter | datagrams | bytes | hammer fds | fingerprinted | field diffs |
|---|---|---|---|---|---|
| 138 | 5 | 40,960 | 251 | **251** | 0 |
| 298 | 6 | 49,152 | 40 | **40** | 0 |
| 978 | 2 | 16,384 | 7 | **7** | 0 |
| 1192 | 6 | 49,152 | 256 | **256** | 0 |
| 2349 | 1 | 8,192 | 5 | **5** | 0 |

Totals over 3,000 iterations: **5,487 hammer fds fingerprinted, 0 field
differences**. Control set consistent at n=16, `SO_TYPE=2 (SOCK_DGRAM)`,
`SO_SNDBUF=9216`, `SO_RCVBUF=786896`, tcpinfo unavailable on this family
(`-1` everywhere, identically on control and raced fds).

Representative lines (iter 138):

```
[!] ITER 138 sockfield: *** CROSS-TYPE HIT: 5 datagram(s)/40960 byte(s) (hammer=251, in flight at close 0/6) ***
[*] sockfield(odd): control n=16 type=2 sndbuf=9216 rcvbuf=786896 tcpinfo=-1
[*] sockfield(odd): VERDICT scanned=251 hits=0 readfail=0
```

## Measured, with object identity unresolved

* The historical run logged 5 UDP delivery events and queried 5,487 hammer descriptors; the
  queried options were within the control ranges and the calls completed.
* This is a result about the descriptors sampled by the harness, not proof that they included
  a reclaimed object. The event detector and option scan do not exclude ordinary numeric fd
  reuse or establish kernel-object identity.
* No conclusion about a stale sender, hidden `sockbuf` state, or a corrupted field follows
  from the zero field-differential.

## Limits

* This measures API-visible options on the descriptors sampled by the harness. The test does
  not establish that any sampled descriptor backed a reclaimed socket. Kernel fields that no
  socket option reads (`so_pcb`, `so_proto`, `sockbuf` bookkeeping, usecount/defunct flags)
  were not queried either.
* The scan runs after the UDP listener drain and contention sends. Since the event does not
  identify a reclaimed object, this scan cannot establish that a transient field state on such
  an object was present or absent.
* One device/build (24A5390f). Primary remains locked.
* No kernel R/W primitive was established. Because object identity is unresolved, this is not
  a validated negative on the conversion route either.

## Interpretation

The earlier conclusion that a cross-type collision had been established is withdrawn. The
event may be explained by ordinary fd reuse, and the option scan did not identify a reclaimer
object. Consequently this run does not close the "name the corrupted field" step or establish
any UAF conversion result.

Any kernel-internal field corruption remains unobserved and untested; no kernel read/write
primitive is established by this experiment.

## Device safety

One clean run. The app completed normally (`=== sockfield done ===`), stayed
alive, and produced **no new AGXProbe crash report** (newest on the device is
`AGXProbe-2026-11-15-124950.ips`, ~2.5 h before the run; the run finished 15:19).
No panic, respring or reboot. Primary untouched (locked).
