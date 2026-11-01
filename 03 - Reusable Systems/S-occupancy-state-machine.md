---
id: S-occupancy-state-machine
type: system
title: Occupancy machine: one occupant, server-owned transitions (extracted)
status: reviewed
updated: 2026-11-01
tags: [systems, hiding, state, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 2
related: "S-hiding-spots", "S-round-phase-machine", "R-raycasting-and-collision-filters", "R-tween-patterns"
---

# Occupancy machine

Anything with a limited slot (hiding spot, seat, vehicle, locker, vault) needs three things: an occupancy map
that is written synchronously, a state the server owns end-to-end, and a release path for **every** way a player
can stop occupying it (exit, death, disconnect, round reset, teleport).

## Structure

```lua
-- Untested in this vault: read from a live place, generalised from a two-door hiding spot.
local CFG = {
    ENTER_DISTANCE = 10,   -- studs
    PROMPT_HOLD = 0.2,     -- seconds (short, deliberate)
    DOOR_TIME = 0.22,      -- seconds per door slide
    BODY_TIME = 0.28,      -- seconds to slide the character in/out
    REMOTE_COOLDOWN = 0.1, -- per-client request throttle
    EXPOSE_TIME = 0.28,    -- seconds of exposure after leaving
}

local occupied = {}   -- [spot] = { player = p, tweens = {...}, inside = true }

local function isCurrent(player, state)     -- guards every async continuation
    local s = occupied[spotFor(player)]
    return s and s.player == player and s == state
end

local function enter(player, spot, state)
    if occupied[spot] then return false, "occupied" end
    occupied[spot] = state                    -- reserve BEFORE any tween/wait
    state.player = player
    player:SetAttribute("IsHiding", true)
    -- animate: door, then body; keep the tween handles so exit can cancel them
    state.tweens = { slideDoors(spot, true), slideBody(player, state.insideCFrame) }
    return true
end

local function release(player, spot, state)
    if occupied[spot] ~= state or state.player ~= player then return false end
    for _, t in ipairs(state.tweens or {}) do if t then t:Cancel() end end
    occupied[spot] = nil
    player:SetAttribute("IsHiding", false)
    player:SetAttribute("ExposedUntil", os.clock() + CFG.EXPOSE_TIME)
    return true
end
```

## The five release paths (all required)

| Event | Why |
|---|---|
| player exits | the normal path |
| `Humanoid.Died` | a dead player must not hold the slot |
| `Players.PlayerRemoving` | a disconnect must not leak the slot |
| round reset | a new round starts with every slot empty |
| teleport / re-parent | the character can move while "inside" |

If any one of these is missing you eventually get "the closet is stuck" and nobody can reproduce it.

## Async is the enemy — the resume guard

```lua
-- Untested: the bug this prevents
coroutine.wrap(function()
    doorTween.Completed:Wait()
    task.wait(CFG.BODY_TIME)
    if not isCurrent(player, state) then return end   -- ← someone released us during the wait
    state.inside = true
    applyInsideEffects(player)
end)()
```

Every `Wait()` / `task.wait()` is a window in which `Died`, a round reset or an exit handler can run. Capture
what you need **before** the yield and re-check the guard **after** it.

## Learned failure modes

- **Two players, one slot, same frame** → the reserve line must be before the first yield, and the second caller
  must see it.
- **The tween is the state.** A door half-open when the round ends stays half-open unless `restoreImmediately()`
  exists for resets. Every animated transition needs a "snap to final" path.
- **A client remote can only ever exit.** Never let a client `enter` on demand — entry is a prompt + server
  validation; `Exit`/`Release` are the only client-driven actions, rate-limited.
- **A hiding slot is not a safe zone.** Do not derive AI immunity from occupancy alone; the AI must consult a
  server attribute and a line-of-sight check ([[S-hiding-spots]]).
- **Noise on entry/exit is gameplay.** Publish a clue (door, rattle) without leaking the exact position — that
  is what makes the slot a risk rather than a free escape.

## Tests

1. Two players, one slot, same frame → one occupant, one refusal.
2. Exit → slot free, exposure window set.
3. Death while inside → slot free, no stuck attribute after respawn.
4. Disconnect while inside → slot free.
5. Round reset while half-way through the door animation → doors snapped closed, slot free.

