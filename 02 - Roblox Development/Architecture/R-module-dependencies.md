---
id: R-module-dependencies
type: reference
title: Module dependencies, folders and cycles
status: reviewed
updated: 2026-11-01
tags: [architecture, modules, structure]
source_urls: [ "https://create.roblox.com/docs/scripting/module" ]
confidence: medium
verification: reference_only
related: [ "R-script-types-and-placement", "S-config-module" ]
---

# Module architecture

A `ModuleScript` is a file with a table and a public API. Good structure is mostly about **who may
require whom**, and keeping that a DAG.

## A layout that scales

```text
ServerScriptService/
  Systems/          orchestration: rounds, NPC controller, doors  (require ↑)
  Modules/          domain logic: PlayerData, Economy, Inventory  (require ↓, no UI)
ReplicatedStorage/
  Shared/           pure helpers both contexts need (math, formatting, types)
  Remotes/          remote instances only, no logic
  Config/           display copy of tunables (never authority)
ServerStorage/
  Models/           NPC rigs, loot templates, backups
```

Dependency direction: `Systems → Modules → Shared`. Never the reverse. `Shared` requires nothing from
`ServerScriptService` (it cannot see it on the client anyway).

## Cycles

Two modules requiring each other deadlocks or returns a partially-built table:

```lua
-- Untested: BREAKS
-- A requires B, B requires A at module scope -> one of them sees an incomplete table.
```

Fixes, in order of preference:

1. **Invert**: B should not need A; pass what it needs as an argument.
2. **Extract** the shared piece into a third module both require.
3. **Lazy require** inside a function (`require(...)` at call time). Works, but hides the cycle —
   use only as a last resort and comment why.

## Public API discipline

```lua
-- Untested
local Inventory = {}
function Inventory.add(player, itemId, qty) end
function Inventory.count(player, itemId) end
function Inventory.snapshot(player) return {} end   -- read-only copy for the client
return Inventory
```

- Return a table with functions; keep state in an upvalue, not on the returned table.
- `snapshot()` returns a **copy**: handing out the live table lets a caller mutate authority state.
- Document `client_server` in the note, and never require a server module from a client script — it
  will not be found (or, worse, an exploiter finds a replicated copy of your logic).

## Config boundary

Tunables live in one `Config` module (`dependencies = { "S-config-module" }`), not scattered constants.
When two systems need the same number, one of them owns it and the other reads it.

See [[S-config-module]] · [[R-collectionservice-tags]] for discovery, [[R-attributes-vs-values-vs-config]]
for where state lives.
