# Apple Neural Engine direct user-client route re-checked against the kernel's published classes

Date: 2026-11-20
Builds: iOS 27.0.1 (24A446, target) and iOS 27.2 (24B119, reference)
Device work: **none.** No authorised Mac currently enumerates a device, so this
pass is static binary reading only.

## What was re-checked

An earlier checkpoint measured the Neural Engine attack surface on device and
closed the direct route: the engine service answered every attempted client type
with an unsupported return, and the one service that did open was dismissed as a
power/load-management helper because of its class name. That dismissal rested on
a class-name substring. Because the project has previously been misled by
substring reasoning about kernel classes, the question was re-opened and settled
from the kernelcache itself.

## Method

The kernelcache's `__PRELINK_INFO` segment carries one property list whose
per-kext entries include `IOKitPersonalities`. Reading that dictionary gives the
exact `IOClass`, provider class and match keys each extension publishes, instead
of inferring services from names. A small reusable reader was written for this;
the same pass joined the published personalities of all 91 extensions that
differ between the two builds.

## Result

The Neural Engine interface extension publishes six personalities. The one keyed
`ANEDriver` instantiates the class **`H1xANELoadBalancer`**, matched through the
resource plane. The engine class **`H11ANEIn`** is published separately through
the RTBuddy service plane (property match on the role) and through the ARM I/O
plane (name match). In other words, the service that the earlier device sweep
successfully opened — registry name containing `ANEDriverRoot`, class
`H1xANELoadBalancer` — is the load balancer, exactly as the earlier note assumed,
and not the engine.

The static shape is consistent with that. The extension contains two
client-factory routines; the larger one logs a `newUserClient` message carrying
the requested type and dispatches two type values into a creation path while
returning an unsupported code for the rest. Neither factory sits on the engine
class's dispatch path, and the engine class exposes no external-method table
entry that the measured opens could have reached. Every measured open type on the
engine returned the same unsupported code, which matches a class that does not
override client creation at all.

## Consequences

* The direct Neural Engine route stays closed for an unprivileged app-carried
  probe. No app-reachable trigger for the two kernel-memory-corruption
  advisories in that component is established.
* The alternative ingress — a crafted CoreML model that drives the driver into
  the unchecked procedure/symbol indexing — remains possible in principle but is
  a large unstarted sub-project (model compiler plus format reverse engineering),
  not a next step with a known shape.
* No percentage changes: nothing here is a vulnerability, a controlled
  corruption, a kernel read/write primitive, or a jailbreak, and no device probe
  ran.
* Reachability calls should use the published personality dictionaries rather
  than class/name substrings. That is the concrete lesson of this pass: the
  ambiguous name `ANEDriverRoot` resolved cleanly once the extension's own
  personality was read.

## Also in this pass

The same census lists the published service classes of every extension whose
code differs between the two builds. It is reconnaissance only. Several
extensions with large cross-build deltas publish services an app can enumerate
(for example a DRM component, a secure-enclave credential component, a firmware
endpoint family and a storage transport family); none is claimed as a lead, and
the delta counts come from index pairing, which overstates change when a build
adds or removes a function. Any follow-up should localise a specific changed
function before treating such a member as a candidate.
