---
id: R-prompt-affordances
type: reference
title: Interaction prompts and contextual affordances
status: reviewed
updated: 2026-11-01
tags: [ui, interaction, feedback]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "S-interaction-prompt", "R-horror-hud", "R-controller-focus"
---

# Prompts

A prompt answers three questions in under a second: *what can I do, with what input, to what.*

| State | Visual | Text |
|---|---|---|
| Available | faint outline on the object + a small centred prompt | "Open" |
| Focused | brighter outline, prompt emphasised | "Open door" |
| Unavailable | prompt hidden, object has a "locked" icon | nothing |
| In progress (hold) | radial fill or a bar | "Unlocking…" |
| Blocked | prompt shows, plus reason | "Needs a red card" |

## Implement with ProximityPrompt

`ProximityPrompt` already renders the input affordance for keyboard/touch/gamepad. Style it with an
`ObjectValue`/`ProximityPrompt.Enabled` and a `ProximityPrompt`-aware custom theme if needed; do not build
a second input system.

## The failure that matters

> The prompt says "Press E" on a phone.

Never put the input in the text. The platform adds the icon. Text should describe the action:
"Open", "Take", "Cut wire".

## Feedback on activation

1. 60–120 ms visual response (a flash on the object, or a slight scale) — before any network round trip.
2. Sound: a confirmation click.
3. Then the world changes.

Skipping step 1 makes an interaction feel broken under any latency, even though the server responded
correctly.

## Accessibility

- Prompt text ≥ 20 px, contrast ≥ 4.5:1 over the world (use a scrim behind it).
- Prompts must be reachable by gamepad focus, not only by proximity.
- Held prompts need a visible progress indicator, not just a fill (colour-blind users).

