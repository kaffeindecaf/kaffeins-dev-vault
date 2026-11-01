---
id: H-environmental-events-catalog
type: principle
title: Environmental events catalogue
status: reviewed
updated: 2026-11-01
tags: [horror, events, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
code_blocks: 1
related: "H-adaptive-director", "H-cooldowns-and-rarity", "H-tension-hierarchy"
---

# Environmental events catalogue

Authored beats the director chooses from. Each entry: what the player perceives, what it costs, what it
must not do.

| ID | Perceived as | Cost | Notes |
|---|---|---|---|
| `distant_thud` | a single heavy impact, far away | 1 | always from a direction with nothing there |
| `pipe_knock` | metal settling in the walls | 1 | most common; becomes the "normal" |
| `door_ajar` | a door that was closed is now open | 2 | must be a door the player has already passed |
| `light_dip` | one bulb dims for 0.4 s | 1 | never the bulb the player is standing under |
| `radio_static` | brief interference on a radio | 2 | ties to an object, so it feels caused |
| `footsteps_above` | someone walking on the floor above | 2 | only in a house with an upper floor |
| `shadow_pass` | a silhouette crosses a doorway | 3 | rare; requires a lit doorway |
| `object_fall` | something falls in another room | 2 | must be a real object that is now on the floor |
| `breathing` | breath near the player, no source | 3 | rare; 3 s max |
| `silence` | every bed cuts for 3–5 s | 2 | the strongest cue in the catalogue |
| `wrong_room` | a room is subtly different on return | 3 | unique per playthrough |

## Rules for authoring a beat

1. **Every sound has a plausible source in the world.** If the player can find nothing, that is fine —
   but there must have been a *place* for it to come from.
2. **No beat that implies a threat can be a lie too often.** A `shadow_pass` that never becomes
   anything is good; three in one round is noise.
3. **Beats must be interruptible.** If the threat starts, cancel any pending ambient event rather than
   layering them.
4. **Non-graphic by design.** Nothing in this catalogue needs gore; the uncertainty is the content.

## Anti-patterns

- Random sound at a random position with no spatial logic → players learn there is nothing to learn.
- A jumpscare with no prior suggestion → cheap, and it burns player trust.
- The same beat fired by two systems (director + a scripted trigger) → reads as a bug.

