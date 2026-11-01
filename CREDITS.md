---
id: N-CREDITS
type: guide
title: Credits and source attribution
status: draft
updated: 2026-11-01
tags: [credits, sources, attribution]
source_urls: []
---

# Credits and source attribution

This file records attribution that can be supported by the vault’s source material. Creator names are not present consistently in the imported records, so none are guessed. CC0 does not require attribution, but source links are retained as a courtesy and to make verification possible.

## Asset research

The 206-row source collection is titled **Roblox Horror Asset Vault** and is dated 2026-11-01. Its original files are listed in `imports/SOURCE_MANIFEST_PUBLIC.json`; that sanitized manifest retains the file hashes and source archive hash but omits the author’s local filesystem path.

Each normalized asset note contains its exact asset ID and a `source_urls` field. Where the source is a Roblox Creator Store page, that link is the place to check the current creator name and listing. Some entries point to Roblox documentation or secondary indexes instead. The source grade identifies where the record came from; it does not establish permission to use the underlying asset.

The original source package does not identify its author. If the author supplies a preferred credit, add it here without changing files under `imports/raw/`.

## Adapted system notes

Nine reusable system notes were adapted from a shipped Roblox experience. Their provenance and the generalizations made are described in [[G-extraction-log]]. The experience and source developer are not named in the vault records. The maintainer has confirmed that permission to redistribute the adapted material is available; this note does not infer or publish the source developer’s identity.

## Roblox and Creator Hub references

Technical notes link to the official Roblox Creator Hub or other cited sources. Follow the `source_urls` and references in each note for the source used and access date. Roblox, Creator Store, and associated marks and assets remain subject to their respective owners’ rights; this repository does not include asset bytes.

## License scope

The repository uses the CC0 1.0 Universal dedication for material the maintainer owns or is authorized to dedicate. This does not waive rights the maintainer does not hold, nor Roblox trademark, privacy, publicity, or third-party asset rights. See [LICENSE](LICENSE) and [CC0’s deed](https://creativecommons.org/publicdomain/zero/1.0/).
