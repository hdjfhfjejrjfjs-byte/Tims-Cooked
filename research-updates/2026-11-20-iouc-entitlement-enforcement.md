# The user-client entitlement gate is enforced on an indirect-entry server path

Date: 2026-11-20
Builds: iOS 27.0.1 (24A446, target)
Device work: **none.** No authorised Mac currently enumerates a device, so this
pass is static binary reading only.

## Why this pass happened

An earlier checkpoint located the kernel's reader of the generic
`IOUserClientEntitlements` property key — the mechanism by which a kernel
extension declares which entitlement a client must hold to obtain its user
client. That left two questions open: whether the routine *enforces* anything
or merely queries the property, and whether it sits on the user-client open
path at all. This pass settles both.

## Method

The answer was not in the call graph. It is in the diagnostic strings the
routine owns. The kernel image contains exactly six user-client refusal
messages ("missing `IOUserClientEntitlements` property", "value not boolean
false or string", "missing entitlement in process", "failed MACF in process",
"failed sandbox in process", and a default-locking requirement). Resolving
every code site that materialises each string shows that all six are referenced
from one single function. A routine that prints a refusal message for a
specific condition is the enforcement point for that condition, so the query
versus enforce question is settled by string ownership rather than by following
callers.

## Result

**Enforcement is real, and the verdict travels in an output slot rather than the
return value.** The function accumulates a failure code and stores it through a
caller-supplied pointer; it returns success itself either way. A caller that
only checked the return value would see success on a refused request. The
failure codes are derived from the IOKit common-error base with small offsets,
matching the `BadArgument`, `Unsupported` and `NotPermitted`-family values this
project has already measured on device; the fourth offset corresponds to the
`NotPrivileged` entry and is inferred from the error table rather than measured
here.

**Its only direct caller is a server-shaped request/reply handler.** That
handler validates a fixed-size request record against several field checks,
resolves an object from the record, calls the entitlement/sandbox gate with an
output pointer, and then writes the gate's verdict into a reply record along
with reply header fields before releasing intermediate objects. That is the
shape of a message-dispatched server routine rather than an inline helper, and
it places the entitlement check on a message-handling path — not dead code, and
not a passive property read.

**The surrounding family is larger than one routine.** Several other handlers
share the same prologue and differ in the request size they declare, so the
size field appears to discriminate between them. Two small helpers compare an
object's class against interned symbols and are called only from two of those
handlers.

**No ingress was found, with controls.** For each of these handlers, three
independent scans over the whole multi-extension kernel image were run: a
word-level scan for direct branch and indirect-branch sites, a raw search for
arm64e authenticated pointer slots, and a chained-fixup reference search. All
returned nothing for every handler, while positive controls in the same runs
returned hundreds to thousands of hits. The handlers are therefore entered
indirectly, consistent with registration in a boot-built routine table — but
that table was not located, so how they are registered remains open.

One related pair is suggestive but unproven: a large dispatcher references the
internal method-shim name strings while validating scalar counts, and is called
once from another routine that itself has no discovered caller and no pointer
slots. That pair may be the top of the RPC shim dispatch, but its entry is
unresolved.

## What this does and does not change

* It closes an open question with exact evidence instead of an inference: the
  entitlement gate enforces, and it runs on an indirectly entered server path.
* It does **not** reopen any candidate path. The gate is the intended barrier;
  nothing here is memory-unsafe, and no selector, syscall or app-facing entry
  reaches this cluster in the scanned image.
* No vulnerability, kernel read/write primitive, kernel code execution, or
  jailbreak is claimed. Device work remains blocked because no authorised build
  host currently enumerates a device.

## Next step if resumed

Locate the boot-built routine array that registers the large dispatcher, so
"indirect entry" becomes a named subsystem. That would either produce an
app-facing entry to test or close the cluster outright; until then, spending a
device cycle here is not justified.
