---
id: H-room-tone-palettes
type: reference
title: Room tone palettes: hum, electrical, weather, radio
status: reviewed
updated: 2026-11-01
tags: [audio, ambience, design]
source_urls: []
confidence: medium
verification: design_only
client_server: both
roblox_services: []
code_blocks: 1
related: "H-ambience-layering", "H-sound-occlusion-notes", "H-tension-hierarchy"
---

# Room tone palettes

Room tone is the quiet bed that makes a space feel occupied. It is almost inaudible alone and its absence
is deafening when cut.

| Palette | Content | Reads as |
|---|---|---|
| Basement | low rumble, water drip, furnace hum | below the house, cold |
| Kitchen | fridge compressor, clock tick, pipe knock | ordinary, recently used |
| Bedroom | mattress creak, faint traffic, clock | private, wrong to be in |
| Attic | wind through eaves, timber settle, insulation hiss | above, exposed |
| Greenhouse | glass tick, water, insects, distant thunder | outside, but enclosed |
| Electrical room | 50/60 Hz hum, relay clicks, fan | machine space, gives you a target |
| Corridor | air movement, distant footsteps of the building | transit, no cover |
| Safe room | warm hum, a radio's low static, nothing else | relief |

## Authoring rules

- **One dominant tone + two details.** Three equal layers sound like noise.
- **Loop point first.** A 30 s loop with a click at the seam is unusable; trim to a zero crossing.
- **Frequency separation between rooms.** If every room has a 60 Hz hum, moving between rooms is
  invisible. Vary the band per palette.
- **Silence is authored.** Give every room a "power off" state: everything but the hum stops.
- **Do not stack a room tone with a music bed at the same level** — pick one to be dominant.

## Mixing targets (starting points)

| Layer | Level | Rolloff |
|---|---|---|
| Room tone | −22 dB | 2D (SoundService) |
| Detail | −14 dB | positional, max 40 studs |
| Weather | −18 dB | 2D |
| Music bed | −12 dB | 2D |

