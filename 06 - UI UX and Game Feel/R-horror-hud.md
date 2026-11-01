---
id: R-horror-hud
type: reference
title: Horror HUD design: restraint and readable affordances
status: reviewed
updated: 2026-11-01
tags: [ui, horror, hud]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-ui-style-guide-tokens", "S-notification-system", "R-ui-sound-layering"
---

# Horror HUD

The HUD is a tension leak. Every permanent element on screen says "this is a game", and the more there
are, the less the world can scare anyone.

## The restraint rule

| Element | Show | Hide |
|---|---|---|
| Objective | on change, then fade after 4 s | when idle |
| Inventory | on demand (a key/tap) | always otherwise |
| Health | only when below full | at full health |
| Interaction prompt | only within range | outside range |
| Pickup count / money | on change, 3 s | idle |
| Timer | last 60 s only, or on demand | early round |
| Compass / minimap | usually never in horror | — |

Persistent minimal set: nothing. If something must be permanent, make it small, low contrast and in a
corner the eye does not treat as a threat direction.

## Readability under stress

- Prompts must be legible at a glance: **verb + object** ("Open door"), not a key.
- Critical text ≥ 20 px at 1080p, contrast ≥ 4.5:1.
- Never put critical feedback in a corner the player's eye does not go to during a chase (bottom-left is
  where the movement thumb is on touch).
- Screen-space feedback for being seen: a vignette pulse, not a text label.

## Practical layout (16:9)

```text
┌────────────────────────────────────────────┐
│ [objective, transient]          [money]    │
│                                            │
│                                            │
│               crosshair (tiny)             │
│                                            │
│        [prompt: centred-below-crosshair]   │
│                                            │
│ [inventory, on demand]      [touch sprint] │
└────────────────────────────────────────────┘
```

Touch controls own the bottom corners; nothing interactive lives there.

## Audio is UI

A UI click that is too loud in a quiet room is a horror bug: it tells the player the game, not the world,
is the loudest thing. Keep UI at −18 dB relative to the loudest ambience.

See [[R-ui-sound-layering]] · [[S-notification-system]] · [[R-ui-style-guide-tokens]].

