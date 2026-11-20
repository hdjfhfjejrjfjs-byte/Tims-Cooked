# AppleJPEGDriver descriptor globals identified; chain-walk caveat recorded

Date: 2026-11-20
Target build: iOS 27.0.1 (24A446). Reference: iOS 27.2 (24B119).
Scope: static binary reading only. **No device cycle** — no authorised Mac enumerates a
device at this checkpoint, so nothing here was measured on hardware.

## What was resolved

An earlier checkpoint left one open question about the AppleJPEGDriver kernel extension:
three constants in its read-only data segment are passed as the first argument to the
extension's imported allocate/free helpers, read as zero in the file, and are written by
no instruction in the extension. Were they objects constructed at boot, or pointer slots
on a page the chained-fixup decoder misses?

They are neither. Each address is the head of a static, prelinked record in a table of
per-class type descriptors:

- `+0x10` — a packed reference to a `site.<ClassName>` string in the extension's own text,
- `+0x20` — a packed reference to a per-class signature string,
- `+0x28` — a flags word and an element size,
- `+0x00` — a cached allocation-view pointer, zero in every record examined.

The three addresses under investigation are all `site.JpegRequest` records (element size
`0x558`, flags `0x64`). The same table names the rest of the extension's allocatable
classes (user client, queue manager, request handling, HAL, and the per-generation helper
groups).

Disassembly of the kernel-side helper confirms the layout: it reads the head pointer and,
when it is zero, falls back to a global default typed-allocation view selected by the
flags word, allocating `{size}` bytes. A zero head is therefore a handled state, not an
uninitialised field, so the records need no runtime construction and JpegRequest objects
are type-isolated allocations of `0x558` bytes.

Why they are not pointer slots, stated carefully: the image has no classic-relocation
load command, and a fileset member carries no fixups of its own, so the only relocation
mechanism present is a chained fixup entry — and a zero quadword cannot encode one. That
byte-level argument is what settles the question, not the decoder output.

## Tooling correction

The chained-fixup walk for this segment stops early (it terminates on a zero quadword),
and several provably live, relocated global-offset slots later in the same segment are
absent from the walked chain — they are loaded through an `adrp`/`add`/`ldr`/authenticated
branch stub island and hold well-formed entries that resolve to imported kernel routines.
So **"absent from the decoded chain" is not evidence that a quadword is not a pointer
slot.** Any future unreferenced/non-slot verdict in this segment must rest on a raw byte
scan or another independent control, not on the walk alone. This corroborates the
correction already published for the historical socket results.

## Status

- Resolved: the descriptor arguments are prelinked `site.<Class>` type-descriptor records,
  not boot-time objects and not chained-fixup pointers.
- Unchanged: whether anything keeps a JPEG request alive between enqueue and deferred
  execution is still open, with no use-after-free claim. The cross-build patch-diff axis
  for this extension was already closed (instruction-shape identical between the target
  and reference builds).
- No vulnerability, kernel read/write primitive, or jailbreak is established. Device work
  remains blocked pending an authorised host that enumerates a phone.
