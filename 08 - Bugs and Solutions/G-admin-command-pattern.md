---
id: G-admin-command-pattern
type: guide
title: Admin / dev tools as chat commands, not GUI panels
status: reviewed
updated: 2026-11-01
tags: [admin, tooling, pattern]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "R-server-authority-replication", "R-ai-debug-overlay", "R-logging-and-tracing"
---

# Chat commands

For small development teams, chat commands can be faster to build than a dedicated panel. For
larger teams, frequently used operations, or tools needing discoverability, a permission-gated panel
may be easier to maintain.

## Shape

```lua
-- Untested
local ADMIN_IDS = {}   -- server-only config; never replicate the list
local Commands = {}
function Commands.give(player, itemId, qty) Inventory.add(player, itemId, tonumber(qty) or 1) end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if not ADMIN_IDS[player.UserId] then return end          -- authority first
        local cmd, rest = message:match("^!(%w+)%s*(.*)$")
        if cmd and Commands[cmd] then Commands[cmd](player, table.unpack(string.split(rest, " "))) end
    end)
end)
```

## Rules
1. Authority by **user id**, from a server-only config. Never by name.
2. Parse **after** the check.
3. `!help` lists commands with usage — that is the documentation.
4. Destructive commands require an explicit target and a confirm token.
5. Style later; plain text replies are fine.

## First commands worth having
`!help` · `!tp <player>` · `!give <item> <qty>` · `!setround <s>` · `!spawnnpc <i>` · `!noclip` ·
`!ai_debug` ([[R-ai-debug-overlay]])

