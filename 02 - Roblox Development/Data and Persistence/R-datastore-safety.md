---
id: R-datastore-safety
type: reference
title: DataStoreService — safety, budgets and failure handling
status: draft
updated: 2026-11-01
tags: [datastore, persistence, safety]
source_urls:
  - https://create.roblox.com/docs/cloud-services/data-stores
  - https://create.roblox.com/docs/cloud-services/data-stores/best-practices
  - https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits
confidence: medium
verification: design_only
related: [ "S-save-load-migration", "S-datastore-player-profile", "R-memorystore-messaging", "SRC-roblox-data-store-player-profile", "G-skill-roblox-core-loop" ]
---

# DataStores

Anything a player would be angry to lose lives here. Treat every write as irreversible.

## The shape that survives contact with production

Untested:

```lua
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local STORE = DataStoreService:GetDataStore("PlayerData_v1")   -- version the NAME, not the shape
local DEFAULT = { coins = 0, level = 1, version = 3 }

local cache = {}       -- [userId] = data
local dirty = {}       -- [userId] = true

local function load(player)
    local key = "u_" .. player.UserId
    local ok, result = pcall(function()
        return STORE:GetAsync(key)      -- add :BindToClose / retries in real code
    end)
    if not ok then
        warn("load failed for", player.UserId, result)
        return nil                      -- do NOT silently start from DEFAULT; that wipes data later
    end
    local data = result or table.clone(DEFAULT)
    -- migrate here, never at save time
    if (data.version or 1) < 3 then
        data.version = 3
    end
    return data
end
```

## Rules

1. **One writer.** Exactly one module owns the store. Two scripts writing the same key is how you
   overwrite a purchase that just happened.
2. **Version the key or the shape, and migrate on load.** Migrating on save loses the data of anyone
   who never triggered a save.
3. **Never fall back to defaults on a read error**, unless you have a session lock and a written
   record — otherwise a transient failure overwrites a real profile with a fresh one.
4. **Budget-aware writes.** Check `DataStoreService:GetRequestBudgetForRequestType()` before
   optional background work. `UpdateAsync()` consumes both read and write budget. Current limits
   depend on request type, server and experience usage; see Roblox's
   [error codes and limits](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits).
   Avoid fixed-rate writes and stagger periodic saves per Roblox's
   [best practices](https://create.roblox.com/docs/cloud-services/data-stores/best-practices).
5. **`BindToClose` is shutdown only.** Roblox's reference describes a 30-second shutdown callback
   limit. Save in parallel with a shared deadline; still save periodically and on `PlayerRemoving`.
6. **Session locking** (a `MemStore` key or an "owner" field with timestamp) stops two servers writing
   the same profile after a crash/rejoin.
7. **Keep Studio away from live data.** Studio cannot access DataStores by default. Enabling
   **Access to API Services** can make Studio use the same DataStores as the live experience.
   Use a separate test experience or isolated store names; do not enable this against live data.
   See Roblox's [Studio access warning](https://create.roblox.com/docs/cloud-services/data-stores).

## Testing without risking data

Untested:

```lua
local USE_REAL = false
local store = USE_REAL and STORE or {
    GetAsync = function(_, k) return MEMORY[k] end,
    SetAsync = function(_, k, v) MEMORY[k] = v end,
}
```

That lets you exercise application logic without a real DataStore write, provided the fake backend
is complete enough for the path under test. A real persistence run belongs in an isolated test
experience. For a current server-memory, session-lock and shutdown design, see
[[S-datastore-player-profile]] and the official-source note [[SRC-roblox-data-store-player-profile]].

## Failure modes to handle explicitly

| Failure | Handle by |
|---|---|
| `GetAsync` throttled/erroring | retry with backoff, keep the player in a "loading" state, never default-overwrite |
| `SetAsync` fails on leave | retry queue + `BindToClose`, alert in logs |
| Player leaves twice (rejoin quickly) | session lock, cancel the old session's writes |
| Schema change | version field + migrate on load, keep old reads working |
| Studio vs live | separate `experienceId` stores by design; don't copy data by hand |

See [[S-save-load-migration]] for the module, [[G-datastore-failure-checklist]] for diagnosis.
