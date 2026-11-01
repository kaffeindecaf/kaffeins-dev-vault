---
id: S-late-join-sync
type: system
title: Late join and reconnect synchronisation
status: reviewed
updated: 2026-11-01
tags: [systems, multiplayer, state]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 1
related: "R-janitor-cleanup", "S-objective-tracker", "R-memorystore-messaging"
---

# Late join / reconnect

A player who joins mid-round must see a consistent world in one frame, not a five-second trickle that
lets them walk through a door that is already open.

## The snapshot pattern

```lua
-- Untested
local function pushSnapshot(player)
    StateEvent:FireClient(player, {
        round = { phase = Round.phase, remaining = Round.remaining, id = Round.id },
        doors = Door.snapshot(),          -- [{id, open, locked}]
        players = PlayerView.snapshot(),  -- [{userId, name, hp, stance}]
        objectives = Objectives.snapshot(player),
        world = { lights = Power.snapshot(), loot = Loot.counts() },
    })
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    pushSnapshot(player)
end)
```

Then deltas: `StateDelta:FireAllClients({ door = { id = "front", open = true } })`.

## Rules

1. **One snapshot function, used by both join and reset.** A snapshot that only the late-join path
   uses is a snapshot that drifts.
2. **Snapshot after the character exists**, or the client applies it to nothing and rebuilds.
3. **Full snapshot on reconnect**, not deltas — the client missed everything.
4. **The client must tolerate a delta for an object it has not seen yet** (arrives before the
   snapshot). Buffer or ignore, never error.
5. **Bindables and connections created per player are leaks** — see [[R-janitor-cleanup]].

## The classic bug this prevents

*A player joining mid-round misses `RoundStartBindable`* and therefore never gets a HUD state: the
HUD shows 0:00 and no objectives. Fix by making every system's state derivable from one snapshot
rather than from a historical event the late joiner will never receive.

## Test cases

1. Join mid-round → HUD, doors and objectives correct within one frame.
2. Rejoin after reconnect → same.
3. Join while a door is opening → snapshot shows the post-transition state, not mid-tween.
4. Delta arrives before snapshot → no error.
5. Leave and rejoin during reset → no duplicate handlers.

