---
id: WL-20261101-worklog-templates
type: worklog
title: Work log — 2026-11-01 — work log templates, schema v2, repo move
status: draft
updated: 2026-11-01
tags: [worklog, agents, handoff, schema, release]
source_urls: []
confidence: high
verification: tested_local
tested_at: 2026-11-01
test_method: python scripts/gamedev_kb.py validate + index, python -m unittest discover -s tests
test_evidence: "§4 — validate 502 notes / 0 errors, index 502 notes (fts5), unittest 31 tests OK"
agent: Hermes Agent (deepseek-flash)
session: 2026-11-01, ~20:20–21:10 local
related: [ "T-worklog", "T-handoff", "G-worklog-protocol", "N-SCHEMA", "N-CHANGELOG", "N-ISSUES" ]
---

# Work log — 2026-11-01 — work log templates, schema v2, repo move

First entry under the protocol it introduces. It is also the worked example: copy [[T-worklog]] the
next time, not this file.

## 1. Task

> "the knowledge base is now in a different folder on my desktop, i think youll find it. keep working
> on it, add templates so when an agent uses this vault, they also write down what they did/changed
> and what logical next steps would be. then commit and push changes to github, inspect the github to
> make sure it looks nice and everything got uploaded correctly"

**Scope decided:** find the moved vault; add the agent work-log / handoff templates plus the protocol
that makes them mandatory; wire them into the schema, maps, README and session-start prompt; run the
real checks; commit and push; verify the rendered repository. Not in scope: content notes, asset
verification, Studio work.

**Where the vault actually is:** `Desktop/kaffeins-dev-vault-v0.0.2/kaffeins-vault-v0.0.2` — the
git root is the inner folder. The old `Desktop/GameDev-Knowledge-Base` folder still exists and is
**empty**; `Downloads/Game-Dev-Vault-v1.0` is the original source package, untouched.

## 2. What I did

1. Located the vault and confirmed the git state: branch `main`, one commit `a907afc`, working tree
   clean, `origin/main` level with `main` (0 ahead / 0 behind).
2. Read the contract files before writing ([[AGENTS]], [[SCHEMA]], MOC-templates,
   MOC-agent-knowledge, [[CHANGELOG]], [[ISSUES]], [[NEXT_STEPS]]).
3. Found the gap: [[T-session-wrapup]] existed but nothing linked it to a location, nothing made it
   mandatory, and no session had ever left one — there was no record of what the previous session
   did beyond a `CHANGELOG` paragraph.
4. Added the work-log system: two templates, one protocol note, a `worklog` note type with the `WL`
   id prefix (`schema_version` 2), and a decision record.
5. Wired it in where an agent would actually look: README (contributing + folder map), NEXT_STEPS
   step 0, the session-start prompt, and the generated maps.
6. Ran the checks and regenerated the maps; committed and pushed; opened the repository in a browser
   to confirm the files render.
7. **Blocked:** the `AGENTS.md` edit was refused by the write guard (approval prompt timed out). The
   rules still bind agents through [[SCHEMA]] §11 and [[G-worklog-protocol]], but the two-line
   pointer in §2 and §6 of `AGENTS.md` is still missing. Logged as I-25 in [[ISSUES]].

## 3. What changed

| File | Change | Why | Verified by |
|---|---|---|---|
| `11 - Templates and Schemas/Templates/T-worklog.md` | added | session record: task, change table, real command output, next three steps | `validate` 0 errors; listed in regenerated MOC-templates |
| `11 - Templates and Schemas/Templates/T-handoff.md` | added | brief for work that stops mid-stream | `validate` 0 errors; listed in MOC-templates |
| `09 - AI Agent Knowledge/Work Log/G-worklog-protocol.md` | added | states when/where an entry is written and how it differs from CHANGELOG, STATUS and ISSUES | `validate` 0 errors; `search --type worklog` returns it |
| `09 - AI Agent Knowledge/Work Log/worklog-2026-11-01-worklog-templates.md` | added | this entry | `validate` counts it |
| `SCHEMA.md` | edited (WL prefix row, `worklog` in the type enum, new §11) | the type has to be legal before any note can use it | `validate`: 0 errors with 4 new notes |
| `config/vault.json` | `schema_version` 1→2, `worklog` in `note_types`, `worklog: WL` in `id_prefixes` | same reason; the validator reads this file | `validate` accepted `type: worklog` |
| `DECISIONS.md` | D-0010 added; dated update under D-0009 | record the decision and correct the now-wrong vault path | `validate` 0 errors |
| `README.md` | "what's inside" bullet, note count 490→494, contributing step 7, folder map line for 09 | the public entry point has to mention the log | rendered on GitHub (checked) |
| `NEXT_STEPS.md` | new step 0, "keep the habit" updated | newest work log outranks a stale handoff note | `validate` 0 errors |
| `09 - AI Agent Knowledge/PR-session-start.md` | closing rule and footer | the prompt that starts a session should end it too | `validate` 0 errors |
| `scripts/build_mocs.py` | two MOC intro strings (dropped the hardcoded "Sixteen", mention `Work Log/`) | a hardcoded count goes stale on the next note | `build_mocs.py` ran; 11 maps written |
| `00 - … /13 - … MOC-*.md` (11 files) | regenerated | the maps must list the new notes | `build_mocs.py`: written 11 · kept 0 |
| `13 - Dashboards/DB-*.md` (5 files) | regenerated (`report --write-dashboards`) | DB-health still quoted 471 notes; the views must match `report` | `report` 494 notes · 0 errors |
| `IMPORT_REPORT.md` | one paragraph reworded by the importer | the importer test in the suite rewrites it against the live root (new issue I-27) | `unittest`: 31 tests OK, incl. `created=0`, `unchanged=206` |
| `CHANGELOG.md` | dated entry | release-level record | `validate` 0 errors |
| `ISSUES.md` | I-25 (AGENTS.md still unedited), I-26 (no `gh` CLI), I-07/I-15 moved to Resolved | open items, not silent gaps; the git rows were false since the repo was pushed | `validate` 0 errors |
| `STATUS.md` | counts, validate/index/report lines, git and work-log lines | the status page quoted 488 notes and "no git repository" | `report` 494 notes; `validate` 502 / 0 errors |
| `AGENTS.md` | **not changed** | write guard refused; approval prompt timed out | see I-25 |

## 4. How I verified it

| Check | Command | Real result |
|---|---|---|
| validate | `python scripts/gamedev_kb.py validate` | 502 notes checked (8 fixtures excluded) · 0 errors · 0 warnings |
| index | `python scripts/gamedev_kb.py index` | indexed 502 notes, engine fts5, fingerprint `2749d4ba7b62debc` identical on the second run |
| maps | `python scripts/build_mocs.py` | written 11 · kept 0 |
| tests | `python -m unittest discover -s tests` | Ran 31 tests · OK |
| report | `python scripts/gamedev_kb.py report` | 494 notes · 0 errors · 0 broken links |
| rendering | repository opened in a browser | README, SCHEMA §11, both templates and the MOC rendering as Markdown |

**Not verified:** no Roblox Studio run (nothing here is Studio material). The GitHub *Pages* or any
external mirror is not in scope — only the repository view. `gh` CLI is not installed on this
machine, so all remote work went through `git` and the browser; `gh pr checks`-style verification was
not possible and none was claimed.

## 5. Decisions and assumptions

| # | Decision / assumption | Reason | Reversible? |
|---|---|---|---|
| 1 | Work logs are their own note type (`worklog`), not `report` | a type is filterable (`--type worklog`) and countable in `report`; overloading `report` would hide them | yes, but it would orphan the existing entries' frontmatter |
| 2 | One file per session, not one growing log | per-entry diffs stay reviewable in a pull request; a single file becomes a merge conflict | yes |
| 3 | Entries are append-only; corrections are new entries | history is evidence; rewriting it makes the record worthless | n/a by design |
| 4 | Template file names follow the existing `T-*.md` convention, although [[SCHEMA]] §8 still says `template-<kind>.md` | 16 existing templates use `T-`; matching them beats matching a stale line | yes — that SCHEMA line should be fixed instead |
| 5 | The vault root is the inner `kaffeins-vault-v0.0.2` folder, not its parent | `.git` and `config/vault.json` live there | no |

## 6. Open questions

- Does the owner want the `AGENTS.md` §2/§6 pointer added? It needs a human-approved write.
- Should the parent folder (`kaffeins-dev-vault-v0.0.2`, which holds `.obsidian/`, `IDEA.md`, the
  v0.0.1 copy and `referenceForBuilding/`) be inside the repository or stay untracked next to it?
  Today it is outside, so the published repo does not contain the v0.0.1 copy.
- `Desktop/GameDev-Knowledge-Base` is now an empty folder — delete it, or leave it as a tombstone?

## 7. Logical next steps

1. **Approve the 2-line `AGENTS.md` edit** — start at `AGENTS.md` §2 and §6 — done when `AGENTS.md`
   tells the reader to open the newest work log before writing and to write [[T-worklog]] after.
2. **Fix the naming contradiction** — start at `SCHEMA.md` §8 (`template-<kind>.md`) — done when
   §8 matches the `T-<kind>.md` files that actually exist, or the files are renamed with every
   `[[...]]` link updated and `validate` green.
3. **Clear the empty folder and decide the parent question** — start at `Desktop/GameDev-Knowledge-Base`
   — done when the folder is removed (or documented) and decision D-0009's parent-folder scope is
   confirmed by the owner.

Then return to the content work already queued in [[NEXT_STEPS]]: Studio verification of one recipe
and of the assets actually in use.

## 8. For the next agent

Read the newest file in `09 - AI Agent Knowledge/Work Log/` before touching anything; this entry is
the format, not a ritual. The expensive mistake to avoid is re-deriving the schema: check
`config/vault.json` and [[SCHEMA]] first — `type: worklog` and the `WL` prefix are legal since
schema v2. Do not edit `imports/raw/**` and do not mark anything `tested_studio` that was not run in
Studio. `AGENTS.md` needs the owner's approval to edit.

## 9. Post-push verification (added after the commit)

Pushed in this order, each verified with `git ls-remote origin` (returning the same hash for `HEAD`
and `refs/heads/main`) rather than by trusting the push output:

| Commit | Subject | Pushed |
|---|---|---|
| `13f1080` | docs(agents): add work log + handoff templates, worklog note type (schema v2) | `a907afc..13f1080` |
| `0006a3d` | docs(worklog): record post-push GitHub verification; note I-28 | `13f1080..0006a3d` |
| `cf8c279` | docs(release): mark the release checks that actually ran | `0006a3d..cf8c279` |

Each later commit is the previous one's honest correction; the record stops at `cf8c279`.

Checked in a browser on `github.com/kaffeindecaf/kaffeins-dev-vault`:

| Check | Observed |
|---|---|
| commits | 2 commits, newest `docs(agents): add work log + handoff templates, worklog note type (schema v2)` |
| root tree | all 14 numbered libraries plus `imports/`, `scripts/`, `tests/`, `config/`, `attachments/` |
| file count on the remote | 529 files (`git ls-tree -r origin/main`) |
| README | renders; 27 Mermaid SVG nodes drawn; sections and folder map intact |
| `09 - AI Agent Knowledge/Work Log/` | both files listed; the README's `blob` link redirects to `tree`, so the folder opens |
| MOC-agent-knowledge | lists `Work Log/ G-worklog-protocol` and `Work Log/ worklog-2026-11-01-…` with their types |
| SCHEMA.md | §11 "Agent work logs (schema_version: 2)" present and rendered |
| repository About | description, five topics (agent-skills, game-development, obsidian-vault, roblox, user-interface) and the CC0-1.0 licence badge already set |

**Cosmetic finding:** GitHub renders each note's YAML frontmatter as a table, and an inline list
(`tags: [a, b]`) shows up as stray half-rows. It affects every note in the vault equally, so it was
recorded as I-28 rather than fixed here — the fix is a 494-file frontmatter change, not a template change.
