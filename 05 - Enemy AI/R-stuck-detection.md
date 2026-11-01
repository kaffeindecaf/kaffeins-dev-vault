---
id: R-stuck-detection
type: reference
title: Pursuit throttling and stuck detection
status: reviewed
updated: 2026-11-01
tags: [ai, pathfinding, debugging]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-pathfinding-cost", "R-npc-state-machine", "R-ai-debug-overlay"
---

# Stuck detection

NPCs get stuck: on doorframes, on each other, inside geometry, or because a path went stale. Without a stuck
watchdog the NPC quietly stands still and the player walks past it — a bug that looks like bad AI design.

## Detector

```lua
-- Untested: compare intended vs actual movement over a window.
local function watchStuck(npc)
    local lastPos, lastProgressAt = npc.root.Position, os.clock()
    return function(now)
        if npc.state ~= "Chase" and npc.state ~= "Investigate" then
            lastPos, lastProgressAt = npc.root.Position, now
            return
        end
        local moved = (npc.root.Position - lastPos).Magnitude
        if moved > 0.5 then
            lastPos, lastProgressAt = npc.root.Position, now
            return
        end
        if now - lastProgressAt > 1.5 then
            npc:onStuck(now)
            lastProgressAt = now
        end
    end
end
```

## `onStuck` escalation (in order)

1. Recompute path from the current position.
2. Try one sidestep (perpendicular MoveTo for 0.4 s) — usually enough for a doorframe.
3. If still stuck, `Recover` for 1 s, then resume patrol.
4. If stuck 3× in 10 s, log `STUCK: model name, position, state` and park the NPC at the nearest waypoint.

That log line is what turns "the AI is dumb" into "the navmesh has a hole at (24, 3, -96)".

## Throttling

| Guard | Value |
|---|---|
| Max path recomputes per NPC per second | 1 |
| Min time between recomputes | 0.5 s |
| Max recomputes per server per second | 10 (queue the rest) |
| Movement speed clamp during recovery | 12 |

## Common causes

| Cause | Fix |
|---|---|
| Agent radius too large for a doorway | raise clearance in the level, or shrink the agent |
| Waypoint inside a wall | validate waypoints at load |
| NPCs colliding with each other | collision groups, or a small separation offset |
| Path computed to a moving target's old position | recompute on target movement, throttled |
| Streaming disabled geometry (client-only) | irrelevant to server AI; check your assumption |

See [[R-pathfinding-cost]] · [[R-npc-state-machine]] · [[R-ai-debug-overlay]].

