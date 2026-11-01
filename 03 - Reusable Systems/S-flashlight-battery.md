---
id: S-flashlight-battery
type: system
title: Flashlight with battery, flicker and accessibility
status: reviewed
updated: 2026-11-01
tags: [systems, tools, accessibility]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [TweenService]
dependencies: []
code_blocks: 2
related: "R-reduced-motion-policy", "R-player-character-humanoid-animator", "S-crouch-and-crawl"
---

# Flashlight

A `SpotLight` on the character, a battery model on the server, and client-side presentation. The
accessibility requirement is not optional: flicker is a photosensitivity hazard.

## Server owns charge

```lua
-- Untested
local Flashlight = {}
local charge = {}   -- [player] = 0..1

function Flashlight.tick(player, dt)
    if not Flashlight.on[player] then return end
    charge[player] = math.max(0, (charge[player] or 1) - dt * (1 / 180))   -- 3 minutes
    LightState:FireClient(player, charge[player])
end
```

## Client owns the light

```lua
-- Untested: presentation only.
LightState.OnClientEvent:Connect(function(frac)
    local light = character.SpotLight
    light.Enabled = frac > 0
    light.Brightness = 2 * math.clamp(frac * 4, 0.15, 1)   -- dim before death, so it is telegraphed
    if frac < 0.15 and frac > 0 then
        -- flicker only if the player allows flashing
        if not reducedMotion then
            light.Enabled = math.random() > 0.35
        end
    end
end)
```

## Rules

1. **The server decides charge; the client decides how it looks.** A flicker toggle that only exists
   client-side is the accessibility-safe design.
2. **`Enabled` on the `SpotLight`, not the `Tool`** — toggling the tool re-parents and breaks input
   bindings.
3. **Respect the setting.** A `reducedMotion`/`reducedFlash` preference must be communicated to the
   server so it can also skip screen-shake cues ([[R-reduced-motion-policy]]).
4. **One input owner.** The classic bug in the companion project was two scripts binding `F`
   (a `SimpleFlashlight` and a `Flashlight`); grep for the key code before adding a binding.

## Failure modes

- Light parented to a part that respawns → dead light after death; re-parent on `CharacterAdded`.
- Battery drain ticking on the client → exploiter with infinite light.
- Flicker at 3–20 Hz → seizure risk. Cap below 3 Hz, and gate it behind the setting.

## Test cases

1. Toggle on/off: light and charge state agree.
2. Drain to 0 → light off, no negative charge.
3. Respawn → light restored at current charge.
4. Reduced-flash on → no flicker, steady dimming instead.
5. Disconnect while on → per-player state cleaned up.

