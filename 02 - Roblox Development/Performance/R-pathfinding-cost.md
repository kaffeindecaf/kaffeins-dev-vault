---
id: R-pathfinding-cost
type: reference
title: PathfindingService — cost, recalculation and failure
status: reviewed
updated: 2026-11-01
tags: [pathfinding, npc, performance]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/PathfindingService" ]
confidence: medium
verification: reference_only
related: [ "R-npc-state-machine", "R-stuck-detection" ]
---

# Pathfinding

`PathfindingService:CreatePath(agentParams)` then `:ComputeAsync(start, goal)`. It is a **server-side,
asynchronous, expensive** call: never per frame, never per NPC per frame, never in a loop that can
pile up.

```lua
-- Untested: one path per NPC, recomputed on a timer or on goal change.
local PathfindingService = game:GetService("PathfindingService")
local path = PathfindingService:CreatePath({
    AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = false,
    AgentMaxSlope = 45, Costs = { Water = math.huge },
})

local ok = pcall(function() path:ComputeAsync(origin, goal) end)
if not ok or path.Status ~= Enum.PathStatus.Success then
    -- fail visibly: fall back to direct movement or a patrol waypoint
    return
end

for _, waypoint in path:GetWaypoints() do
    humanoid:MoveTo(waypoint.Position)
    if waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
    humanoid.MoveToFinished:Wait()
end
```

## Recalculation policy

| Trigger | Recompute? |
|---|---|
| Goal moved > 4 studs | yes |
| Path blocked signal fired | yes (once, with backoff) |
| Every X seconds while chasing | yes, with X ≥ 0.5 s |
| Every physics frame | **no** |
| Target not visible and no memory | stop, don't recompute |

`path.Blocked:Connect(...)` fires when geometry blocks the current path — recompute once, and if it
fails twice, switch to a search behaviour ([[R-npc-state-machine]]).

## Budget math

`ComputeAsync` costs roughly 0.1–1 ms per call depending on map complexity. 10 NPCs recomputing every
0.5 s = 20 calls/s — fine. 30 NPCs recomputing every frame = 1800 calls/s — server frame time
collapses.

Stagger: give each NPC a different tick phase (`index * 0.1`), so recomputations spread out instead
of bursting on the same frame. See [[R-npc-think-budget]].

## Common failures

| Symptom | Cause |
|---|---|
| `NoPath` from a valid-looking spot | agent radius too fat for the gap; raise `AgentRadius` awareness in level design |
| Path succeeds but NPC walks into a wall | waypoints at ground level under a ledge; add `AgentCanJump` or fix the level |
| NPC freezes mid-path | `MoveToFinished` never fires because the humanoid was pushed; add a timeout |
| Works in Studio, fails live | streaming/`Workspace` differences, or the destination is inside a `Model` that moved |

Level-side implications: [[R-spawn-placement]], [[R-level-blockout-template]].
