---
id: S-save-load-migration
type: system
title: Save / load with schema migration and failure handling
status: reviewed
updated: 2026-11-01
tags: [systems, data, persistence]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [DataStoreService]
dependencies: []
code_blocks: 2
related: [ "R-datastore-safety", "R-memorystore-messaging", "S-objective-tracker", "S-datastore-player-profile", "G-skill-roblox-core-loop" ]
---

# Save, load, migrate

The module every game grows wrong first. Three rules, then code.

1. **One writer.** One module owns the store.
2. **Migrate on load**, never on save.
3. **Never default-overwrite on a read failure.**

## Schema with versions

```lua
-- Untested
local MIGRATIONS = {
    [1] = function(d) d.streak = d.streak or 0; d.version = 2; return d end,
    [2] = function(d) d.quests = d.quests or {}; d.version = 3; return d end,
}

local function migrate(data)
    local v = data.version or 1
    while MIGRATIONS[v] do
        data = MIGRATIONS[v](data)
        v = data.version
    end
    return data
end
```

A migration chain is the only shape that survives three deploys. A single `if version < 3 then ... end`
block becomes unreadable and untestable by the fourth.

## Load path

```lua
-- Untested
local function loadProfile(player)
    local ok, result = pcall(STORE.GetAsync, STORE, "u_" .. player.UserId)
    if not ok then
        return nil, "datastore_error"     -- caller must not treat this as "new player"
    end
    if result == nil then return table.clone(DEFAULTS), "new" end
    return migrate(result), "loaded"
end
```

The distinction between *"no data"* and *"could not read data"* is the difference between a new player
and a wiped profile. Both return `nil` from `GetAsync`-ish APIs if you are not careful.

## Write path

- Dirty flag on change; a single loop writes every 30–60 s.
- `BindToClose` flushes, but with a shared deadline (~25 s) — batch, and `task.wait` between writes.
- A failed write keeps the dirty flag set; never clear it optimistically.
- Session lock ([[R-memorystore-messaging]]) so two servers cannot both write.

## Migration test template

1. A v1 profile loads, migrates to v3, saves as v3.
2. A v3 profile loads unchanged.
3. A profile with an *unknown* newer version (rollback) → refuse to overwrite, log it.
4. A corrupt profile (missing fields) → repaired with defaults per field, not discarded.
5. Read failure → player told "try again", no default profile written.

See [[R-datastore-safety]] for budgets, [[S-datastore-player-profile]] for the official architecture
and example diagrams, [[G-skill-roblox-core-loop]] for the linked runtime skill, and
[[G-datastore-failure-checklist]] for diagnosis.

