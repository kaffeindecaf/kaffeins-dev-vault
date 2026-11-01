---
id: S-notification-system
type: system
title: Notification / toast system with priority and dedupe
status: reviewed
updated: 2026-11-01
tags: [systems, ui, feedback]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [None]
dependencies: []
code_blocks: 2
related: "H-horror-hud", "S-interaction-prompt", "R-ui-transitions-tween"
---

# Notifications

One server-pushed event, one client queue. The queue is what stops the "five toasts stacked on top of
each other" failure and the "bought an item twice, got four messages" bug.

## Contract

```lua
-- Untested: server side
-- (title, text, duration, kind, priority, dedupeKey)
NotificationEvent:FireClient(player, "Locked", "Needs a red keycard", 2.5, "warn", 2, "door_locked")
```

## Client queue

```lua
-- Untested
local MAX_VISIBLE = 3
local queue, visible, nowShowing = {}, {}, {}

NotificationEvent.OnClientEvent:Connect(function(player, title, text, duration, kind, priority, key)
    if key and nowShowing[key] and os.clock() - nowShowing[key] < 3 then return end   -- dedupe window
    if key then nowShowing[key] = os.clock() end
    table.insert(queue, { title = title, text = text, duration = duration or 2, kind = kind or "info", priority = priority or 1 })
    table.sort(queue, function(a, b) return a.priority > b.priority end)             -- higher first
    pump()
end)
```

## Behaviour rules

- **Priority sorts the queue, not the screen.** A high-priority message jumps ahead of waiting ones;
  it does not interrupt a message already on screen (that reads as a glitch).
- **Dedupe with a key and a short window.** "Door is locked" spammed by a player holding E should
  appear once per 3 seconds.
- **One card type.** Different kinds change colour/icon, not layout — consistent position is what
  makes it readable ([H-horror-hud](H-horror-hud.md) for restraint).
- **Never above input.** Reserve a top-centre region and keep interactive UI out of it.

## Failure modes

- Server fires per-player in a loop over all players for a global event → one message per player is
  correct; firing once per *event* to everyone is a different function.
- Queue unbounded during a burst → cap it (drop lowest priority).
- Duration 0 → a toast that never disappears if the removal is a tween that never completes.

## Test cases

1. Two identical events with a key inside 3 s → one toast.
2. Priority 3 event while priority 1 visible → shown next, not interrupting.
3. 20 events in one frame → at most MAX_VISIBLE on screen, queue drains in order.
4. Round end clears the queue.

