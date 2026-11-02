---
id: S-round-phase-machine
type: system
title: Round phase machine (extracted from a shipping game)
status: reviewed
updated: 2026-11-02
tags: [systems, rounds, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 2
related: "R-server-authority-replication", "S-interaction-prompt", "S-late-join-sync"
---

# Round phase machine

For the v1.0.0 implementation with independent rooms, membership, loader tokens and phase events,
see [[S-matchmaking-room-orchestrator]]. Its scoped Studio tests do not promote this older extracted code.

A 60-line module that owns the round's phase and nothing else. Small on purpose: every other system asks it
`canInteract()` instead of keeping its own copy of "is the round running", which is where inconsistent gating
comes from.

## Why this shape works

- **`canInteract()` is the single gate.** Pickups, doors, prompts and sales all call it. When a bug says
  "the player could interact during intermission", there is exactly one place to look.
- **Transitions return booleans.** `activate()` returns `false` if the phase was not `Intermission`, so a
  double-call cannot skip a phase. Every transition is idempotent-by-refusal.
- **`changed()` is a hook, not an event bus.** One optional callback; the owner decides who hears about it.

## The pattern

```lua
-- Untested in this vault: read verbatim from a live place, generalised. The place exercised it in play.
local Round = {}
Round.__index = Round

function Round.new()
    return setmetatable({ phase = "Boot", id = 0, collected = 0, total = 0 }, Round)
end

function Round:changed()
    if self.onChange then self.onChange(self) end
end

function Round:begin(items)                 -- intermission, fresh round id
    self.id += 1
    self.phase, self.reason, self.complete = "Intermission", nil, false
    self.collected, self.total, self.originals = 0, 0, {}
    for _, item in ipairs(items) do          -- dedupe: the same instance cannot count twice
        if not self.originals[item] then
            self.originals[item] = true
            self.total += 1
        end
    end
    self:changed()
end

function Round:activate(now)                 -- intermission -> active
    if self.phase ~= "Intermission" then return false end
    self.phase, self.startedAt = "Active", now
    self:changed()
    return true
end

function Round:canInteract() return self.phase == "Active" end

function Round:collect(item)                 -- returns true only on the completing collect
    if not self:canInteract() or not self.originals[item] then return false end
    self.originals[item] = nil
    self.collected += 1
    local completedNow = self.total > 0 and self.collected == self.total and not self.complete
    if completedNow then self.complete = true end
    self:changed()
    return completedNow
end

function Round:finish(reason)                -- idempotent end
    if self.phase ~= "Active" and self.phase ~= "Intermission" then return false end
    self.phase, self.reason = "Ending", reason
    self:changed()
    return true
end

Round.current = Round.new()
return Round
```

## What to change per game

| Field | Meaning |
|---|---|
| `phase` names | keep Boot/Intermission/Active/Ending or add `Post` — but never two sources of truth |
| `originals` | anything one-shot that must not double-count (loot spawns, objectives, collectibles) |
| `onChange` | wire to your HUD/state publisher; do not let it mutate the round |

## Learned failure modes

- **`collect()` returning `true` on the completing item is the whole reward trigger.** A caller that ignores
  the return silently loses "round complete". A caller that fires on every collect double-rewards.
- **The end path must be idempotent.** Two callers (timer, vote, all-caught) will race eventually; `finish()`
  refusing a second call is what stops the double teleport/double reward.
- **Never store a `Player` or a live `Instance` in `originals`** — it is a set of round objects, and a set
  holding a player would keep the character alive after they leave.

## Tests

1. `activate` twice → second returns `false`, phase stays `Active`.
2. `collect` the same item twice → second returns `false`.
3. `collect` all items → exactly one `true`.
4. `finish` from `Active` then again → second `false`.
5. `canInteract()` false in every phase except `Active`.

