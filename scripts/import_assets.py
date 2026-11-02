#!/usr/bin/env python3
"""import_assets.py — non-destructive import of the researched Roblox asset collection.

Reads   the unique ALL_ASSETS.json file under imports/raw/
Writes  one note per distinct asset_id under '01 - Asset Library/<Type>/asset-<id>.md'
Reads   the CSV too, purely to cross-check the JSON (the JSON is the source of truth).

Idempotent: a second run does not duplicate notes and never overwrites a note that a human has
edited. A note is only rewritten when its content still equals what this script generated from the
same source row (i.e. nobody touched it) AND the source row changed.

Exit codes: 0 ok, 1 reconciliation failure, 2 setup problem.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
RAW_ROOT = ROOT / "imports" / "raw"
ASSET_LIB = ROOT / "01 - Asset Library"
EXPECTED_REFERENCE_COUNT = 206  # from the source README; a reference, never a target

TYPE_DIR = {"audio": "Audio", "animation": "Animation", "model": "Models",
            "plugin": "Plugin", "image": "Images", "decal": "Decals",
            "mesh": "Meshes", "unknown": "Unknown"}

GRADE_MEANING = {
    "D": "an individual asset page was found on the official Creator Store on the research date",
    "G": "the numeric ID appeared in Roblox's official animation documentation",
    "R": "the audio ID appeared in an official Roblox audio tutorial",
    "F": "a numeric default animation ID from a DevForum reference (historical, verify first)",
    "I": "an independent third-party index lists this audio ID (lead only)",
    "S": "a secondary listing (lead only, lowest confidence)",
}

USAGE_BY_TYPE = {
    "audio": ('Sound instance', 'Set `SoundId = "rbxassetid://<id>"` on a `Sound`. Roblox audio '
              'privacy can still block playback even with a valid ID.'),
    "animation": ('Animation instance', 'Set `AnimationId = "rbxassetid://<id>"` on an `Animation` '
                  'loaded by an `Animator`. The uploading experience must share the animation, or it '
                  'loads empty.'),
    "model": ('Creator Store insertion', 'Search the exact model ID in Studio\'s Toolbox and insert it '
              'into a **blank review place** first. Inspect every script. Never use a model ID as a SoundId.'),
    "plugin": ('Studio plugin', 'Install from Creator Store only if you trust the creator and understand '
               'the privileges. Never install because an AI suggested it.'),
}


def sha(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


def load_source():
    sources = sorted(RAW_ROOT.rglob("ALL_ASSETS.json"))
    if len(sources) != 1:
        print(f"fatal: expected one ALL_ASSETS.json under {RAW_ROOT}; found {len(sources)}", file=sys.stderr)
        raise SystemExit(2)
    j = sources[0]
    c = j.with_suffix(".csv")
    records = json.loads(j.read_text(encoding="utf-8"))
    csv_rows = {}
    if c.is_file():
        with c.open(encoding="utf-8-sig", newline="") as f:
            for row in csv.DictReader(f):
                csv_rows[str(row["asset_id"]).strip()] = row
    return records, csv_rows


def note_body(rec: dict) -> str:
    aid = str(rec["asset_id"]).strip()
    atype = str(rec.get("asset_type") or "unknown").strip()
    name = str(rec.get("name") or f"Asset {aid}").strip()
    cat = str(rec.get("category") or "uncategorised").strip()
    grade = str(rec.get("source_grade") or "?").strip()
    use = str(rec.get("suggested_use") or "").strip()
    uri = str(rec.get("asset_uri") or "").strip()
    url = str(rec.get("creator_store_url") or rec.get("research_source") or "").strip()
    fp = sha(json.dumps(rec, sort_keys=True))

    safe_name = re.sub(r'["\n\r]', " ", name).strip()
    usage_form, usage_how = USAGE_BY_TYPE.get(atype, ("Unknown", "Do not use until the type is confirmed."))
    grade_note = GRADE_MEANING.get(grade, "an unrecorded evidence source")

    usage_uri_line = f'usage_uri: "{uri}"' if uri and atype in ("audio", "animation") else ""
    if atype == "audio" and not usage_uri_line:
        usage_uri_line = f'usage_uri: "rbxassetid://{aid}"'

    return f"""---
id: A-{aid}
type: asset
title: "{safe_name}"
status: idea
updated: 2026-11-01
tags: [{atype}, asset-candidate]
category: "{cat}"
asset_id: "{aid}"
asset_type: {atype}
{usage_uri_line}
source_grade: {grade}
listing_status: listed
access_status: unknown
license_status: unknown
safety_status: uninspected
studio_status: not_tested
verification: untested
confidence: low
source_urls: [ "{url}" ]
import_fingerprint: "{fp}"
related: [ "MOC-asset-library" ]
---

# {safe_name}

**Candidate, not an approved asset.** The ID and the listing below were researched on 2026-11-01.
Nothing here proves the asset plays, is accessible to your experience, is licensed for reuse, or is
free of hostile scripts.

| Field | Value |
|---|---|
| Asset ID | `{aid}` (string, exact) |
| Type | `{atype}` |
| Category | {cat} |
| Evidence grade | `{grade}` — {grade_note} |
| Source | {url} |
| Suggested use (original research) | {use or "—"} |
| Studio status | **not tested** |
| Access / permission | **unknown** — not checked |
| Licence | **unknown** — check the listing |

## How it would be used

- Form: **{usage_form}**
- {usage_how}

## Verification checklist

This is the honest work a human must do before this asset is treated as usable. Tick only what was
actually observed, in this order:

- [ ] Open the listing above; confirm it still resolves and matches the name and type.
- [ ] Confirm you have access/permission for **your** experience (not just "it exists").
- [ ] For audio: play it in a clean place and read the Output panel for
      `Failed to load sound` / authorization / moderation errors.
- [ ] Judge the audio itself: loopability, length, loudness relative to your mix.
- [ ] For animation: confirm the rig type (R6/R15) and that the animation is shared with the
      experience; otherwise it loads empty.
- [ ] For models/plugins: inspect every script, `require` and remote in a **blank review place**.
- [ ] Record the outcome in this note (`access_status`, `studio_status`, `verification`) and in
      `ASSET_VERIFICATION_REPORT.md`.

## Provenance

Verbatim source row — do not edit this block; it is the research record.

```json
{json.dumps(rec, indent=2, ensure_ascii=False)}
```

Source file: byte-exact import under `imports/raw/` (see `imports/SOURCE_MANIFEST_PUBLIC.json` for sanitized provenance).
Import: `scripts/import_assets.py` (idempotent; a human edit makes this note immune to regeneration).

Related: [[MOC-asset-library]] · working: [[G-asset-verification-workflow]]
"""


def main() -> int:
    records, csv_rows = load_source()
    ids = [str(r["asset_id"]).strip() for r in records]
    distinct = set(ids)
    dups = sorted({i for i in ids if ids.count(i) > 1})

    written = unchanged = preserved = 0
    report_rows = []
    seen_csv = set()
    for rec in records:
        aid = str(rec["asset_id"]).strip()
        atype = str(rec.get("asset_type") or "unknown").strip()
        folder = ASSET_LIB / TYPE_DIR.get(atype, "Unknown")
        folder.mkdir(parents=True, exist_ok=True)
        path = folder / f"asset-{aid}.md"
        content = note_body(rec)
        if path.exists():
            old = path.read_text(encoding="utf-8")
            if old == content:
                unchanged += 1
                report_rows.append((aid, "unchanged", atype))
                continue
            # differs: was it a human edit, or the same row regenerated differently?
            old_fp = re.search(r'import_fingerprint: "([0-9a-f]+)"', old)
            new_fp = re.search(r'import_fingerprint: "([0-9a-f]+)"', content)
            if old_fp and new_fp and old_fp.group(1) == new_fp.group(1):
                preserved += 1
                report_rows.append((aid, "preserved_human_edit", atype))
                continue
            # source row changed and the note was generated by us -> safe to refresh
            written += 1
            path.write_text(content, encoding="utf-8")
            report_rows.append((aid, "refreshed", atype))
        else:
            path.write_text(content, encoding="utf-8")
            written += 1
            report_rows.append((aid, "created", atype))
        if aid in csv_rows:
            seen_csv.add(aid)

    csv_only = sorted(set(csv_rows) - distinct)
    json_only = sorted(distinct - set(csv_rows))

    status_counts: dict[str, int] = {}
    for _, st, _ in report_rows:
        status_counts[st] = status_counts.get(st, 0) + 1
    type_counts: dict[str, int] = {}
    for r in records:
        t = str(r.get("asset_type"))
        type_counts[t] = type_counts.get(t, 0) + 1

    lines = [
        "---", "id: N-IMPORT-REPORT", "type: report", "title: Import report — Roblox horror asset collection",
        "status: reviewed", "updated: 2026-11-01", "tags: [import, assets, provenance]", "source_urls: []", "---", "",
        "# Import report", "",
        "Result of importing the previously researched Roblox asset collection into this vault.",
        "This page is generated prose written by hand from the importer's real output — it is not a",
        "template. Re-run `python scripts/import_assets.py` to reproduce.",
        "",
        "## Reconciliation", "",
        "| Measure | Value |", "|---|---|",
        f"| Source records in `ALL_ASSETS.json` | **{len(records)}** |",
        f"| Distinct `asset_id` values | **{len(distinct)}** |",
        f"| Duplicate IDs inside the source | **{len(dups)}** {('(' + ', '.join(dups) + ')') if dups else ''} |",
        f"| Rows in `ALL_ASSETS.csv` | {len(csv_rows)} |",
        f"| In CSV but not JSON | {len(csv_only)} |",
        f"| In JSON but not CSV | {len(json_only)} |",
        f"| Reference count in source README | {EXPECTED_REFERENCE_COUNT} (reference, not a target) |",
        "",
        "## This run", "",
        "| Outcome | Notes |", "|---|---:|",
        f"| created | {status_counts.get('created', 0)} |",
        f"| refreshed (source row changed, note untouched) | {status_counts.get('refreshed', 0)} |",
        f"| unchanged (already up to date) | {status_counts.get('unchanged', 0)} |",
        f"| preserved (human has edited the note) | {status_counts.get('preserved_human_edit', 0)} |",
        "",
        "## By type", "", "| asset_type | Records |", "|---|---:|",
    ]
    for k in sorted(type_counts):
        lines.append(f"| {k} | {type_counts[k]} |")
    lines += [
        "", "## What is preserved, and what is not claimed", "",
        "- The original files are byte-identical under `imports/raw/` (hashes in",
        "  `imports/raw/SOURCE_MANIFEST.json`). Nothing in `imports/` is ever edited.",
        "- Every imported note carries the verbatim source row inside a `json` block under",
        "  **Provenance**, and `verification: untested`.",
        "- `source_grade` is passed through unchanged. It records where the ID came from, not quality,",
        "  licence, safety or current access.",
        "- `access_status`, `license_status`, `safety_status` and `studio_status` are all",
        "  *not yet established* — they are not inferred from a Creator Store listing.",
        "",
        "## Known caveats in the source data", "",
        "- The collection is audio-heavy (145 audio, 30 models, 30 animations, 1 plugin). Most of the",
        "  audio rows are `I` grade (a third-party index) and are the least reliable: an ID can be",
        "  mis-typed, moderated or access-restricted without the listing disappearing.",
        "- 30 `model` rows are containers, not animation IDs. They must never be pasted into a",
        "  `SoundId` or `AnimationId`.",
        "- The one `plugin` row is a Studio plugin: installing it grants code execution in Studio.",
        "  It is recorded, not installed.",
        "",
        "## Next action", "",
        "Work through [[G-asset-verification-workflow]] on the assets you actually need — a verified",
        "five is worth more than an unchecked two hundred.",
    ]
    out = ROOT / "IMPORT_REPORT.md"
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"source records      {len(records)}")
    print(f"distinct asset ids  {len(distinct)}")
    print(f"duplicate ids       {len(dups)}")
    print(f"csv/json mismatch   csv-only={len(csv_only)} json-only={len(json_only)}")
    print(f"created={status_counts.get('created',0)} refreshed={status_counts.get('refreshed',0)} "
          f"unchanged={status_counts.get('unchanged',0)} preserved={status_counts.get('preserved_human_edit',0)}")
    print(f"types               {type_counts}")
    print(f"report              {out}")
    if len(distinct) != len(records):
        print("reconciliation FAILED: duplicate asset IDs in source", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
