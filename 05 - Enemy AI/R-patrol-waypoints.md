---
id: R-patrol-waypoints
type: reference
title: Patrol waypoint schema and navigation fallbacks
status: reviewed
updated: 2026-11-01
tags: [ai, patrol, level]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-pathfinding-cost", "R-npc-state-machine", "R-spawn-placement"
---

# Patrol waypoints

Waypoints are level data, not AI data. The NPC should be able to patrol any route a designer authors,
including a route that changes per round.

## Schema

```lua
-- Untested
local ROUTE = {
    id = "ground_floor",
    loop = true,
    points = {
        { pos = Vector3.new(12, 3, -40), wait = 1.5, lookAt = "door" },
        { pos = Vector3.new(28, 3, -40), wait = 0.5 },
        { pos = Vector3.new(28, 3, -70), wait = 2.0, lookAt = "window" },
    },
}
```

- `wait` is dwell time (stops the "roomba" look).
- `lookAt` names a tagged instance; the NPC turns toward it during the wait. This is what makes a patrol
  feel like someone checking the room.
- `loop` false = ping-pong, which reads as more natural in a corridor.

## Fallbacks

| Failure | Fallback |
|---|---|
| `MoveTo` never completes | timeout at `distance / speed * 2`, then advance |
| Path unreachable | stop, log, pick the next waypoint |
| Waypoint inside geometry | validate at load, warn with the waypoint index |
| Player blocks the waypoint | wait 2 s, then skip |

```lua
-- Untested: timeout-protected move
local function moveTo(humanoid, pos, speed)
    humanoid.WalkSpeed = speed
    humanoid:MoveTo(pos)
    local timeout = os.clock() + math.max(3, (humanoid.RootPart.Position - pos).Magnitude / speed * 2)
    repeat task.wait(0.1) until humanoid.MoveToFinished or os.clock() > timeout
end
```

## Authoring rules

- Waypoints at least 3 studs from walls; an agent radius of 2.5 needs clearance.
- Never route through a doorway that is usually closed, unless the NPC opens doors.
- A patrol route that only covers half the map is why players find a "safe" corner — coverage is a
  design decision, so document it.
- Give each route an id so a round can pick a subset (`ROUTE_A` for early, both later).

See [[R-pathfinding-cost]] and [[R-spawn-placement]].

