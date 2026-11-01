---
id: R-npc-state-machine
type: reference
title: Server-owned NPC state machine: states, guards, timeouts
status: reviewed
updated: 2026-11-01
tags: [ai, npc, architecture]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-npc-perception-model", "R-stuck-detection", "R-npc-think-budget", "R-enemy-taxonomy"
---

# NPC state machine

One server-owned machine per NPC, ticking at a low fixed rate, with explicit guards. Everything the
player perceives is a consequence of state, not of ad-hoc scripting.

## States

| State | Purpose | Exit conditions |
|---|---|---|
| `Idle` | stand, look around | timer, noise, sight |
| `Patrol` | follow waypoints | waypoint reached + timer, noise, sight |
| `Suspicious` | stop, look toward a stimulus | sight → Chase; timeout → Investigate; nothing → Patrol |
| `Investigate` | walk to last known position | arrived → Search; new sight → Chase |
| `Search` | look around the area for N s | sight → Chase; timeout → Patrol |
| `Chase` | pursue target directly | lost sight > N s → Investigate(last pos) |
| `Recover` | cooldown after losing the target | timer → Patrol |
| `Disabled` | round over / scripted | external only |

## Guards (checked before any transition)

```lua
-- Untested
function Brain:canSee(target)
    if target:GetAttribute("IsHiding") then return false end
    if self.state == "Recover" then return false end        -- do not instantly re-acquire
    return Perception.hasLineOfSight(self.eyePos, target)
end

function Brain:transition(next, reason)
    if self.state == next then return end
    if not ALLOWED[self.state][next] then
        warn(("illegal transition %s->%s (%s)"):format(self.state, next, reason))
        return
    end
    self.stateChangedAt = os.clock()
    self.state = next
    self.model:SetAttribute("BrainState", next)             -- observable for tests
end
```

`ALLOWED` is an explicit table. An illegal transition should be impossible; logging it turns a rare bug
into a line in the output.

## Timeouts (never rely on one event)

| Transition | Timeout | Fallback |
|---|---|---|
| Suspicious → Investigate | 2.5 s | Investigate |
| Chase → Investigate (no sight) | 4 s | Investigate last known |
| Investigate → Search | arrival or 8 s | Search |
| Search → Patrol | 6 s | Patrol |
| Recover → Patrol | 5 s | Patrol |

Every timeout has a fallback, so a lost event cannot leave the NPC frozen in a state forever.

## Tick

0.2 s per NPC is plenty, staggered so not all NPCs think on the same frame ([[R-npc-think-budget]]).
The tick order is: perception → memory update → transition → movement.

## Test matrix

| Scenario | Expected |
|---|---|
| Target leaves sight behind a wall | Investigate last known, then Search, then Patrol |
| Target hidden (`IsHiding`) | no acquire |
| Door blocked mid-chase | path recompute, then Recover if still blocked ([[R-stuck-detection]]) |
| Target disconnects during chase | drop target, Recover |
| Round ends during chase | Disabled immediately |

