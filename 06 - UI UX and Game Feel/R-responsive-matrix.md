---
id: R-responsive-matrix
type: reference
title: Responsive verification matrix
status: reviewed
updated: 2026-11-01
tags: [ui, responsive, testing]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "G-ui-buttons-drift", "R-mobile-safe-areas", "R-controller-focus"
---

# Responsive matrix

The minimum set of viewports to check before a UI is "done". Screenshot each; compare a known element's
size and its distance from a corner.

| # | Class | Size | Aspect | Checks |
|---|---|---|---|---|
| 1 | Desktop 1080p | 1920×1080 | 16:9 | baseline |
| 2 | Laptop | 1366×768 | 16:9 | no overlap at small height |
| 3 | Ultrawide | 2560×1080 | 21:9 | panels not stretched, anchored correctly |
| 4 | Tablet | 1024×768 | 4:3 | text not tiny |
| 5 | Phone landscape | 667×375 | 16:9 (small) | tap targets ≥ 44, no overlap with thumbs |
| 6 | Phone landscape large | 932×430 | ~19.5:9 | notch inset |
| 7 | Phone portrait | 375×667 | 9:16 | if supported: single column, or explicitly unsupported |
| 8 | TV | 1280×720 @ 3 m | 16:9 | text ≥ 24 px, focus visible |

## Pass criteria

- No element overlaps another at any of the 8.
- No interactive element under 44 px.
- Every anchored element keeps its distance from its corner (± 4 px by design).
- Text remains legible: ≥ 16 px effective, contrast ≥ 4.5:1.
- Nothing is clipped by the safe inset.
- The world still reads: the HUD occupies < 20% of the screen.

## How to run it

Studio → Test → Device → pick each resolution. For portrait, rotate the emulator. Take a screenshot per
row and attach it to the project's test evidence.

## What this does not test

- Real touch input (the emulator sends simulated taps).
- Real controller (use the Controller Emulator).
- Real GPU performance ([[H-profiling-budgets]]).

See [[G-ui-buttons-drift]] · [[G-ui-unintended-widening]] · [[R-mobile-safe-areas]].

