---
id: S-smart-door
type: system
title: Smart door with state, locks and sound hooks
status: reviewed
updated: 2026-11-01
tags: [systems, doors, interaction]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [TweenService, CollectionService]
dependencies: []
code_blocks: 2
related: "S-keycard-locks", "S-interaction-prompt", "H-door-sound-matrix"
---

# Smart door

A door is a small state machine with a physical consequence. Get the state explicit or you will get
"door stuck open" bugs that only reproduce under latency.

## States

```text
Closed --(open request, unlocked)--> Opening --> Open --(auto-close timer)--> Closing --> Closed
Closed --(lock request)--> Locked --(unlock)--> Closed
any    --(round reset)--> Closed (locked state per config)
```

## Implementation

```lua
-- Untested: hinge door, server-owned rotation.
local TweenService = game:GetService("TweenService")
local DOOR_OPEN_CFRAME = CFrame.Angles(0, math.rad(95), 0)

local Door = {}
function Door.new(model)
    local self = setmetatable({ model = model, state = "Closed" }, { __index = Door })
    self.hinge = model:WaitForChild("Hinge")
    self.closedCFrame = self.hinge.CFrame
    return self
end

function Door:toggle(player)
    if self.state == "Locked" then return false, "locked" end
    if self.state ~= "Closed" and self.state ~= "Open" then return false, "busy" end
    local opening = self.state == "Closed"
    self.state = opening and "Opening" or "Closing"
    local goal = opening and self.closedCFrame * DOOR_OPEN_CFRAME or self.closedCFrame
    local tween = TweenService:Create(self.hinge, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { CFrame = goal })
    tween:Play()
    tween.Completed:Once(function()
        self.state = opening and "Open" or "Closed"
        self.model:SetAttribute("Open", opening)
    end)
    return true
end
return Door
```

The `busy` state is what stops double-toggles during the 0.35 s swing. Without it, two players spamming
the prompt produce a door that ends up in the wrong state.

## Sound hooks (the cheap 80% of "feels real")

| Moment | Sound |
|---|---|
| open start | latch click (short, 0.1 s) |
| swing | creak, volume scaled by speed |
| close | slam if fast, soft click if slow |
| locked attempt | handle rattle, no creak |

Play on the server (so everyone hears it consistently) or on each client near the door. Server-played
is simpler and gives a shared experience — use `Sound:Play()` on a part, not on a SoundService sound
if you want it positional.

## Failure modes

- `Hinge` named differently after a rebuild → `WaitForChild` yields forever. Fail with a timeout and
  warn.
- NPC auto-open vs player open racing → route both through `Door:toggle`, with an `actor` argument.
- Door left open when the round resets → reset must set state and CFrame, not just tween back.
- Collision: tweening a hinged part's CFrame while `CanCollide` is on can trap a player inside — set
  `CanCollide = false` during the swing.

## Test cases

1. Toggle twice within 0.1 s → ends Closed, no stuck state.
2. Locked door: prompt shows "Locked", no swing, rattle sound.
3. Round reset while Open → Closed and locked as configured.
4. Player standing in the doorway during close → not trapped (collision off during swing).
5. Two players, same door, same frame → one swing, both hear it.

