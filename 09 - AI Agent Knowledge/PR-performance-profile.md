---
id: PR-performance-profile
type: prompt
title: Prompt — profiling and targeted optimisation
status: reviewed
updated: 2026-11-01
tags: [prompts, performance]
source_urls: []
confidence: medium
verification: reference_only
client_server: both
code_blocks: 0
related: "G-profiling-workflow", "H-profiling-budgets", "R-npc-think-budget"
---

# Prompt: performance

```text
Task: find and fix the dominant cost in <scenario>, with measurements.

Steps:
1. Ask for the target device and the current frame time (do not assume).
2. Offer the instrumentation from G-profiling-workflow; ask for the output.
3. Rank candidate costs: per-frame raycasts, shadow lights, transparent overdraw, particle fill rate.
4. Change ONE thing, then ask for a re-measure of the same scenario.

Rules:
- No optimisation without a before/after number from the same scenario.
- Studio measurements are labelled as such; they are not device results.
- Report the number you observed, not the improvement you expect.
```

See [[G-profiling-workflow]] and [[H-profiling-budgets]].

