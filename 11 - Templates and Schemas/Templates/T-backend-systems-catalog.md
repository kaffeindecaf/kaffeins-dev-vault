---
id: T-backend-systems-catalog
type: template
title: Backend systems catalog and integration guide — v1.0.0
status: draft
updated: 2026-11-02
tags: [template, luau, backend, integration, v1]
source_urls: []
confidence: medium
verification: tested_studio
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["SRC-backend-platform-contracts", "N-BACKEND-SYSTEMS-TEST-REPORT"]
---

# Backend systems catalog — v1.0.0

Ten original framework-independent systems based on a requested feature list. They use small constructor-based ModuleScripts and explicit dependencies; Knit, Matter, Janitor and ProfileStore are optional project choices, not required packages. The code is a reusable starting point with scoped Studio evidence, not a claim of production certification.

## Choose a system

| System | Entry | Implementation files |
|---|---|---|
| 1. Data Vault shadow backup and session integrity guard | [[S-data-vault-shadow-backup]] | [data-vault-guard.luau](<../Luau Snippets/data-vault-guard.luau>), [redacted-webhook-alert.luau](<../Luau Snippets/redacted-webhook-alert.luau>) |
| 2. Cross-server transaction and gift ledger with durable recovery | [[S-cross-server-gift-ledger]] | [cross-server-gift-ledger.luau](<../Luau Snippets/cross-server-gift-ledger.luau>), [backend-account-store.luau](<../Luau Snippets/backend-account-store.luau>) |
| 3. Dynamic component lifecycle and memory leak suspect profiler | [[S-lifecycle-memory-leak-profiler]] | [lifecycle-leak-profiler.luau](<../Luau Snippets/lifecycle-leak-profiler.luau>) |
| 4. Live RemoteEvent telemetry and developer dashboard | [[S-remote-event-telemetry-dashboard]] | [remote-telemetry.luau](<../Luau Snippets/remote-telemetry.luau>), [telemetry-dashboard.luau](<../Luau Snippets/telemetry-dashboard.luau>) |
| 5. Universal rolling replay and killcam recorder | [[S-rolling-replay-killcam]] | [rolling-replay-recorder.luau](<../Luau Snippets/rolling-replay-recorder.luau>), [replay-player.luau](<../Luau Snippets/replay-player.luau>) |
| 6. State-driven matchmaking and room orchestrator | [[S-matchmaking-room-orchestrator]] | [match-room-fsm.luau](<../Luau Snippets/match-room-fsm.luau>), [room-orchestrator.luau](<../Luau Snippets/room-orchestrator.luau>) |
| 7. Proximity component culling and network interest routing | [[S-proximity-workspace-streamer]] | [proximity-component-culler.luau](<../Luau Snippets/proximity-component-culler.luau>), [interest-event-router.luau](<../Luau Snippets/interest-event-router.luau>) |
| 8. Daily rewards and multi-tier retention engine | [[S-daily-retention-engine]] | [retention-engine.luau](<../Luau Snippets/retention-engine.luau>), [backend-account-store.luau](<../Luau Snippets/backend-account-store.luau>) |
| 9. Centralized gamepass and developer product fulfillment center | [[S-purchase-fulfillment-center]] | [purchase-fulfillment-center.luau](<../Luau Snippets/purchase-fulfillment-center.luau>), [backend-account-store.luau](<../Luau Snippets/backend-account-store.luau>) |
| 10. Modular quest and achievement blueprint factory | [[S-quest-achievement-blueprint-factory]] | [quest-blueprint-factory.luau](<../Luau Snippets/quest-blueprint-factory.luau>), [quest-progress-view.luau](<../Luau Snippets/quest-progress-view.luau>), [backend-account-store.luau](<../Luau Snippets/backend-account-store.luau>) |

Shared economy helper: [backend-account-store.luau](<../Luau Snippets/backend-account-store.luau>).
Tests: [backend-systems.spec.luau](<../Luau Snippets/backend-systems.spec.luau>), [backend-runtime.spec.luau](<../Luau Snippets/backend-runtime.spec.luau>), [backend-test-runner.luau](<../Luau Snippets/backend-test-runner.luau>).
Evidence and remaining tests: [[BACKEND_SYSTEMS_TEST_REPORT]].

## Copy layout

Create ModuleScripts with the exact filename stem, including hyphens and `.spec` for the test files. Keep modules that require siblings in the same folder. Roblox ModuleScript Source is the content of the corresponding `.luau` file.

Keep the account store, guard, webhook sender, ledger, telemetry server, room FSM/orchestrator, interest router, retention engine, purchase center and quest factory server-only. Copy only the following client presentation modules into ReplicatedStorage: telemetry-dashboard, rolling-replay-recorder (if recording client visuals), replay-player, proximity-component-culler and quest-progress-view. A server recorder may instead stay server-only.

The files create no DataStores, remotes or purchase callback merely by being required. Constructors wire dependencies; `Center:Install()` explicitly claims the receipt callback. The host owns event connections, timers, admin authorization, remote creation, retries and teardown.

## Shared atomic account owner

The helper is an isolated, low-throughput account-store example. It uses UpdateAsync for every operation; it does not hold a session-locked cached profile or implement ProfileService/ProfileStore. **Never point it at keys written by a separate cached profile saver.** To reuse an existing profile library, implement the same account transaction contract within that library's single writer, including durable commit acknowledgment, deduplication and offline-account policy.

The account schema includes integer `coins`, unique `inventory`, receipt history, transfer inbox/outbox, retention streak/checkpoints/claims, versioned quest states and quest event history. Missing/unknown stored schemas fail closed rather than becoming defaults. `nil` inside a successful UpdateAsync is the only new-account path.

The Data Vault guard's default checks use the separate illustrative fields `Inventory` and `Coins`; customize those checks before connecting it to the lowercase account schema. It is intended to supervise an existing save owner, not to become a second writer.

Untested: server bootstrap template. Create `BackendModules` next to the host Script, fill your product dictionary, and pass a deliberately selected isolated DataStore.

```lua
local Backend = script.Parent.BackendModules
local Accounts = require(Backend["backend-account-store"])
local Ledger = require(Backend["cross-server-gift-ledger"])
local Retention = require(Backend["retention-engine"])
local Center = require(Backend["purchase-fulfillment-center"])
local Factory = require(Backend["quest-blueprint-factory"])

local function buildServices(isolatedDataStore, productRewards)
    local accounts = Accounts.new(isolatedDataStore)
    local function grant(data, reward)
        assert(type(reward) == "table" and Accounts.Integer(reward.coins), "invalid_reward")
        assert(Accounts.Integer(data.coins + reward.coins), "balance_overflow")
        data.coins += reward.coins
    end
    return {
        accounts = accounts,
        gifts = Ledger.new(accounts), -- optionally inject a MemoryStoreSortedMap + MessagingService
        retention = Retention.new(accounts, {
            daily = {{coins = 25}, {coins = 50}, {coins = 100}},
            playtime = {hour = {seconds = 3600, reward = {coins = 200}}},
            events = {},
        }, grant),
        purchases = Center.new(accounts, productRewards, grant),
        quests = Factory.new(accounts, {
            hunt = {version = 1, title = "Defeat enemies", event = "EnemyDefeated",
                target = 50, reward = {coins = 500}},
        }, grant),
    }
end

-- Your project selects its test store and supplies its real product mappings:
-- local services = buildServices(testDataStore, productRewards)
-- services.purchases:Install()
```

`accounts:Update(userId, transform)` returns `true, result, committedSnapshot` or `false, diagnostic`.
A successful transform may return a semantic refusal such as `insufficient_funds` or `already_claimed`; read the result as well as the transport boolean. Transforms are deterministic, non-yielding and free of external effects. Roblox may rerun them. Do not create Instances, send remotes, call services or grant external items inside a transform.

After a successful commit, update your read-only UI cache from the returned snapshot. Never make a cached snapshot authoritative for later replacement writes. An API error may follow a committed write; retry the same operation ID instead of generating a new receipt, transfer or quest event ID. The host must maintain its own durable command/event source when losing an operation ID or an undelivered event is unacceptable.

## Budgets, history and shutdown

The example limits each history/inventory map to 2,000 entries, retention claims to 2,000 entries, encoded account bytes to 3,000,000 and waiting requests per user to 16. Writes use explicit FIFO tickets per user within a server; UpdateAsync resolves cross-server conflicts, without imposing a global arrival order. These are chosen safeguards, not Roblox platform quota claims. Hitting them refuses updates and can defer purchases; design archival and partitioning before a project reaches them. Never delete idempotency records simply to make space.

Reads via Snapshot also consume an UpdateAsync operation. Batch high-frequency quest/progression events through a reviewed durable source; avoid per-frame writes. Spread playtime checkpoints and recovery jobs across keys, monitor budgets and retry with bounded jitter. The helper performs one API attempt and reports ambiguous failures to the operation owner.

On PlayerRemoving: forget telemetry rows, leave rooms, stop per-character work, flush owned cumulative playtime and recover pending work within a shared deadline. On BindToClose: stop accepting new work, disconnect hint subscriptions/timers and wait for in-flight operations within the shutdown window. `accounts:Close()` refuses queued/new work; it does not cancel an already executing UpdateAsync or guarantee a full drain. Preserve durable pending transfers for later recovery.

## Reproduce the Studio checks

In an isolated test place, create `ServerStorage.UnitTest` with `Modules` and `Cases` folders. Put the 19 modules other than backend-test-runner in Modules. Put backend-test-runner at UnitTest.RunUnitTest. A disabled ServerScriptService.UnitTestRunner can call that entry point manually. These tests use fake account storage and fake player lookup; no live purchases, webhooks or persistent writes are made.

Tested: the following case adapter and runner invocation were used in Studio Play on 2026-11-02; see [[BACKEND_SYSTEMS_TEST_REPORT]].

```lua
-- Source for ServerStorage.UnitTest.Cases.Backend_Test:
return function(t)
    local m = script.Parent.Parent.Modules
    t.test("durable economy interruption scenarios", function()
        require(m["backend-systems.spec"])(m)
    end)
    require(m["backend-runtime.spec"])(t, m)
end
```

Tested: server command in Play.

```lua
return require(game:GetService("ServerStorage").UnitTest.RunUnitTest)(nil, 5)
```

The built-in runner was adapted from Roblox's `rbx-unit-test` skill. It is intended for controlled tests; a yielding timeout cannot preempt a tight non-yielding loop. Published multi-server recovery, live purchase processing, animation asset playback, webhook delivery and mobile performance remain integration tests. Per-system notes name their exact gaps.
