---
id: R-notifications-toasts
type: reference
title: Notifications, objective updates and failure alerts
status: reviewed
updated: 2026-11-01
tags: [ui, notifications, feedback]
source_urls: []
confidence: medium
verification: design_only
client_server: client
code_blocks: 1
related: "S-notification-system", "R-horror-hud", "R-ui-transitions-tween"
---

# Notifications

A toast is a sentence with a shape. Its job is to confirm an action or explain a failure — never to
narrate the game.

## Kinds and treatment

| Kind | Timing | Visual | Sound |
|---|---|---|---|
| Success | 2 s | accent border | short confirm |
| Info | 2.5 s | neutral | soft |
| Warning | 3 s | amber | double tap |
| Error / blocked | 3 s | red + icon | low buzz |
| Objective | 4 s | wide card | distinct chime |
| Story | until dismissed | full card | none |

## Placement

Top-centre, below the safe inset, max 3 stacked. Never bottom (touch controls), never centre (blocks the
crosshair).

## Copy rules

- Verb-first, present tense: "Needs a red keycard", not "You cannot open this door right now".
- One sentence. If it needs two, it needs a panel.
- Never blame the player: "Too far away" not "You are too far".
- Numbers formatted by the shared formatter ([[R-text-scaling-overflow]]).

## Dedupe and priority

See [[S-notification-system]] for the queue, dedupe key and priority implementation. The UI rule: a
higher priority message waits for the current one to finish rather than cutting it off.

## What not to notify

- Every pickup ("+1 watch") — a HUD counter handles it.
- Anything the player just did deliberately and can see the result of.
- Round start on every round, if the round is already obvious.

