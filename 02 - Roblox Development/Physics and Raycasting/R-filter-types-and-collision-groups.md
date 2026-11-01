---
id: R-filter-types-and-collision-groups
type: reference
title: Filter types vs collision groups — the difference that breaks queries
status: reviewed
updated: 2026-11-01
tags: [physics, raycast, filters]
source_urls: [ "https://create.roblox.com/docs/workspace/collisions" ]
confidence: medium
verification: reference_only
related: [ "R-raycasting-and-collision-filters", "S-hiding-spots" ]
---

# Two different filters

| Mechanism | What it filters | Where used |
|---|---|---|
| `RaycastParams.FilterType` + `FilterDescendantsInstances` | which **instances** a ray/overlap query may see | `workspace:Raycast`, `GetPartBoundsInBox`, `GetPartsInPart` |
| `PhysicsService` collision groups | which **groups** physically collide | physics simulation, and `RaycastParams.CollisionGroup` |

They compose: a ray can be filtered by instance *and* by collision group, and getting one wrong
produces "the ray hits the thing I excluded".

## Include vs Exclude

```lua
-- Untested
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude   -- everything EXCEPT these
params.FilterDescendantsInstances = { selfCharacter, workspace.Effects }
```

`Include` means **only** these instances are hit — a filter box, essentially. Most "my ray misses
everything" bugs are an `Include` filter left in place while the instance was replaced.

## Filtering descendants

`FilterDescendantsInstances` accepts Models and Folders, matching all descendants. That is the cheap
way to exclude an entire rig or a whole `Effects` folder, and it is why cleanup of that folder
matters: a destroyed instance in the filter list is silently skipped.

## Collision groups

```lua
-- Untested
local PhysicsService = game:GetService("PhysicsService")
PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("NPC")
PhysicsService:CollisionGroupSetCollidable("Player", "NPC", true)
PhysicsService:CollisionGroupSetCollidable("Player", "Player", false)
part.CollisionGroup = "NPC"
```

Group assignment is per-part and **per rig**: an NPC model needs every `BasePart` assigned, including
the accessories, or its hat collides with a door while its body does not.

## Practical recipes

| Need | Use |
|---|---|
| NPC sees the player, not the player's hat | exclude the character in the ray filter |
| Player hidden behind a crate: crate blocks the ray | **include** the crate in the filter (hiding check) |
| Kill volume that ignores players | `CanCollide=false` part + `GetPartsInPart` with `Exclude` = {players} |
| "Is any living NPC near this point" | `GetPartBoundsInRadius` with `FilterDescendantsInstances = NPCModels` |

See [[S-hiding-spots]] for a real use: hiding works only if the cover is the *first* obstruction on the
sightline — which is a filter-and-order problem, not a physics one.
