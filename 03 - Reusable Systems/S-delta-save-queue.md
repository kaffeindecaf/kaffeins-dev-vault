---
id: S-delta-save-queue
type: system
title: Single-writer delta save queue (extracted from a shipping game)
status: reviewed
updated: 2026-11-01
tags: [systems, persistence, datastore, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 3
related: "S-save-load-migration", "R-datastore-safety", "R-memorystore-messaging", "G-datastore-failure-checklist"
---

# Delta save queue — one writer, additive writes, idempotent tokens

The most valuable pattern in the set. 600 lines of production persistence reduce to four ideas: **one writer,
write deltas not whole records, make the write idempotent, and never let a read failure become a default
record.**

## The four ideas

| Idea | Why |
|---|---|
| **One module owns the key** | two writers with different schemas silently zero each other's fields |
| **Queue deltas, not snapshots** | `{kc=+50}` cannot clobber another server's `xp`; a whole-record write can |
| **`UpdateAsync` + a write token** | a retried batch must not apply twice; the token proves it did |
| **Read failure ≠ new player** | a throttled `GetAsync` must never produce a default record that then gets saved |

## The queue (as shipped)

```lua
-- Untested in this vault: read from a live place, generalised. The place ran this against real DataStores.
local CONFIG = {
    WRITE_INTERVAL = 5,        -- seconds: at most one write per user per interval (2-10)
    RETRY_ATTEMPTS = 3,        -- per retained batch (1-5)
    RETRY_BASE_DELAY = 0.5,    -- seconds of linear backoff (0.1-2)
    SAVE_WAIT_TIMEOUT = 20,    -- seconds to wait on an in-flight save (5-25)
    WRITE_TOKEN_LIMIT = 32,    -- committed tokens retained per record (16-64)
    SCHEMA_VERSION = 3,
}

local pending = {}   -- userId -> additive delta { coins, xp, runs, ... }
local batches = {}   -- userId -> { delta = d, token = guid }   (retained across a failed write)
local locks = {}     -- userId -> true while a save is running

local function queueDelta(userId, delta)       -- accumulation, never a write
    local p = pending[userId]
    if not p then p = {}; pending[userId] = p end
    for k, v in pairs(delta) do p[k] = (p[k] or 0) + v end
end

local function retryStore(fn)                  -- returns ok, RESULT (not just an error)
    local ok, result
    for attempt = 1, CONFIG.RETRY_ATTEMPTS do
        ok, result = pcall(fn)
        if ok then return true, result end
        if attempt < CONFIG.RETRY_ATTEMPTS then task.wait(CONFIG.RETRY_BASE_DELAY * attempt) end
    end
    return false, result
end

function Store.flush(userId)
    if Studio then return true end                       -- in-memory stand-in in Studio
    local deadline = os.clock() + CONFIG.SAVE_WAIT_TIMEOUT
    while locks[userId] do
        if os.clock() >= deadline then return false end  -- bounded wait, never forever
        task.wait()
    end
    locks[userId] = true

    local ok, failure = pcall(function()
        while true do
            local batch = batches[userId]
            if not batch then
                local d = pending[userId]
                if not hasDelta(d) then pending[userId] = nil; return true end
                pending[userId] = nil
                batch = { delta = d, token = HttpService:GenerateGUID(false) }
                batches[userId] = batch                       -- retained: a failure retries THIS batch
            end
            local d = batch.delta
            local saved, err = retryStore(function()
                return store:UpdateAsync("u_" .. tostring(userId), function(old)
                    local rec = normalize(old)
                    local tokens = rec.writeTokens or {}
                    if table.find(tokens, batch.token) then return rec end   -- already applied
                    rec.coins += (d.coins or 0)                              -- additive, not replace
                    rec.xp += (d.xp or 0)
                    rec.level = levelForXp(rec.xp)
                    rec.stats = rec.stats or {}
                    rec.stats.runs = (rec.stats.runs or 0) + (d.runs or 0)
                    table.insert(tokens, batch.token)
                    while #tokens > CONFIG.WRITE_TOKEN_LIMIT do table.remove(tokens, 1) end
                    rec.writeTokens = tokens
                    rec.updatedAt, rec.v = os.time(), CONFIG.SCHEMA_VERSION
                    return rec
                end)
            end)
            if not saved then return false, err end
            batches[userId] = nil
            if os.clock() >= deadline and hasDelta(pending[userId]) then return false end
        end
    end)
    locks[userId] = nil
    return ok and failure ~= false
end
```

`normalize(old)` is the migration gate: it accepts the old numeric-only shape, today's table shape, and
anything in between, filling missing fields from defaults. **Every writer must call the same `normalize`** —
a second normalizer with an older field list is how a save wipes a feature.

## The trap this code contains (and survives by accident)

```lua
local saved, err = retryStore(...)
if not saved or err == nil then ... end     -- `err` is really the RESULT on success
```

`retryStore` returns `(true, result)` on success, where `result` is whatever `UpdateAsync` returned (a table,
so non-nil). The check works **only** because that callback always returns a table. If a future `UpdateAsync`
callback could return `nil`, a successful save would be reported as failed and the batch retained forever.

**Rule:** name it `ok, result` and branch on `ok`. Never reuse one variable for "value" and "error".

## What to change per game

| Knob | Typical |
|---|---|
| `WRITE_INTERVAL` | 5 s for currency; 30–60 s for big records |
| `SCHEMA_VERSION` | bump on any shape change; migrate on **load** |
| key | `"u_" .. UserId` — never a display name |
| `hasDelta` | must list every field you queue, or that field silently never saves |

## Failure modes learned

- **A read error treated as "no data"** produces a default record, which the next flush writes over the real
  one. Return `nil, "load_failed"` and keep the player in a loading state.
- **Two flush paths** (autosave loop + save-on-leave) both setting `locks` is fine; both writing without a
  lock is a lost update.
- **`BindToClose` gets ~30 s for the whole server** — batch, and `task.wait()` between users.
- **Studio never exercised the real path** in the source project for months. If Studio uses a stand-in, the
  production write path is untested until you test it against the real store in a private place.

Tests: see [[S-save-load-migration]] §4 and [[G-datastore-failure-checklist]].

