---
id: S-remote-event-telemetry-dashboard
type: system
title: Live RemoteEvent telemetry and developer dashboard
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/RemoteEvent","https://create.roblox.com/docs/reference/engine/classes/UnreliableRemoteEvent"]
confidence: medium
verification: tested_studio
client_server: both
roblox_services: [Players, ReplicatedStorage]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","R-remotes-and-validation"]
---

# Live RemoteEvent telemetry and developer dashboard

Files: `remote-telemetry.luau`, `telemetry-dashboard.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Instrument explicit RemoteEvent routes to count inbound/outbound calls and estimate application payload size per player. A token bucket rejects excessive inbound requests before the registered gameplay handler. A small client dashboard shows aggregated rows and flags.

## API and server/client split

Server: `new(config?)`, `Bind(name, remote, handler)`, `Register(name, remote)`, `Send(name, player, ...)`, `Snapshot()`, `Forget(player)`, `Destroy()`. Outbound-only routes use `Register`; inbound routes use `Bind`. Client: `Dashboard.new(playerGui)`, `Render(rows)`, `Destroy()`.

Untested: integration sketch with required modules `Telemetry` and `Dashboard`.

```lua
local telemetry = Telemetry.new({rate = 10, burst = 20})
telemetry:Bind("Interact", interactRemote, validateAndHandleInteraction)
local leaving = game:GetService("Players").PlayerRemoving:Connect(function(player)
    telemetry:Forget(player)
end)
-- On a bounded server timer: send Snapshot() only to server-verified developer UserIds.
-- Client admin listener: dashboard:Render(rows)
```

Create a separate, server-to-admin snapshot RemoteEvent. Check an explicit server-owned UserId allowlist before sending every snapshot; hiding a client panel does not authorize access. Publish at a low cadence (for example every two seconds), exclude telemetry's own remote from instrumentation, and disconnect the timer/listeners at shutdown. A recipient can modify their local display; it has no authority.

## Measurement boundaries

There is no universal transparent hook installed here. Calls bypassing `Bind` / `Send`, existing independent listeners, RemoteFunctions and UnreliableRemoteEvents are not covered. Remove duplicate gameplay listeners when adopting the wrapper. Estimated bytes are not serialized/compressed wire bytes. The estimator stops at 512 nodes/eight levels and flags unsupported/cyclic payloads; it never logs raw contents.

Rows expire logically after the configured window and are capped to registered routes; the host must forget departed players. Snapshot output is bounded to 50 rows, UI to 20. Outbound sends are observed and flagged, not silently suppressed. Automatic sanctions based on size estimates are outside the contract.

| Fault | Behavior |
|---|---|
| Burst exceeds bucket | Inbound handler skipped |
| Cyclic / unsupported / oversized payload | Flagged and rejected |
| Legitimate action passes rate gate | Handler must still validate identity, ownership, shape and state |
| Developer leaves | Forget row ownership; stop sending snapshots |
| Existing handler bypasses wrapper | No protection from this module |

Studio tests covered burst/refill, cyclic rejection, outbound counting and player cleanup with a fake remote. The client panel was rendered with synthetic data; real-network bandwidth and admin authorization integration remain untested.
