---
id: X-experiments-index
type: experiment
title: Experiments — index and template
status: draft
updated: 2026-11-01
tags: [experiments, testing]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "MOC-bugs", "R-responsive-matrix", "G-knowledge-promotion"
---

# Experiments

An experiment answers one question with a measurement. Nothing here has been run: this vault shipped without a
Studio session, so these are **open questions with a method**, not results.

## Template

```text
Question:     one sentence
Hypothesis:   what you expect and why
Variable:     the single thing you change
Method:       exact steps, device, build
Measure:      the number you record
Result:       observed (blank until observed)
Conclusion:   what you now do differently
```

## Open

### X-01 — Does clamping `UIScale` to 0.75–1.5 keep text legible on all 8 viewports?
- Method: token-based panel, screenshot each viewport, measure effective text height in pixels.
- Measure: minimum effective text height per viewport.

### X-02 — Frame cost of 10 NPCs with 2 rays each at 5 Hz?
- Hypothesis: < 0.5 ms/frame server-side.
- Method: instrument `think()` ([[G-profiling-workflow]]), read `[perf]` output.
- Measure: ms/s per NPC, total.

### X-03 — Is a 0.28 s exposure window after exiting hiding fair?
- Method: A/B two builds, ask testers to describe the catch; measure catch rate.
- Measure: catch rate + verbatim quotes.

## Rule
Do not fill in a `Result` you did not measure. An experiment with a guessed result is worse than an empty one.

