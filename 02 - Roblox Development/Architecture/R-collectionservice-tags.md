---
id: R-collectionservice-tags
type: reference
title: CollectionService tags — feature discovery instead of find-by-name
status: reviewed
updated: 2026-11-01
tags: [architecture, tags, modular]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/CollectionService" ]
confidence: medium
verification: reference_only
related: [ "R-attributes-vs-values-vs-config", "R-module-dependencies" ]
---

# Tags

`CollectionService` lets a system claim instances by tag instead of by path or name. This is the
difference between a system that breaks when a builder renames a part and one that survives a
remodel.

```lua
-- Untested: server-side system that owns every tagged door.
local CollectionService = game:GetService("CollectionService")
local TAG = "LockpickDoor"

local function bind(model)
    if not model:IsA("Model") then return end
    if model:GetAttribute("Bound") then return end   -- idempotent: never bind twice
    model:SetAttribute("Bound", true)

    local prompt = model:FindFirstChild("UnlockPrompt", true)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.Triggered:Connect(function(player)
            -- server-authoritative handling
        end)
    end
end

for _, inst in CollectionService:GetTagged(TAG) do bind(inst) end
CollectionService:GetInstanceAddedSignal(TAG):Connect(bind)
CollectionService:GetInstanceRemovedSignal(TAG):Connect(function(inst)
    -- release occupancy, disconnect, clear attributes
end)
```

## Rules

1. **Tags are for discovery, attributes are for state.** `tag = "BreakableWindow"`,
   `attribute = NumberOfShards`. Putting data in the tag string (`BreakableWindow_3`) is a smell.
2. **Binding must be idempotent.** The added-signal fires for parts created later, including ones the
   system itself creates.
3. **`GetTagged` only returns descendants of `workspace`** (and `ServerStorage` server-side), not
   everything in the DataModel — check `Instance.Parent` if a model lives under a folder that is not
   replicated.
4. **Clean up on removed-signal**, or a destroyed door keeps a closure alive.
5. **Studio authoring:** the Tag Editor shows every tag. Document the tag names in the project's
   `ASSET_MANIFEST`/`SYSTEM_DEPENDENCIES` so builders know what to tag.

## When not to use tags

- Anything that must exist exactly once and be reachable by name (a `RoundState` module, a specific
  truck model). Tags are for many, optional, editor-authored instances.
- Client-side discovery of server-created parts: the tag replicates, but timing is after streaming —
  prefer a remote event that names the instance.

Next: [[R-attributes-vs-values-vs-config]] · [[S-smart-door]] · [[S-hiding-spots]].
