---
id: S-objective-tracker
type: system
title: Quest / objective tracker with save-compatible progress
status: reviewed
updated: 2026-11-02
tags: [systems, quests, ui]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 1
related: "S-save-load-migration", "S-config-module", "S-notification-system"
---

# Objective tracker

For concrete versioned blueprints, durable event deduplication, claims and generated progress rows,
see the v1.0.0 [[S-quest-achievement-blueprint-factory]]. This older sketch retains its design-only label.

Progress is a small map of counters, keyed by objective id, persisted with the player's data. The
hard part is never the UI — it is defining progress so a schema change does not invalidate saves.

## Model

```lua
-- Untested
type Objectives = { [string]: number }   -- objectiveId -> progress count
-- definitions are static config, progress is per player
local DEFS = {
    steal_3_items   = { need = 3, label = "Steal 3 items" },
    escape_undetected = { need = 1, label = "Escape unseen" },
}

function Objectives.progress(player, id, amount)
    local state = Data.get(player).objectives
    local def = DEFS[id]
    if not def then return end
    state[id] = math.min(def.need, (state[id] or 0) + amount)
    Views.push(player, id, state[id], def.need)
    if state[id] >= def.need then Rewards.grant(player, id) end
end
```

## Rules

1. **Progress keys are strings, never array positions.** Adding a new objective must not shift
   everyone's saved progress.
2. **Clamp to `need`.** Uncapped counters let a player bank progress for the next tier.
3. **Definitions live in config** ([[S-config-module]]); a balance change must not need a save
   migration.
4. **Server-only mutation.** The tracker is authoritative; the client gets `(id, current, need)`.
5. **Version the objectives table** with the player data schema; on load, unknown keys are kept (not
   deleted) so a reverted deploy does not lose progress.

## Failure modes

- Incrementing on the client → double-count exploit.
- Not clamping → tier 2 completes instantly.
- Deleting unknown keys on load → a rollback wipes a week of progress.
- Reward granted per increment rather than on completion → infinite XP.

## Test cases

1. Progress 1..3 → completes exactly at 3, reward once.
2. Progress beyond need → stays at need.
3. Relog → progress persists, completed objectives stay completed.
4. New objective added → existing saves load and show 0.
5. Objective removed from config → its saved value is retained, not deleted.

