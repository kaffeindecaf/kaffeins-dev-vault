---
id: S-plot-resource-deposit
type: system
title: Owner-checked bounded resource deposit
status: draft
updated: 2026-11-02
tags: [systems, plots, inventory, interaction]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: [ProximityPromptService, Workspace]
code_blocks: 0
related: [ "R-pop-popcorn-pattern-audit", "S-interaction-guard", "S-inventory-data-model" ]
---

# Owner-checked bounded resource deposit

Move a carried resource into the player's own machine buffer, preserving the remainder if capacity is insufficient. Use this for a spatial collect-and-process loop; a direct inventory action may suit a less spatial game. `PlotService:91–132` in Pop Popcorn creates a prompt and checks owner, empty backpack and hopper capacity before moving `min(carried, room)` and updating feedback; actual prompt inputs were not tested. See [[R-pop-popcorn-pattern-audit]].

Server responsibilities: verify active plot ownership, valid character and distance, prompt state, source and destination values, capacity, rate and concurrent use. Move both values as one non-yielding authoritative mutation; if durable state is needed, use a reviewed atomic profile transaction. `bounded-transfer.luau` is an untested pure arithmetic helper, not authorization or persistence. Keep the prompt's keyboard, gamepad and touch affordance accessible, show how much moved and why a buffer is full, and test spoofed requests, race conditions, overflow, full/empty/partial cases, reconnect and plot reassignment. The source's 12-stud range is one observed choice, not a universal recommendation.
