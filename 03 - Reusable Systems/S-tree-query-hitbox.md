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
related: [ "S-world-object-validation", "S-interaction-guard" ]
---

# Configured query hitbox for a grown world object

An ornate or variable tree can have a simple invisible query target independent of its visual
geometry. Choose this for consistent targeting across model variations; use visible geometry when it
already gives adequate precision. Configure the target from validated model state, clamp its size,
anchor it, enable queries and disable collision/touch. Use a documented pivot/ground convention and
remove duplicates when rebuilding a model.

This geometry is a targeting aid, not authorization: separately validate target identity, ownership,
distance, tool state, cooldown and action on the server. Bounding-box fallback can misplace asymmetric
or rotated models; test pivot convention and scale. Watcher lifecycle, streaming, many-object overhead
and competing hitbox names need profiling and testing.
