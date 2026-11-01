---
id: N-LICENSES
type: guide
title: LICENSES_AND_SOURCES — attribution, provenance and reuse policy
status: reviewed
updated: 2026-11-01
tags: [licensing, provenance, policy]
source_urls: []
---

# LICENSES_AND_SOURCES

How this vault treats other people's work. Read before importing anything.

## Public repository dedication

The repository uses CC0 1.0 Universal for material the maintainer owns or is authorized to dedicate. The full text is in `LICENSE`; creator/source attribution that can be supported by the records is collected in [[CREDITS]]. This dedication does not grant rights to Roblox assets, trademarks, or other material the maintainer is not authorized to license.

## Rules

1. **A link is not a licence.** Seeing a Creator Store page proves a listing exists. It does not
   grant permission to use, re-upload, modify or redistribute the asset.
2. **Verify access where it matters.** Audio and animation assets in Roblox are frequently
   access-restricted to the uploader's experience; a model may be a different uploader's build with
   scripts inside. The asset's own page (and Studio) is the only authority.
3. **No asset bytes are stored here.** This vault records **IDs and links only**. Nothing is
   re-uploaded, re-hosted or republished.
4. **Never execute imported code.** An imported model's scripts are inspected as text at most.
5. **Attribution when you reuse.** Record the asset ID and the creator name (only if the page
   actually shows one — never inferred) in the project's `ASSET_MANIFEST.md`.
6. **Code snippets in this vault are original** unless the note says otherwise, and are offered
   for reuse in your own experience. Quoted documentation text stays attributed and short.
7. **Platform docs** (Creator Hub) are quoted in short excerpts with a link and an access date,
   under ordinary fair-use practice. They are not mirrored.
8. **Do not buy, subscribe or accept a licence on the user's behalf.** That is an explicit
   approval boundary (`PROJECT_CONFIG.md`).

## Source record

Every non-trivial factual claim should trace to a `SRC-*` note (see [[MOC-sources]]) or
to an imported asset record. Where that is impossible, the note says `confidence: low` and states
the uncertainty inline.

## Images and diagrams

Diagrams in this vault are plain-text Mermaid or ASCII, authored here, so they carry no third-party
rights. Screenshots of Roblox Studio may be attached only if they are the user's own capture;
`attachments/` holds nothing today.

| What | Where it is recorded |
|---|---|
| Imported research rows | `original:` in each `asset-*.md`, plus `imports/raw/` |
| Local immutable hash manifest | `imports/raw/SOURCE_MANIFEST.json` (not included in the public tree because it contains a personal local path) |
| Sanitized public hash manifest | `imports/SOURCE_MANIFEST_PUBLIC.json` |
| Import reconciliation | `IMPORT_REPORT.md` |
| Per-asset verification | `ASSET_VERIFICATION_REPORT.md` |
