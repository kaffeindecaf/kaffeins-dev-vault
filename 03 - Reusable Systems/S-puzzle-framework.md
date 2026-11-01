---
id: S-puzzle-framework
type: system
title: Multi-step puzzle framework with deterministic reset
status: reviewed
updated: 2026-11-01
tags: [systems, puzzles, level]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [CollectionService]
dependencies: []
code_blocks: 2
related: "R-clue-placement-and-softlock", "S-pressure-plates", "R-seeded-generation"
---

# Puzzle framework

Most "puzzles" are a set of switches feeding a condition. Build the condition, not the puzzle: a
list of required inputs, an evaluation function, and a reset path.

## Structure

```lua
-- Untested
local Puzzle = {}
Puzzle.__index = Puzzle

function Puzzle.new(def)
    -- def = { id = "fuse_box", inputs = { "switch_a", "switch_b", "dial_3" },
    --         solved = function(state) return state.switch_a and state.switch_b and state.dial_3 == 4 end }
    return setmetatable({ def = def, state = {}, solved = false, history = {} }, Puzzle)
end

function Puzzle:set(inputId, value, actor)
    if self.solved then return false, "already solved" end
    local prev = self.state[inputId]
    self.state[inputId] = value
    table.insert(self.history, { input = inputId, value = value, prev = prev, actor = actor, t = os.clock() })
    if self.def.solved(self.state) then
        self.solved = true
        self:onSolved()
    end
    return true
end

function Puzzle:reset()
    self.state, self.history, self.solved = {}, {}, false
    self:publish()      -- clients re-render from authoritative state
end
```

## The three properties that make it maintainable

1. **Pure solve function.** `solved(state) -> boolean`, no side effects. That makes it testable
   outside Roblox (extract it, run it in plain Luau) and reviewable.
2. **Deterministic reset.** `reset()` must return the puzzle to exactly the authored state, including
   the world parts. Reset the objects, not only the bookkeeping.
3. **Single publish point.** Clients render from one replicated snapshot; they never infer the solved
   state themselves.

## Anti-softlock rules

- Every input must be re-usable if the puzzle can be failed (a lever that jams = dead run).
- Clues must be redundant: one readable label *and* one visual state per input
  ([[R-clue-placement-and-softlock]]).
- A reset always exists: button, timer, or round restart.

## Failure modes

- Solve check reads client state → desync.
- Solver mutates world inside itself → cannot re-run safely.
- Solved flag not cleared on round reset → door already open next round.
- Two players hitting two switches in the same frame → both registered (that is correct); but if your
  handler yields before writing state, one is lost. Write state synchronously.

## Test cases

1. Set all inputs in any order → solved exactly once.
2. Set a wrong combination → not solved, state recorded.
3. Reset mid-puzzle → authored state restored, solvable again.
4. Solve, then reset → re-solvable.
5. 50 random input sequences → never leaves an unsolvable state that cannot be reset.

