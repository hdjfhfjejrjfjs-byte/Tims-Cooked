# AppleJPEGDriver request lifetime: candidate closed (bounded static negative)

Date: 2026-11-20
Target build: iOS 27.0.1 (24A446). Reference: iOS 27.2 (24B119).
Scope: static binary reading only. **No device cycle** — no authorised Mac
enumerates a phone at this checkpoint, so nothing here was measured on hardware.

This note closes the open question raised in
[`2026-11-20-applejpeg-request-lifetime.md`](2026-11-20-applejpeg-request-lifetime.md):
whether the request object is released while the command-gate worker still needs
it. It does not establish a vulnerability; it records why the earlier hazard
reading was wrong.

## What was assumed

The earlier note observed that all six reachable decoder/encoder entry bodies
release their `JpegRequest` immediately unless the caller's input source field is
non-NULL *and* the enqueue returned success, and that when the source field is
NULL the release runs even on success. That was read as "freed after an
asynchronous enqueue", which would be a use-after-free if the gated work ran
later.

## Why that reading was wrong

Two independent facts settle it.

**The command gate does not defer.** IOKit's `IOCommandGate::runAction` takes the
workloop gate and invokes the supplied action inline on the calling thread; it
returns only after the action returns. It is not a queue that hands the action to
a separate gate thread. So there is no interval in which the caller releases the
object while the action is still pending. (This semantics was read from public
XNU source; the kernelcache ships no symbol table, so the target-side routine
identity is not symbol-proven — but the target code shape agrees.)

**The NULL-source case is explicitly synchronous inside the driver.** When the
request's source field is NULL, the queued-I/O worker takes a dedicated branch:
after validation and setup it sleeps on the command gate in a loop until a
completion flag in the request is set by the completion path, then returns the
status stored there. The completion routine sets that flag and, in this same
NULL case, wakes the waiter but deliberately **skips its own free**. Its free
path is taken only when the source field is non-NULL, i.e. in the asynchronous
case where the caller has already chosen to keep the object.

Finally, the bookkeeping helper both routines call was checked directly: it does
not invoke the typed-free stub at all. A whole-extension scan for calls to the
free stub confirms the only request frees are the ones already accounted for —
the entry bodies' own cleanup branches and the completion path's asynchronous
free.

## Net effect

- Source field NULL: the worker completes synchronously (or fails), the caller
  releases exactly once, after completion. No use-after-free, no double free.
- Source field non-NULL: the caller retains ownership on success, and the
  completion path frees the object when the operation finishes. Ownership
  transfer is explicit.

This is a bounded static negative for the request-lifetime lead. It also retires
the planned device oracle for this specific question: there is no defect to
reproduce, and running the panic-capable decode path would add risk without
testing anything.

## Status

No kernel read/write primitive, kernel code execution, or jailbreak is
demonstrated. No device probe was run.
