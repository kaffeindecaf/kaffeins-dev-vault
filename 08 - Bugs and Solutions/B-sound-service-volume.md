---
id: B-sound-service-volume
type: bug
title: Ambience keeps playing after the round ends
status: reviewed
updated: 2026-11-01
tags: [audio, state, cleanup]
source_urls: []
confidence: medium
verification: design_only
severity: medium
hypothetical: true
client_server: both
code_blocks: 1
related: "R-sound-service-3d", "R-janitor-cleanup", "H-ambience-layering"
---

> ⚠️ **Hypothetical case, not a real incident.** Written from general Roblox behaviour to teach the
> diagnostic path. No log below came from a real session. Do not cite it as evidence.

# Ambience survives the round

## Observed
Basement ambience continues under the intermission music.

## Diagnosis

| Check | Finding |
|---|---|
| `Sound.Playing` after round end | true |
| Who started it | a `Touched` handler calling `Play()` |
| Anything stopping it | none — round end only stops music |
| Instance count | +1 `Sound` per round |

## Cause
Ambience state is owned by room triggers, not by the round; nobody is responsible for stopping it.

## Fix
One ambience controller per game state; every `Play()` has a paired stop tied to a lifecycle (round end, zone
exit, player leave).

## Verification
Round end with ambience active: loop stops within 0.5 s, intermission bed audible alone, instance count stable
over 3 rounds.

## Regression prevention
"A started sound needs an owner that can stop it" + an `InstanceCount` check across rounds
([[R-janitor-cleanup]]).

