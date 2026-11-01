---
id: S-checkpoints
type: system
title: Checkpoints and respawn state recovery
status: reviewed
updated: 2026-11-01
tags: [systems, respawn, state]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 1
related: "S-save-load-migration", "S-crouch-and-crawl", "S-hiding-spots"
---

# Checkpoints

A checkpoint is a claim about state, and it is only worth anything if respawn restores that state
exactly. Design the state list first, then the trigger.

## What respawn must restore

| State | Restore by |
|---|---|
| Position | teleport spawn point (not a saved CFrame of a live character) |
| Inventory | server-side inventory is untouched by death — do not clear it |
| Health | `Humanoid.Health = Humanoid.MaxHealth` after `CharacterAdded` |
| Round progress | round state is server-owned; nothing to restore |
| UI | rebuilt by `ResetOnSpawn = false` HUDs; never rebuild per life |
| Puzzle state | unaffected (server-owned), but verify reset did not fire |

```lua
-- Untested
local function onCharacterAdded(player, character)
    local spawnPoint = CHECKPOINTS[player] or DEFAULT_SPAWN
    local hum = character:WaitForChild("Humanoid")
    hum.Health = hum.MaxHealth
    task.defer(function()
        character:PivotTo(spawnPoint.CFrame)   -- after the default spawn has settled
    end)
end
```

`PivotTo` in `task.defer` avoids the race with Roblox's own spawn positioning.

## Failure modes

- Saving the character's CFrame at checkpoint time → the player respawns inside whatever moved since.
- Clearing the inventory on death in a "hardcore" mode you did not intend → check the design first.
- Restoring `WalkSpeed` incorrectly → crouch/sprint state leaks into the next life.
- Checkpoint inside a hidden state → respawn stuck invisible; clear `IsHiding` on death.

## Test cases

1. Die → respawn at the last checkpoint, full health.
2. Die before any checkpoint → default spawn.
3. Die while hiding → not invisible on respawn.
4. Die while crouched → normal stance.
5. Checkpoint after a puzzle → puzzle still solved.

