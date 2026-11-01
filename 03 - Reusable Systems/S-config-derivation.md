---
id: S-config-derivation
type: system
title: Config derivation, reject logging and the debug gate (extracted)
status: reviewed
updated: 2026-11-01
tags: [systems, config, quality, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 3
related: "S-config-module", "R-logging-and-tracing", "G-server-authority-checklist", "R-module-dependencies"
---

# Config derivation and instrumentation

Three habits from production code that make a system tunable and debuggable without touching logic. None of them
is clever; all of them are routinely skipped.

## 1. Derive, never re-type

The shipped sell prompt gets slower the more you carry — computed, not a second table:

```lua
-- Untested: read from a live place.
local CONFIG = {
    SELL_HOLD_BASE = 0.6,      -- seconds when empty-handed
    SELL_HOLD_PER_ITEM = 0.15, -- + per carried item
    SELL_HOLD_MAX = 2,         -- cap
}

local hold = math.min(CONFIG.SELL_HOLD_MAX,
                      CONFIG.SELL_HOLD_BASE + CONFIG.SELL_HOLD_PER_ITEM * carriedCount)
```

Two copies of "the sell hold is 1.5" is a future bug: one gets tuned and the other does not.

## 2. Optional dependency with a baseline fallback

A shop upgrade changes the carry cap, but the shop must never be able to break the round:

```lua
-- Untested: read from a live place.
local ShopEffects = safeRequire(ServerScriptService, "ShopEffects")   -- may be nil

local function carryCapFor(player)
    return ShopEffects and ShopEffects.carryCap(player) or CONFIG.MAX_CARRY_ITEMS
end
```

`and ... or` reads as "use the upgrade if the module exists and is healthy, else the baseline". The module
itself wraps every read in `pcall`, so a half-deployed feature degrades to baseline instead of erroring in the
loop.

## 3. Log every refusal, rate-capped

A refusal with no log is indistinguishable from a broken feature once debug output is off.

```lua
-- Untested: the shape of a small debug facade; each system gets its own instance.
local Debug = {}
local counts = {}

function Debug.for(system)
    local D = {}
    function D.deny(fmt, ...)          -- ALWAYS prints, but rate-limited
        local n = (counts[system] or 0) + 1
        counts[system] = n
        if n > 10 then
            if n == 11 then warn(("[%s] further denials suppressed"):format(system)) end
            return
        end
        warn(("[%s] DENIED "):format(system) .. string.format(fmt, ...))
    end
    function D.log(fmt, ...)           -- master switch + per-script switch
        if not DebugConfig.ENABLED then return end
        print(("[%s] "):format(system) .. string.format(fmt, ...))
    end
    return D
end
```

Rules that survived contact:

- **`deny()` bypasses the debug switch** (you need refusals even in a build with tracing off) **but is
  rate-capped per system** (10 lines, then a summary line).
- **`fail()` prints always** and is not capped — it is for actual errors.
- **`log()` respects both a master switch and a per-script switch**, so one noisy file can be silenced without
  losing the rest.
- **Put a `deny()` on every `return` in a validation chain**, naming which check refused.

## What to change per game

| Habit | Your version |
|---|---|
| derived values | any number that is a function of two config values |
| optional module | `local ok, mod = pcall(require, path)`, then `mod and mod.thing() or baseline` |
| debug gate | one master flag + per-system channels + a capped deny channel |

## Learned failure modes

- **`pcall(require, ...)` also swallows a syntax error in your own module.** That is the trade: a broken
  optional module degrades to baseline instead of crashing the loop. Log the `pcall` failure once so it does
  not stay invisible forever.
- **A deny cap that resets per call is not a cap.** Count in a table keyed by system, for the session.
- **Debug output in a shipped build is a frame cost and a logic leak.** Assert the master flag is off in the
  release checklist.

