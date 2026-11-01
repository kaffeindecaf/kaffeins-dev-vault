---
id: R-ui-sound-layering
type: reference
title: UI sound layering: hover, select, cancel, error
status: reviewed
updated: 2026-11-01
tags: [ui, audio, feedback]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "R-sound-service-3d", "R-prompt-affordances", "R-ui-transitions-tween"
---

# UI sound

Four sounds cover almost every interface. Recording/mixing them consistently is what makes a UI feel
expensive.

| Event | Length | Character | Level |
|---|---|---|---|
| Hover / focus | 30–60 ms | tiny tick, high frequency | −26 dB |
| Select / confirm | 80–140 ms | click with a slight body | −18 dB |
| Cancel / back | 80–140 ms | lower, inverted contour | −20 dB |
| Error / blocked | 150–250 ms | two-tone, dissonant but quiet | −18 dB |

## Rules

1. **Never louder than the world.** UI at 0 dB over a quiet horror ambience destroys the atmosphere.
2. **Hover is optional and rate-limited.** On a controller or touch there is no hover; and scrolling a
   list should not machine-gun ticks (cap at ~10/s).
3. **Do not play a sound for every state change** — a toggle that is already on does not need a confirm.
4. **Same sample family.** Four sounds from four different packs is audible as cheapness.

## Implementation

```lua
-- Untested: one 2D player, no per-click instance churn
local UI = {}
local players = {}
for _, name in { "hover", "select", "cancel", "error" } do
    local s = SoundService.UISounds[name]
    s.Parent = SoundService            -- 2D
    s.SoundGroup = SoundService:FindFirstChild("UIGroup")
    players[name] = s
end

function UI.play(name)
    local s = players[name]
    if not s then return end
    s.TimePosition = 0
    s:Play()
end
```

Setting `TimePosition = 0` before `Play()` lets one instance serve rapid repeats without creating a new
`Sound` per click.

## Accessibility

Every UI sound that carries meaning needs a visual equivalent: a blocked action shows a message
([[R-notifications-toasts]]), not just a buzz.

