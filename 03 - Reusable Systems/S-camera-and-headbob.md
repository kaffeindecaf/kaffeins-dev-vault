---
id: S-camera-and-headbob
type: system
title: Camera effects, head bob and reduced motion
status: reviewed
updated: 2026-11-01
tags: [systems, camera, accessibility]
source_urls: []
confidence: medium
verification: design_only
client_server: client
roblox_services: [RunService, TweenService]
dependencies: []
code_blocks: 2
related: "R-reduced-motion-policy", "R-tween-patterns", "H-safe-room-rhythm"
---

# Camera and head bob

Camera work is the cheapest way to make a game feel expensive, and the fastest way to make a player
sick. One writer, one setting, one off switch.

## Single-writer rule

Roblox's default camera, a custom first-person script and a sprint FOV script all write
`Camera.CFrame`/`FieldOfView`. Two writers = jitter that no amount of tuning fixes.

```lua
-- Untested: one place owns the camera transform.
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local bobAmount, bobSpeed = 0.06, 9
local phase = 0

RunService:BindToRenderStep("CameraBob", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not enabled then return end
    local speed = humanoid.RootPart.AssemblyLinearVelocity.Magnitude
    if speed > 1 then phase += dt * bobSpeed * math.clamp(speed / 16, 0.5, 2) end
    local y = math.sin(phase) * bobAmount * math.clamp(speed / 16, 0, 1)
    local x = math.cos(phase * 0.5) * bobAmount * 0.5 * math.clamp(speed / 16, 0, 1)
    camera.CFrame = camera.CFrame * CFrame.new(x, y, 0)
end)
```

`BindToRenderStep` with a priority just after `Camera` runs after the camera has been positioned, which
is why the offset sticks.

## Accessibility (non-negotiable)

| Effect | Minimum mitigation |
|---|---|
| Head bob | toggle, and a reduced-motion mode that disables it |
| Camera shake | intensity slider + off switch |
| FOV punch on sprint | smaller amplitude, or disabled in reduced motion |
| Tilt/roll | off by default; it is the most nauseating |
| Screen flash | no full-screen white flashes; cap luminance |

Store the preference with the player's settings and apply it **before** the first frame, so a player
who turned bob off never sees it once.

## Failure modes

- Bob applied to `Humanoid.CameraOffset` and `Camera.CFrame` → double effect.
- FOV tween fighting a sprint tween → single tween handle per property ([[R-tween-patterns]]).
- Effect active during death/spectate → camera spins on a dead body.
- Preference only read at join → changing it mid-session does nothing.

## Test cases

1. Walk → bob; stop → settles to zero (no residual offset).
2. Reduced motion on → no bob, no shake, no FOV change.
3. Death while bobbing → camera returns to normal.
4. Two effects (shake + bob) at once → no jitter, sum is bounded.

