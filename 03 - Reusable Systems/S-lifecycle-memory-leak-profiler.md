---
id: S-lifecycle-memory-leak-profiler
type: system
title: Dynamic component lifecycle and memory leak suspect profiler
status: draft
updated: 2026-11-02
tags: [systems, backend, reusable, v1]
source_urls: ["https://luau.org/library/"]
confidence: medium
verification: tested_studio
client_server: both
roblox_services: []
test_method: Studio Play mock fault harness and scoped runtime checks
tested_at: 2026-11-02
test_evidence: BACKEND_SYSTEMS_TEST_REPORT.md
related: ["T-backend-systems-catalog","SRC-backend-platform-contracts","R-janitor-cleanup","G-profiling-workflow"]
---

# Dynamic component lifecycle and memory leak suspect profiler

Files: `lifecycle-leak-profiler.luau` in `11 - Templates and Schemas/Luau Snippets/`. Executed scope is documented below; project integration examples remain untested.

Register component tables using weak values, their scope and a registration traceback. After a round ends and a grace period passes, report components that remain reachable. The profiler retains diagnostic strings, not the tracked component.

## API and cleanup integration

`new(graceSeconds?, maxRecords?)`, `Track(scopeId, componentTable, label)`, `EndScope(scopeId, now)`, `Poll(now, report)`, `Forget(ticket)`, `Destroy()`. Call `Poll` periodically from the host and use one monotonic clock. Connect cleanup ownership to the existing cleanup scope / Janitor, but let the profiler observe without owning the component.

Untested: integration sketch; `Profiler` and `Scope` are the required modules.

```lua
local profiler = Profiler.new(60, 2000)
local cleanup = Scope.new()
local component = {name = "RoundController"}
local ticket = profiler:Track(roundId, component, "RoundController")
-- At round end: close all registered resources, then drop your strong references.
cleanup:Destroy()
profiler:EndScope(roundId, os.clock())
-- Periodic host: profiler:Poll(os.clock(), function(row) warn(row.label, row.trace) end)
```

Keep the ticket only while needed; after investigating a suspect, `Forget` removes its diagnostic record. The cap refuses registrations rather than growing indefinitely. `Destroy` clears the profiler itself.

## What a report means

A live weak reference is a suspect, not proof of a leak: GC timing, a legitimate owner, a cached closure or the caller's own local may retain it. The trace identifies registration, not the exact retaining script or forgotten event connection. This module deliberately tracks component tables; engine Instances and RBXScriptConnections require explicit lifecycle checks or heap profiling. It cannot enumerate every reference or force Roblox GC.

| Case | Check |
|---|---|
| Round ends at t=0 | No suspect before grace |
| Component intentionally retained | One report at grace, no repeated spam |
| Component collected | Record disappears on a later poll |
| Legitimate long-lived component | Use a different scope or forget the ticket |
| Scope cleanup missed an event | Investigate trace with real heap tools |

Studio verified timing and one-shot reporting with a deliberately retained table. Real GC collection and retaining-path attribution remain untested.
