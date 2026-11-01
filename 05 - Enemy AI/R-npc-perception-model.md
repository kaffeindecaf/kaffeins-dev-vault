---
id: R-npc-perception-model
type: reference
title: Perception: distance, sight, hearing, last-known position
status: reviewed
updated: 2026-11-01
tags: [ai, perception, npc]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-raycasting-and-collision-filters", "R-npc-state-machine", "S-hiding-spots", "R-npc-memory-last-known"
---

# Perception

Three channels, each with a cost and a failure mode. Budget them: perception is the expensive part of an
NPC.

## Channel comparison

| Channel | Cost | Accuracy | Failure |
|---|---|---|---|
| Distance | trivial | coarse | "sees through walls" if used alone |
| Line of sight (ray) | medium | precise | false negatives on limbs/small gaps |
| Hearing (noise events) | trivial | directional-ish | through walls by design |
| Last-known memory | trivial | decays | stale by the time you use it |

## Sight

```lua
-- Untested: cone + two-point ray
local function canSee(npc, targetRoot)
    local toTarget = targetRoot.Position - npc.eyePos
    local dist = toTarget.Magnitude
    if dist > npc.sightRange then return false end
    local facing = npc.root.CFrame.LookVector
    if facing:Dot(toTarget.Unit) < math.cos(math.rad(npc.fov / 2)) then return false end
    -- two points: chest and head, reduces false negatives from cover clipping
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { npc.model, targetRoot.Parent }
    for _, p in { targetRoot.Position, targetRoot.Position + Vector3.new(0, 1.5, 0) } do
        local hit = workspace:Raycast(npc.eyePos, p - npc.eyePos, params)
        if not hit then return true end
    end
    return false
end
```

A single ray from the eye to the `HumanoidRootPart` will miss a player standing behind a low crate but
visible from the chest up. Two points costs one extra ray and removes most "it didn't see me" reports.

## Hearing

Emit noise events rather than raycasting for sound: `{ position, radius, source }` pushed to a shared
`NoiseService`. An NPC subscribes and compares distance; walls attenuate rather than block.

| Action | Noise radius |
|---|---|
| Walk | 14 studs |
| Sprint | 26 |
| Crouch | 6 |
| Door open/close | 18 |
| Item smash | 30 |

Consider scaling by `Crouched` (a server attribute) so a crouching player is quieter.

## Memory

Store `lastKnown = { position, at, confidence }`. Decay confidence over time (`confidence -= dt / 8`), and
drop it below a floor. Memory is what makes an NPC feel intelligent without giving it clairvoyance.

## Budget

| Channel | Rate |
|---|---|
| Cone distance check | every tick (cheap) |
| Ray | every tick per NPC, max 2 rays |
| Hearing | event-driven |
| Pathfinding | on transition only |

See [[R-raycasting-and-collision-filters]] for the ray mechanics and [[R-npc-think-budget]] for scheduling.

