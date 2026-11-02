---
id: R-memorystore-messaging
type: reference
title: MemoryStoreService and MessagingService — use cases and limits
status: reviewed
updated: 2026-11-02
tags: [datastore, memorystore, messaging, multiplayer]
source_urls: [ "https://create.roblox.com/docs/cloud-services/memory-stores", "https://create.roblox.com/docs/cloud-services/cross-server-messaging", "https://create.roblox.com/docs/reference/engine/classes/MessagingService/SubscribeAsync" ]
confidence: medium
verification: reference_only
related: [ "R-datastore-safety", "S-late-join-sync" ]
---

# Two different tools

| Service | Lifetime | Use for |
|---|---|---|
| `MemoryStoreService` | expiring (seconds to ~45 days) | queues, session locks, matchmaking hints, cross-server cooldowns |
| `MessagingService` | ephemeral, best-effort delivery | "this player's balance changed", "round ended", cross-server broadcast |

Neither replaces a DataStore. Both are best-effort: a message can be dropped or delivered late, so
never put the only copy of a value in a message.

## Session lock (the most valuable MemoryStore pattern)

```lua
-- Untested: one server at a time owns a player's profile.
local MemoryStoreService = game:GetService("MemoryStoreService")
local locks = MemoryStoreService:GetHashMap("ProfileLocks")

local function acquire(userId, serverId, ttl)
    local ok, prev = pcall(function()
        return locks:UpdateAsync("u_" .. userId, function(current)
            if current and os.time() - current.at < (current.ttl or 60) then
                return nil            -- somebody else holds it and is still alive
            end
            return { server = serverId, at = os.time(), ttl = ttl }
        end, ttl)
    end)
    return ok and prev ~= nil
end
```

`UpdateAsync` on a `HashMap` is atomic per key; that is what makes this work. Always set a TTL so a
crashed server does not lock a player out forever.

A MemoryStore lease alone does not fence a stale server from saving after its lease expires.
Profile ownership must also be checked by the durable save owner; see [[S-datastore-player-profile]].

## MessagingService rules

- Topics are global to the experience. `Robbery_BankUpdate_v1` style versioning avoids old code
  reading new payloads.
- Messages have a size limit (~1 KB) and are not ordered. Send IDs, re-read the truth from the
  DataStore/your own cache.
- Subscribe once, at server start; subscribe callbacks run in a different thread than your logic —
  never mutate game state directly from inside one without a queue.
- Delivery is best effort and not guaranteed. Make handlers idempotent and provide durable
  reconciliation when a lost message matters; see [[S-cross-server-gift-ledger]] and the
  [SubscribeAsync contract](https://create.roblox.com/docs/reference/engine/classes/MessagingService/SubscribeAsync).

## When you do not need them

Single-server experiences (most Roblox games outside of lobbies) need neither. A late-joining player
is fixed by sending them state on join, not by messaging between servers
([[S-late-join-sync]]).

## Budgets

Both are quota-limited per minute; wrap calls in `pcall` and degrade instead of erroring in a live
round. See [[R-datastore-safety]] for the general "never lose the only copy" rule.
