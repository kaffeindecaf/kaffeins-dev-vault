---
id: S-daily-retention-engine
type: system
title: Daily rewards and multi-tier retention engine
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/GlobalDataStore","https://luau.org/library/"]
confidence: medium
verification: tested_studio
client_server: server
roblox_services: [DataStoreService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-session-reward-grid"]
---

# Daily rewards and multi-tier retention engine

Files: `retention-engine.luau`, `backend-account-store.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Use server UTC timestamps for daily streaks, server monotonic elapsed time for playtime, and explicit event windows for loyalty claims. Reward dictionaries are separate from the core engine. Each claim writes its marker and reward in one atomic account update.

## API and reward dictionaries

`new(accounts, rewards, grant)`, `ClaimDaily(userId, utcNow)`, `CheckpointPlaytime(userId, sessionId, totalSeconds)`, `ClaimPlaytime(userId, tierId)`, `ClaimEvent(userId, eventId, utcNow, eligible)`. `grant(data, reward)` and `eligible(data)` are deterministic, non-yielding server functions. The catalog includes a complete coins-only grant adapter.

Untested: dictionary sketch; `Retention`, `accounts` and `grant` come from the catalog bootstrap.

```lua
local retention = Retention.new(accounts, {
    daily = {{coins = 25}, {coins = 50}, {coins = 100}},
    playtime = {hour = {seconds = 3600, reward = {coins = 200}}},
    events = {}, -- eventId = {starts = utcStart, ends = utcEnd, reward = {...}}
}, grant)
local ok, result = retention:ClaimDaily(player.UserId, os.time())
```

A UTC day is `floor(timestamp / 86400)`: next UTC day increments the streak; a missed day resets it to one; same/backward day does not award. This is a calendar reset, so claims shortly before/after midnight are valid. It does not mean a rolling 24-hour cooldown. Daily rewards cycle through the dictionary.

Use one generated session GUID and cumulative `floor(os.clock() - sessionStart)` for playtime checkpoints. Retrying the same session total adds only the delta; retain pending checkpoints before issuing newer ones if retries can reorder. Flush at coarse intervals, departure and shutdown within budgets. Unsaved elapsed time can be lost on a crash. Never accept a client's reported elapsed time or session ID.

## Failure modes and checks

| Case | Behavior |
|---|---|
| Repeated daily/tier/event claim | Previously recorded marker prevents repeat |
| Streak crosses a DST change | UTC day logic has no local DST branch |
| Event end timestamp reached | End is exclusive |
| Write commits but response is lost | Retry the same claim/checkpoint |
| Histories reach cap | Refuse update; plan safe migration/compaction |
| Rewards/config change | Version tier/event IDs deliberately; keep historical meaning |

Studio mocks covered midnight, duplicate day, missed-day reset, cumulative checkpoint deduplication, tier replay and event end exclusivity. Clock drift operations, long-term history migration and actual persistence remain untested.
