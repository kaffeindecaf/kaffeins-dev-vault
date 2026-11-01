---
id: S-hiding-spots
type: system
title: Hiding spots with occupancy and cover checks
status: reviewed
updated: 2026-11-01
tags: [systems, stealth, npc]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [CollectionService, RaycastParams]
dependencies: []
code_blocks: 2
related: "R-raycasting-and-collision-filters", "R-filter-types-and-collision-groups", "R-npc-perception-model"
---

# Hiding spots

Two kinds, and they are not the same problem:

- **Enclosed spots** (closet, locker, under-bed): occupancy + an "I am not visible" flag.
- **Cover spots** (behind a crate): position + a sightline check, because a cover only works from
  the side it covers.

## Enclosed spot

```lua
-- Untested
local Closet = {}
local occupied = {}   -- [spot] = player, cleared on leave/death

function Closet.enter(player, spot)
    if occupied[spot] then return false, "occupied" end
    occupied[spot] = player
    player:SetAttribute("IsHiding", true)
    player.Character.HumanoidRootPart.CFrame = spot.InsidePoint.CFrame
    -- anchor the character so physics cannot leak the position
    return true
end

function Closet.exit(player, spot)
    if occupied[spot] ~= player then return false, "not yours" end
    occupied[spot] = nil
    player:SetAttribute("IsHiding", false)
    player:SetAttribute("ExposedUntil", os.clock() + 0.28)   -- short exposure window
end
```

## Cover spot (the sightline check)

The only correct test: **is the cover the first thing on the ray** from the NPC's eyes to the player?

```lua
-- Untested
local function isBehindCover(npcEye, playerRoot, cover)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { cover }
    local hit = workspace:Raycast(npcEye, playerRoot.Position - npcEye, params)
    return hit ~= nil and hit.Instance:IsDescendantOf(cover)
end
```

An `Include` filter of just the cover answers "does the cover block this line" in one ray — cheaper and
less fragile than checking every obstacle's order.

## Failure modes

| Failure | Fix |
|---|---|
| Two players enter one closet | occupancy map, synchronous reserve ([[S-pickup-server-authoritative]] pattern) |
| Player leaves by wiggling (physics) | anchor or weld while hidden |
| NPC still sees the hidden player | NPC must consult `IsHiding` server-side, not the client's flag |
| Hiding "works" while standing in the open | require a real spot; never trust a client's claimed hide |
| Player caught while hidden and exits → teleported | release occupancy on catch |

## Test cases

1. Two players, one closet, same frame → one occupant.
2. Enter → NPC cannot acquire target while line of sight is blocked by the closet.
3. Peek → NPC can acquire (the exposed side).
4. Exit → 0.28 s exposure, then normal.
5. Caught while hidden → occupancy released, no stuck flag after respawn.

