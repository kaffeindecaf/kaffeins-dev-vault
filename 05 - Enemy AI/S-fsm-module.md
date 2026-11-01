---
id: S-fsm-module
type: system
title: Reference FSM module with testable transitions
status: reviewed
updated: 2026-11-01
tags: [ai, code, fsm]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: []
code_blocks: 1
related: "R-npc-state-machine", "G-npc-test-matrix", "R-npc-think-budget"
---

# Reference FSM module

A tiny, dependency-free finite state machine with an explicit transition table and observable state. The
point is that transitions are **data**, so an illegal one is a logged error rather than a mystery.

```lua
-- Untested: ~60 lines, no dependencies.
local FSM = {}
FSM.__index = FSM

function FSM.new(name, states, allowed, initial)
    return setmetatable({
        name = name, states = states, allowed = allowed,
        state = initial, enteredAt = os.clock(), history = {},
    }, FSM)
end

function FSM:canTransition(to)
    if to == self.state then return false end
    local from = self.allowed[self.state]
    return from ~= nil and from[to] == true
end

function FSM:transition(to, reason)
    if not self:canTransition(to) then
        return false, ("illegal transition %s->%s (%s)"):format(self.state, to, reason or "?")
    end
    local from = self.state
    local handler = self.states[self.state]
    if handler and handler.exit then handler.exit(self) end
    self.history[#self.history + 1] = { from = from, to = to, at = os.clock(), reason = reason }
    self.state = to
    self.enteredAt = os.clock()
    local next = self.states[to]
    if next and next.enter then next.enter(self) end
    return true
end

function FSM:timeInState(now)
    return (now or os.clock()) - self.enteredAt
end

return FSM
```

## Usage

```lua
-- Untested
local allowed = {
    Idle = { Patrol = true, Suspicious = true },
    Patrol = { Suspicious = true, Investigate = true, Chase = true },
    Suspicious = { Chase = true, Investigate = true, Patrol = true },
    Investigate = { Chase = true, Search = true, Patrol = true },
    Search = { Chase = true, Patrol = true, Recover = true },
    Chase = { Investigate = true, Recover = true, Disabled = true },
    Recover = { Patrol = true, Disabled = true },
    Disabled = {},
}
local brain = FSM.new("homeowner", handlers, allowed, "Idle")
assert(brain:transition("Patrol", "boot"))
assert(not brain:transition("Chase", "should be illegal"))   -- Patrol->Chase is allowed; Idle->Chase is not
```

## Why `history`

When a player reports "the guard got stuck", `brain.history` is the answer: the last ten transitions with
timestamps and reasons. Keep it bounded (drop beyond 50).

## Test it without Roblox

The module has no `game` references, so it can be pasted into any Luau runtime and tested with plain
assertions — which is exactly the point ([[G-npc-test-matrix]]).

