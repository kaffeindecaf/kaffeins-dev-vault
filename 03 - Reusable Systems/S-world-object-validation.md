---
id: S-world-object-validation
type: system
title: Validating a world object before granting anything (extracted)
status: reviewed
updated: 2026-11-01
tags: [systems, security, loot, extraction]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 2
related: "S-pickup-server-authoritative", "R-server-authority-replication", "S-inventory-data-model"
---

# Validating a world object

A client says "I picked up that". Before you grant a single coin you validate the **instance itself**: is it
really a loot object, is it really in the spawn folder, does it have a sane value, and is it unclaimed.

## The validator

```lua
-- Untested in this vault: read from a live place, generalised.
local function validateWorldLoot(model)
    if not model or typeof(model) ~= "Instance" then return false, "not an instance" end
    if not model:IsA("Model") then return false, "not a model" end
    if model:GetAttribute("Claimed") then return false, "already claimed" end
    if not model.PrimaryPart then return false, "no PrimaryPart" end

    -- it must be a descendant of the runtime spawn folder, not just anywhere in Workspace
    local lootFolder = Workspace:FindFirstChild("Loot")
    local inFolder, node = false, model
    while node do
        if node == lootFolder then inFolder = true; break end
        node = node.Parent
    end
    if not inFolder then return false, "not in the loot folder" end

    -- value must be a finite, non-negative number (catches NaN and inf, not just nil)
    local value = model:GetAttribute("Value")
    if type(value) ~= "number" or value ~= value or value < 0 or value == math.huge then
        return false, "invalid value"
    end

    -- soft check: the name should correspond to a template (log, do not fail)
    local templates = ReplicatedStorage:FindFirstChild("Items")
    if templates and templates:FindFirstChild(model.Name:gsub("_Loot", "")) == nil then
        warn("loot without a matching template:", model.Name)
    end
    return true, nil
end
```

## Why each check is there

| Check | Attack/accident it stops |
|---|---|
| `typeof(...) == "Instance"` | a client sending a table/string instead of an instance |
| `:IsA("Model")` | any instance with a `PrimaryPart`-ish shape |
| `Claimed` attribute | **two players claiming one object** (set it *before* the first `task.wait`) |
| descendant-of-folder walk | a decoy model the exploit spawned in Workspace with a huge `Value` |
| `value ~= value` | NaN (NaN passes `< 0` and `> 0` comparisons) |
| `value == math.huge` | infinity, same reason |
| template name check (warn only) | a renamed/duplicated model — tells you, does not block |

## The ordering rule

```lua
-- reserve, then grant, then remove
model:SetAttribute("Claimed", true)     -- synchronous, before any yield
local ok = Inventory.add(player, itemId, 1)
if not ok then model:SetAttribute("Claimed", nil); return end
model.Parent = nil
```

Reserve-then-grant is the whole trick: two clients can pass validation in the same frame, and only the first
one finds `Claimed` unset. Grant-then-remove loses the item if the grant fails.

## Learned failure modes

- **`Player.Caught` / `Round.canInteract()` must be checked before the object**, or a caught player still picks
  things up.
- **A tiny distance error looks like a broken feature.** A test that teleports a player with a +4 Y offset can
  land 8.6 studs from an 8-stud limit and every scripted pickup is silently denied.
- **Silent refusals are invisible.** Log every refusal branch (with a rate cap) — "too far" with no log reads
  as "the feature does not work".
- **Never trust `model.Name` for the item id.** Map it through a server-side table.

## Tests

1. Claim from range → granted, object gone.
2. Two players, same frame → one grant.
3. Full carry → denied, object still present, claim released.
4. Forged instance (a plain Part) → denied.
5. NaN/`Value = math.huge` → denied.

