# Socket probe correction: post-close fd reuse — 2026-11-20

## Current conclusion

Historical socket probe outputs remain observations, but they do **not** establish a kernel use-after-free, a reclaimed socket object, or a kernel write primitive. The earlier `--sockuaf`, `--sockprec`, `--sockmix`, and `--sockfield` interpretations are superseded pending an fd-safe control.

## Why the old oracle was ambiguous

A source review of the harness found that the sender increments its `entered` counter immediately before calling `sendmsg(fd, ...)`. That counter does not establish that the kernel has looked up or pinned the descriptor. The race then closes the target descriptor and allocates new TCP/UDP sockets without an fd placeholder or numeric-fd check. A sender whose syscall resolves after the close can therefore use a newly allocated socket that reused the same descriptor number. That ordinary file-descriptor reuse can produce the same peer bytes or UDP datagram without a stale kernel pointer.

The precision mode counted peer bytes above a baseline as a “stale write”; `--sockmix` counted datagrams observed on a UDP listener. Neither detector excluded the descriptor-reuse explanation. The recorded 20 precision peer-delivery hits and the 109/4 TCP→UDP delivery events on the two devices are not UAF hit counts. `doneAtClose` is the number of `sendmsg` calls whose returns were recorded before the snapshot; it does not prove when the kernel looked up the fd. Historical logs called it “sends in flight at close,” a misleading/inverted label: 4/6 means four returns were counted, not four operations proven in flight. A syscall may also continue via a file reference acquired before `close`.

The `sockfield` follow-up queried API-visible options on hammer descriptors after an event, but it did not identify which kernel object backed any descriptor. Its zero field-differential result is therefore not a validated negative on a reclaimed socket.

## Scope and next gate

This is a source-and-historical-log reclassification, not a new device run. It does not establish that no socket vulnerability exists; it means the previous evidence is insufficient. The CVE-2026-112514 attribution and the proposed 27.2 fix mapping also remain unverified for this target.

Before another device test, the harness needs an fd-pinned control: atomically replace the target descriptor with a pre-opened placeholder using `dup2`, keep the placeholder open until all senders finish, prevent reclaimer allocations from taking that number, and log target/reclaimer fd values. Run the unguarded fd-reuse case separately as a control, use distinct target and reclaimer peers, and require an independent oracle for object identity and memory-corruption impact. No device rerun or new app build was made for this correction.

No kernel read/write primitive, code execution, or jailbreak is claimed. No new IPA or release is warranted; the existing research-harness IPA is unchanged.
