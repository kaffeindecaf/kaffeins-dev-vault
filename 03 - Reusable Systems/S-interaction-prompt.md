---
id: S-interaction-prompt
type: system
title: Interaction prompt (keyboard, touch, gamepad)
status: reviewed
updated: 2026-11-01
tags: [systems, ui, input]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [ProximityPrompt, UserInputService]
dependencies: []
code_blocks: 1
related: "R-remotes-and-validation", "S-smart-door", "S-pickup-server-authoritative"
---

# Interaction prompt

One reusable "look at it, act on it" affordance for doors, loot, levers, panels. Server decides.

## Why ProximityPrompt and not a custom raycast UI

`ProximityPrompt` already handles keyboard, touch, gamepad, hold duration, range, line-of-sight and
accessibility (it exposes prompts to players using switch control). A hand-rolled version re-solves
all of that badly. Use it, and style it with `ProximityPromptService` if you need a custom look.

## Server-side binding

```lua
-- Untested: bind every tagged prompt once, idempotently.
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local TAG = "Interactable"

local function onTriggered(prompt, player)
    if not prompt:GetAttribute("Interactable") then return end
    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return end
    -- range is enforced again here: prompts can be triggered by a lagging client
    if (playerRoot.Position - prompt.Parent.Position).Magnitude > prompt.MaxActivationDistance + 2 then
        return
    end
    -- per-feature handling reads the prompt's attributes, not its name
    local action = prompt:GetAttribute("Action") or "Interact"
    if action == "Open" then
        prompt.Parent:SetAttribute("Open", not prompt.Parent:GetAttribute("Open"))
    end
end

ProximityPromptService.PromptTriggered:Connect(onTriggered)
```

`PromptTriggered` is the single server-side choke point — bind once, and do **not** also connect
`prompt.Triggered` per prompt (you get two handlers and double actions).

## Authoring contract

| Attribute on prompt | Meaning |
|---|---|
| `Action` | what the server should do (`Open`, `Take`, `Cut`) |
| `Interactable` | `true` marks it as owned by this system |
| `HoldDuration` | leave 0 for taps, 0.4–1.0 for "commit" actions |

Prompt text should name the outcome ("Open door"), not the input ("Press E") — Roblox renders the
key/touch affordance itself, and a hardcoded "E" is wrong on phone.

## Failure modes

- Two prompts overlapping at a range: keep `MaxActivationDistance` smaller than the spacing between
  interactions.
- Holding a prompt while walking away: re-check distance server-side (above).
- Prompt inside a `Model` that gets destroyed: connections die with the instance; destroy the model,
  not just the prompt.

## Test cases

1. Trigger by keyboard, touch tap and gamepad — same result.
2. Trigger from 2× range by a scripted client → rejected.
3. Two players trigger the same prompt in the same frame → one effect, not two.
4. Trigger while dead/hidden → rejected.
5. Prompt on a part that is later destroyed → no error in Output.

