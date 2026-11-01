---
title: Roblox Horror Asset Vault
aliases: [Roblox Horror IDs, Roblox Horror Assets]
tags: [roblox, horror, asset-vault, obsidian]
research_date: 2026-11-01
asset_count: 206
---

# Roblox Horror Asset Vault

**206 distinct researched Roblox asset IDs** across 11 categories, with searchable CSV and JSON exports for AI agents.

> ⚠️ **Research status, NOT Studio tested.** Individual Creator Store listing availability, runtime permissions, animation ownership, audio licensing, and script safety have **not** been tested in your game. A listing or ID is not proof that it can be used. A small number of low-confidence candidates are labelled `S`. Do not blindly import third-party models or grant permissions.

## Notes and navigation

- [[01-outdoor-ambience-weather|01 · Outdoor ambience & weather]] — **17 IDs**
- [[02-interior-ambience-electronics-room-tone|02 · Interior ambience, electronics & room tone]] — **16 IDs**
- [[03-footsteps-locomotion-environmental-foley|03 · Footsteps, locomotion & environmental foley]] — **14 IDs**
- [[04-doors-locks-switches-physical-interactions|04 · Doors, locks, switches & physical interactions]] — **15 IDs**
- [[05-ui-clicks-prompts-inventory-gadget-beeps|05 · UI clicks, prompts, inventory & gadget beeps]] — **32 IDs**
- [[06-horror-stingers-suspense-cues-music|06 · Horror stingers, suspense cues & music]] — **34 IDs**
- [[07-mechanical-radio-glitch-creature-design|07 · Mechanical, radio, glitch & creature design]] — **17 IDs**
- [[08-ui-kits-icon-packs-menus-models-plugins|08 · UI kits, icon packs & menus (models/plugins)]] — **12 IDs**
- [[09-character-animations-individual-animation-ids|09 · Character animations (individual animation IDs)]] — **30 IDs**
- [[10-animation-systems-horror-rigs-gameplay-models|10 · Animation systems, horror rigs & gameplay models]] — **9 IDs**
- [[11-flashlights-lighting-locations|11 · Flashlights, lighting & locations]] — **10 IDs**

## Understanding the evidence markers

- **D** — Individual asset page surfaced on the official Roblox Creator Store. Strongest evidence the ID has a matching listing, **not** a guarantee that it's playable, public, safe, or usable.
- **G** — Numeric animation ID published in Roblox's current official animation documentation.
- **R** — Audio ID included in an official Roblox audio tutorial.
- **F** — Numeric default animation ID found in a Roblox Developer Forum reference; historical reference, verify before use.
- **I** — Audio ID/name indexed by independent [Roblox IDs Hub](https://robloxidshub.com/audio/sfx); **not** independently checked in Creator Store.
- **S** — Secondary audio listing; treat as a lead only.

Evidence marker describes the source, **not** quality, price, copyright license, malicious-code status or current access.

## Agent ingestion guide

**Use `ALL_ASSETS.json`** for an AI coding agent, `ALL_ASSETS.csv` for searching/filtering in other tools, or browse linked category notes in Obsidian. For example:

> “Use this vault as a **candidate lookup**, not a definitive permissioned asset source. Search by `suggested_use` and `category`, and propose a few asset IDs for each requested feature. Favor `D`/`G` over `I`/`S`. Never execute third-party scripts automatically. Validate access and inspect the contents before use; explain failures and propose alternatives. Do not treat model asset IDs as SoundIds or as animation IDs.”

### Usage by type

**Audio:** In a `Sound` instance set `SoundId = "rbxassetid://ID"`. Roblox's audio privacy/permissions may still prevent playback.

**Animation:** Use an `Animation` instance with `AnimationId = "rbxassetid://ID"`, loaded by an `Animator`. Only the individual IDs in the animation note are intended for this; model IDs from other files are containers, **not** animation IDs. Access rules apply to restricted animations.

**Models:** Search the exact model ID in Studio’s Toolbox / Creator Store and insert into a **blank review place first**. Do not use the numeric model ID as an audio ID. Review all scripts, unusual external requires, malicious remotes, and dependencies, and review asset rights.

**Plugins:** Install/review from Creator Store only when you trust the creator and understand requested privileges. Never install a plugin solely because an AI recommended it.

## Studio quick smoke test for audio

Place a `LocalScript` in a clean test place under `StarterPlayerScripts`, replace `123456789` with one audio ID, and check the Output panel for `Failed to load sound`, authorization, and moderated asset errors. Do not interpret absence of errors as proof of licensing.

```lua
local SoundService = game:GetService("SoundService")
local test = Instance.new("Sound")
test.SoundId = "rbxassetid://123456789"
test.Volume = 0.25
test.Parent = SoundService
test:Play()
```

## General trusted references

- [Roblox: Audio assets and Creator Store licensing/access](https://create.roblox.com/docs/audio/assets)
- [Roblox: Audio tutorial with example IDs](https://create.roblox.com/docs/tutorials/use-case-tutorials/audio/play-background-music)
- [Roblox: Asset ID usage](https://create.roblox.com/docs/projects/assets)
- [Roblox: Animation IDs and how to use them](https://create.roblox.com/docs/animation/using)
- [Roblox: Animation permissions update](https://devforum.roblox.com/t/improving-animation-asset-permissions/3852101)
- [Independent audio index](https://robloxidshub.com/audio/sfx)
- [Default animation reference](https://devforum.roblox.com/t/list-of-the-default-r15-animation-ids/140425)

## Curator's selection notes

- Prioritize professional effect libraries (such as sound effects attributed to Pro Sound Effects or APM Music) for atmosphere.
- For environmental 3D sound, add `Sound` to an Attachment or world Part. For UI, use `SoundService` or the UI hierarchy.
- Many multi-second ambience clips contain several takes and do not seamlessly loop; audition and cut/reupload assets only if licensing permits.
- Keep UI interactions legible: a quiet confirmation, a separate warning, and very rare louder cinematic stingers.
- “Sound from another game” descriptions and third-party-themed models can have copyright or asset access problems despite a visible Creator Store page.
- Some models have scripts or misleading tag spam: the vault includes IDs so you can inspect **before** committing them, not an endorsement of their contents.
