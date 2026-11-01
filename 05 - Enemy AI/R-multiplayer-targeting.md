---
id: R-multiplayer-targeting
type: reference
title: Multiplayer target selection and anti-oscillation
status: reviewed
updated: 2026-11-01
tags: [ai, multiplayer, targeting]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "H-multiplayer-fairness", "R-npc-memory-last-known"
---

# Target selection

With several players, an NPC must pick one target and **stay with it** long enough for the choice to be
readable.

## Score, don't first-match

```lua
-- Untested
local function scoreTarget(npc, player, now)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return -math.huge end
    if char:GetAttribute("IsHiding") then return -math.huge end      -- server-stamped
    local dist = (root.Position - npc.root.Position).Magnitude
    local score = 100 - dist                                            -- closer is better
    score += 25 * (npc.memory[player] and npc.memory[player].confidence or 0)
    if npc.target == player then score += 20 end                        -- hysteresis
    if char:GetAttribute("Crouched") then score -= 10 end
    return score
end
```

## Anti-oscillation rules

1. **Hysteresis:** the current target gets a bonus (20 above) so a marginally closer player does not steal
   the chase every tick.
2. **Minimum dwell:** do not switch targets within 2 s of the last switch (`lastSwitchAt`).
3. **Prefer the already-committed target** when positions are near-equal.
4. **Never switch to a hidden target** — hiding should break the chase, not merely deprioritise.

## Fairness

- Do not retarget to a player who just respawned (they have no chance).
- If the current target disconnects, drop to `Recover`, do not instantly snap to the next player.
- In co-op, the *pursuer* should have one target at a time; multiple simultaneous chases need multiple
  NPCs.

## Logging

Log `(time, from, to, reason, scoreA, scoreB)` for every switch. Oscillation shows up immediately as a
stream of alternating pairs — the most useful AI log there is.

