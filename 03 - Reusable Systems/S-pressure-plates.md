---
id: S-pressure-plates
type: system
title: Pressure plates, switches and timed sequences
status: reviewed
updated: 2026-11-01
tags: [systems, puzzles, physics]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [CollectionService]
dependencies: []
code_blocks: 2
related: "S-puzzle-framework", "S-interaction-prompt", "R-runservice-update-loops"
---

# Plates and switches

Two input devices with different physics models: a plate detects **occupancy**, a switch detects
**use**. A timed sequence needs both plus a clock the reset can trust.

## Plate

```lua
-- Untested
local plate = script.Parent
local trigger = plate:FindFirstChild("Trigger")   -- CanCollide=false, CanTouch=true
trigger.Touched:Connect(function(hit)
    local hum = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    plate:SetAttribute("Pressed", true)
end)
trigger.TouchEnded:Connect(function(hit)
    -- only release if nothing else is on the plate
    local parts = workspace:GetPartBoundsInBox(trigger.CFrame, trigger.Size * Vector3.new(0.95, 2, 0.95))
    for _, p in parts do
        local hum = p.Parent and p.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return end
    end
    plate:SetAttribute("Pressed", false)
end)
```

`Touched` alone leaves the plate pressed when a player hops off; the `GetPartBoundsInBox` re-check is
what makes release correct. Alternatively poll occupancy on a 0.2 s tick for all plates at once — one
loop, no per-plate connection.

## Timed sequence

```lua
-- Untested: "hit these three within 5 seconds"
local Sequence = { window = 5, steps = { "a", "b", "c" } }
Sequence.index, Sequence.startedAt = 0, 0

function Sequence.hit(id, now)
    if id ~= Sequence.steps[Sequence.index + 1] then
        Sequence.index, Sequence.startedAt = 0, 0       -- wrong step resets
        return false
    end
    if Sequence.index == 0 then Sequence.startedAt = now end
    if now - Sequence.startedAt > Sequence.window then
        Sequence.index, Sequence.startedAt = 0, 0
        return false
    end
    Sequence.index += 1
    return Sequence.index == #Sequence.steps
end
```

Use `os.clock()` (monotonic-ish) on the server, never the client's timestamps.

## Failure modes

- `Touched` firing on accessories/debris → filter by `Humanoid`.
- Two players on one plate: release checks occupancy, not the last leaver.
- Timed window measured on the client → exploitable and wrong under latency.
- Reset does not clear `index` → next round starts mid-sequence.

## Test cases

1. Step on → pressed; step off → released.
2. Two players, one leaves → still pressed.
3. Wrong order → reset, no progress.
4. Correct order inside window → solved; outside → reset.
5. Round reset → index 0, plate released.

