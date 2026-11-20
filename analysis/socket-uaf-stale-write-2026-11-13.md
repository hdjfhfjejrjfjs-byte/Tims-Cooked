# Historical socket peer-delivery observations — UAF not established (corrected 2026-11-20)

Target: iPhone 17 Pro, iPhone18,1, iOS 27.0.1 (24A446). Carrier AGXProbe `--sockuaf`.

> **Correction:** The 20 reported peer-delivery events below are not confirmed stale kernel writes. In the precision variant, `entered` is incremented immediately before `sendmsg`; it does not prove the kernel resolved the fd. The harness closes the target fd, then allocates connected reclaimer sockets without pinning the numeric descriptor. A late `sendmsg(fd)` can therefore use a newly allocated socket that reused that number and deliver ordinary peer bytes. The CVE mapping, UAF, and reclaimed-object interpretation are unverified; see `../research-updates/2026-11-20-socket-fd-reuse-erratum.md`.

## Result

The historical log reported 20 peer-delivery hits, starting at iteration 9 and continuing every
few iterations (9, 14, 19, 29, 34, 44 …), with 8–24 KiB payloads. These are observed outputs,
not confirmed stale kernel writes. The run was stopped by an unrelated build replacement at 20
reported hits, not by a failure.

The historical interpretation was that a sender entered `sendmsg()` on socket A, `close(A)`
freed its `struct socket`, and the in-flight syscall wrote into socket B. Source review does not
establish that sequence: the counter is incremented before the syscall, and ordinary numeric fd
reuse can produce the same peer output without a kernel use-after-free.

## Why the earlier oracle is not decisive

The peer-delivery oracle detects bytes at a peer, but does not exclude ordinary fd-table reuse.
The precision variant (E) has these relevant properties:

1. Dedicated listener on `127.0.0.1:8089`; accepted peers are held and never read.
2. Spray sockets are freshly created **and connected to that listener**, never sent on.
3. Six senders park on a gate, then each fires exactly one 8 KiB `sendmsg` with 8 iovecs.
4. `st.entered` increments immediately before `sendmsg`; reaching six does not prove any
   sender has completed fd lookup.
5. The target is closed, then 48 connected spray sockets are allocated without an fd placeholder
   or numeric-fd check.
6. A sender whose syscall resolves after close can send through a new socket that reused the
   same descriptor; peer bytes therefore do not prove a stale kernel pointer.

`doneAtClose` is the count of `sendmsg` calls whose returns were recorded before the snapshot; it does not show fd-lookup timing. The historical label “sends in flight at close” is misleading/inverted: 4/6 means four returns were counted, not four operations proven in flight. An operation may also continue through a file reference acquired before `close`.

## Harness changes used in the historical run

| Problem | Fix |
|---|---|
| Fatal SIGPIPE on iter 0 | `signal(SIGPIPE, SIG_IGN)` |
| `0x8BADF00D` scene-create watchdog kill at 20 s (the old "SIGKILL after N iters") | whole loop moved off the MainActor into `Task.detached`, background logging via `emitBg` |
| ~2.7 threads per iteration | six persistent sender threads + one closer, created once, spinning on a shared `Int32` word array |
| Close timing | gate plus a pre-`sendmsg` `entered` counter; this does not prove kernel fd lookup occurred before close |
| Double-close of a reused fd number | CAS on `phase 2 → 3`, exactly one closer |
| Peer detection | peer-delivery signal; does not rule out ordinary numeric fd reuse |

Run rate ~100–200 iterations/s, 145 M+ sends per run, fd count flat, footprint stable.

## Log signature

The following is the historical log text; its word “confirmed” is not the current evidence assessment.

```
[!] ITER 9 precision: *** STALE WRITE: 8192 byte(s) delivered into a reallocated socket (sends in flight at close: 4/6) ***
...
[+] socket UAF: 20 confirmed hit(s) — stale write primitive
```

Full log on the Mac: `/tmp/appdata/reach.log`.

## Current status

Established: the historical run logged peer bytes after the race. Not established: that a
kernel-held stale pointer was used, that the freed allocation was reclaimed by a particular
object, or that any kernel field was corrupted. Do not use these events as a UAF primitive or
as the starting point for kernel R/W conversion. First require an fd-pinned replacement/control
that excludes numeric reuse, then an independent object-lifetime and corruption oracle.

## Notes

- No kernel panic or device reboot in any run. The write is into valid reused memory.
- The socket zone is not in the `kalloc_type` type-isolation framework, which is why this path
  survived when the IOKit paths did not.
- `SO_NWRITE` does not exist on iOS (`ENOPROTOOPT`); `TCP_CONNECTION_INFO` works but loopback
  ACKs drain the send queue, so it is not a good standalone oracle.
