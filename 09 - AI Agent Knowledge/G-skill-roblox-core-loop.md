---
id: G-skill-roblox-core-loop
type: guide
title: Skill bridge — roblox-core-loop
status: draft
updated: 2026-11-01
tags: [agents, skills, persistence, gameplay-loop]
source_urls: []
confidence: medium
verification: reference_only
related: [ "G-skills-inventory", "S-datastore-player-profile", "S-save-load-migration", "R-datastore-safety", "PR-datastore-review" ]
---

# Skill bridge — `roblox-core-loop`

The `roblox-core-loop` harness skill covers changes to round flow, economy, persistence and related
server systems. The skill itself lives in the agent runtime; this note is the Obsidian graph entry
point and does not copy or replace the installed skill.

## Read with this vault material

- Player profiles: [[S-datastore-player-profile]]
- Schema migration: [[S-save-load-migration]]
- DataStore safety: [[R-datastore-safety]]
- Review checklist: [[PR-datastore-review]]
- Skill catalog: [[G-skills-inventory]]

Before using the skill, check this vault's current source links and evidence status. Any code adapted
from the note remains untested until it is run in the target place and evidence is recorded.
