---
id: S-matchmaking-room-orchestrator
type: system
title: State-driven matchmaking and room orchestrator
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://create.roblox.com/docs/reference/engine/classes/MessagingService"]
confidence: medium
verification: tested_studio
client_server: server
roblox_services: [Players, RunService]
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","S-round-phase-machine","S-late-join-sync"]
---

# State-driven matchmaking and room orchestrator

Files: `match-room-fsm.luau`, `room-orchestrator.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Create independent server-local rooms with player capacity and explicit phases: WaitingForPlayers → Intermission → MapLoading → ActiveRound → MatchOver. A player belongs to at most one room. Each room exposes a BindableEvent for state changes and a snapshot for late UI listeners.

## API and scheduling

`Rooms.new()`, `Add(id, capacity, config, loader)`, `Join(player, id)`, `Leave(player)`, `Step(now)`, `Remove(id)`, `Destroy()`. `Add` returns the room FSM: `Changed`, `Snapshot()`, `Finish(now, reason)`. Call `Step(os.clock())` at a bounded cadence. A custom clock may be injected via `config.clock`, and must match Step's time domain.

Untested: setup sketch; `Rooms` is the required module.

```lua
local rooms = Rooms.new()
local round = rooms:Add("lobby", 8, {
    minPlayers = 2, intermission = 10, loadTimeout = 20,
    roundDuration = 180, resultsDuration = 8,
}, loadMapAndReturnCleanup)
round.Changed:Connect(function(nextState, previous, epoch, reason)
    publishRoomState(nextState, epoch)
end)
```

The loader may yield and returns an idempotent, non-yielding map cleanup function. It must clean partial work if it errors. Load tokens prevent a slow cancelled loader from activating a stale map. A timeout invalidates the token; it cannot preempt a loader that never yields. Keep total concurrent loaders bounded in the project host.

Connect PlayerRemoving to `Leave`, disconnect room listeners, and call `Destroy` on shutdown. Joins are allowed only during Waiting/Intermission; the host defines spectators, team assignment, eligibility, rewards and spawn placement. MatchOver cleanup runs once. Falling below the minimum ends an active round.

## Failure modes and tests

| Case | Contract |
|---|---|
| Player joins twice / two rooms | Reject |
| Room full / already loading | Reject join |
| Players leave intermission | Return to waiting |
| Loader errors or deadline expires | Return to waiting; stale results cleaned |
| Timer and objective finish together | Only first Finish succeeds |
| Late listener | Read Snapshot before subscribing/publishing under host ordering |

Studio covered phase progression, repeated finish refusal, cleanup, capacity and membership. Stale-loader races, real map errors and multiplayer scheduling remain project tests. This is local room orchestration; cross-server skill queues, reserved server allocation and TeleportService recovery are separate systems.
