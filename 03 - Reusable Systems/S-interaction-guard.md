---
id: S-interaction-guard
type: system
title: Interaction guard: re-validate prompt use server-side (extracted)
status: reviewed
updated: 2026-11-01
tags: [systems, security, prompts, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 2
related: "S-interaction-prompt", "R-remotes-and-validation", "R-request-rate-limiting", "G-server-authority-checklist"
---

# Interaction guard

`ProximityPrompt` is a convenience, not an authority. A client can fire a prompt it is nowhere near. The
shipped pattern is a small module that answers *"is this player allowed to use a prompt for this action right
now?"* — and every server-side handler calls it **first**.

## The guard

```lua
-- Untested in this vault: read from a live place, generalised.
local Workspace = game:GetService("Workspace")
local CONFIG = { RANGE_MARGIN = 2 }   -- studs beyond native prompt range (1-3 tolerates latency)

local Guard = {}

-- 1. Is the player in a state where any interaction is legal?
function Guard.root(player)
    if not player or player.Parent ~= game:GetService("Players") then return nil end
    if player:GetAttribute("Caught") == true then return nil end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum or hum.Health <= 0 then return nil end
    if player:GetAttribute("IsHiding") == true or char:GetAttribute("IsHiding") == true then return nil end
    return root
end

-- 2. Is the player near an ENABLED prompt for this action?
function Guard.near(player, action)
    local root = Guard.root(player)
    if not root then return false end
    for _, prompt in ipairs(Prompts.forAction(action)) do
        local parent = prompt.Parent
        local pos
        if parent and parent:IsA("Attachment") then pos = parent.WorldPosition
        elseif parent and parent:IsA("BasePart") then pos = parent.Position
        elseif parent and parent:IsA("Model") then pos = parent:GetPivot().Position
        end
        if pos and prompt.Enabled
            and (root.Position - pos).Magnitude <= prompt.MaxActivationDistance + CONFIG.RANGE_MARGIN then
            return true
        end
    end
    return false
end

return Guard
```

## The two rules that matter

1. **`Guard.root` is state, `Guard.near` is geometry.** Handlers call both, in that order, and refuse otherwise.
2. **Resolve the prompt's world position by parent type.** Prompts are mounted on `BasePart`s, `Attachment`s
   (for moving rigs) and `Model`s; assuming `.Position` on a Model is a nil-index waiting for a rig.

## How to wire it

```lua
-- Untested: the call sites this guard exists for
PickupRequest.OnServerEvent:Connect(function(player, target)
    if not Round:canInteract() then return end       -- phase gate
    if not Guard.near(player, "pickup") then return end   -- geometry gate
    -- then the feature's own validation (distance, ownership, capacity)
end)
```

## Learned failure modes

- **Rate limits are still required.** A guard makes the *location* honest; it does not stop 200 calls a second
  ([[R-request-rate-limiting]]).
- **`prompt.Enabled` must be checked** — a disabled prompt still exists in the tree and still has a position.
- **Hidden players must fail the state check** (both player and character attributes). Hiding is broken the
  moment a hidden player can open a door.
- **The margin is a tolerance, not a range.** 1–3 studs covers latency; more than that is a free pass.

## Tests

1. Fire the action from 2× range → denied.
2. Fire while caught → denied.
3. Fire while hidden → denied.
4. Fire on a disabled prompt standing next to it → denied.
5. Fire from the legitimate position → allowed, action happens once.

