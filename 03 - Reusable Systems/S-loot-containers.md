---
id: S-loot-containers
type: system
title: Drawers, cabinets and loot containers
status: reviewed
updated: 2026-11-01
tags: [systems, loot, interaction]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [CollectionService]
dependencies: []
code_blocks: 2
related: "S-pickup-server-authoritative", "R-seeded-generation", "S-smart-door"
---

# Loot containers

A container is a one-shot random draw with a state machine: `Closed → Open → Emptied`. The draw must
happen server-side and be recorded so a re-open cannot re-roll.

## Implementation

```lua
-- Untested
local rng = Random.new()   -- seeded per round, see R-seeded-generation
local opened = {}          -- [container] = { itemId, taken = false }

local LOOT_TABLE = {
    { id = "gold_ring", weight = 3 },
    { id = "watch", weight = 5 },
    { id = "junk", weight = 12 },
}

local function roll()
    local total = 0
    for _, e in LOOT_TABLE do total += e.weight end
    local pick = rng:NextNumber() * total
    for _, e in LOOT_TABLE do
        pick -= e.weight
        if pick <= 0 then return e.id end
    end
    return LOOT_TABLE[1].id
end

local function open(player, container)
    if opened[container] then return false, "already opened" end
    opened[container] = { itemId = roll(), taken = false }   -- reserve before any yield
    container:SetAttribute("Open", true)
    return true
end
```

## Why weights and not a flat list

A flat list makes rare items as common as junk, and retuning the drop rate later means editing the
list structure. Weights let you change one number.

## Interaction detail that matters

- Drawer should animate open (0.2 s) **before** the loot is visible.
- The loot becomes its own pickup ([[S-pickup-server-authoritative]]) so two players can race for it
  legitimately.
- `Emptied` state must persist through the round so a player cannot farm by closing the UI.

## Failure modes

- Roll on the client → every player sees a different item, one gets it.
- Roll on every open → infinite loot; record the roll.
- Round reset not clearing `opened` → next round has empty containers.
- Loot spawns inside the drawer geometry → offset the spawn point upward.

## Test cases

1. Open twice → second returns "already opened", no new item.
2. Two players open the same container in one frame → one roll.
3. Take the item, re-open → empty.
4. Round reset → container closed and re-rollable.
5. 1000 rolls match the configured weight distribution within tolerance.

