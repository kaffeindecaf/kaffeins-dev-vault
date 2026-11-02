---
id: S-tree-query-hitbox
type: system
title: Configured query hitbox for a grown world object
status: draft
updated: 2026-11-02
tags: [interaction, models, hitbox, roblox]
source_urls: []
confidence: medium
verification: design_only
client_server: server
roblox_services: [Workspace]
code_blocks: 0
related: [ "R-grow-a-tree-pattern-audit", "S-world-object-validation", "S-interaction-guard" ]
---

# Configured query hitbox for a grown world object

An ornate or variable tree can have a simple invisible query target independent of its visual geometry. Choose this for consistent targeting across model variations; use the visible geometry directly when it already gives adequate precision. Static source: `ServerScriptService.TreeHitboxService` checks FullyGrown and planted-tree markers, derives a seed-specific configuration through `Modules.GameConfig.GetTreeHitbox`, clamps scale and dimensions, uses stored PlantX/Y/Z or a bounding-box fallback, and creates/reuses a transparent anchored part with CanQuery true and CanCollide/CanTouch false. It removes duplicate named hitboxes and watches FullyGrown. Source paths and caveats are in [[R-grow-a-tree-pattern-audit]].

This geometry is a targeting aid, not authorization: separately validate target identity, ownership, distance, tool state, cooldown and action on the server. Bounding-box fallback can misplace asymmetric or rotated models; test the pivot/ground convention and scale. Watcher lifecycle, streaming, many-object overhead and competing hitbox names need profiling and testing. Avoid copying its implementation uncritically; server scripts in the source mutate instances at runtime, but none were run during this audit.
