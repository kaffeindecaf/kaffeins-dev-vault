---
id: S-inventory-data-model
type: system
title: Inventory data model and replication contract
status: reviewed
updated: 2026-11-01
tags: [systems, inventory, data]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [None]
dependencies: []
code_blocks: 2
related: "S-pickup-server-authoritative", "R-server-authority-replication", "S-save-load-migration"
---

# Inventory

A fixed-size slot array owned by the server, mirrored to the client as a view. Fixed size is the
decision that prevents an entire category of exploit (unbounded stacking).

## Data model

```lua
-- Untested
type Item = { id: string, qty: number, meta: { [string]: any }? }
type Inventory = { slots: { Item? }, capacity: number, version: number }

local inv: Inventory = {
    capacity = 6,
    version = 1,
    slots = table.create(6, nil),   -- holes are legitimate here
}
```

Rules:

- `slots` is always length `capacity`; an empty slot is `nil`, never `false` or `{}`.
- Stacking is per-`Item.id` with a `maxStack` from config; overflow becomes another slot.
- `meta` is for instance-specific data (a keycard's access level). Never store functions.

## Server API (the only way in)

| Function | Returns | Notes |
|---|---|---|
| `add(player, itemId, qty)` | `ok, reason` | respects `maxStack`, returns `"full"` cleanly |
| `remove(player, slotIndex, qty)` | `ok, reason` | validates index in range |
| `has(player, itemId, qty)` | `boolean` | for gates, no mutation |
| `snapshot(player)` | deep copy | what goes over the wire |

## Replication

```lua
-- Untested: dirty-flag push, not per-action push.
local dirty = {}
function Inventory.markDirty(player) dirty[player] = true end

task.spawn(function()
    while true do
        task.wait(0.1)
        for player in dirty do
            dirty[player] = nil
            StateRemote:FireClient(player, Inventory.snapshot(player))
        end
    end
end)
```

Batching 10×/s is invisible to players and turns a per-pickup storm into a fixed-rate stream.

## Client never mutates

The client renders `snapshot`. A local "remove item" that is not confirmed by the server creates the
classic ghost item: visible until the next snapshot, then it flickers back.

## Failure modes

- Sending the whole inventory on every change → bandwidth burn with 20 players.
- Mutating `slots` while iterating → skips.
- Trusting `slotIndex` from the client without range check → nil index error, or removing slot -1.
- Changing `capacity` in code while saved data has 6 slots → decide migration on load.

## Test cases

1. Add 10 of a maxStack-3 item → 4 slots (3+3+3+1) or `full` if capacity is 3.
2. Remove slot 99 → `ok=false`, no error.
3. Snapshot mutation by caller does not affect server state (deep copy test).
4. Two adds in one frame → both applied, both replicated.

