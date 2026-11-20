# Jailbreak paths — completion by path

Updated: 2026-11-20. Target: iPhone 17 Pro, iOS 27.0.1 (24A446).

Same percentage convention as `PROGRESS.md`: **how far along that path is toward being a
working part of the chain**, not the probability it eventually works. 100 % means done and
verified on hardware. A path can be at 90 % and still be dead (for example, entitlement-gated).

Overall readiness: **not re-scored**. The earlier ~30% included the socket lead as a demonstrated race; that interpretation is withdrawn. No kernel read/write primitive is verified, and the remaining chain is not established.

## Paths

| # | Path | Primitive | Reachable | % | Status |
|---|------|-----------|-----------|---|--------|
| 1 | Socket UAF lead (CVE-2026-112514 mapping unverified) | unknown | socket API reachable; bug path unproven | **5 %** | Historical peer-delivery/UDP events do not establish UAF: the sender counter increments before `sendmsg`, target fd closes before reclaimer allocation, and ordinary fd reuse can explain the output. No kernel primitive established. |
| 2 | AppleJPEGDriver struct surface | unknown (bulk image input) | yes — opens type 0/1 | **40 %** | Dispatch table recovered, selectors 1–7 callable with no entitlement. Structs partly reconstructed. No bug found yet. |
| 3 | IOSurface notify UAF family (CVE-2026-112517 / -112516 / -112477) | UAF | yes — `IOSurfaceRoot` opens type 0 | **25 %** | Bug site confirmed in the 27.0.1→27.2 diff. PAC/type-confusion constraints unresolved. |
| 4 | IOHIDFamily OOB R/W (CVE-2026-112507) | OOB read/write | unproven | **20 %** | Patch confirmed in diff. No sandbox-openable HID user client identified. |
| 5 | Diff-derived kernel UAF candidates (542 changed kernel funcs) | unknown | unknown | **15 %** | Triage list produced; state-byte check clusters unmapped. No candidate confirmed. |
| 6 | IOGPU / Metal F1 cross-object GPU overlap | GPU write into another allocation | **no** on t8150 | **35 %** | Primitive proven on A16/27.3β. Direct `IOSurfaceRoot` user-client route returns `kIOReturnBadArgument` for every shape; parser never entered. |
| 7 | AGXG18P channel-index OOB read | 1-bit read oracle | entitlement-gated | **45 %** | Unchecked sequence confirmed live. Needs `com.apple.private.agx.performance-spi`; shapes for the one reachable selector do not match. |
| 8 | GMMU-TLBI DeviceTree gap | TLB-invalidation race | yes | **15 %** | Gap confirmed absent in both v53ap DeviceTrees. Needs SPTM-level timing, realistically Corellium-only. |
| 9 | Exclave / ImageIO decoders | parser corruption | yes | **10 %** | Saturated surface; shared caches only partly extracted. No concrete lead. |
| 10 | TXM loop-counter diff | — | — | **5 %** | Hardening, not a vulnerability. Kept as context for the post-R/W stage. |

## Downstream stages (shared by every path)

| Stage | % | Status |
|---|---|---|
| KASLR slide oracle (timing) | **60 %** | Referenced as `z=7.67` in `analysis/references/SOCKET_UAF_ANALYSIS.md`; not yet documented or re-verified against 27.0.1. |
| Kernel R/W conversion | **0 %** | No kernel write primitive has been established; historical socket peer-delivery hits are inconclusive. |
| EL1 code exec past PAC / CTRR / SPTM (TXM trustcache) | **5 %** | Not started. |
| Credential patch + rootless bootstrap (package manager) | **5 %** | Not started. |

## Path detail

### 1. Socket lead — CVE-2026-112514 link unverified

The historical precision and cross-protocol probes produced peer bytes and UDP datagrams,
but the harness does not pin the target fd. Its `entered` counter advances immediately before
`sendmsg`; after the target is closed, the harness allocates reclaimer sockets. A syscall that
resolves the numeric fd afterward can use a newly allocated socket, explaining the same output
without a stale kernel pointer. The old 20 precision hits and 109/4 `--sockmix` events are
therefore **not confirmed UAF writes or object-reclaim hits**.

The follow-up `sockfield` scan queried ordinary socket options on hammer descriptors but did
not identify which kernel object backed any descriptor. Its zero-differential result does not
close the corrupted-field question. The claimed CVE mapping and 27.2 fix attribution are also
unverified for the target; the target `sbunlock` candidate already contains relevant guards.

Next falsifiable step: implement an fd-pinned control that atomically replaces the target
number with a pre-opened placeholder using `dup2`, keeps it open through all sender returns,
and logs target/reclaimer descriptor numbers. Run an unguarded fd-reuse control separately.
Do not claim UAF or reclaim without excluding numeric reuse and adding an independent
object-lifetime/corruption oracle. No new device run was made for this correction.

### 2. AppleJPEGDriver

40 %: open confirmed on types 0 and 1; vtable and 10-entry dispatch table recovered at
`0xfffffe00080dd320` / `0xfffffe00080dd990`; selectors 1–7 (`startDecoder`, `startEncoder`,
`startDecoderExt`, `startEncoderExt`, `startDecoder2024`, `startEncoder2024`) accept 0x58 /
0x1000 / 0xda0-byte caller structs with no `com.apple.private.*` gate
(`analysis/LEAD-ASSESSMENT.md` §12). Structs partly reconstructed.

Missing: the actual bug. No validation flaw yet; 0x58/0x1000/0xda0 paths only partly traced.

### 3–5. Other diff-derived kernel bugs

Bug sites are confirmed in the binary diff but none is converted. IOSurface is the furthest
(25 %) because the fix is exactly two instructions; it is also the most PAC-constrained.

### 6–8. Demoted paths

Kept because each has a proven primitive or a confirmed property gap, but each is blocked by a
specific external condition (unreachable parser, entitlement, SPTM timing).

### 9–10. Long tail

No concrete candidate; recorded so the search space stays visible.

## Priority

1. Socket UAF conversion (path 1) — only live primitive, and it is already reliable enough to
   produce hits on demand.
2. AppleJPEGDriver struct review (path 2) — best untouched static surface.
3. IOSurface notify family (path 3) — strongest fallback if socket conversion stalls.
4. Everything else stays parked.
