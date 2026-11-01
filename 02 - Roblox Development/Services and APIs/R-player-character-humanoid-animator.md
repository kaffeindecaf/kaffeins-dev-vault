---
id: R-player-character-humanoid-animator
type: reference
title: Player, Character, Humanoid, Animator — and the ordering traps
status: reviewed
updated: 2026-11-01
tags: [character, humanoid, animation]
source_urls: [ "https://create.roblox.com/docs/reference/engine/classes/Humanoid", "https://create.roblox.com/docs/reference/engine/classes/Animator" ]
confidence: medium
verification: reference_only
related: [ "R-animation-loading-and-priorities", "R-script-types-and-placement" ]
---

# The character stack

`Player` → `Character` (Model) → `Humanoid` + `HumanoidRootPart` + body parts → `Animator` (inside
`Humanoid`). The character is **destroyed and rebuilt on every respawn**, which is why character
scripts are a different programming environment from player scripts.

## The lifecycle that causes bugs

```text
PlayerAdded → CharacterAdded → HumanoidRootPart exists → Animator exists → Humanoid.Died → CharacterRemoving
```

Two ordering facts people get wrong:

1. `CharacterAdded` can fire **before** the `Animator` exists. Wait for it:
   `character:WaitForChild("Humanoid"):WaitForChild("Animator")`.
2. `Humanoid.Died` fires before the character is removed. Anything you connect for cleanup must
   tolerate a dying humanoid.

```lua
-- Untested
local Players = game:GetService("Players")
local function onCharacter(player, character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    local animator = humanoid:WaitForChild("Animator", 5)
    if not animator then return end

    humanoid.Died:Once(function()
        -- release occupancy, stop loops, clear per-life state
    end)
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) onCharacter(p, c) end)
end)
for _, p in Players:GetPlayers() do
    if p.Character then onCharacter(p, p.Character) end
end
```

That last `for` loop matters: players who joined before your script ran already have characters.

## What the server can and cannot trust

| Value | Authority |
|---|---|
| `Humanoid.Health` | server (client can request; server decides) |
| `Humanoid.WalkSpeed` | set on the server; client sees the replica but can lie locally |
| `Humanoid:MoveTo()` | server-initiated movement for NPCs and forced walks |
| `Humanoid.MoveDirection` | client-simulated; useful input signal, not proof of position |
| `Humanoid.Running` / `Running` event | convenience event; measure velocity if you need ground truth |

`Humanoid.Running` is known to be unreliable in some builds — measure
`HumanoidRootPart.AssemblyLinearVelocity` yourself if footsteps or animation speed depend on
movement. (This vault's companion project hit exactly that.)

## Rig type matters

R15 joints are `AnimationConstraint`/`BallSocketConstraint` with no `C0`, so old R6 tricks (offsetting
a Motor6D `C0` to lean the torso) do nothing. Check what your place actually spawns before writing
rig-aware code: Game Settings → Avatar → Rig Type, and `Humanoid.RigType` at runtime.

## Crouch, seats and exotic states

`Enum.HumanoidStateType.Seated` is the state you want; reading a non-existent enum value throws.
Disabling states (e.g. `Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)`) is the
supported way to prevent an action — not cancelling `Jumping` in a loop.

Next: [[R-animation-loading-and-priorities]] · [[S-crouch-and-crawl]] · [[S-sprint-stamina]].
