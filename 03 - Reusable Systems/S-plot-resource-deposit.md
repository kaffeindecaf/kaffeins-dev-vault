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
related: [ "S-interaction-guard", "S-inventory-data-model" ]
---

# Owner-checked bounded resource deposit

Move a carried resource into the player's machine buffer, preserving the remainder if capacity is
insufficient. Use this for a spatial collect-and-process loop; a direct inventory action may suit a
less spatial game. A prompt can expose the action, but validate ownership, inventory and capacity on
the server immediately before the transfer.

Server responsibilities: verify active plot ownership, valid character and distance, prompt state,
source and destination values, capacity, rate and concurrent use. Move both values as one non-yielding
authoritative mutation; if durable state is needed, use a reviewed atomic profile transaction.
`bounded-transfer.luau` is an untested pure arithmetic helper, not authorization or persistence.
Keep keyboard, gamepad and touch affordances accessible, explain partial/full transfers, and test
spoofed requests, races, overflow, full/empty/partial cases, reconnect and plot reassignment. Choose
an interaction range based on the game's geometry and verify it at runtime.
