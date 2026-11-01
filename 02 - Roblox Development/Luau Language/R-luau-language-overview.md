---
id: R-luau-language-overview
type: reference
title: Luau language overview
status: reviewed
updated: 2026-11-01
tags: [luau, language, fundamentals]
source_urls: [ "https://create.roblox.com/docs/luau" ]
confidence: medium
verification: reference_only
related: [ "R-luau-strict-typing", "R-script-types-and-placement", "R-module-dependencies" ]
---

# Luau language overview

What actually matters when writing Roblox code, in the order you will hit it. Luau is Lua 5.1 with a
type checker, string interpolation, compound assignment, `continue`, and generalized iteration.

## Values, tables and iteration

```lua
-- Untested: language semantics, not run here. Verified against the Luau docs.
local t = { a = 1, b = 2 }
t.c = 3                      -- tables are always references
for k, v in t do             -- generalized iteration: no pairs() needed
    print(k, v)
end

local arr = { 10, 20, 30 }
for i, v in arr do print(i, v) end          -- index, value
table.insert(arr, 40)                        -- append
table.remove(arr, 1)                         -- remove by index (shifts)
```

`#t` is only meaningful for a sequence (1..n with no holes). Using a dictionary with `#` is the
single most common Luau bug; use the length of a separately maintained count instead.

## Modules

A `ModuleScript` returns exactly one value, and `require` caches it per place. Requiring the same
module from client and server gives **two separate instances** — they do not share state.

```lua
-- Untested
local Config = {}
Config.ROUND_TIME = 300
function Config.formatTime(s: number): string
    return string.format("%d:%02d", math.floor(s / 60), s % 60)
end
return Config
```

## Error handling

`pcall` returns `ok, result-or-error`. Use it around anything that can fail for external reasons
(DataStore calls, HTTP, asset loading). Do not use it to hide logic bugs.

```lua
-- Untested
local ok, err = pcall(function()
    return store:GetAsync("key")
end)
if not ok then
    warn("datastore read failed:", err)   -- degrade, do not crash the player's session
end
```

## Strings and formatting

```lua
-- Untested
local name, hp = "Ghost", 87
print(`{name} has {hp} HP`)              -- string interpolation, Luau only
print(string.format("%s · %d", name, hp))
```

## Things that bite

- **Integer division vs float:** `/` always yields a float; use `//` for integer division. UDim2
  offsets are integers — round deliberately.
- **No `goto`.** Restructure with functions or `continue`.
- **`gsub` has no "plain" flag.** Escape magic characters yourself: `([^%w%s])` → `"%%%1"`.
- **Locals are scoped from the declaration point.** Pre-declare anything captured in a closure that
  is defined earlier.
- **`math.random` is not seeded for game logic you need to reproduce** — use a seed you control
  (see [[R-seeded-generation]]).
- **`task.wait` inside a loop throttles the whole loop.** `RunService` connections are cheaper for
  per-frame work — see [[R-runservice-update-loops]].

## Where to go next

Types: [[R-luau-strict-typing]] · placement and execution context: [[R-script-types-and-placement]] ·
module structure: [[R-module-dependencies]] · official language docs: [[G-roblox-api-links]].
