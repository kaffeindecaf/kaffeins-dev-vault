---
id: R-janitor-cleanup
type: reference
title: Janitor / maid pattern — connection and instance cleanup
status: reviewed
updated: 2026-11-01
tags: [performance, memory, architecture]
source_urls: [ "https://create.roblox.com/docs/scripting/events" ]
confidence: medium
verification: reference_only
related: [ "R-runservice-update-loops", "S-save-load-migration" ]
---

# Cleanup

Every `:Connect` you do not disconnect is a leak that keeps the closure — and everything it captures —
alive. In a game with respawns and rounds, that is the difference between a stable session and one
that degrades over an hour.

## A minimal janitor

```lua
-- Untested: ~25 lines, no dependency.
local Janitor = {}
Janitor.__index = Janitor

function Janitor.new()
    return setmetatable({ items = {} }, Janitor)
end

function Janitor:add(item, method)
    table.insert(self.items, { item = item, method = method })
    return item
end

function Janitor:clean()
    for i = #self.items, 1, -1 do
        local entry = self.items[i]
        local item = entry.item
        local ok, err = pcall(function()
            if entry.method then
                item[entry.method](item)
            elseif typeof(item) == "RBXScriptConnection" then
                item:Disconnect()
            elseif typeof(item) == "Instance" then
                item:Destroy()
            elseif type(item) == "function" then
                item()
            end
        end)
        if not ok then warn("janitor clean failed:", err) end
        self.items[i] = nil
    end
end

return Janitor
```

Usage:

```lua
-- Untested
local janitor = Janitor.new()
janitor:add(humanoid.Died:Connect(onDied))
janitor:add(RunService.Heartbeat:Connect(step), "Disconnect")
janitor:add(highlight)                          -- destroyed on clean
humanoid.Died:Once(function() janitor:clean() end)
```

## Where cleanups are mandatory

| Context | Clean up on |
|---|---|
| Character scripts | `Humanoid.Died`, `CharacterRemoving`, `Players.PlayerRemoving` |
| Round systems | round end, **and** player leaving mid-round |
| UI built at runtime | screen close, respawn (`ResetOnSpawn = false` means you own it) |
| Per-player caches | `PlayerRemoving` — always, including on a disconnect mid-tween |
| NPC controllers | NPC death/destroy, round reset |

## The two leaks that are hard to see

1. **Reconnecting on every spawn.** A script under `StarterCharacterScripts` that connects to
   `workspace.ChildAdded` creates a new listener per life. After 20 deaths you have 20 listeners.
2. **Remotes created per player.** `Instance.new("RemoteEvent")` inside `PlayerAdded` grows forever
   unless parented to something that dies with the player. Prefer one shared remote.

Detect them: Studio → **Performance** stats + `Stats().InstanceCount` over time, or print
`#connections` in a debug overlay.

See [[G-profiling-workflow]] · [[R-npc-think-budget]].
