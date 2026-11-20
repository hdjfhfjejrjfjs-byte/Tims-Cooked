# Tims Cooked

Tims Cooked is an exploratory iOS security-research harness and analysis repository for iOS 27.0 and 27.0.1 on arm64e. The research goal is a semi-untethered jailbreak; this repository does **not** contain one.

## Current status

No kernel read/write primitive, kernel code execution, PAC/SPTM bypass, or working jailbreak has been demonstrated. The repository tracks candidate socket, VM, IOSurface, and other kernel paths. Treat each result according to its evidence: a reachable interface or race observation is not, by itself, a memory-corruption primitive or exploit. A 2026-11-20 source review reclassified the earlier socket peer-delivery events as inconclusive because the trigger does not exclude ordinary file-descriptor reuse; no socket UAF is established. See the [socket fd-reuse correction](research-updates/2026-11-20-socket-fd-reuse-erratum.md).

Start with the relevant notes under [`analysis/`](analysis/) and distinguish confirmed observations from hypotheses before running a probe.

## Latest research update — 2026-11-20

Static work on iOS 27.0.1 (build 24A446) has completed an enumeration of kernel writers of the virtual-memory object “pager ready” flag bit. Two candidate producers are identified and characterised: the pager-association routine behind the freezer/pageout chain, which sets the bit only when the object’s internal flag is set, and a memory-object attribute handler reached from the system pager initialisers. Four previously unclassified candidate stores were shown to belong to VFS, network-interface, packet-buffer and Skywalk networking state rather than virtual-memory objects, so they do not affect the guarded fault predicate. Earlier the same day, static analysis connected a Mach-VM-read-like request path to a VM copy/fault candidate. Neither result is a confirmed vulnerability, controlled corruption, kernel read/write primitive, or jailbreak. No new CoW device trigger was run, and device work remains blocked because no authorised Mac currently enumerates a device.

See the [dated research note](research-updates/2026-11-20.md), the [socket fd-reuse correction](research-updates/2026-11-20-socket-fd-reuse-erratum.md), and the [GitHub checkpoint release](https://github.com/ramonburf/Tims-Cooked/releases/tag/research-2026-11-20-d). That release includes the unchanged, sanitized v0.6 IPA (SHA-256 `dd7a4680155fd738d5b279bf0da3e8debf385a0cf44d8636a0c35a3e1039ce50`); no new app build is claimed.

A later static pass re-verified, with an independently written strict address-reference scanner, which kernel functions read the interned DriverKit entitlement keys, and named the single kernel reader of the generic `IOUserClientEntitlements` key (an indirectly entered routine whose enforcement role and owning subsystem are not established). This closes the earlier open question about those readers with exact addresses instead of an inference; it does not reopen any candidate path and no device work was possible.

A later static pass revisited an AppleJPEGDriver request-processing routine that an earlier checkpoint had recorded as unreferenced and possibly dead code. That was a tooling false negative: the address-reference scanner had been handed a truncated address and returned no hits while the rest of the run looked normal. With the full address, six genuine references exist — the decoder/encoder entry bodies hand the routine's signed address to the driver's command gate as a deferred work action, so the shared request-validation checks do execute, asynchronously after the external-method call returns. This corrects the record rather than opening a path: the earlier bounded-negative conclusion stands, now resting on validators that are actually dispatched. A new open question, untested, is whether the request object can be released before the deferred work runs.

A later static pass closed the patch-diff axis of that new question. iOS 27.0.1 (build 24A446) and iOS 27.2 (build 24B119) contain the same number of functions in the AppleJPEGDriver kernel extension, and an index-paired comparison of every function's instruction stream finds no differing functions; an alignment pass that flagged 167 "changed" blocks was re-checked per function and all 167 turned out to be address/data-segment drift. The queued-I/O worker, the completion and client-teardown routines, the six decoder/encoder entry bodies and the validation chain are therefore instruction-shape unchanged upstream, so there is no patch evidence for the deferred-lifetime lead. The four imported-helper targets were disassembled (allocator-shaped, free/delete-shaped, and two object-lifetime-shaped helpers); those identities remain inference, not symbol proof. Whether anything keeps the request alive between enqueue and gate execution is still unresolved, and no use-after-free or kernel primitive is claimed.

A later source-and-log review corrected the historical socket results. The earlier precision and cross-protocol probes counted peer bytes and UDP datagrams as “stale writes”, but their sender counter advances immediately before `sendmsg` and the target descriptor is closed before reclaimer sockets are allocated, so ordinary file-descriptor reuse can produce the same output. Those events are therefore observations, not confirmed use-after-free or object-reclaim hits, and the proposed CVE-2026-112514 mapping remains unverified for this target. The detailed correction and the fd-pinned control needed before any rerun are in the [socket fd-reuse correction](research-updates/2026-11-20-socket-fd-reuse-erratum.md).

## Safety

- Test only on devices you own or are authorized to assess.
- The research workflow is intended to preserve device data. Do not restore, update, downgrade, or write firmware as part of these probes.
- A kernel or system-service probe can still crash or reboot a device. Stop after a crash, respring, or unexpected reboot, then preserve the logs before continuing.
- Review a probe and its resource limits before running it. Do not treat a successful launch or a userland crash as proof of kernel impact.
- Keep signing credentials, device identifiers, host details, and private operational notes out of commits.

## Release 0.6

The `v0.6` release asset is `TimsCooked-v0.6.ipa` (build 6, bundle identifier `com.example.timscooked`). It is an ad-hoc-signed research build with no embedded provisioning profile. Re-sign and provision it with your own development identity before installation. It is a harness for research, not a jailbreak or a general-purpose security tool.

## Build and run

Building requires macOS and Xcode. Installing on a device also requires a locally configured signing identity and a device enabled for development.

From the `carrier/` directory, build for a connected device:

```sh
cd carrier
DEV=<device-identifier> ./build_race.sh
```

The script writes the app to `.build13/Build/Products/Debug-iphoneos/AGXProbe.app`. Install and launch it with the bundle identifier configured in your local Xcode signing settings:

```sh
xcrun devicectl device install app --device "$DEV" \
  .build13/Build/Products/Debug-iphoneos/AGXProbe.app
xcrun devicectl device process launch --device "$DEV" --console \
  --terminate-existing <your-bundle-identifier> --sockprec
```

The build helper accepts `KEYCHAIN_PW` from the environment when Xcode needs the login keychain unlocked. Do not put the password in the script or in shell history. Signing settings belong in your local Xcode configuration, not in this repository.

### Harness modes

| Argument | Purpose |
|---|---|
| `--sockuaf` | Run the socket-lifetime race variants |
| `--sockprec` | Run the gated socket probe with its peer-delivery oracle |
| `--sockool`, `--sockxz`, `--sockgc` | Run experimental reclaim and spray variants |
| `--web`, `--webscan` | Run WebKit probes |
| `--probe` | Run the IOSurface probe sweep |

These modes are experimental and may crash the app or device. Their names describe what a probe attempts, not a confirmed vulnerability or exploit.

## Tests

The standalone Swift regression checks do not require a device or signing. Run them on macOS:

```sh
cd carrier/tests
swiftc -O fixcheck.swift -o "$TMPDIR/fixcheck" && "$TMPDIR/fixcheck"
swiftc -O logcheck.swift -o "$TMPDIR/logcheck" && "$TMPDIR/logcheck"
```

See [`carrier/tests/README.md`](carrier/tests/README.md) for test coverage and limits.

## Repository layout

- `carrier/` — SwiftUI research harness and headless regression checks.
- `analysis/` — firmware, kernel, reachability, and experiment notes.
- `tools/` — supporting parsers and analysis utilities.

Research notes can be build-specific and provisional. Reproduce a result on the stated OS build before drawing conclusions from it.
