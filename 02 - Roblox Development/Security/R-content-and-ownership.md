---
id: R-content-and-ownership
type: reference
title: Content restrictions, moderation and asset ownership
status: reviewed
updated: 2026-11-01
tags: [assets, moderation, ownership]
source_urls: [ "https://create.roblox.com/docs/production/publishing/publish-games-and-places", "https://create.roblox.com/docs/audio/assets" ]
confidence: medium
verification: reference_only
related: [ "G-asset-verification-workflow", "LICENSES_AND_SOURCES" ]
---

# Ownership and content rules

This is a high-level operational summary, not legal advice. The platform's own documentation is
canonical ([[G-roblox-api-links]]).

## Who owns what

- An asset is owned by the **account or group that uploaded it**.
- **Animations and audio are frequently restricted to the uploading experience.** A valid ID can
  exist, be visible in the catalogue, and still load nothing in your game.
- Models are copied into your place; their scripts come with them. Ownership of the model does not
  make its scripts trustworthy.
- Group-owned assets require the place to be owned by the same group (or the asset to be shared).

## Practical verification sequence

1. Does the listing open, and is the type what you expect (`audio` vs `model`)?
2. Does it load in a **blank** test place owned by the same account/group as the target place?
3. Do you have permission to use it in *this* experience (not just to view it)?
4. Is there any doubt about the rights? Then do not use it in something commercial.

## Moderation realities

- Audio and images can be moderated after the fact. A working asset today can be dead in a month.
  Keep a note of what each game depends on so a dead ID is a 5-minute fix.
- Uploading someone else's content, or re-uploading a Creator Store asset, can get the *uploading
  account* actioned. This vault therefore stores **IDs and links only**, never copies.
- Third-party IP ("that movie character") is a real risk even when a model is on the Store.

## What this means for the asset catalogue

Every `asset-*.md` note keeps `access_status`, `license_status` and `safety_status` unknown until
someone checks. A `D` grade is *listing exists*, nothing more. See [[LICENSES_AND_SOURCES]] and
[[G-asset-verification-workflow]].
