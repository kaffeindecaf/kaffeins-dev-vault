---
id: S-quest-achievement-blueprint-factory
type: system
title: Modular quest and achievement blueprint factory
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore","https://create.roblox.com/docs/reference/engine/classes/RemoteEvent"]
confidence: medium
verification: tested_studio
client_server: both
roblox_services: [DataStoreService, ReplicatedStorage]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-objective-tracker","S-ui-progress-bar-component"]
---

# Modular quest and achievement blueprint factory

Files: `quest-blueprint-factory.luau`, `quest-progress-view.luau`, `backend-account-store.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Define objectives by trusted gameplay event, target, version and reward. The factory increments matching quest counters, persists event IDs for replay protection, clamps progress, and atomically claims completion rewards. A client progress view creates and updates rows from server snapshots.

## API and blueprint schema

Server: `new(accounts, definitions, grant)`, `Emit(userId, event, eventId, amount)`, `Claim(userId, questId)`, `Snapshot(userId)`. Client: `View.new(parent)`, `Render(rows)`, `Destroy()`. Definition IDs and versions become durable keys, so migrate existing progress intentionally when changing targets.

Untested: blueprint and event integration; `Factory` is the required module.

```lua
local quests = Factory.new(accounts, {
    hunt = {version = 1, title = "Defeat enemies", event = "EnemyDefeated",
        target = 50, reward = {coins = 500}},
}, grant)
-- After a server-validated defeat:
local eventId = game:GetService("HttpService"):GenerateGUID(false)
local ok, rows = quests:Emit(player.UserId, "EnemyDefeated", eventId, 1)
-- Retain eventId for retries; send successful rows only to that player.
```

The host subscribes to its trusted gameplay bus and owns event delivery. Client messages never choose increments, reward amounts or completion. A remote claim handler accepts only a bounded quest ID, rate-limits requests, derives UserId from the caller, and calls Claim. Send a fresh Snapshot on join and after claims. Snapshot here is a durable update and consumes write budget; use committed rows for display refreshes.

## Failure modes and scale

| Case | Behavior |
|---|---|
| Same event ID retried | No repeated increment |
| Distinct events delivered in a different order | Each counts once |
| Same ID with conflicting amount | Fail closed |
| Completion claimed twice | Reward marker and data grant prevent repeat |
| Client edits its progress bar | No server effect |
| Event source crashes before durable delivery | Progress may be lost unless source has an outbox |
| Frequent gameplay events | Batch using a reviewed durable event source; this example writes per Emit |

The event history is bounded by the shared account store and is never blindly pruned. It records IDs across blueprint versions; deliberately replaying an old event will not apply it to newly added quests. Recurring quests need period/version IDs and a migration policy. The view caps rows at 50; pagination, localization, claim buttons and accessibility are host concerns.

Studio mocks covered duplicate and out-of-order event IDs and single reward claims. UI row reuse/removal and a rendered two-row client preview were checked. Durable gameplay-event sourcing, actual network authorization and long-running history migration remain untested.
