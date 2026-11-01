---
id: G-profiling-workflow
type: guide
title: Profiling with MicroProfiler and the developer console
status: reviewed
updated: 2026-11-01
tags: [performance, profiling, workflow]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-profiling-budgets", "R-npc-think-budget", "R-runservice-update-loops"
---

# Profiling

## Order of operations

1. **Frame time first** (Studio Performance stats, or a `Heartbeat` delta tracker).
2. **Split CPU/GPU** in MicroProfiler: compare `Render` vs `Script` scopes.
3. **Find the top scope** — click the biggest block; the label names the system.
4. **Change one thing**, re-measure the same scenario.

## What the numbers mean (mobile target)

| Frame time | Verdict |
|---|---|
| ≤ 16.6 ms | 60 fps, headroom |
| 16.6–33 ms | 30–60 fps, fine for a slow horror game |
| 33–50 ms | 20–30 fps, players notice |
| > 50 ms | unplayable |

Studio on a laptop is *slower* than a phone at scripting and *faster* at rendering. Never conclude "it runs
fine" from the editor.

## Script-cost instrumentation

```lua
-- Untested: per-system timings, Studio only
local marks = {}
local function timed(name, fn)
    local t = os.clock(); fn()
    marks[name] = (marks[name] or 0) + (os.clock() - t)
end
task.spawn(function()
    while true do
        task.wait(1)
        for name, total in marks do
            if total > 0.002 then print(("[perf] %s %.1f ms/s"):format(name, total * 1000)) end
            marks[name] = 0
        end
    end
end)
```

Over ~2 ms/s of a 16 ms budget deserves attention.

## The four usual culprits

1. Per-frame raycasts → stagger ([[R-npc-think-budget]]).
2. Too many shadow-casting lights → [[H-profiling-budgets]].
3. Stacked transparent panes → overdraw.
4. Uncapped particle emitters → fill rate.

A measurement without device, date and scenario is a rumour.

