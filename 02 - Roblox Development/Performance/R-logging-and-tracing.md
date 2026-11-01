---
id: R-logging-and-tracing
type: reference
title: Logging and tracing — one switch, structured, off in release
status: reviewed
updated: 2026-11-01
tags: [debugging, logging, quality]
source_urls: [ "https://create.roblox.com/docs/studio/debugging" ]
confidence: medium
verification: reference_only
related: [ "G-profiling-workflow", "G-replication-debugging" ]
---

# Logging

`print` is not a logging system. A single `DebugConfig` module with a global switch, per-system
channels and a rate cap turns debugging from archaeology into reading.

```lua
-- Untested
local DebugConfig = { ENABLED = false, VERBOSE = false, RATE = 20 }

local counts = {}
local Debug = {}

function Debug.for(system: string)
    return function(fmt: string, ...)
        if not DebugConfig.ENABLED then return end
        local n = (counts[system] or 0) + 1
        counts[system] = n
        if n > DebugConfig.RATE then
            if n == DebugConfig.RATE + 1 then
                print(("[%s] rate cap reached, output suppressed"):format(system))
            end
            return
        end
        print(("[%s %6.2f] "):format(system, os.clock()) .. string.format(fmt, ...))
    end
end

return Debug
```

## Why the rate cap matters

An instrumented `Heartbeat` loop printing every frame produces ~3600 lines/minute and pushes the real
error out of the Output buffer. Cap it, and make the cap itself visible.

## What to log

- **State transitions** (`Idle → Chase`), with the reason and the inputs that caused it.
- **Rejections**: a remote the server refused, with which check failed (never with the client's
  arbitrary payload dumped raw — truncate it).
- **Timings**: `os.clock()` deltas around a path recompute or a save.

Not: per-frame values, player names in bulk, anything a player typed (privacy, [[G-player-privacy]]).

## Levels that map to cost

| Level | Release | Use |
|---|---|---|
| `error` (warn) | on | something is broken now |
| `state` | off | transitions, round events |
| `trace` | off | per-action detail |
| `spam` | off | per-frame |

## Shipping

- `ENABLED = false` in anything published. Assert it in a release checklist, because tracing left on
  is a measurable frame cost and a leak of internal logic.
- Studio-only tools (an XP grant remote, a debug overlay) must be gated on
  `RunService:IsStudio()` — and a Studio-only remote that grants currency with no author check is a
  bug waiting for a "test this in production" moment.

See [[G-profiling-workflow]] and [[R-npc-think-budget]] for consuming these numbers.
