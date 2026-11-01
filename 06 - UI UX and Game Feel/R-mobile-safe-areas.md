---
id: R-mobile-safe-areas
type: reference
title: Mobile safe areas, touch targets and thumbs
status: reviewed
updated: 2026-11-01
tags: [ui, mobile, input]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-anchorpoint-and-insets", "R-responsive-matrix", "S-sprint-stamina"
---

# Mobile

Most Roblox players are on a phone. Design the phone first, desktop second.

## The occupied zones

```text
┌─────────────────────────────┐
│ status bar (safe inset)     │  never place UI here
├─────────────────────────────┤
│                             │
│   top-left: joystick area   │  ← left thumb rests here
│   bottom-right: jump/tools  │  ← right thumb rests here
│                             │
├─────────────────────────────┤
│ gesture bar (safe inset)    │
└─────────────────────────────┘
```

Rules:

- **Nothing interactive** in the bottom 25% × 45% (left) and bottom 25% × 45% (right).
- Read-only HUD can go top-centre and top-right.
- Buttons in the middle band must be reachable without moving the thumb off the joystick — rare.

## Touch-specific behaviour

| Need | Use |
|---|---|
| Tap an object in the world | `ProximityPrompt` (handles touch natively) |
| Hold to sprint | an on-screen button that fires the same remote as the keyboard |
| Drag to look | leave to Roblox camera; do not fight it |
| Long press | avoid; the OS gesture bar eats it |

## Text and DPI

Phones have high DPI: a 14 px label is physically tiny. Treat 16 px as the floor for body text and 44 px as
the tap floor ([[R-anchorpoint-and-insets]]).

## Performance note

Mobile is also the performance target: fewer lights, no `Future` lighting, no stacked blurs
([[H-profiling-budgets]]). A beautiful desktop HUD on a phone at 22 fps is a failed HUD.

## Test matrix

| Device class | Resolution | Check |
|---|---|---|
| Small phone | 667×375 | no overlap, tap targets ≥ 44 |
| Large phone | 932×430 | text legible |
| Tablet | 1024×768 | not stretched |
| Desktop | 1920×1080 | not comically small |

