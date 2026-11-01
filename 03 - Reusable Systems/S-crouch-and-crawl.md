---
id: S-crouch-and-crawl
type: system
title: Crouch and crawl with animation and collision tradeoffs
status: reviewed
updated: 2026-11-01
tags: [systems, movement, animation]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [UserInputService]
dependencies: []
code_blocks: 1
related: "S-sprint-stamina", "R-player-character-humanoid-animator", "R-npc-perception-model"
---

# Crouch / crawl

Three things must change together or it feels broken: speed, camera height, collision profile.

## The stack

| Layer | Change | Owner |
|---|---|---|
| Speed | walk 16 → crouch 6.4 | server |
| Camera | raise/lower the camera offset | client |
| Animation | crouch idle / crouch move tracks | client (replicated playback is fine) |
| Collision | optional: shorter `Humanoid.HipHeight` or a smaller collider | server |
| Detection | smaller "can be seen" profile, quieter footsteps | server |

## Implementation

```lua
-- Untested
local CROUCH_SPEED, WALK_SPEED = 6.4, 16

local function setCrouch(player, crouch)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.WalkSpeed = crouch and CROUCH_SPEED or WALK_SPEED
    hum.HipHeight = crouch and 1.2 or 2.0        -- only if the rig tolerates it
    char:SetAttribute("Crouched", crouch)         -- server-stamped, NPCs read this
end
```

Set the attribute **on the server** so NPCs can hear a crouching player more quietly
(`Crouched` → lower noise radius). A client-set attribute is a cheat vector.

## Bind once

The classic duplicate-binding bug: a stock `LocalScript` in `StarterCharacterScripts` toggles crouch
*and* your own `Crouch` script does. Result: pressing C toggles twice and nothing happens. Grep the
key code across `StarterPlayer` and `StarterGui` before adding an input.

## Failure modes

- `HipHeight` change on an R15 rig can sink the character into the floor → test on the actual rig; if
  it misbehaves, skip collision and only change speed + camera.
- Crouch while sprinting → decide precedence explicitly (crouch cancels sprint).
- Crouch under a low ceiling, then stand → clip into geometry; raycast up before allowing stand.
- Crouch during a hide → exit hide first, then apply crouch.

## Test cases

1. Toggle: speed, camera height and attribute all change.
2. Crouch under a 4-stud gap → allowed; stand under it → blocked.
3. Sprint + crouch → one wins, no oscillating speed.
4. Respawn → crouch state cleared.
5. Noise radius while crouched is measurably smaller in the NPC's log.

