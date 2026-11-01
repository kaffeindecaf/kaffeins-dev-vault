---
id: S-keycard-locks
type: system
title: Keys, keycards and access control
status: reviewed
updated: 2026-11-01
tags: [systems, locks, security]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 2
related: "S-smart-door", "S-inventory-data-model"
---

# Locks and access control

Access is a server-side predicate. Never let a client say "I have the key".

## Model

```lua
-- Untested
local Access = {}
-- level: 0 = none, 1 = staff key, 2 = manager card, 3 = master
local LEVEL = { keycard_blue = 1, keycard_red = 2, master_key = 3 }

function Access.check(player, requiredLevel)
    for _, item in Inventory.slots(player) do
        if item and (LEVEL[item.id] or 0) >= requiredLevel then return true, item end
    end
    return false
end
```

## Door integration

```lua
-- Untested
local ok = Access.check(player, lock.RequiredLevel)
if not ok then
    playRattle(lock)
    Toast(player, "This needs a level " .. lock.RequiredLevel .. " card")
    return
end
Door:toggle(player)
```

## Consumables vs persistent

| Kind | Example | Rule |
|---|---|---|
| Persistent tool | master key | stays in inventory, unlimited uses |
| Consumable | one-use key | server removes on success, **after** the door opens |
| Timed | 20-second blue card | server stores an expiry tick, client displays a countdown from a replicated value |

Removing a consumable before the door opens is how "I used my key and the door didn't open" support
tickets happen.

## Failure modes

- Client sends `hasKey = true` → exploiter opens every door. Access must read server inventory.
- Duplicate key items in two slots → `check` returns on the first match; make sure `remove` takes the
  index it found, not "any slot with that id".
- Level numbers drift between config and doors → one config table, referenced by attribute name.

## Test cases

1. No key → denied with feedback.
2. Wrong level → denied.
3. Right level, consumable → door opens **and** item removed exactly once.
4. Same consumable used twice in one frame → second denied.
5. Key in slot 4 of 6 → still found.

