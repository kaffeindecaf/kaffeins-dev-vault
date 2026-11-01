---
id: R-animation-loading-and-priorities
type: reference
title: Animation, Animator — loading, priorities, blending and ownership
status: reviewed
updated: 2026-11-01
tags: [animation, character, rig]
source_urls: [ "https://create.roblox.com/docs/animation/using", "https://create.roblox.com/docs/reference/engine/classes/Animator" ]
confidence: medium
verification: reference_only
related: [ "R-player-character-humanoid-animator", "G-animation-owner-checklist" ]
---

# Animations

An `Animation` instance holds an `AnimationId`; an `Animator` (inside the `Humanoid`) loads and plays
`AnimationTrack`s. The default character animations live in the `Animate` script inside
`StarterCharacterScripts`.

```lua
-- Untested
local animator = humanoid:FindFirstChildOfClass("Animator")
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://507770239"      -- R6 walk, ID must belong to a shared animation
local track = animator:LoadAnimation(anim)
track.Priority = Enum.AnimationPriority.Movement
track.Looped = true
track:Play(0.2)                                   -- fade in
```

## Priorities (what wins when two play)

| Priority | Intent |
|---|---|
| `Idle` | lowest; the fallback pose |
| `Movement` | walk/run loops |
| `Action` | one-shots: jump, hit, interact |
| `Action2..Action4` | layered or competing one-shots (crouch overrides walk) |
| `Core` | highest; reserved for the default `Animate` script's own core poses |

A higher-priority track wins on the bones it animates. Two tracks that animate the same bones at the
same priority blend by weight, which is usually not what you want — differentiate priorities instead.

## Stop the stock animations before you own them

```lua
-- Untested: take over movement animation on a custom rig
for _, track in animator:GetPlayingAnimationTracks() do
    if track.Animation and track.Animation.Name ~= "myIdle" then track:Stop(0.1) end
end
```

For player characters the supported approach is to replace `Animate` (or disable it and drive
movement tracks yourself) rather than fighting it every frame.

## Ownership is the failure you will actually hit

Roblox shares animations **per experience**. An ID that works in the place that uploaded it can load
**nothing** in yours. Symptom: no error, no pose, `track.Length == 0`.

Checklist: [[G-animation-owner-checklist]]. Signs: the animation plays for the uploader only, or the
Output shows an access warning, or `track.Length` is 0 after `Loaded`.

## Rig compatibility

- R15 needs R15-authored animations; R6 needs R6. Playing an R15 clip on an R6 rig moves nothing.
- Custom rigs need matching joint names (`Motor6D`s) for the clip's tracks to bind.
- See [[R-player-character-humanoid-animator]] for the `AnimationConstraint` difference on R15.

## Cost

Each playing track is cheap; each *loaded* unique animation costs memory. Reuse `Animation` instances
(one per clip) rather than creating one per NPC.
