---
id: H-flicker-safety
type: principle
title: Flicker and strobe: recipes with seizure safety
status: reviewed
updated: 2026-11-01
tags: [horror, accessibility, lighting]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-intensity-config", "R-reduced-motion-policy", "H-profiling-budgets"
---

# Flicker

Flicker is the most effective and most dangerous effect in the toolkit. Treat it like a hazard.

## Hard limits

- **No flicker above 3 Hz.** The photosensitive range is roughly 3–60 Hz with a peak near 15–20 Hz.
- **No full-screen luminance jumps.** Dimming a lamp by 30% is fine; strobing the whole screen white is
  not.
- **Never more than 3 flashes in a second, and never more than 10 s of flicker in a row.**
- **Always behind a setting**, default off for anything that strobes.

## Safe flicker (a dying bulb)

```lua
-- Untested
local function dyingBulb(light, seconds)
    local t0 = os.clock()
    while os.clock() - t0 < seconds do
        light.Brightness = 0.4 + math.random() * 0.2
        task.wait(0.12 + math.random() * 0.18)   -- ~3-4 Hz max, irregular
    end
    light.Brightness = 0.9
end
```

Irregular timing below 3 Hz reads as "failing bulb"; a regular 10 Hz pulse reads as a strobe and is the
thing that hurts people.

## Better alternatives to strobe

| Want | Use instead |
|---|---|
| Mechanical threat | audio glitch, a brief 0.3 s light *dip* (not off) |
| Glitch aesthetic | `ColorCorrection` hue shift + subtle `BlurEffect`, no luminance flash |
| Shock | a single loud sound + a 0.2 s darkening |

## Implement the gate

```lua
-- Untested: read the player's setting, never a global
local allowsFlash = player:GetAttribute("AllowFlash") or false
if not allowsFlash then return end
```

Level 0/1 players must get the non-flashing variant of every effect ([[H-intensity-config]]).

