#!/usr/bin/env python3
"""build_mocs.py — generate a map-of-content note per library from the files that actually exist.

Rationale: a hand-written index drifts. A generated index cannot point at a note that does not exist.
Each MOC keeps a hand-written introduction (below) and appends a generated, sorted list.

    python scripts/build_mocs.py            # write MOCs (skips ones marked generated: false)
    python scripts/build_mocs.py --force    # overwrite every MOC
"""

from __future__ import annotations

import datetime as dt
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent

# folder -> (moc file stem, id, title, intro)
LIBS = [
    ("00 - Start Here", "MOC-start-here", "MOC-start-here", "Start here",
     "The shortest path into the vault. Read the three rules first: cause before fix, proof over promises, "
     "never invent a permission."),
    ("02 - Roblox Development", "MOC-roblox-development", "MOC-roblox-development", "Roblox Development",
     "Engineering knowledge: language, architecture, services, data, physics, performance and security. "
     "Each note states its execution context (server/client/both) and whether it is documentation-derived "
     "(`reference_only`) or design (`design_only`)."),
    ("03 - Reusable Systems", "MOC-reusable-systems", "MOC-reusable-systems", "Reusable Systems",
     "Twenty mechanic recipes. Every one has an API contract, a server/client split, a failure-mode table and "
     "a test list. **No code here has been executed** — each block is labelled `Untested:` until someone runs it."),
    ("04 - Horror Design", "MOC-horror-design", "MOC-horror-design", "Horror Design",
     "Pacing, tension, audio layering, an adaptive director and the accessibility rules that make intensity "
     "safe. Numbers here are starting points to measure against, not results."),
    ("05 - Enemy AI", "MOC-enemy-ai", "MOC-enemy-ai", "Enemy AI",
     "Server-owned NPC behaviour: taxonomy, a finite state machine with explicit guards, perception, memory, "
     "targeting and the think-budget maths that keeps 10 NPCs affordable."),
    ("06 - UI UX and Game Feel", "MOC-ui-and-game-feel", "MOC-ui-and-game-feel", "UI, UX and Game Feel",
     "Responsive layout, design tokens, prompts, notifications, transitions, camera feel and accessibility. "
     "Includes the two failure modes that bite every Roblox project: buttons that drift and panels that widen."),
    ("07 - Level Design and Progression", "MOC-level-design", "MOC-level-design", "Level Design",
     "Blockouts, floorplan patterns, room arcs, puzzles, procedural constraints and a complete worked level "
     "plan. Solvability is treated as a testable property, not a hope."),
    ("09 - AI Agent Knowledge", "MOC-agent-knowledge", "MOC-agent-knowledge", "AI Agent Knowledge",
     "The contract for agents (`AGENTS.md` at the root), per-harness briefs, prompt templates, context packs "
     "and the promotion rules that stop AI output from becoming 'documented fact'."),
    ("10 - Projects and Experiments", "MOC-projects", "MOC-projects", "Projects and Experiments",
     "A reusable project starter and one worked sample project. Projects link to reusable systems instead of "
     "copying them, so a fix to a recipe reaches every project."),
    ("11 - Templates and Schemas", "MOC-templates", "MOC-templates", "Templates and Schemas",
     "Sixteen note templates with valid frontmatter, plus the fixtures the validator tests against. Copy a "
     "template, replace the placeholders, run `validate`."),
    ("13 - Dashboards", "MOC-dashboards", "MOC-dashboards", "Dashboards",
     "Generated views: asset status, vault health and recently updated notes. Regenerate with "
     "`python scripts/gamedev_kb.py report --write-dashboards`."),
]

SKIP_STEMS = {"MOC-asset-library", "MOC-bugs", "MOC-sources"}

DATE_RE = re.compile(r"^updated:\s*(\S+)", re.M)


def read_meta(p: Path):
    text = p.read_text(encoding="utf-8", errors="replace")
    fm = {}
    if text.startswith("---"):
        end = text.find("\n---", 3)
        if end != -1:
            for line in text[3:end].splitlines():
                m = re.match(r"^([A-Za-z0-9_\-]+):\s*(.*)$", line.strip())
                if m:
                    fm[m.group(1)] = m.group(2).strip().strip('"')
    return fm, text


def main() -> int:
    force = "--force" in sys.argv
    written = skipped = 0
    for folder, stem, nid, title, intro in LIBS:
        d = ROOT / folder
        if not d.is_dir():
            print(f"skip (no folder): {folder}")
            continue
        target = d / f"{stem}.md"
        if target.exists() and not force:
            fm, _ = read_meta(target)
            if fm.get("generated", "").lower() != "true":
                print(f"keep (hand-written): {target.relative_to(ROOT)}")
                skipped += 1
                continue
        notes = []
        for p in sorted(d.rglob("*.md")):
            if p == target or p.stem in SKIP_STEMS or p.stem.startswith("MOC-"):
                continue
            fm, _ = read_meta(p)
            notes.append((p.relative_to(d).as_posix(), p.stem, fm.get("type", "note"),
                          fm.get("verification", ""), fm.get("title", p.stem)))
        rows = ["| Note | Type | Verification | Title |", "|---|---|---|---|"]
        for relpath, st, ntype, ver, ntitle in notes:
            sub = relpath.rsplit("/", 1)[0] if "/" in relpath else ""
            prefix = f"`{sub}/` " if sub else ""
            rows.append(f"| {prefix}[[{st}]] | {ntype} | {ver or '—'} | {ntitle} |")
        if not notes:
            rows.append("| _no notes yet_ | | | |")
        body = f"""---
id: {nid}
type: moc
title: {title} — map of content
status: reviewed
updated: {dt.date.today().isoformat()}
tags: [moc]
source_urls: []
confidence: high
verification: reference_only
generated: true
related: [ "N-HOME" ]
---

# {title}

{intro}

_Generated by `scripts/build_mocs.py` from the {len(notes)} note(s) actually in `{folder}/`. Counts are real;
re-run the script after adding notes._

## Contents

""" + "\n".join(rows) + """

## Related

- Home: [[HOME]] · Start here: [[MOC-start-here]]
- Agents: [[AGENTS]] · schema: [[SCHEMA]] · status: [[STATUS]]
"""
        target.write_text(body, encoding="utf-8")
        written += 1
        print(f"wrote {target.relative_to(ROOT)} ({len(notes)} notes)")
    print(f"\nwritten {written} · kept {skipped}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
