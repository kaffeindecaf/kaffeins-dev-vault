---
id: A-fixture-uri
type: asset
title: Fixture — a model used as a sound
status: idea
updated: 2026-11-01
tags: [model, fixture]
asset_id: "1234567890"
asset_type: model
usage_uri: "rbxassetid://1234567890"
verification: untested
fixture: true
source_urls: []
---

# Fixture — a model with a sound URI

A `model` must never carry an `rbxassetid://` usage URI. Expect `usage_uri_type_mismatch` — the
"model ID pasted into SoundId" bug caught at validation time.
