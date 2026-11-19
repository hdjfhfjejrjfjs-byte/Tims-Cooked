# IOSurface notify ABI and teardown race window — static pass (2026-11-19)

Date: 2026-11-19
Build: `firmware/24A446/kernelcache.release.macho` (iOS 27.0.1, 24A446, target);
reference `firmware/24B119/kernelcache.release.macho` (iOS 27.2).
Member: `com.apple.iokit.IOSurface`.
Tool added: `tools/kz-static-diff/kz_iomethod_table.py`.
Raw output: `analysis/evidence/iosurface-notify-abi-2026-11-19/`.

**No device cycle.** The macOS build host is unreachable (no VPN route; SSH
times out) and the PC-side usbmux endpoint (`127.0.0.1:27015`) enumerates zero
devices, so nothing here was measured on hardware. Everything below is static
control-flow reading, marked proven/inferred per item.

This is a follow-up to `analysis/iosurface-notify-uaf-CVE-2026-112477.md`. It
settles the selector-`0x11` marshalling (§9 item 3 there), settles which word is
the notification index, and turns the candidate teardown race into a precise,
bounded static claim (§6).

---

## 1. Decoding the external-method table

`kz_iomethod_table.py` recovers the `IOExternalMethodDispatch2022` array of a
fileset member. Three decoding traps were hit and are now handled:

1. **Stride is `0x28`, not `0x18`.** iOS 27 uses
   `IOExternalMethodDispatch2022` (`function`, four `uint32_t` checks,
   `uint8_t allowAsync`, `const char *checkEntitlement`) = 40 bytes. Reading it
   with the older `IOExternalMethodDispatch` stride lands mid-entry and invents
   nonsense selectors.
2. **Entries are arm64e auth-jump-table qwords**: `(pac_signature << 32) |
   file_offset_of_target`. The low 32 bits are a **file offset**, not an
   address; comparing the low 48 bits against VAs finds zero slots while looking
   like a clean negative. Decode with `va = __TEXT_EXEC_vm + (lo -
   __TEXT_EXEC_fo)`.
3. **`IOExternalMethodArguments` field offsets** (public `iokit/IOKit/IOUserClient.h`,
   cross-validated twice below): `scalarInput` **+0x20**, `structureInput`
   **+0x30**, `structureOutput` **+0x58**, `asyncReference` **+0x10**.

Selector `0x04`'s thunk is the cross-validation: it does `ldr x8,[x2,#0x20];
ldr w1,[x8]; ldr x2,[x2,#0x58]` — i.e. `scalarInput[0]` and `structureOutput`,
both matching the public header exactly. So the layout above is confirmed on the
target build, not assumed.

---

## 2. The table itself

Two 60-entry arrays exist in `__DATA_CONST`:

| table | base VM | role |
|---|---|---|
| A | `0xfffffe000837fa10` | implemented variant |
| B | `0xfffffe0008380370` | stub variant (unimplemented selectors share `0xfffffe000a34aa64`) |

Both are referenced from one function, `0xfffffe000a34f678` (size `0x16c`), an
`externalMethod` override: it tests byte `[client+0x127]` bit 0 and `csel`s
between table A and table B, then tail-calls `0xfffffe000a35a17c` with
`w4 = 0x3c` (60 = entry count) and `x6 = 0`. Full dumps:
`table-A-24A446.txt`, `table-B-24A446.txt`.

Rows that matter (table A):

| sel | thunk | scalarIn | structIn | structOut | async | meaning |
|---|---|---|---|---|---|---|
| 0 | `0xa349114` | 1 | variable | `0xc68` | 0 | surface create |
| 4 | `0xa34932c` | 1 | 0 | `0xc68` | 0 | resolve root slot → client table |
| 6 | `0xa349354` | 0 | `0x20` | `0xc68` | 0 | |
| 7 | `0xa349364` | 2 | 0 | `0xc68` | 0 | |
| 13 | `0xa34980c` | 0 | 0 | `0x28` | 0 | |
| **17 (`0x11`)** | `0xa3498f4` | 0 | **`0x18`** | 0 | **1** | **set surface notify** |
| 18 (`0x12`) | `0xa34991c` | 0 | `0x18` | 0 | 0 | remove surface notify |
| 27 | `0xa349edc` | 0 | `0xa0` | 0 | 0 | |
| 40 | `0xa34a1c4` | 0 | 0 | 0 | 1 | |

---

## 3. Selector `0x11` marshalling — settled (proven)

Thunk `0xfffffe000a3498f4` (size `0x28`):

```asm
ldr  x1, [x2, #0x10]      ; x1 = args->asyncReference  (io_user_reference_t *)
cbz  x1, -> 0xE00002C2    ; BadArgument
mov  x3, x0               ; x3 = target (the notifier user client)
ldr  x2, [x2, #0x30]      ; x2 = args->structureInput
ldr  x0, [x0, #0xe8]      ; x0 = root = client->+0xe8
b    0xfffffe000a3460f0   ; register(root, ref, input, client)
```

`register()` (`0xfffffe000a3460f0`, size `0x104`) then does:

```c
lock(root+0x150);
for (node = root->list_head /* +0x188 */; node; node = node->next)
    if (node->key /* +0x20 */ == input[1] /* +0x08 */
        && node->bound /* +0x58 */ == client)
        return 0xE00002C9;                     // duplicate
node = kalloc(0x60);
ipc_init(node+0x10, ref[0], input[0], input[1]);
node->extra /* +0x50 */ = input[2];            // input+0x10
node->bound  /* +0x58 */ = client;
link_at_head(node);
unlock(root+0x150);
return 0;
```

So the private-connection call is fully determined:

* it **must** be `IOConnectCallAsyncMethod` — the wake port is read from
  `args->asyncReference`, and XNU copies the wake port into `asyncReference[0]`
  before the external method runs. `allowAsync = 1` agrees.
* `structureInput` is 0x18 bytes: `{u64 +0x00, u64 +0x08 = key, u64 +0x10 =
  extra}`. Only `+0x08` and `+0x10` are consumed; `+0x00` is passed to the IPC
  constructor alongside `+0x08`.
* A null `asyncReference` is rejected with `0xE00002C2`.

This resolves the long-standing "13-argument async shape" confusion in
`ContentView-v116`: the call is genuinely async, and the harness's guessed
direction (`outS` passed where `structureInput` belongs) needs re-deriving from
this ABI rather than from the wrapper stub it heuristically selected.

`removeByKey` (`0xfffffe000a3461f4`) matches by `input[1] == node->key &&
client == node->bound`, unlinks, destroys the IPC object and frees the node.

---

## 4. Which word is the notification index (corrected)

`dispatchNotify` (`0xfffffe000a3462f0`):

```c
lock(root+0x150);
for (node = root->list_head; node; node = node->next) {
    client = node->bound;          // +0x58
    index  = eventObj->slot;       // [eventObj + 0x10]
    perRequestDispatch(client, node, flags, index);
}
```

`perRequestDispatch` (`0xfffffe000a34ff48`) takes `IOLockLock([client+0xd8])`,
then `lookupElement(client, index, &out)` (`0xfffffe000a34f8cc`), unlocks, and
only if the lookup succeeded sends **two scalars** `(flags, index)` to the IPC
object at `node+0x10`.

Consequences, all proven from the disassembly:

* The lookup index is **`[eventObj+0x10]` — the triggering surface object's
  field**, not anything stored in the request. The `extra` word supplied at
  registration (`node+0x50`) is stored but is **not** used by this dispatch.
* Therefore the notifier client must own an entry at the triggering surface's
  slot for any notification to be delivered. That is what selector `0x04` builds
  (scalar = root slot, output `0xc68`).
* `lookupElement`'s returned element pointer is written to the caller's stack
  slot and never read; only its boolean matters. There is no information leak
  through this path.

---

## 5. Destructor order and the race window

`free`/`destructor` of the notifier client, 24A446 `0xfffffe000a34b2dc`
(size `0xf4`):

```
if (!(client+0xf0 & 1)) goto release;
clear client+0xf0;
teardown1(root = [client+0xe8], client, [client+0xf8]);   // 0xfffffe000a348910
teardown2(root = [client+0xe8], [client+0xf8]);           // 0xfffffe000a3450b0
unlinkByObject(root, client);                             // 0xfffffe000a346364  <-- LAST
release:
  ... OSMetaClass release / free
```

`teardown1`/`teardown2` only detach the client's pointers from root-internal
tables (root `+0x3e8/+0x3f0/+0x400/+0x428` and the list at root `+0x90`,
fields `+0x170`). Neither touches the notify list, and neither frees the client.

`register` and `unlinkByObject` **both** take `root+0x150`, so they serialise
against each other. That is the only ordering guarantee.

**Proven:** after `unlinkByObject` returns and releases `root+0x150`, the client
memory is still live but its destructor has already passed the unlink step; the
memory is released by `free()` after the destructor body returns, **outside the
lock**. A `register` that acquires `root+0x150` in that interval links a node
whose `+0x58` names a client that is being freed, and the node is never removed.
The lock does not close this window — it only orders `register` against
`unlinkByObject` itself.

**Corroboration (inferred, strong):** the 27.2 patch is shaped exactly for this
window. In 24B119 the destructor calls `unlinkByObject` **first`
(`0xfffffe000a3996c4`: `strb wzr,[x20,#0xf0]`, then `bl 0xfffffe000a394744`),
that routine now sets `client+0xf1` while holding the lock
(`0xfffffe000a394744`), and `register` (`0xfffffe000a3944c0`) checks
`[client+0xf1]` immediately after taking `root+0x150` and returns
`0xE00002D8` (`kIOReturnNotAttached`) when set. That is precisely a guard
against "registration landing after unlink".

**Not established:** that a userspace thread can win that interval on real
hardware, that a stale node survives in the list, or that `dispatchNotify`
later walks it. No device evidence yet.

---

## 6. Ceiling — why this is not a kernel read/write lead

If `dispatchNotify` ever reaches `perRequestDispatch` with a stale `node+0x58`,
the only operations on that pointer are:

1. `IOLockLock(*(void**)(stale+0xd8))` — dereference of a garbage/non-existent
   lock pointer;
2. `lookupElement(stale, index)`: reads `stale+0x108`, `stale+0x110`,
   `stale+0x118`, then `elem = base[index]`, `autda elem, #0xf69b<<48`,
   `xpacd`/`cmp`/`brk #0xc472`, and `elem->+0x10 != stale->+0x118`.

Failure modes are a bad-lock dereference (panic) or a PAC mismatch
(`brk #0xc472`, panic). Nothing attacker-controlled is read or written, and the
looked-up element is discarded. `kalloc_type` type isolation means the freed
client slot is normally recycled by another object of the **same** type, so a
foreign object's fields at `+0xd8/+0x108/+0x110/+0x118` are not reachable from
userspace grooming.

Verdict: this is a credible Apple-fixed lifecycle bug (the 27.2 patch shape
matches the identified window exactly) whose realistic impact is a kernel panic
— a denial-of-service, **not** a path to kernel read/write. Keep it as a bounty
candidate; do not spend jailbreak cycles on it beyond the confirmation probe in
§7.

---

## 7. Next steps

1. **Device, when a host enumerates a phone** (Mac over Tailscale currently
   down; PC usbmux empty):
   * open a **private** `IOSurfaceRootUserClient` (`IOServiceOpen` type 0);
   * populate the client table at a surface's root slot with selector `0x04`
     (scalar = slot, `0xc68` output), after resolving slot ↔ public ID;
   * register with selector `0x11` via `IOConnectCallAsyncMethod(wake_port,
     reference, 1, NULL, 0, input18, 0x18, ...)`;
   * validate the receive path with a benign trigger that reaches
     `dispatchNotify` and a known-good message ID/payload.
2. Only then run the bounded race (thread A `IOServiceClose`, thread B
   registering in a loop) with synchronised counters and a validated
   notification oracle, watching for a new kernel panic in the crash-log diff.
3. Reconcile the earlier selector-`0x04` watchdog report against the ABI now in
   §3 before re-running it: the call's input direction is settled, so the old
   "zeroed `0xc68` buffer" record can be attributed properly.

## Reproduction

```sh
python tools/kz-static-diff/kz_iomethod_table.py 24A446 com.apple.iokit.IOSurface \
        --find 0xfffffe000a3498f4 --count 60
python tools/opencode-temp/kc_iosurface.py firmware/24A446/kernelcache.release.macho \
        com.apple.iokit.IOSurface --fn 0xfffffe000a3460f0
```
