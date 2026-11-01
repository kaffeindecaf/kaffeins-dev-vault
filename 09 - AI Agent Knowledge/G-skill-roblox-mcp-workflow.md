---
id: G-skill-roblox-mcp-workflow
type: guide
title: Skill bridge — roblox-mcp-workflow
status: draft
updated: 2026-11-01
tags: [agents, skills, studio, verification]
source_urls: []
confidence: medium
verification: reference_only
related: [ "G-skills-inventory", "G-asset-verification-workflow", "S-datastore-player-profile" ]
---

# Skill bridge — `roblox-mcp-workflow`

The `roblox-mcp-workflow` harness skill describes safe Roblox Studio inspection and edit batches.
The runtime skill remains outside this vault; this note links its workflow to relevant evidence and
reference notes without claiming a Studio run happened.

## Use with these notes

- Asset inspection and permission evidence: [[G-asset-verification-workflow]]
- DataStore test design: [[S-datastore-player-profile]]
- Agent skill inventory: [[G-skills-inventory]]

For a Studio task, record the exact place and script paths inspected, whether a playtest occurred,
what output was observed, and the evidence path. Do not change a note to `tested_studio` based on
code reading or MCP inventory alone.
