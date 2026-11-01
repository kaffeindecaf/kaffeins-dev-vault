"""Automated tests for the knowledge-base tools.

    python -m unittest discover -s tests -v

Standard library only. Tests build a throwaway vault in the OS temp dir so the real vault is never
mutated, and a few read-only assertions run against the real vault.

Every assertion is on observable output (codes, records, exit status), not on "it did not crash".
"""

from __future__ import annotations

import csv
import json
import os
import shutil
import sqlite3
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CLI = ROOT / "scripts" / "gamedev_kb.py"
IMPORTER = ROOT / "scripts" / "import_assets.py"


def run(*args, cwd=None):
    """Run the CLI and return (exit_code, stdout, stderr)."""
    cmd = [sys.executable, str(CLI), *args]
    p = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace",
                       cwd=str(cwd or ROOT))
    return p.returncode, p.stdout, p.stderr


def run_json(*args):
    code, out, err = run(*args, "--json")
    try:
        return code, json.loads(out), err
    except json.JSONDecodeError as e:               # pragma: no cover - surfaces a real bug
        raise AssertionError(f"CLI did not emit JSON (exit {code}): {err[:400]}") from e


class TmpVault:
    """A minimal vault: config + a handful of notes + secret and symlink fixtures."""

    def __init__(self):
        self.dir = Path(tempfile.mkdtemp(prefix="gamedev_kb_test_"))
        (self.dir / "config").mkdir()
        (self.dir / "content").mkdir()
        cfg = {
            "project_name": "test-vault",
            "vault_root": ".",
            "exclude_dirs": [".git", ".obsidian", "imports", "exports", "__pycache__"],
            "exclude_globs": [".env", ".env.*", "*.key", "*.pem", "credentials*", "secrets*", "*.sqlite"],
            "index_path": "config/index.sqlite",
            "exports_dir": "exports",
            "required_frontmatter": ["id", "type", "title", "status", "updated", "tags"],
            "note_types": ["asset", "system", "bug", "guide", "moc", "reference", "template"],
            "statuses": ["idea", "draft", "reviewed", "tested", "deprecated"],
            "confidences": ["low", "medium", "high"],
            "verification": ["untested", "design_only", "reference_only", "tested_studio", "tested_published", "failed"],
            "asset_types": ["audio", "animation", "model", "decal", "image", "mesh", "plugin", "unknown"],
        }
        (self.dir / "config" / "vault.json").write_text(json.dumps(cfg), encoding="utf-8")

        self.note("door-note", "guide", "Wooden door creak guide",
                  "A door creak is a short friction sound at the hinge.\n"
                  "Use it when a door opens slowly.")
        self.note("pickup-note", "system", "Server authoritative pickup",
                  "The server decides pickup. The client only requests.\n"
                  "Validate distance and claim ownership before granting.")
        self.note("layout-note", "guide", "Button shifts when resizing",
                  "AnchorPoint and scale positions explain the drift.\n"
                  "A scale position needs a matching anchor.",
                  extra="tags: [ui, layout]\n")
        self.note("model-asset", "asset", "Candidate model",
                  "A model container, inserted by ID from the store.",
                  extra='asset_id: "1234567890"\nasset_type: model\nusage_uri: ""\nsource_grade: D\n')
        # secret + credential fixtures (must never be walked or indexed)
        (self.dir / ".env").write_text("API_KEY=sk-should-never-appear\n", encoding="utf-8")
        (self.dir / "content" / "fake-credentials.json").write_text('{"password":"nope"}\n', encoding="utf-8")
        (self.dir / "content" / "notes.key").write_text("PRIVATE KEY\n", encoding="utf-8")

    def note(self, stem, ntype, title, body, extra="", tags="[test]"):
        text = (f"---\nid: N-{stem}\ntype: {ntype}\ntitle: {title}\nstatus: draft\n"
                f"updated: 2026-11-01\ntags: {tags}\nsource_urls: []\n{extra}---\n\n# {title}\n\n{body}\n")
        (self.dir / "content" / f"{stem}.md").write_text(text, encoding="utf-8")

    def path(self, *p):
        return str(self.dir.joinpath(*p))

    def close(self):
        shutil.rmtree(self.dir, ignore_errors=True)


class TestSchemaValidation(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.v = TmpVault()

    @classmethod
    def tearDownClass(cls):
        cls.v.close()

    def test_valid_notes_produce_no_errors(self):
        code, payload, _ = run_json("validate", "--root", self.v.path())
        self.assertEqual(code, 0, payload.get("errors"))
        self.assertEqual(payload["errors"], [])

    def test_malformed_frontmatter_is_actionable(self):
        v = TmpVault()
        try:
            (v.dir / "content" / "broken.md").write_text("---\nid: N-broken\ntype: guide\n", encoding="utf-8")
            code, payload, _ = run_json("validate", "--root", v.path())
            codes = {e["code"] for e in payload["errors"]}
            self.assertEqual(code, 1)
            self.assertTrue({"unterminated_frontmatter"} & codes or "missing_field" in codes, codes)
        finally:
            v.close()

    def test_unsupported_yaml_is_rejected_not_misparsed(self):
        v = TmpVault()
        try:
            v.note("blockscalar", "guide", "Block scalar", "body",
                   extra="description: |\n  not supported\n")
            code, payload, _ = run_json("validate", "--root", v.path())
            self.assertIn("yaml_block_scalar_unsupported", {e["code"] for e in payload["errors"]})
        finally:
            v.close()

    def test_duplicate_ids_fail(self):
        v = TmpVault()
        try:
            v.note("dupe-a", "guide", "Dupe A", "body")
            (v.dir / "content" / "dupe-b.md").write_text(
                "---\nid: N-dupe-a\ntype: guide\ntitle: Dupe B\nstatus: draft\n"
                "updated: 2026-11-01\ntags: [x]\nsource_urls: []\n---\nbody\n", encoding="utf-8")
            code, payload, _ = run_json("validate", "--root", v.path())
            self.assertEqual(code, 1)
            self.assertIn("duplicate_id", {e["code"] for e in payload["errors"]})
        finally:
            v.close()

    def test_asset_id_must_be_string(self):
        v = TmpVault()
        try:
            v.note("intasset", "asset", "Int id", "body",
                   extra="asset_id: 7274920568\nasset_type: audio\n")
            code, payload, _ = run_json("validate", "--root", v.path())
            self.assertIn("asset_id_not_string", {e["code"] for e in payload["errors"]})
        finally:
            v.close()

    def test_model_cannot_carry_sound_uri(self):
        v = TmpVault()
        try:
            v.note("modelbad", "asset", "Model as sound", "body",
                   extra='asset_id: "111"\nasset_type: model\nusage_uri: "rbxassetid://111"\n')
            code, payload, _ = run_json("validate", "--root", v.path())
            self.assertIn("usage_uri_type_mismatch", {e["code"] for e in payload["errors"]})
        finally:
            v.close()

    def test_broken_wikilink_is_reported(self):
        v = TmpVault()
        try:
            v.note("linker", "guide", "Has a bad link", "See [[this-note-does-not-exist]] for more.")
            code, payload, _ = run_json("validate", "--root", v.path())
            broken = [w for w in payload["warnings"] if w["code"] == "broken_wikilink"]
            self.assertTrue(broken, payload["warnings"])
            self.assertEqual(broken[0]["detail"], "this-note-does-not-exist")
        finally:
            v.close()

    def test_links_inside_code_blocks_are_ignored(self):
        v = TmpVault()
        try:
            v.note("coder", "guide", "Code example", "```lua\nlocal x = \"[[not-a-link]]\"\n```\n")
            code, payload, _ = run_json("validate", "--root", v.path())
            self.assertEqual([w for w in payload["warnings"] if w["code"] == "broken_wikilink"], [])
        finally:
            v.close()


class TestSecurityBoundaries(unittest.TestCase):
    def test_secrets_are_not_walked_or_indexed(self):
        v = TmpVault()
        try:
            code, out, err = run("index", "--root", v.path())
            self.assertEqual(code, 0, err)
            con = sqlite3.connect(v.path("config", "index.sqlite"))
            rows = con.execute("SELECT path, body FROM notes").fetchall()
            con.close()
            joined = " ".join(f"{p} {b}" for p, b in rows).lower()
            self.assertNotIn("should-never-appear", joined)
            self.assertNotIn(".env", joined)
            self.assertNotIn("fake-credentials", joined)
            self.assertNotIn("notes.key", joined)

            code, payload, _ = run_json("export", "--root", v.path(), "--format", "json")
            exported = (Path(v.path("exports")) / "notes.json").read_text(encoding="utf-8")
            self.assertNotIn("should-never-appear", exported)

            code, payload, _ = run_json("doctor", "--root", v.path())
            self.assertGreater(payload["skipped_dirs_and_files"], 0, "secrets should be skipped")
        finally:
            v.close()

    def test_symlink_outside_vault_is_not_followed(self):
        v = TmpVault()
        outside = Path(tempfile.mkdtemp(prefix="gamedev_kb_outside_"))
        try:
            (outside / "secret-note.md").write_text(
                "---\nid: N-outside\ntype: guide\ntitle: Outside secret\nstatus: draft\n"
                "updated: 2026-11-01\ntags: [x]\nsource_urls: []\n---\nOUTSIDE-CONTENT\n", encoding="utf-8")
            link = v.dir / "content" / "linked-outside.md"
            try:
                os.symlink(outside / "secret-note.md", link)
            except (OSError, NotImplementedError):
                self.skipTest("symlink creation not permitted on this platform/account")
            code, payload, _ = run_json("validate", "--root", v.path())
            paths = [e["path"] for e in payload["errors"]] + [w["path"] for w in payload["warnings"]]
            self.assertNotIn("content/linked-outside.md", paths)
            run("index", "--root", v.path())
            con = sqlite3.connect(v.path("config", "index.sqlite"))
            bodies = [r[0] for r in con.execute("SELECT body FROM notes").fetchall()]
            con.close()
            self.assertNotIn("OUTSIDE-CONTENT", " ".join(bodies))
        finally:
            shutil.rmtree(outside, ignore_errors=True)
            v.close()

    def test_path_traversal_root_is_refused(self):
        """--root pointing at a directory without config/vault.json must fail, not wander."""
        code, out, err = run("doctor", "--root", str(ROOT / "scripts"))
        self.assertNotEqual(code, 0)
        self.assertIn("vault.json", (out + err).lower())


class TestSearchAndRetrieval(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.v = TmpVault()
        run("index", "--root", cls.v.path())

    @classmethod
    def tearDownClass(cls):
        cls.v.close()

    def test_search_returns_path_and_type(self):
        code, payload, _ = run_json("search", "door creak", "--root", self.v.path())
        self.assertEqual(code, 0)
        self.assertGreaterEqual(payload["count"], 1)
        top = payload["results"][0]
        self.assertEqual(top["path"], "content/door-note.md")
        self.assertEqual(top["type"], "guide")
        self.assertIn("id", top)

    def test_title_match_outranks_incidental_body_mention(self):
        # "creak" appears in the title of door-note and in the body of nothing else;
        # "door" appears in both titles, so check the ranked order is stable and sensible.
        code, payload, _ = run_json("search", "door creak", "--root", self.v.path(), "--limit", "5")
        self.assertEqual(payload["results"][0]["path"], "content/door-note.md")
        # a term that only appears in one body mentions nearer the end must not outrank a title hit
        code, payload, _ = run_json("search", "server authoritative pickup", "--root", self.v.path())
        self.assertEqual(payload["results"][0]["path"], "content/pickup-note.md")

    def test_type_filter(self):
        code, payload, _ = run_json("search", "pickup", "--root", self.v.path(), "--type", "system")
        self.assertTrue(all(r["type"] == "system" for r in payload["results"]))

    def test_asset_lookup_is_exact_and_string_preserving(self):
        v = TmpVault()
        try:
            v.note("leadingzero", "asset", "Leading zero asset", "body",
                   extra='asset_id: "0012345678"\nasset_type: audio\nusage_uri: "rbxassetid://0012345678"\n')
            run("index", "--root", v.path())
            code, payload, _ = run_json("asset", "0012345678", "--root", v.path())
            self.assertEqual(code, 0)
            self.assertTrue(payload["found"])
            self.assertEqual(payload["matches"][0]["asset_id"], "0012345678")
        finally:
            v.close()

    def test_unknown_asset_is_not_invented(self):
        code, payload, _ = run_json("asset", "999999999999", "--root", self.v.path())
        self.assertEqual(code, 1)
        self.assertFalse(payload["found"])
        self.assertNotIn("matches", payload)

    def test_non_numeric_asset_query_is_refused(self):
        code, payload, _ = run_json("asset", "door-creak", "--root", self.v.path())
        self.assertEqual(code, 2)
        self.assertFalse(payload["found"])

    def test_fallback_engine_when_fts_table_missing(self):
        con = sqlite3.connect(self.v.path("config", "index.sqlite"))
        con.execute("DROP TABLE notes_fts")
        con.commit()
        con.close()
        code, payload, _ = run_json("search", "door creak", "--root", self.v.path())
        self.assertEqual(code, 0)
        self.assertEqual(payload["engine"], "fallback")
        self.assertGreaterEqual(payload["count"], 1)
        run("index", "--root", self.v.path())      # restore for other tests

    def test_corrupt_index_recovers_without_inventing_results(self):
        idx = self.v.path("config", "index.sqlite")
        good = Path(idx).read_bytes()
        try:
            Path(idx).write_bytes(b"this is not a sqlite database at all")
            code, out, err = run("search", "door creak", "--root", self.v.path())
            self.assertEqual(code, 2)
            self.assertIn("index", (out + err).lower())
            code, out, err = run("index", "--root", self.v.path())
            self.assertEqual(code, 0)
            code, payload, _ = run_json("search", "door creak", "--root", self.v.path())
            self.assertGreaterEqual(payload["count"], 1)
        finally:
            run("index", "--root", self.v.path())

    def test_index_is_idempotent(self):
        first = run_json("index", "--root", self.v.path())[1]
        second = run_json("index", "--root", self.v.path())[1]
        self.assertEqual(first["sha"], second["sha"])
        self.assertEqual(first["notes"], second["notes"])

    def test_context_pack_is_cited_and_budgeted(self):
        code, out, _ = run("context", "server authoritative pickup", "--root", self.v.path(), "--budget", "1200")
        self.assertEqual(code, 0)
        self.assertIn("content/pickup-note.md", out)
        self.assertIn("approximate", out.lower())

    def test_export_json_and_csv_are_stable_and_exact(self):
        run("export", "--root", self.v.path(), "--format", "json")
        run("export", "--root", self.v.path(), "--format", "csv")
        j = json.loads((Path(self.v.path("exports")) / "notes.json").read_text(encoding="utf-8"))
        paths = [r["path"] for r in j["records"]]
        self.assertEqual(paths, sorted(paths), "export order must be deterministic")
        with (Path(self.v.path("exports")) / "notes.csv").open(encoding="utf-8", newline="") as fh:
            rows = list(csv.DictReader(fh))
        self.assertEqual(len(rows), len(j["records"]))
        by_path = {r["path"]: r for r in rows}
        self.assertEqual(by_path["content/model-asset.md"]["asset_id"], "1234567890")


class TestRealVault(unittest.TestCase):
    """Read-only assertions against the actual knowledge base."""

    def test_vault_validates_clean(self):
        code, payload, err = run_json("validate")
        self.assertEqual(code, 0, f"{len(payload.get('errors', []))} errors: {payload.get('errors')[:5]}")
        self.assertGreater(payload["notes"], 400)

    def test_every_asset_id_is_a_string_in_the_index(self):
        con = sqlite3.connect(str(ROOT / "config" / "index.sqlite"))
        rows = con.execute("SELECT asset_id, typeof(asset_id) FROM notes WHERE type='asset'").fetchall()
        con.close()
        self.assertTrue(rows)
        for aid, t in rows:
            self.assertEqual(t, "text", f"asset_id stored as {t}: {aid!r}")

    def test_models_never_expose_a_sound_uri(self):
        bad = []
        for p in (ROOT / "01 - Asset Library" / "Models").glob("asset-*.md"):
            text = p.read_text(encoding="utf-8")
            head = text.split("---")[1]
            if "asset_type: model" in head and "usage_uri: \"rbxassetid" in head:
                bad.append(p.name)
        self.assertEqual(bad, [], "a model must not carry a SoundId-style usage_uri")

    def test_every_imported_asset_is_untested(self):
        offenders = []
        for p in (ROOT / "01 - Asset Library").rglob("asset-*.md"):
            head = p.read_text(encoding="utf-8").split("---")[1]
            if "verification: tested_studio" in head:
                offenders.append(p.name)
        self.assertEqual(offenders, [], "no asset may claim a Studio test in a build that ran none")

    def test_d_source_grade_never_implies_access(self):
        offenders = []
        for p in (ROOT / "01 - Asset Library" / "Audio").glob("asset-*.md"):
            head = p.read_text(encoding="utf-8").split("---")[1]
            if "source_grade: D" in head and "access_status: unknown" not in head:
                offenders.append(p.name)
        self.assertEqual(offenders, [])

    def test_home_links_all_resolve(self):
        stems = {p.stem.lower() for p in ROOT.rglob("*.md")}
        import re
        text = (ROOT / "HOME.md").read_text(encoding="utf-8")
        links = re.findall(r"\[\[([^\]\|#]+)", text)
        missing = [l for l in links if l.strip().lower() not in stems]
        self.assertEqual(missing, [])

    def test_search_door_creak_finds_real_assets_with_caveats(self):
        code, payload, _ = run_json("search", "door creak", "--type", "asset", "--limit", "5")
        self.assertEqual(code, 0)
        self.assertGreaterEqual(payload["count"], 1)
        self.assertTrue(payload["caveats"], "asset results must carry the untested caveat")
        for r in payload["results"]:
            self.assertTrue(r["path"].startswith("01 - Asset Library/"))

    def test_search_responsive_ui_question_finds_the_troubleshooting_note(self):
        code, payload, _ = run_json("search", "button shifts when resizing", "--limit", "5")
        self.assertEqual(code, 0)
        paths = [r["path"] for r in payload["results"]]
        self.assertTrue(any("G-ui-buttons-drift" in p for p in paths), paths)

    def test_import_is_idempotent(self):
        p = subprocess.run([sys.executable, str(IMPORTER)], capture_output=True, text=True,
                           encoding="utf-8", errors="replace", cwd=str(ROOT))
        self.assertEqual(p.returncode, 0, p.stderr)
        self.assertIn("created=0", p.stdout)
        self.assertIn("unchanged=206", p.stdout)


if __name__ == "__main__":
    unittest.main(verbosity=2)
