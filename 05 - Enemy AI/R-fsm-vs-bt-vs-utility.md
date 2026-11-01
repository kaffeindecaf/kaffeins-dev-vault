---
id: R-fsm-vs-bt-vs-utility
type: reference
title: FSM vs behaviour tree vs utility AI — tradeoffs
status: reviewed
updated: 2026-11-01
tags: [ai, architecture, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "R-npc-think-budget", "R-enemy-taxonomy"
---

# FSM vs behaviour tree vs utility AI

A comparison, then the recommendation for Roblox-scale NPCs.

| | FSM | Behaviour tree | Utility AI |
|---|---|---|---|
| Mental model | explicit states + transitions | tree of tasks with status | score every option, pick best |
| Debuggability | excellent (one state string) | medium (tree traversal) | medium (scores) |
| Emergent behaviour | low | medium | high |
| Re-running a tick | cheap | cheap | cheap |
| Authoring cost | low for 5–8 states, grows badly | medium, good for hierarchical tasks | high (needs scoring curves) |
| Failure mode | spaghetti transitions | silently returning `RUNNING` forever | oscillation between near-equal scores |
| Roblox fit | very good | good | good if you have 4+ competing goals |

## When to pick which

- **FSM** for 1–3 NPCs with clear modes (patrol/chase): nearly every horror game.
- **Behaviour tree** when an NPC has nested tasks ("investigate → check 3 spots → if door locked, try
  next") that a flat FSM would explode into states.
- **Utility AI** when many soft goals compete (guard 5 rooms, respond to noise, protect an object) and
  you need believable prioritisation.

## The hybrid that usually wins

FSM for the **outer mode**, and either a tree or utility scoring inside `Investigate`/`Search`. It keeps
the debuggable single-state string while allowing richer behaviour in the states that need it.

```lua
-- Untested: score-based selection inside one state
local function pickSearchPoint(npc, candidates)
    local best, bestScore = nil, -math.huge
    for _, p in candidates do
        local score = 0
        score += 1 / (1 + (p.Position - npc.root.Position).Magnitude / 10)   -- prefer near
        score += p.noiseConfidence * 2                                       -- prefer noisy
        score -= p.lastCheckedAt and (os.clock() - p.lastCheckedAt) * 0.05 or 0
        if score > bestScore then best, bestScore = p, score end
    end
    return best
end
```

## Anti-patterns

- A BT that re-evaluates the whole tree every frame for 20 NPCs → cost without benefit.
- Utility AI with hard-coded magic weights and no logging → untunable.
- FSM with 25 states → you actually wanted a tree.

