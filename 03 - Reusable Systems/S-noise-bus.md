---
id: S-noise-bus
type: system
title: Noise bus: velocity and events into one perceivable signal (extracted from a shipping game)
status: reviewed
updated: 2026-11-01
tags: [systems, npc, perception, audio, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 1
related: "R-npc-perception-model", "R-npc-think-budget", "S-hiding-spots", "H-ambience-layering"
---

# Noise bus

AI hearing needs a single answer to "how loud is this player right now, and from where". This module computes
it from **measured velocity** plus **discrete events** (a door, breaking glass), publishes it as an attribute,
and pushes an estimate to the perception system.

## Two inputs, one output

| Input | Source | Used for |
|---|---|---|
| Continuous | `RootPart.AssemblyLinearVelocity` (horizontal) | a radius that rises with speed, falls when crouched |
| Discrete | events with a radius (`Emit(player, pos, radius)`) | doors, glass, thrown objects, gunshots |
| Output | `player:SetAttribute("NoiseLevel", 0..1)` + a hearing event | HUD meter, NPC acquisition |

```lua
-- Untested in this vault: read from a live place, generalised (the AI and audio specifics are yours).
local CONFIG = {
    SAMPLE_INTERVAL = 0.2,   -- seconds (0.1-0.5)
    MAX_RADIUS      = 60,    -- studs represented by a full meter
    DOOR_RADIUS     = 30,    -- studs a player-operated door is heard from
    GLASS_RADIUS    = 60,
    EVENT_HOLD      = 1.5,   -- seconds a discrete event stays visible on the meter
}

local Noise = {}
local peaks = {}   -- [player] = { radius = n, expires = clock }

function Noise.Emit(player, position, radius)
    if typeof(position) ~= "Vector3" or type(radius) ~= "number" then return end
    if player and player:IsA("Player") then
        peaks[player] = { radius = radius, expires = os.clock() + CONFIG.EVENT_HOLD }
    end
    -- hand the cue to the perception system once, with a positional error so it is not exact
    Perception.Publish({ kind = "noise", position = position, radius = radius, player = player })
end

Players.PlayerRemoving:Connect(function(p) peaks[p] = nil end)   -- never leak per-player state

task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local radius = 0
            if root and hum and hum.Health > 0 and not player:GetAttribute("Caught") then
                local v = root.AssemblyLinearVelocity
                radius = NoiseRadius(Vector3.new(v.X, 0, v.Z).Magnitude,
                                     char:GetAttribute("Crouched") == true)
                local mult = tonumber(player:GetAttribute("NoiseMult"))
                if mult and mult > 0 and mult < 1 then radius *= mult end
            end
            local peak = peaks[player]
            if peak and peak.expires > os.clock() then radius = math.max(radius, peak.radius)
            else peaks[player] = nil end
            player:SetAttribute("NoiseLevel", math.clamp(radius / CONFIG.MAX_RADIUS, 0, 1))
        end
        task.wait(CONFIG.SAMPLE_INTERVAL)
    end
end)
```

## Design decisions worth copying

- **Measured velocity, not `Humanoid.Running`.** The event is unreliable in some builds; velocity is ground
  truth and also gives you the crouch multiplier for free.
- **Horizontal magnitude only.** Falling should not make you audible across the map.
- **A temporary peak that beats the continuous value, then expires.** This is what lets a door slam be louder
  than the walk that preceded it, without a second state machine.
- **One attribute (`NoiseLevel`) for the HUD.** The client renders a meter from a replicated 0–1 number and
  needs no custom remote.
- **A positional error on the estimate.** Handing AI an exact position turns hearing into a wallhack.

## Learned failure modes

- **The shared alert bus can confound tests.** A stale cue (10 s decay) makes an NPC react "instantly" to a
  stimulus you did not cause. Export the sensing maths as a **pure function** and unit-test the curve; then
  test the bus separately.
- **Per-player tables must be cleaned on `PlayerRemoving`**, or a busy server grows forever.
- **Don't tick this per frame.** 0.2 s is imperceptible to players and 5× cheaper.

## Tests

1. Standing still → `NoiseLevel` ≈ 0.
2. Walking vs sprinting → monotonic increase.
3. Crouched → lower than walking at the same speed.
4. Fire a door event → level jumps for `EVENT_HOLD`, then returns to the continuous value.
5. Player leaves → no entry in the peaks table (probe the module's size).

