# AppleJPEGDriver request lifetime: candidate free-after-enqueue (unconfirmed)

Date: 2026-11-20
Target build: iOS 27.0.1 (24A446). Reference: iOS 27.2 (24B119).
Scope: static binary reading only. **No device cycle** — no authorised Mac
enumerates a phone at this checkpoint, so nothing here was measured on hardware.
This is an open candidate, not a confirmed vulnerability.

## Background

An earlier checkpoint established that the AppleJPEGDriver kernel extension's six
decoder/encoder entry bodies are reachable from an ordinary unsigned app through
selectors 1–7 (the only precondition is that the driver pointer held by the user
client is non-NULL), and that each entry body hands a heap-allocated `JpegRequest`
object to the driver's command gate as deferred work. It also corrected an earlier
false negative: the deferred worker does run, asynchronously, after the
external-method call returns. What stayed open was whether anything keeps the
request alive between that enqueue and the deferred execution.

## What the code does now

Reading all six entry bodies instruction by instruction (the decoder and encoder
families of each generation share the same shape) shows a consistent sequence:

1. allocate one `JpegRequest` object from the extension's typed allocator;
2. copy fields out of the caller's `structureInput` into it;
3. pass it to the command gate as the deferred work action;
4. then decide whether to release it immediately.

The imported helpers were disassembled rather than inferred. The allocator path
selects a typed-allocation view from a prelinked per-class descriptor record and
calls the kernel allocator. The release path selects a view from the same record
layout and calls a helper that derives a zone from the object's address, verifies
the stored size, and tail-calls the kernel free routine — i.e. a real typed
`kfree`, not a reference-count decrement.

The decision in step 4 is guarded identically in all six bodies:

```
load  x8, [input + 0x30]      ; the caller's source-buffer / descriptor field
if x8 == 0            -> release the request
if enqueue status == 0 -> keep the request
otherwise             -> release the request
```

So the request is released **unless** two conditions hold together: the caller's
`structureInput+0x30` is non-NULL **and** the command-gate enqueue returned
success. When that field is NULL, the release happens on every outcome —
including success, i.e. after the object has already been handed to the deferred
worker.

Two independent facts frame why that matters:

- The deferred worker touches the object immediately: its first act is a load
  from `request+0x10` (which is exactly where `structureInput+0x30` was copied),
  and it later writes several fields of the object.
- The completion path in the same extension releases a finished request with the
  same typed-free helper, so the asynchronous pipeline does take ownership of the
  object elsewhere.

`structureInput+0x30` is inside the declared input size for these selectors
(selector 1 declares `0x58`), and the bytes are copied straight through, so an app
chooses whether that field is zero.

## What is not established

- **Whether the deferred work actually runs later.** In the branch that frees, the
  code copies result fields back out of the request *before* releasing it, which
  only makes sense if it assumes the request was already completed by the time the
  enqueue call returns. If the command gate executes the action inline for these
  requests, the release is correct and there is no defect. If it defers — which is
  the normal behaviour for external-method threads, but which this analysis did not
  prove for this driver — the worker reads and writes freed memory.
- **Whether a successful enqueue with a NULL `+0x30` can occur at all.** If the
  deferred worker always rejects such a request, the release is ordinary error
  cleanup. The worker's validation logic was not shown to reject it.
- **Any runtime effect.** Nothing was executed. There is no crash evidence, no
  controlled corruption, and no primitive.

There is also no patch-diff support: the whole kernel extension is
instruction-shape identical between the target build and the 27.2 reference build,
so this is not a fixed-in-27.2 site.

## Status

Unchanged overall: no kernel read/write primitive, kernel code execution, or
jailbreak is demonstrated, and no socket, VM or CoW trigger was run. This note
records a concrete lifetime hazard candidate and the single fact that decides it,
so that the next device session can test it directly instead of re-deriving it.
