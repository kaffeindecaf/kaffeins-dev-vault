#!/usr/bin/env python3
"""build_asset_indexes.py — generate asset indexes and the asset MOC from the imported records.

Every count in the generated notes comes from ALL_ASSETS.json (the import source of truth), not from
memory. Re-run after fixing an import:  python scripts/build_asset_indexes.py

Writes into '01 - Asset Library/Indexes/'. Does not touch the per-asset notes.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "imports/raw/Roblox_Horror_Asset_Vault_2026-11-01/Roblox_Horror_Asset_Vault/ALL_ASSETS.json"
LIB = ROOT / "01 - Asset Library"
OUT = LIB / "Indexes"

TYPE_DIR = {"audio": "Audio", "animation": "Animation", "model": "Models", "plugin": "Plugin",
            "image": "Images", "decal": "Decals", "mesh": "Meshes", "unknown": "Unknown"}

GRADE_NOTE = {
    "D": "a Creator Store listing existed on the research date",
    "G": "official Roblox animation documentation",
    "R": "an official Roblox audio tutorial",
    "F": "a DevForum reference (historical)",
    "I": "a third-party index (lead only)",
    "S": "a secondary listing (lead only)",
}

# Each index: (slug, title, id, predicate description, matcher)
INDEXES = [
    ("IDX-footsteps", "Footsteps by surface and pace", "DB-idx-footsteps",
     "audio whose name or suggested use mentions a footstep, step, walk, run or surface",
     lambda r: _has(r, ["footstep", "foot step", "steps", "walk", "run", "sneak", "boot", "heel", "gravel", "wood floor", "carpet", "snow step"])),
    ("IDX-doors", "Doors: creaks, latches, handles, slams", "DB-idx-doors",
     "audio mentioning a door, latch, handle, hinge, lock, squeak or slam",
     lambda r: _has(r, ["door", "latch", "handle", "hinge", "lock", "squeak", "creak", "slam", "knob", "gate"])),
    ("IDX-ambience", "Ambience: indoor, outdoor, electrical, room tone", "DB-idx-ambience",
     "audio mentioning ambience, atmosphere, room tone, hum, wind, rain, weather or forest",
     lambda r: _has(r, ["ambien", "atmos", "room tone", "hum", "wind", "rain", "weather", "forest", "crickets", "night", "storm", "thunder", "electr"])),
    ("IDX-ui-sounds", "UI sounds: menu, hover, confirm, error, notification", "DB-idx-ui-sounds",
     "audio mentioning ui, click, beep, notification, menu, button, hover, confirm or error",
     lambda r: _has(r, ["ui", "click", "beep", "notif", "menu", "button", "hover", "confirm", "error", "alert", "pop", "blip", "digital"])),
    ("IDX-horror-cues", "Horror cues: tension builds, stingers, sparse music", "DB-idx-horror-cues",
     "audio mentioning horror, sting, tension, dread, screech, whisper, drone or music",
     lambda r: _has(r, ["horror", "sting", "tension", "dread", "screech", "whisper", "drone", "creep", "ominous", "heartbeat", "music", "suspense", "eerie", "spooky"])),
    ("IDX-animations", "Animation IDs by rig and movement", "DB-idx-animations",
     "records of type animation, grouped by rig hint and movement",
     lambda r: str(r.get("asset_type")) == "animation"),
    ("IDX-models", "Models, props, rigs and systems", "DB-idx-models",
     "records of type model (containers, not animation IDs)",
     lambda r: str(r.get("asset_type")) == "model"),
    ("IDX-ui-kits", "UI kits, icon packs and menu systems", "DB-idx-ui-kits",
     "models and records mentioning ui, icon, menu, gui, hud, pack or interface",
     lambda r: _has(r, ["ui", "icon", "menu", "gui", "hud", "interface", "pack", "button", "cursor"])
               and str(r.get("asset_type")) in ("model", "image", "decal", "mesh")),
    ("IDX-lighting", "Lighting, flashlights and atmosphere", "DB-idx-lighting",
     "audio or models mentioning light, flashlight, lamp, flicker, fog or glow",
     lambda r: _has(r, ["light", "flashlight", "lamp", "flicker", "fog", "glow", "torch", "dark"])),
]

PLUGIN_INDEX = ("IDX-plugins", "Studio plugins", "DB-idx-plugins")


def _has(rec: dict, words) -> bool:
    hay = (str(rec.get("name", "")) + " " + str(rec.get("suggested_use", ""))).lower()
    return any(w in hay for w in words)


def link(rec) -> str:
    aid = str(rec["asset_id"])
    return f"[[asset-{aid}|{aid}]]"


def table(records) -> list[str]:
    rows = ["| Asset | ID | Type | Grade | Suggested use |", "|---|---|---|---|---|"]
    for r in records:
        name = str(r.get("name", "")).replace("|", "/")[:52]
        use = str(r.get("suggested_use", "")).replace("|", "/")[:52]
        rows.append(f"| {name} | {link(r)} | {r.get('asset_type')} | {r.get('source_grade')} | {use} |")
    return rows


def main() -> int:
    if not SRC.is_file():
        print(f"fatal: missing {SRC}", file=sys.stderr)
        return 2
    records = json.loads(SRC.read_text(encoding="utf-8"))
    OUT.mkdir(parents=True, exist_ok=True)

    written = []
    for slug, title, nid, desc, match in INDEXES:
        hits = [r for r in records if match(r)]
        lines = [
            "---", f"id: {nid}", "type: dashboard", f"title: {title}", "status: reviewed",
            "updated: 2026-11-01", "tags: [assets, index, dashboard]", "source_urls: []",
            "verification: reference_only", "confidence: medium", "generated: true",
            "related: [ \"MOC-asset-library\", \"G-asset-verification-workflow\" ]", "---", "",
            f"# {title}", "",
            f"_Generated by `scripts/build_asset_indexes.py` from the imported records: "
            f"**{len(hits)} of {len(records)}** matched ({desc}). Re-run to refresh; do not hand-edit._", "",
            "> Every row is an **untested candidate**. Matching keywords means the name mentions it — not that the",
            "> asset sounds right, is accessible, or is licensed. Verify before use "
            "([[G-asset-verification-workflow]]).", "",
        ]
        if hits:
            lines += table(hits)
        else:
            lines += ["_No records matched this filter. That is a real result, not a placeholder — the import "
                      "does not contain a candidate for this category._"]
        lines += ["", "## Grade distribution", "", "| Grade | Records | Meaning |", "|---|---:|---|"]
        for g in "DGRFIS":
            n = sum(1 for r in hits if r.get("source_grade") == g)
            if n:
                lines.append(f"| {g} | {n} | {GRADE_NOTE[g]} |")
        (OUT / f"{slug}.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
        written.append((slug, len(hits)))

    # plugins get their own warning-laden index
    plugins = [r for r in records if str(r.get("asset_type")) == "plugin"]
    slug, title, nid = PLUGIN_INDEX
    lines = ["---", f"id: {nid}", "type: dashboard", f"title: {title}", "status: reviewed",
             "updated: 2026-11-01", "tags: [assets, index, plugin]", "source_urls: []",
             "verification: reference_only", "confidence: medium", "generated: true",
             "related: [ \"MOC-asset-library\", \"G-asset-verification-workflow\" ]", "---", "",
             f"# {title}", "",
             f"_Generated from the imported records: **{len(plugins)}** plugin record(s)._", "",
             "> ⚠️ **A Studio plugin executes code with your permissions.** Installing one is a code-execution",
             "> decision, not an asset decision. None here has been inspected. Read "
             "[[G-asset-verification-workflow]] first, and prefer the Creator Store listing over any ID handed",
             "> to you by a model or a blog.", ""]
    lines += table(plugins) if plugins else ["_No plugin records._"]
    (OUT / f"{slug}.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    written.append((slug, len(plugins)))

    # type indexes (P04-02)
    for atype in ("audio", "animation", "model", "plugin", "unknown"):
        hits = [r for r in records if str(r.get("asset_type")) == atype]
        if not hits:
            continue
        slug = f"IDX-type-{atype}"
        lines = ["---", f"id: DB-idx-type-{atype}", "type: dashboard", f"title: All {atype} records",
                 "status: reviewed", "updated: 2026-11-01", "tags: [assets, index]", "source_urls: []",
                 "verification: reference_only", "generated: true",
                 "related: [ \"MOC-asset-library\" ]", "---", "",
                 f"# All {atype} records ({len(hits)})", "",
                 "_Generated. Every record is `untested`._", ""]
        lines += table(hits)
        (OUT / f"{slug}.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
        written.append((slug, len(hits)))

    # MOC-asset-library
    cats: dict[str, int] = {}
    types: dict[str, int] = {}
    grades: dict[str, int] = {}
    for r in records:
        cats[str(r.get("category"))] = cats.get(str(r.get("category")), 0) + 1
        types[str(r.get("asset_type"))] = types.get(str(r.get("asset_type")), 0) + 1
        grades[str(r.get("source_grade"))] = grades.get(str(r.get("source_grade")), 0) + 1

    lines = ["---", "id: MOC-asset-library", "type: moc", "title: Asset Library — map of content",
             "status: reviewed", "updated: 2026-11-01", "tags: [assets, moc]", "source_urls: []",
             "verification: reference_only", "confidence: medium", "generated: false",
             "related: [ \"N-HOME\", \"G-asset-verification-workflow\" ]", "---", "",
             "# Asset Library", "",
             f"**{len(records)} researched Roblox asset candidates**, imported unchanged from the 2026-11-01",
             "research collection. This is a **lookup**, not a permissioned asset source.", "",
             "> ⚠️ **Nothing here has been verified.** An ID and a listing prove an asset exists. They do not",
             "> prove it plays in your game, that you may use it, that it is safe, or that it still exists today.",
             "> `access_status`, `license_status` and `studio_status` are `unknown`/`not_tested` on every record.",
             "> Start with [[G-asset-verification-workflow]] before putting any of these in a game.", "",
             "## Don't confuse the ID types", "",
             "| Type | Use as | Never |", "|---|---|---|",
             "| `audio` | `Sound.SoundId = \"rbxassetid://<id>\"` | as an AnimationId |",
             "| `animation` | `Animation.AnimationId = \"rbxassetid://<id>\"` | as a model ID |",
             "| `model` | search the ID in Studio's Toolbox, review in a blank place | as a SoundId |",
             "| `plugin` | Creator Store only, after review | install because a model said so |", "",
             "## Indexes", "",
             "| Index | What it gathers |", "|---|---|"]
    for slug, title, nid, desc, _m in INDEXES:
        n = dict(written).get(slug, 0)
        lines.append(f"| [[{slug}]] | {desc} — {n} records |")
    lines.append(f"| [[{PLUGIN_INDEX[0]}]] | Studio plugins — {dict(written).get(PLUGIN_INDEX[0], 0)} record(s), all uninspected |")
    lines += ["", "## By type", "", "| Type | Records | Folder |", "|---|---:|---|"]
    for t in sorted(types, key=lambda x: -types[x]):
        lines.append(f"| {t} | {types[t]} | `01 - Asset Library/{TYPE_DIR.get(t, 'Unknown')}/` |")
    lines += ["", "## By source grade", "",
              "| Grade | Records | What it means (and does not) |", "|---|---:|---|"]
    for g in "D I G F S R":
        if grades.get(g):
            lines.append(f"| `{g}` | {grades[g]} | {GRADE_NOTE.get(g, '')} — not quality, licence or access |")
    lines += ["", "## By original research category", "",
              "| Category | Records |", "|---|---:|"]
    for c in sorted(cats):
        lines.append(f"| {c} | {cats[c]} |")
    lines += ["", "## Additional Creator Store candidates", "",
              "The following three manually researched records were found after the raw import. They are not included in the 206-row imported totals above:",
              "- [[MOC-new-creator-store-candidates]] — three additional candidate notes, all untested.",
              "", "## Working with these records", "",
              "- Read the caveat table at the top of any `asset-*.md` note.",
              "- Verification workflow: [[G-asset-verification-workflow]].",
              "- Quality rubric and review outcomes: [[G-asset-quality-rubric]].",
              "- Rejected / unusable findings: [[G-asset-rejection-log]].",
              "- Totals and evidence: [[ASSET_VERIFICATION_REPORT]].",
              "- Import provenance: [[IMPORT_REPORT]] and `imports/raw/SOURCE_MANIFEST.json`.", "",
              "Search: `python scripts/gamedev_kb.py search \"door creak\" --type asset --limit 10`",
              "Exact ID: `python scripts/gamedev_kb.py asset 9114145200`"]
    (LIB / "MOC-asset-library.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    written.append(("MOC-asset-library", len(records)))

    for slug, n in written:
        print(f"{slug:26} {n}")
    print(f"\ntotal records {len(records)} · indexes {len(written)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
