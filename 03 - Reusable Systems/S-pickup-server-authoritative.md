---
id: S-pickup-server-authoritative
type: system
title: Server-authoritative pickup with claim ownership
status: reviewed
updated: 2026-11-01
tags: [systems, inventory, security]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [CollectionService]
dependencies: []
code_blocks: 2
related: "S-inventory-data-model", "S-loot-containers", "R-server-authority-replication"
---

# Server-authoritative pickup

The single most exploited interaction in any game: *"I am near the thing, give it to me."* The
server must decide proximity, ownership and capacity, in that order.

## Contract

```lua
-- Untested: server module.
local Pickup = {}
local claimed = {}   -- [instance] = userId, cleared on despawn/round reset

function Pickup.tryClaim(player, instance)
    if claimed[instance] then return false, "claimed" end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return false, "no character" end

    if not instance:HasTag("Loot") then return false, "not loot" end
    if (root.Position - instance.Position).Magnitude > 10 then return false, "too far" end
    if not Inventory.hasSpace(player) then return false, "full" end

    claimed[instance] = player.UserId          -- atomically reserve BEFORE yielding
    local ok = Inventory.add(player, instance:GetAttribute("ItemId"), 1)
    if not ok then
        claimed[instance] = nil
        return false, "add failed"
    end
    instance.Parent = nil                      -- remove from world only after the grant
    return true
end
return Pickup
```

Order matters: **reserve → grant → remove**. Remove-then-grant loses the loot if the grant fails.

## Why `claimed` and not `instance:Destroy()` first

Two players can pass the distance check in the same frame. Setting the claim map synchronously (no
`task.wait` between check and write) makes the second caller see `claimed` and fail cleanly. This is
the Lua equivalent of a compare-and-swap, and it is the only reason the "two players, one item" test
passes.

## Failure modes

| Failure | Result if unhandled |
|---|---|
| Client sends the item instance | exploiter picks up loot across the map → always take the instance, never trust its position |
| Capacity checked after granting | 7th item in a 6-slot bag |
| Loot destroyed before grant | item vanishes, player gets nothing |
| Round reset while a claim is pending | item respawns already "claimed" forever → clear `claimed` on round start |

## Test cases

1. Two clients claim one item in the same frame → exactly one grant.
2. Claim from beyond range → denied, item stays.
3. Full inventory → denied, item stays, no claim leak.
4. Player dies mid-claim → no grant, item stays.
5. Round reset → claims cleared, loot respawns claimable.

Related: [[S-inventory-data-model]] · [[S-loot-containers]] · [[R-server-authority-replication]].

