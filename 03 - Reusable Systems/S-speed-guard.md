---
id: S-speed-guard
type: system
title: Server speed guard with an excess-stud budget (extracted from a shipping game)
status: reviewed
updated: 2026-11-01
tags: [systems, security, anti-cheat, extracted]
source_urls: []
confidence: high
verification: design_only
source_place: "a shipped Roblox experience (read in Edit mode, 2026-11-01)"
provenance: "read from the live place via the Studio MCP; names/values generalised; not re-executed in this form"
client_server: server
code_blocks: 2
related: "R-server-authority-replication", "S-sprint-stamina", "G-server-authority-checklist", "B-remote-exploit-hypothetical"
---

# Speed guard

The client owns its own movement, so the server cannot read a trustworthy `WalkSpeed`. It **can** measure real
horizontal displacement. This guard turns that into a fair ceiling, and a budget so a legitimate dash is
forgiven while a sustained hack is not.

## Why not "if speed > X then kick"

| Naive clamp | Problem |
|---|---|
| compare against a constant | punishes players who bought a speed upgrade, or carried a heavy item that slows them |
| act on one sample | lag spikes and slopes produce single-sample spikes |
| no exemption list | teleports, seats, spawns and scripted drags all look like hacks |

The shipped version derives the ceiling from **server-set attributes**, accumulates excess studs into a
**budget** that decays, and ignores a documented list of legitimate states.

## The pattern

```lua
-- Untested in this vault: read from a live place, generalised. The place ran it in play and tested a
-- scripted 60 st/s hack (rubber-banded) against a 20 st/s control (not).
local Players = game:GetService("Players")

local CFG = {
    SampleInterval   = 0.25,   -- seconds (0.2-0.5)
    BaseSpeed        = 32,     -- the fastest legitimate run
    CarrySlowPerItem = 1.5,    -- same formula the client's movement code uses
    MinSpeed         = 16,
    Tolerance        = 1.15,   -- multiplier for lag/slope/tween slop
    Flat             = 3,      -- + studs/s
    Budget           = 22,     -- excess studs forgiven before action
    Decay            = 6,      -- studs/s of excess forgiven while under the ceiling
    TeleportJump     = 120,    -- st/s above which a sample is a server teleport, not a hack
    GraceAfterSpawn  = 3,      -- seconds ignored after (re)spawn
}

local state = {}   -- [player] = { pos, excess, strikes, lastGood, spawnT }

local function ceilingFor(char)
    local carried = char:GetAttribute("CarriedCount") or 0
    local sprint = math.max(CFG.MinSpeed, CFG.BaseSpeed - CFG.CarrySlowPerItem * carried)
    local player = Players:GetPlayerFromCharacter(char)
    local mult = player and tonumber(player:GetAttribute("SpeedMult")) or 1
    if not mult or mult < 1 then mult = 1 end       -- a paid upgrade legitimately raises the ceiling
    return sprint * mult * CFG.Tolerance + CFG.Flat
end

local function step(dt)
    for player, s in pairs(state) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (root and hum) or hum.Health <= 0 then s.pos = nil; continue end

        local pos = root.Position
        local exempt = player:GetAttribute("Caught") == true
            or hum.Sit or hum.PlatformStand
            or (os.clock() - s.spawnT) < CFG.GraceAfterSpawn
        if not s.pos or exempt then
            s.pos, s.lastGood, s.excess = pos, root.CFrame, 0
            continue
        end

        local d = Vector3.new(pos.X - s.pos.X, 0, pos.Z - s.pos.Z).Magnitude   -- horizontal only
        s.pos = pos
        local speed = d / dt

        if speed > CFG.TeleportJump then            -- server teleport: re-baseline, do not punish
            s.lastGood, s.excess = root.CFrame, 0
            continue
        end

        local ceiling = ceilingFor(char)
        if speed > ceiling then
            s.excess += (speed - ceiling) * dt
        else
            s.excess = math.max(0, s.excess - CFG.Decay * dt)
            if s.excess == 0 then s.lastGood = root.CFrame end
        end

        if s.excess > CFG.Budget then
            s.strikes += 1
            warn(("[SpeedGuard] %s %.1f st/s (ceiling %.1f) rubber-banded (strike %d)")
                :format(player.Name, speed, ceiling, s.strikes))
            if s.lastGood then root.CFrame = s.lastGood end
            root.AssemblyLinearVelocity = Vector3.zero
            s.pos, s.excess = root.Position, 0
            player:SetAttribute("SpeedStrikes", s.strikes)
        end
    end
end
```

## Why the budget beats a threshold

| Behaviour | Excess accumulated | Result |
|---|---|---|
| One 0.5 s dash at 45 st/s | ~6 studs | forgiven (budget 22) |
| Lag spike, one 0.25 s sample at 80 | ~10 | forgiven, then decays |
| Sustained 60 st/s for 2 s | ~50 | rubber-banded, strike 1 |

`lastGood` is only updated when the budget returns to zero — that is what makes the rubber-band snap back to
the last position you are *sure* was legal rather than to the previous frame.

## What to change per game

- The ceiling formula must match your **client** movement maths exactly, or you punish your own players.
- Every player-facing speed modifier must be a **server-set attribute** the guard can read (`SpeedMult`,
  `CarriedCount`). A client-side speed write is invisible here, which is the point.
- Add your own exemptions — but each one is a hole; keep the list short and comment why.

## Learned failure modes

- **Server-authorised teleports read as hacks.** Round resets, pad hops and scripted drags all produce a huge
  single sample; `TeleportJump` + a short `ServerTravelGrace` after a known teleport are the fix.
- **`hum.Sit` vs `Seated`**: use `Sit` on `Humanoid` and guard member access, enum names vary by build.
- **Strike counters are for the owner, not for kicks.** A player on a bad connection will accumulate strikes;
  auto-kicking from this data punishes the wrong people.

## Test it

Drive the character from the **server** datamodel (a `Heartbeat` loop adding `speed*dt` to `root.CFrame`) at a
legal speed then a hack speed, and read the `SpeedStrikes` attribute. Client-side injection cannot move a
player character reliably, so a client-driven test proves nothing.

