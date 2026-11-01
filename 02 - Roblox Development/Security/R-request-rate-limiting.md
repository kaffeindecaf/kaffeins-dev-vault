---
id: R-request-rate-limiting
type: reference
title: Request budgets — rate limiting without wrecking game feel
status: reviewed
updated: 2026-11-01
tags: [security, networking, performance]
source_urls: [ "https://create.roblox.com/docs/scripting/events/remote" ]
confidence: medium
verification: reference_only
related: [ "R-remotes-and-validation" ]
---

# Request budgets

A legit player generates steady, low-rate requests. An exploiter generates a burst. You want to be
invisible to the first and cheap against the second.

## Token bucket (the default choice)

```lua
-- Untested: reusable budget helper.
local Budget = {}
Budget.__index = Budget

function Budget.new(capacity, refillPerSecond)
    return setmetatable({ capacity = capacity, refill = refillPerSecond,
                          tokens = capacity, last = os.clock() }, Budget)
end

function Budget:take(cost)
    local now = os.clock()
    self.tokens = math.min(self.capacity, self.tokens + (now - self.last) * self.refill)
    self.last = now
    if self.tokens < cost then return false end
    self.tokens -= cost
    return true
end

return Budget
```

Budget shapes that match real mechanics:

| Mechanic | Capacity | Refill | Cost |
|---|---|---|---|
| Interact / open door | 6 | 4/s | 1 |
| Sell an item | 5 | 1/s | 1 |
| Claim reward | 2 | 0.1/s | 1 |
| Any chat-command style action | 3 | 0.5/s | 1 |

## What not to do

- **Global bucket.** One spammer starves everyone.
- **Bucket per remote instance created per player.** Creates unbounded tables; put budgets in one
  table keyed by `player` and clear on `PlayerRemoving`.
- **Silent drop with no telemetry.** You need to know if a real mechanic is mis-budgeted: keep a
  counter, surface it in a dev-only overlay.
- **Punitive kicks** for a first offense. Budgets are for protecting the server, not policing.

## Where else a budget belongs

- **DataStore writes:** Roblox budgets them per key; a 5-second autosave per player is already
  aggressive in a 30-player server. Batch and dirty-flag instead.
- **Pathfinding recalculation:** per-NPC, not per-player input ([[R-pathfinding-cost]]).
- **Audio:** a `Sound` that is `Play()`ed every frame from a loop is a budget bug, not a sound bug.

## Test it

In Studio, fire the remote 100× in a `for` loop from the client and confirm: no server stall, the
counter increments, and the legitimate path still works afterwards. Then confirm your real mechanic
still feels instant at 1/s.
