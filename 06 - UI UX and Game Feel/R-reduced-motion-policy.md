---
id: R-reduced-motion-policy
type: reference
title: Reduced motion and reduced flash policy
status: reviewed
updated: 2026-11-01
tags: [ui, accessibility, motion]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "H-flicker-safety", "S-camera-and-headbob", "H-intensity-config"
---

# Reduced motion / reduced flash

Not a niche feature: motion sickness from head bob and camera shake is common, and photosensitivity is a
medical risk. Both are cheap to support if designed in.

## The setting

Two independent booleans (not one slider):

- `reducedMotion` — no camera bob, no shake, no FOV punch, no tween overshoot, no parallax.
- `reducedFlash` — no luminance flashes, no strobing, no full-screen white.

Store with player settings; apply before the first frame after spawn
([[H-intensity-config]] for how it maps to horror intensity).

## What each must change

| Effect | reducedMotion | reducedFlash |
|---|---|---|
| Head bob | off | — |
| Camera shake | off (or ≤ 0.1°) | — |
| Sprint FOV punch | off | — |
| Screen flash | — | replaced by a 0.3 s dim |
| Flickering light | — | steady, or a slow dip |
| VHS/glitch overlay | off | amplitude reduced |
| Tween overshoot (Back easing) | replaced by Quad | — |
| Screen distortion | off | off |

## Implementation

```lua
-- Untested: one gate, read once, applied everywhere
local Settings = { reducedMotion = false, reducedFlash = false }

local function shake(intensity, duration)
    if Settings.reducedMotion then return end
    -- ... actual shake
end

local function flash(color, duration)
    if Settings.reducedFlash then
        -- dim instead of flash
        return dim(0.3)
    end
end
```

Route every effect through these functions instead of inlining `TweenService:Create(...)` at call sites —
otherwise the setting will be honoured in six places and forgotten in the seventh.

## Verify

1. Toggle on, then trigger every effect in the game (a debug menu helps).
2. Record the screen and check max luminance delta per second — target < 10% for reducedFlash.
3. Confirm gameplay is still legible: the player must still know a threat is happening (audio + a dim,
   not a flash).

See [[H-flicker-safety]] · [[S-camera-and-headbob]].

