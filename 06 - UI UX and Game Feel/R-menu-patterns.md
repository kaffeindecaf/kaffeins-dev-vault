---
id: R-menu-patterns
type: reference
title: Main menu, pause and settings patterns
status: reviewed
updated: 2026-11-01
tags: [ui, menus, patterns]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-controller-focus", "R-horror-hud", "R-ui-style-guide-tokens"
---

# Menus

Three screens, three different jobs. Most games make them one screen and everything is mediocre.

| Screen | Job | Rule |
|---|---|---|
| Main menu | get the player in fast | one primary action, big; never a wall of options |
| Pause | stop the world, offer 4 things | resume, settings, restart, leave |
| Settings | change one thing at a time | grouped, with immediate preview |

## Main menu

- Primary action top-level and unambiguous ("Play"). Everything else secondary.
- Do not put a shop in front of "Play" on a first launch — it reads as a mobile cash grab.
- Background: the world, slowly moving, or a still with atmosphere. Never a static logo on black with no
  sound.

## Pause

```lua
-- Untested: pause that actually stops the round clock
local paused = false
local function setPaused(v)
    paused = v
    PauseMenu.Enabled = v
    -- do not "pause" the server: in multiplayer a pause menu is per-player UI,
    -- the round keeps running, so never stop the clock for one player
end
```

**In multiplayer there is no pause.** A "pause" that freezes the world is a single-player concept; in a
multiplayer horror game it is an exploit.

## Settings

Group into: Controls, Audio, Video, Accessibility. Every change applies immediately and shows its effect.
Never require "Apply" for a slider.

```text
Controls     sensitivity, invert Y, binding hints
Audio        master, music, sfx, voice
Video        quality preset, lighting quality
Access      reduced motion, reduced flash, subtitles, UI scale
```

**Accessibility in its own section**, not buried under Video. See [[R-reduced-motion-policy]].

## Focus

Every menu takes focus on open and restores it on close ([[R-controller-focus]]).

