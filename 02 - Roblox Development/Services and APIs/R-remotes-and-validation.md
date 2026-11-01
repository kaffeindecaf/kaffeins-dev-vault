---
id: R-remotes-and-validation
type: reference
title: RemoteEvent and RemoteFunction — validation and rate limiting
status: reviewed
updated: 2026-11-01
tags: [remotes, security, networking]
source_urls: [ "https://create.roblox.com/docs/scripting/events/remote" ]
confidence: medium
verification: reference_only
related: [ "R-server-authority-replication", "R-request-rate-limiting" ]
---

# Remotes

`RemoteEvent` is fire-and-forget in both directions. `RemoteFunction` blocks the caller until the
server returns — **never use one from server→client inside a hot path**, and never let a client's
`InvokeServer` be the only thing standing between them and money.

## Placement and naming

All remotes in one place (`ReplicatedStorage.Remotes`) with a name that says the direction and the
purpose: `RequestInteract`, `StateUpdate`, `PurchaseRequest`. A remote whose name is a verb is a
request (needs validation); a noun is state (server pushes).

## Validation order (cheap → expensive, fail fast)

```lua
-- Untested: reference implementation.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.Remotes.PurchaseRequest

local RATE = {}   -- [player] = { tokens, last }

local function allow(player, cost)
    local budget = RATE[player]
    local now = os.clock()
    if not budget then
        budget = { tokens = 10, last = now }
        RATE[player] = budget
    end
    budget.tokens = math.min(10, budget.tokens + (now - budget.last) * 2)  -- 2/s refill
    budget.last = now
    if budget.tokens < cost then return false end
    budget.tokens -= cost
    return true
end

Remote.OnServerEvent:Connect(function(player, itemId, qty)
    if typeof(itemId) ~= "string" then return end           -- 1. types
    if typeof(qty) ~= "number" or qty ~= qty then return end -- NaN guard
    if qty <= 0 or qty > 99 or qty % 1 ~= 0 then return end  -- 2. range and shape
    if not allow(player, 3) then return end                  -- 3. budget
    local price = PRICES[itemId]                             -- 4. existence in server config
    if not price then return end
    -- 5. authority: balance comes from server state, never from the client
    if Bank.get(player).kc < price * qty then return end
    Bank.charge(player, price * qty)                         -- 6. mutate
    Bank.grant(player, itemId, qty)
end)
```

Notice what is missing: **the client never sends a price or a balance.** If your remote takes a
`price` argument, that is the bug.

## Rate limiting, concretely

- Token bucket per player per remote (above): survives bursts, recovers smoothly, no global lock.
- A hard floor (`os.clock() - last < 0.05 then return`) is a cheap first line for spam.
- Budgets must be **per player**, cleared on `PlayerRemoving`, or you leak a table entry per player.
- Log denials with a counter, not with `print` per event — a spammer will otherwise flood the server
  log and hide the real errors.

## RemoteFunction caveats

- If it errors on the server, the client's `InvokeServer` throws — wrap both sides.
- If the server yields inside it for a slow DataStore call, the client hangs. Return an acknowledgement
  and push the result via a RemoteEvent instead.
- A client can call `InvokeServer` at any rate; the server must still budget it.

See also: [[R-request-rate-limiting]] · [[S-interaction-prompt]] · [[G-server-authority-checklist]].
