---
id: R-raycasting-and-collision-filters
type: reference
title: Raycasting, RaycastParams and collision groups
status: reviewed
updated: 2026-11-01
tags: [raycast, physics, npc, line-of-sight]
source_urls: [ "https://create.roblox.com/docs/workspace/raycasting" ]
confidence: medium
verification: reference_only
related: [ "R-npc-perception-model", "R-filter-types-and-collision-groups" ]
---

# Raycasting

`workspace:Raycast(origin, direction, params)` returns a `RaycastResult` or `nil`. Direction's length
is the range — a unit direction is a 1-stud ray, which is the most common silent bug.

```lua
-- Untested
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = { character, workspace.Decor }
params.IgnoreWater = true
params.RespectCanCollide = false   -- hit non-colliding parts (invisible blockers) or not, deliberately

local result = workspace:Raycast(origin, direction.Unit * 60, params)
if result then
    print(result.Instance, result.Position, result.Normal, result.Material, result.Distance)
end
```

## Line of sight that actually works

The classic failure: a ray from the NPC's head to the player's `HumanoidRootPart` is blocked by the
player's own arm, or passes through an invisible `CanCollide = false` glass pane.

```lua
-- Untested: two-point check reduces false negatives from limbs.
local function hasLineOfSight(fromPos, targetRoot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { targetRoot.Parent, workspace:FindFirstChild("Decor") }
    local head = targetRoot.Parent:FindFirstChild("Head")
    local targets = { targetRoot.Position, head and head.Position or targetRoot.Position }
    for _, p in targets do
        local dir = p - fromPos
        local hit = workspace:Raycast(fromPos, dir, params)
        if not hit or hit.Instance:IsDescendantOf(targetRoot.Parent) then
            return true
        end
    end
    return false
end
```

## Ranges and budgets

- 60–80 studs is a believable "sees you" range indoors; beyond that use zones, not rays.
- A ray per NPC per frame is affordable; a ray per NPC **per body part** per frame is not.
- Cast from the eyes forward, and separately toward the target. The forward ray tells you if a wall
  is in the way of the NPC's gaze; the target ray tells you if the target is visible.

## Collision groups (separate from raycasting but usually needed together)

```lua
-- Untested: players do not collide with each other, NPCs pass through each other.
local PhysicsService = game:GetService("PhysicsService")
PhysicsService:RegisterCollisionGroup("Players")
PhysicsService:RegisterCollisionGroup("NPCs")
PhysicsService:CollisionGroupSetCollidable("Players", "Players", false)
PhysicsService:CollisionGroupSetCollidable("NPCs", "NPCs", false)
-- then assign: part.CollisionGroup = "NPCs"
```

Note: collision groups affect physics, `RaycastParams.CollisionGroup` filters rays by group, and
`FilterType` (Include/Exclude) is a different axis. Mixing them up is why "my ray hits the player I
excluded".

See [[R-npc-perception-model]] · [[R-streamingenabled]] for raycasts against streamed-out parts.
