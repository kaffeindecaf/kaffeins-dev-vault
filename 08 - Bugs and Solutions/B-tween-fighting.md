---
id: B-tween-fighting
type: bug
title: Camera FOV jitters between two systems
status: reviewed
updated: 2026-11-01
tags: [ui, camera, tween]
source_urls: []
confidence: medium
verification: design_only
severity: medium
hypothetical: true
client_server: both
code_blocks: 1
related: "R-tween-patterns", "S-camera-and-headbob", "R-runservice-update-loops"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# FOV jitter

## Observed
While sprinting, FOV oscillates between 70 and 78 several times per second.

## Diagnosis
Two writers on `FieldOfView`: a sprint tween writes 78, a camera script writes `base + sin(t)` every
`RenderStepped`. Each overwrites the other.

## Cause
No single owner for the property.

## Fix
One writer reads a target attribute and smooths toward it:
```lua
RunService:BindToRenderStep("FovSmooth", Enum.RenderPriority.Camera.Value - 1, function(dt)
    local target = camera:GetAttribute("FovTarget") or 70
    camera.FieldOfView += (target - camera.FieldOfView) * math.min(1, dt * 8)
end)
```
The sprint system only sets `FovTarget`.

## Verification
Sprint → stop → dash: monotonic movement to the target, no overshoot, settles.

## Regression prevention
Document the single writer per property in the feature note; grep `FieldOfView =`, `WalkSpeed =`, `Health =`
when adding a system ([[R-tween-patterns]]).

