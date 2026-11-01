#!/usr/bin/env python3
"""gamedev_kb — local search, validation and retrieval for a GameDev knowledge vault.

Standard library only (no pip installs). Cross-platform: Windows, Linux, macOS.
Every command is read-only except `index`, `export` and `report --write-dashboards`,
which only write inside config/ and exports/ of the vault root.

Exit codes: 0 success, 1 validation/quality errors, 2 usage or safety refusal.
"""

from __future__ import annotations

import argparse
import csv
import datetime as _dt
import hashlib
import io
import json
import os
import re
import shutil
import sqlite3
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

SCHEMA_DEFAULT_VERSION = 1
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
WIKILINK_RE = re.compile(r"\[\[([^\]\|#]+)(?:#[^\]\|]*)?(?:\|[^\]]*)?\]\]")
DIGITS_RE = re.compile(r"^\d{1,20}$")


# --------------------------------------------------------------------------- config


class Config:
    def __init__(self, root: Path | None = None):
        self.root = (root or Path(__file__).resolve().parent.parent).resolve()
        cfg_path = self.root / "config" / "vault.json"
        if not cfg_path.is_file():
            raise SystemExit(f"fatal: missing config/vault.json under {self.root}")
        raw = json.loads(cfg_path.read_text(encoding="utf-8"))
        self.raw = raw
        self.exclude_dirs = set(raw.get("exclude_dirs", []))
        self.exclude_globs = [g.lower() for g in raw.get("exclude_globs", [])]
        self.index_path = (self.root / raw.get("index_path", "config/index.sqlite")).resolve()
        self.exports_dir = (self.root / raw.get("exports_dir", "exports")).resolve()
        self.required = raw.get("required_frontmatter", ["id", "type", "title", "status", "updated", "tags"])
        self.note_types = set(raw.get("note_types", []))
        self.statuses = set(raw.get("statuses", []))
        self.confidences = set(raw.get("confidences", []))
        self.verifications = set(raw.get("verification", []))
        self.asset_types = set(raw.get("asset_types", []))
        self.id_prefixes = raw.get("id_prefixes", {})
        self.content_roots = raw.get("content_roots", [])

    # -- path safety -------------------------------------------------------
    def inside(self, p: Path) -> bool:
        try:
            p.resolve().relative_to(self.root)
            return True
        except (ValueError, OSError):
            return False

    def is_excluded_file(self, name: str) -> bool:
        n = name.lower()
        for g in self.exclude_globs:
            if g.startswith("*.") and n.endswith(g[1:]):
                return True
            if "*" in g and g.replace("*", "") in n:
                return True
            if n == g or n.startswith(g.rstrip("*")):
                return True
        return False


# --------------------------------------------------------------------- frontmatter

class YamlError(ValueError):
    pass


def _scalar(v: str):
    v = v.strip()
    if v == "":
        return None
    if (v[0] == v[-1]) and v[0] in "'\"" and len(v) >= 2:
        q = v[0]
        inner = v[1:-1]
        return inner.replace(q * 2, q) if q == "'" else inner.replace('\\"', '"')
    if v in ("null", "~"):
        return None
    if v.lower() in ("true", "false"):
        return v.lower() == "true"
    if re.fullmatch(r"-?\d+", v):
        return int(v)
    if re.fullmatch(r"-?\d+\.\d+", v):
        return float(v)
    return v


def _inline_list(v: str):
    inner = v.strip()[1:-1].strip()
    if not inner:
        return []
    out, buf, q = [], "", None
    for ch in inner:
        if q:
            buf += ch
            if ch == q:
                q = None
        elif ch in "'\"":
            q = ch
            buf += ch
        elif ch == ",":
            out.append(_scalar(buf))
            buf = ""
        else:
            buf += ch
    if buf.strip():
        out.append(_scalar(buf))
    return out


def parse_frontmatter(text: str):
    """Restricted YAML subset parser. Returns (meta, body, problems)."""
    problems: list[str] = []
    if not text.startswith("---"):
        return {}, text, ["no_frontmatter"]
    lines = text.splitlines()
    end = None
    for i in range(1, len(lines)):
        if lines[i].strip() in ("---", "..."):
            end = i
            break
    if end is None:
        return {}, text, ["unterminated_frontmatter"]
    block = lines[1:end]
    body = "\n".join(lines[end + 1:])
    meta: dict = {}
    key = None
    for raw_line in block:
        line = raw_line.rstrip()
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line.startswith("\t"):
            problems.append("tab_indent")
        stripped = line.strip()
        if stripped.startswith("- "):
            if key is None:
                problems.append("list_without_key")
                continue
            if not isinstance(meta.get(key), list):
                meta[key] = []
            meta[key].append(_scalar(stripped[2:]))
            continue
        m = re.match(r"^([A-Za-z0-9_\-\.]+):\s*(.*)$", stripped)
        if not m:
            problems.append(f"yaml_unsupported_line:{stripped[:40]}")
            continue
        k, v = m.group(1), m.group(2)
        if v in ("|", ">", "|-", ">-"):
            problems.append("yaml_block_scalar_unsupported")
            meta[k] = None
            key = None
            continue
        if "&" in v and v.startswith("&"):
            problems.append("yaml_anchor_unsupported")
        if v.startswith("[") and v.endswith("]"):
            meta[k] = _inline_list(v)
        elif v == "":
            meta[k] = None
            key = k
            continue
        elif v.startswith("{") and v.endswith("}"):
            inner = v[1:-1].strip()
            d = {}
            if inner:
                for part in inner.split(","):
                    if ":" in part:
                        pk, pv = part.split(":", 1)
                        d[pk.strip()] = _scalar(pv)
            meta[k] = d
        else:
            meta[k] = _scalar(v)
        key = k
    return meta, body, problems


# ------------------------------------------------------------------------- walker

class Note:
    __slots__ = ("path", "rel", "meta", "body", "problems", "raw")

    def __init__(self, path: Path, rel: str, meta, body, problems, raw):
        self.path, self.rel, self.meta, self.body = path, rel, meta, body
        self.problems, self.raw = problems, raw

    @property
    def id(self):
        return str(self.meta.get("id") or "")

    @property
    def type(self):
        return str(self.meta.get("type") or "")

    @property
    def title(self):
        return str(self.meta.get("title") or self.path.stem)

    @property
    def tags(self):
        t = self.meta.get("tags")
        return [str(x) for x in t] if isinstance(t, list) else ([str(t)] if t else [])

    def as_dict(self):
        m = self.meta
        return {
            "id": self.id,
            "path": self.rel,
            "type": self.type,
            "title": self.title,
            "status": str(m.get("status") or ""),
            "verification": str(m.get("verification") or "untested"),
            "confidence": str(m.get("confidence") or ""),
            "tags": self.tags,
            "category": str(m.get("category") or ""),
            "asset_id": str(m["asset_id"]) if m.get("asset_id") is not None else "",
            "asset_type": str(m.get("asset_type") or ""),
            "source_grade": str(m.get("source_grade") or ""),
            "updated": str(m.get("updated") or ""),
            "source_urls": m.get("source_urls") if isinstance(m.get("source_urls"), list) else [],
        }


def walk_notes(cfg: Config, extra_skip=()):
    """Deterministic, confined walker. Skips symlinks and excluded paths."""
    out, skipped = [], []
    root = cfg.root
    for dirpath, dirnames, filenames in os.walk(root, followlinks=False):
        d = Path(dirpath)
        keep = []
        for name in sorted(dirnames):
            sub = d / name
            if name in cfg.exclude_dirs or name.startswith(".") or name in extra_skip:
                skipped.append(str(sub.relative_to(root)).replace("\\", "/") + "/")
                continue
            if sub.is_symlink():
                skipped.append("symlink:" + str(sub.relative_to(root)).replace("\\", "/"))
                continue
            keep.append(name)
        dirnames[:] = keep
        for name in sorted(filenames):
            p = d / name
            rel = str(p.relative_to(root)).replace("\\", "/")
            if not name.lower().endswith(".md"):
                continue
            if cfg.is_excluded_file(name):
                skipped.append(rel)
                continue
            if p.is_symlink():
                skipped.append("symlink:" + rel)
                continue
            if not cfg.inside(p):
                skipped.append("outside:" + rel)
                continue
            try:
                text = p.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                text = p.read_text(encoding="utf-8", errors="replace")
            meta, body, probs = parse_frontmatter(text)
            out.append(Note(p, rel, meta, body, probs, text))
    out.sort(key=lambda n: n.rel)
    return out, skipped


# ----------------------------------------------------------------------- validate

def validate(cfg: Config, notes: list[Note]):
    errors, warnings = [], []
    seen_ids: dict[str, str] = {}
    stems: dict[str, str] = {}
    fixtures = 0
    for n in notes:
        if str(n.meta.get("fixture") or "").lower() == "true":
            fixtures += 1
            continue          # negative-control fixtures are asserted by tests/, not by the vault check
        def err(code, detail=""):
            errors.append({"path": n.rel, "code": code, "detail": detail})

        def warn(code, detail=""):
            warnings.append({"path": n.rel, "code": code, "detail": detail})

        for p in n.problems:
            if p == "no_frontmatter":
                warn("no_frontmatter", "note has no YAML frontmatter")
            elif p.startswith("yaml_unsupported_line") or p in (
                "yaml_block_scalar_unsupported", "yaml_anchor_unsupported", "tab_indent",
                "unterminated_frontmatter", "list_without_key"):
                err(p.split(":")[0], p)
            else:
                warn(p, p)

        for field in cfg.required:
            if n.meta.get(field) in (None, "", []):
                if field == "source_urls" and n.type in ("moc", "dashboard"):
                    continue
                err("missing_field", field)
        if n.type and cfg.note_types and n.type not in cfg.note_types:
            err("bad_type", n.type)
        if n.meta.get("status") and cfg.statuses and str(n.meta["status"]) not in cfg.statuses:
            err("bad_status", str(n.meta["status"]))
        if n.meta.get("confidence") and str(n.meta["confidence"]) not in cfg.confidences:
            err("bad_confidence", str(n.meta["confidence"]))
        ver = str(n.meta.get("verification") or "")
        if ver and cfg.verifications and ver not in cfg.verifications:
            err("bad_verification", ver)
        if ver.startswith("tested_") and not n.meta.get("test_evidence"):
            warn("tested_without_evidence", ver)

        upd = str(n.meta.get("updated") or "")
        if upd and not DATE_RE.match(upd):
            err("bad_date", upd)
        elif upd:
            try:
                _dt.date.fromisoformat(upd)
            except ValueError:
                err("bad_date", upd)

        if n.id:
            if n.id in seen_ids:
                err("duplicate_id", f"{n.id} also in {seen_ids[n.id]}")
            else:
                seen_ids[n.id] = n.rel

        stem = n.path.stem.lower()
        if stem in stems:
            err("duplicate_filename", f"collides case-insensitively with {stems[stem]}")
        else:
            stems[stem] = n.rel

        if n.type == "asset":
            aid = n.meta.get("asset_id")
            if aid is None:
                err("asset_missing_id", "asset note without asset_id")
            elif not isinstance(aid, str):
                err("asset_id_not_string", f"{type(aid).__name__}: {aid!r}")
            elif not DIGITS_RE.match(aid):
                err("asset_id_not_digits", aid)
            at = str(n.meta.get("asset_type") or "")
            if at and cfg.asset_types and at not in cfg.asset_types:
                err("bad_asset_type", at)
            uri = str(n.meta.get("usage_uri") or "")
            if uri:
                ok = (at in ("audio", "animation") and uri.startswith("rbxassetid://")) or (
                    at not in ("audio", "animation") and not uri.startswith("rbxassetid://"))
                if not ok:
                    err("usage_uri_type_mismatch", f"{at} vs {uri}")
            if str(n.meta.get("access_status") or "unknown") not in ("unknown", "shared", "restricted", "blocked"):
                err("bad_access_status", str(n.meta.get("access_status")))
            if str(n.meta.get("access_status") or "unknown") != "unknown" and not n.meta.get("access_evidence"):
                warn("access_claim_without_evidence", n.rel)
        if (n.type == "reference" and not n.meta.get("source_urls")
                and str(n.meta.get("verification") or "") == "reference_only"):
            warn("reference_without_sources", "reference_only note has no source_urls")

    existing = {n.path.stem.lower() for n in notes}
    broken = []
    fence = re.compile(r"```.*?```", re.S)
    for n in notes:
        prose = re.sub(r"`[^`\n]*`", " ", fence.sub(" ", n.raw))   # inline code is an example, not a link
        for target in WIKILINK_RE.findall(prose):
            t = target.strip().lower()
            if t and t not in existing and not t.endswith(".md"):
                broken.append({"path": n.rel, "target": target.strip()})
    for b in broken:
        warnings.append({"path": b["path"], "code": "broken_wikilink", "detail": b["target"]})
    dedup = {(w["path"], w["code"], w["detail"]) for w in warnings}
    warnings = [{"path": p, "code": c, "detail": d} for (p, c, d) in sorted(dedup)]
    return errors, warnings, fixtures


# -------------------------------------------------------------------------- index

def build_index(cfg: Config, notes: list[Note]):
    cfg.index_path.parent.mkdir(parents=True, exist_ok=True)
    tmp = cfg.index_path.with_suffix(".tmp.sqlite")
    if tmp.exists():
        tmp.unlink()
    fts = True
    con = sqlite3.connect(tmp)
    try:
        con.executescript(
            """
            CREATE TABLE notes(
                note_id TEXT, path TEXT, type TEXT, title TEXT, status TEXT,
                verification TEXT, tags TEXT, category TEXT, asset_id TEXT,
                asset_type TEXT, source_grade TEXT, updated TEXT, body TEXT
            );
            """
        )
        try:
            con.execute("CREATE VIRTUAL TABLE notes_fts USING fts5(title, tags, body, path, tokenize='porter unicode61')")
        except sqlite3.OperationalError:
            fts = False
        rows = []
        for n in notes:
            d = n.as_dict()
            body = n.body
            rows.append((d["id"], d["path"], d["type"], d["title"], d["status"], d["verification"],
                         " ".join(d["tags"]), d["category"], d["asset_id"], d["asset_type"],
                         d["source_grade"], d["updated"], body))
        con.executemany("INSERT INTO notes VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", rows)
        if fts:
            con.executemany(
                "INSERT INTO notes_fts(rowid, title, tags, body, path) VALUES (?,?,?,?,?)",
                [(i + 1, r[3], r[6], r[12], r[1]) for i, r in enumerate(rows)],
            )
        con.commit()
        meta = {"built_at": _dt.datetime.now().isoformat(timespec="seconds"),
                "notes": len(rows), "engine": "fts5" if fts else "fallback",
                "sha": hashlib.sha256("\n".join(r[1] for r in rows).encode()).hexdigest()[:16]}
        con.execute("CREATE TABLE IF NOT EXISTS meta(k TEXT PRIMARY KEY, v TEXT)")
        con.executemany("INSERT OR REPLACE INTO meta VALUES (?,?)", [(k, str(v)) for k, v in meta.items()])
        con.commit()
    finally:
        con.close()
    os.replace(tmp, cfg.index_path)
    return meta


def _tokens(q: str):
    return [t for t in re.findall(r"[A-Za-z0-9_]+", q.lower()) if len(t) > 1]


def search_index(cfg: Config, query: str, limit=10, type_filter=None, category=None, status=None):
    """Returns (results, engine). Falls back to the notes table if FTS is missing."""
    if not cfg.index_path.is_file():
        return [], "no_index"
    try:
        con = sqlite3.connect(cfg.index_path)
        con.row_factory = sqlite3.Row
    except sqlite3.Error:
        return [], "corrupt_index"
    try:
        engine = "fts5"
        try:
            con.execute("SELECT count(*) FROM notes_fts").fetchone()
        except sqlite3.OperationalError:
            engine = "fallback"
        toks = _tokens(query)
        rows = []
        if engine == "fts5" and toks:
            match = " OR ".join(f'"{t}"*' for t in toks)
            sql = ("SELECT n.*, bm25(notes_fts, 12.0, 6.0, 1.0, 2.0) AS rank "
                   "FROM notes_fts JOIN notes n ON n.rowid = notes_fts.rowid "
                   "WHERE notes_fts MATCH ? ")
            params: list = [match]
            if type_filter: sql += "AND n.type = ? "; params.append(type_filter)
            if category: sql += "AND n.category LIKE ? "; params.append(f"%{category}%")
            if status: sql += "AND n.status = ? "; params.append(status)
            sql += "ORDER BY rank LIMIT ?"
            params.append(limit * 6)
            rows = con.execute(sql, params).fetchall()
        if not rows:
            if engine == "fts5":
                engine = "fallback"
            rows = _fallback_rows(con, toks, limit * 6, type_filter, category, status, query)

        scored = []
        ql = query.lower()
        for r in rows:
            title, tags, body = (r["title"] or ""), (r["tags"] or ""), (r["body"] or "")
            base = -(r["rank"] or 0) if engine == "fts5" else (r["rank"] or 0)
            score = float(base)
            tl, bl, tgl = title.lower(), body.lower(), tags.lower()
            if ql and ql in tl: score += 40
            if all(t in tl for t in toks): score += 30
            elif any(t in tl for t in toks): score += 8
            if all(t in tgl for t in toks): score += 20
            if all(t in bl for t in toks): score += 6
            snip = _snippet(body, toks)
            scored.append({
                "id": r["note_id"], "path": r["path"], "type": r["type"], "title": title,
                "status": r["status"], "verification": r["verification"] or "untested",
                "category": r["category"] or "", "asset_id": r["asset_id"] or "",
                "asset_type": r["asset_type"] or "", "source_grade": r["source_grade"] or "",
                "snippet": snip, "score": round(score, 3),
            })
        scored.sort(key=lambda x: (-x["score"], x["path"]))
        return scored[:limit], engine
    except sqlite3.DatabaseError:
        return [], "corrupt_index"      # a half-written or foreign file: never return invented rows
    finally:
        con.close()


def _fallback_rows(con, toks, limit, type_filter, category, status, query):
    sql = "SELECT notes.*, 0 AS rank FROM notes WHERE 1=1 "
    params: list = []
    if type_filter: sql += "AND type = ? "; params.append(type_filter)
    if category: sql += "AND category LIKE ? "; params.append(f"%{category}%")
    if status: sql += "AND status = ? "; params.append(status)
    rows = con.execute(sql, params).fetchall()
    out = []
    ql = query.lower()
    for r in rows:
        hay = f"{r['title']} {r['tags']} {r['body']}".lower()
        score = 0
        for t in toks:
            score += hay.count(t)
        if ql in hay:
            score += 5
        if score:
            row = dict(r)
            row["rank"] = score
            out.append(row)
    class R(dict):
        def __getitem__(self, k): return dict.__getitem__(self, k)
    out.sort(key=lambda x: -x["rank"])
    return [R(x) for x in out[:limit]]


def _snippet(body: str, toks, width=180):
    """Return the most query-relevant line of the note, trimmed to `width`.

    Picking the *best* line (most distinct terms) rather than the first match keeps snippets
    readable: an early mention of one term in a table cell is rarely the useful paragraph.
    """
    lines = [re.sub(r"\s+", " ", ln).strip() for ln in body.lstrip().splitlines()]
    if lines and lines[0].startswith("#"):
        lines = lines[1:]
    best, best_score = "", -1
    for ln in lines:
        if not ln or ln.startswith(("---", "|", "Related:", "Source:", "Sources:", "- [")):
            continue    # structural lines match terms but explain nothing
        low = ln.lower()
        score = sum(1 for t in toks if t in low)
        if score > best_score or (score == best_score and best_score > 0 and len(ln) > len(best)):
            best, best_score = ln, score
    if not best:
        best = next((ln for ln in lines if ln and not ln.startswith("---")), "")
    if len(best) <= width:
        return best
    low = best.lower()
    pos = min((low.find(t) for t in toks if t in low), default=0)
    start = max(0, pos - width // 3)
    return ("…" if start else "") + best[start:start + width].strip() + "…"


# ------------------------------------------------------------------------- output

def emit(obj, as_json):
    if as_json:
        print(json.dumps(obj, indent=2, ensure_ascii=False))
        return
    for r in obj.get("results", []):
        print(f"[{r.get('score')}] {r['title']}  ({r['type']}{'/' + r['verification'] if r['verification'] else ''})")
        print(f"      {r['path']}  id={r['id']}" + (f"  asset={r['asset_id']}" if r.get("asset_id") else ""))
        if r.get("snippet"):
            print(f"      {r['snippet']}")
    for w in obj.get("warnings", [])[:60]:
        print(f"WARN  {w['path']}: {w['code']} {w['detail']}")
    for e in obj.get("errors", []):
        print(f"ERROR {e['path']}: {e['code']} {e['detail']}")


# ----------------------------------------------------------------------- commands

def cmd_doctor(cfg: Config, args):
    notes, skipped = walk_notes(cfg)
    fts = False
    try:
        c = sqlite3.connect(":memory:")
        c.execute("CREATE VIRTUAL TABLE t USING fts5(x)")
        fts = True
        c.close()
    except sqlite3.OperationalError:
        fts = False
    idx = None
    if cfg.index_path.is_file():
        try:
            con = sqlite3.connect(cfg.index_path)
            idx = dict(con.execute("SELECT k, v FROM meta").fetchall())
            con.close()
        except sqlite3.Error as e:
            idx = {"error": str(e)}
    info = {
        "vault_root": str(cfg.root),
        "vault_root_exists": cfg.root.is_dir(),
        "python": sys.version.split()[0],
        "sqlite": sqlite3.sqlite_version,
        "fts5": fts,
        "markdown_notes": len(notes),
        "notes_with_frontmatter": sum(1 for n in notes if n.meta),
        "asset_notes": sum(1 for n in notes if n.type == "asset"
                           and str(n.meta.get("fixture") or "").lower() != "true"),
        "test_fixtures": sum(1 for n in notes if str(n.meta.get("fixture") or "").lower() == "true"),
        "skipped_dirs_and_files": len(skipped),
        "index": idx,
        "exports_dir": str(cfg.exports_dir),
        "git": shutil.which("git") is not None,
        "obsidian_cli": shutil.which("obsidian") is not None,
        "platform": sys.platform,
    }
    if args.json:
        emit(info, True)
    else:
        print(f"vault root      {info['vault_root']}  (exists: {info['vault_root_exists']})")
        print(f"python          {info['python']}   sqlite {info['sqlite']}   fts5: {'yes' if fts else 'NO (fallback)'}")
        print(f"notes           {info['markdown_notes']} markdown ({info['test_fixtures']} test fixtures), "
              f"{info['asset_notes']} assets, {info['notes_with_frontmatter']} with frontmatter")
        print(f"skipped         {info['skipped_dirs_and_files']} excluded paths (imports/, exports/, .obsidian, secrets)")
        print(f"index           {info['index'] if idx else 'not built — run: python scripts/gamedev_kb.py index'}")
        print(f"tools           git: {'yes' if info['git'] else 'no'}   obsidian cli: {'yes' if info['obsidian_cli'] else 'no'}")
    return 0


def cmd_validate(cfg: Config, args):
    notes, skipped = walk_notes(cfg)
    errors, warnings, fixtures = validate(cfg, notes)
    counts: dict[str, int] = {}
    for e in errors:
        counts[e["code"]] = counts.get(e["code"], 0) + 1
    payload = {"notes": len(notes), "errors": errors, "warnings": warnings,
               "error_counts": counts, "skipped": len(skipped), "fixtures": fixtures}
    if args.json:
        emit(payload, True)
    else:
        emit({"errors": errors, "warnings": warnings}, False)
        print(f"\n{len(notes)} notes checked ({fixtures} test fixtures excluded) · "
              f"{len(errors)} errors · {len(warnings)} warnings")
        if counts:
            print("errors by code: " + ", ".join(f"{k}={v}" for k, v in sorted(counts.items())))
    return 1 if errors else 0


def cmd_index(cfg: Config, args):
    notes, _ = walk_notes(cfg)
    meta = build_index(cfg, notes)
    if args.json:
        emit(meta, True)
    else:
        print(f"indexed {meta['notes']} notes into {cfg.index_path} (engine: {meta['engine']})")
        print(f"fingerprint {meta['sha']} — a second run over unchanged files produces the same value")
    return 0


def cmd_search(cfg: Config, args):
    if not cfg.index_path.is_file():
        print("no index yet — run: python scripts/gamedev_kb.py index", file=sys.stderr)
        return 2
    results, engine = search_index(cfg, args.query, args.limit, args.type, args.category, args.status)
    if engine in ("no_index", "corrupt_index"):
        print(f"{engine}: run: python scripts/gamedev_kb.py index", file=sys.stderr)
        return 2
    warn = []
    for r in results:
        if r["type"] == "asset":
            if r["verification"] in ("untested", ""):
                warn.append(f"{r['id']}: untested candidate — listing is not a permission")
    payload = {"query": args.query, "engine": engine, "count": len(results),
               "results": results, "caveats": warn}
    if args.json:
        emit(payload, True)
    else:
        emit(payload, False)
        print(f"\n{len(results)} result(s), engine={engine}")
        if warn:
            print("! " + "\n! ".join(warn[:6]))
    return 0


def cmd_asset(cfg: Config, args):
    raw = str(args.asset_id).strip()
    if not DIGITS_RE.match(raw):
        payload = {"query": raw, "found": False, "error": "not a valid asset ID (digits only)"}
        emit(payload, args.json) if args.json else print(f"not a valid asset ID: {raw!r} (digits only)")
        return 2
    if not cfg.index_path.is_file():
        print("no index yet — run: python scripts/gamedev_kb.py index", file=sys.stderr)
        return 2
    con = sqlite3.connect(cfg.index_path)
    con.row_factory = sqlite3.Row
    rows = con.execute("SELECT * FROM notes WHERE asset_id = ? ORDER BY path", (raw,)).fetchall()
    con.close()
    if not rows:
        payload = {"query": raw, "found": False}
        if args.json:
            emit(payload, True)
        else:
            print(f"no asset with ID {raw} in this vault. Not inventing one.")
        return 1
    out = []
    for r in rows:
        out.append({"id": r["note_id"], "path": r["path"], "title": r["title"],
                    "asset_id": r["asset_id"], "asset_type": r["asset_type"],
                    "source_grade": r["source_grade"], "verification": r["verification"]})
    payload = {"query": raw, "found": True, "matches": out}
    if args.json:
        emit(payload, True)
    else:
        for r in out:
            print(f"{r['asset_id']}  {r['title']}  ({r['asset_type']}, grade {r['source_grade']})")
            print(f"  note   {r['path']}")
            print(f"  status {r['verification']} — ID known, access/permission unverified")
    return 0


def cmd_context(cfg: Config, args):
    if not cfg.index_path.is_file():
        print("no index yet — run: python scripts/gamedev_kb.py index", file=sys.stderr)
        return 2
    results, engine = search_index(cfg, args.query, args.count, args.type, args.category, args.status)
    budget = args.budget
    used, blocks = 0, []
    for r in results:
        note_path = cfg.root / r["path"]
        try:
            text = note_path.read_text(encoding="utf-8")
        except OSError:
            continue
        _, body, _ = parse_frontmatter(text)
        excerpt = body.strip()
        if len(excerpt) > 1400:
            excerpt = excerpt[:1400].rsplit("\n", 1)[0] + "\n…"
        cost = len(excerpt) // 4 + 40
        if used + cost > budget and blocks:
            break
        used += cost
        blocks.append((r, excerpt))
    lines = [f"# Context pack — {args.query}", "",
             f"_engine: {engine} · notes: {len(blocks)} · approx tokens: {used} "
             f"(≈4 chars/token — approximate, not a tokenizer count)_", ""]
    for r, excerpt in blocks:
        lines += [f"## {r['title']} — `{r['path']}`", "",
                  f"- id: {r['id']} · type: {r['type']} · verification: **{r['verification']}**"
                  + (f" · asset_id: {r['asset_id']} ({r['asset_type']}, grade {r['source_grade']})" if r.get("asset_id") else ""),
                  "", excerpt, "", "---", ""]
    text = "\n".join(lines)
    if args.out:
        out = (cfg.root / args.out).resolve()
        if not cfg.inside(out):
            print("refused: output path outside vault", file=sys.stderr)
            return 2
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding="utf-8")
        print(f"wrote {len(blocks)} notes (~{used} tokens) to {out}")
    else:
        print(text)
    return 0


def cmd_export(cfg: Config, args):
    notes, _ = walk_notes(cfg)
    records = []
    for n in notes:
        d = n.as_dict()
        d["source_urls"] = ";".join(str(u) for u in d.get("source_urls") or [])
        d["tags"] = ";".join(d["tags"])
        records.append(d)
    records.sort(key=lambda r: r["path"])
    cfg.exports_dir.mkdir(parents=True, exist_ok=True)
    if args.format == "json":
        out = cfg.exports_dir / "notes.json"
        out.write_text(json.dumps({"generated": _dt.date.today().isoformat(), "count": len(records),
                                   "records": records}, indent=2, ensure_ascii=False), encoding="utf-8")
    else:
        out = cfg.exports_dir / "notes.csv"
        cols = ["id", "path", "type", "title", "status", "verification", "confidence", "category",
                "asset_id", "asset_type", "source_grade", "updated", "tags", "source_urls"]
        with out.open("w", encoding="utf-8", newline="") as f:
            w = csv.writer(f, quoting=csv.QUOTE_ALL, lineterminator="\n")
            w.writerow(cols)
            for r in records:
                w.writerow([str(r.get(c, "")) for c in cols])
    if args.json:
        emit({"format": args.format, "count": len(records), "path": str(out.relative_to(cfg.root))}, True)
    else:
        print(f"exported {len(records)} records to {out}")
    return 0


def cmd_report(cfg: Config, args):
    notes, skipped = walk_notes(cfg)
    errors, warnings, _fixtures = validate(cfg, notes)
    by_type, by_status, by_ver, assets_by_type, grades = {}, {}, {}, {}, {}
    note_count = 0
    for n in notes:
        if str(n.meta.get("fixture") or "").lower() == "true":
            continue                      # negative-control fixtures are test data, not content
        note_count += 1
        d = n.as_dict()
        by_type[d["type"]] = by_type.get(d["type"], 0) + 1
        by_status[d["status"]] = by_status.get(d["status"], 0) + 1
        by_ver[d["verification"]] = by_ver.get(d["verification"], 0) + 1
        if d["type"] == "asset":
            assets_by_type[d["asset_type"]] = assets_by_type.get(d["asset_type"], 0) + 1
            grades[d["source_grade"]] = grades.get(d["source_grade"], 0) + 1
    refs_missing = sum(1 for n in notes
                       if n.type == "reference" and not n.meta.get("source_urls")
                       and str(n.meta.get("fixture") or "").lower() != "true")
    report = {
        "generated": _dt.date.today().isoformat(),
        "notes": note_count,
        "by_type": dict(sorted(by_type.items())),
        "by_status": dict(sorted(by_status.items())),
        "by_verification": dict(sorted(by_ver.items())),
        "assets": {"total": assets_by_type and sum(assets_by_type.values()),
                   "by_type": dict(sorted(assets_by_type.items())),
                   "by_source_grade": dict(sorted(grades.items()))},
        "errors": len(errors), "warnings": len(warnings),
        "broken_wikilinks": sum(1 for w in warnings if w["code"] == "broken_wikilink"),
        "references_without_sources": refs_missing,
    }
    if args.json:
        emit(report, True)
    else:
        print(f"GameDev-Knowledge-Base — {report['generated']}")
        print(f"notes: {report['notes']}  errors: {report['errors']}  warnings: {report['warnings']}"
              f"  broken links: {report['broken_wikilinks']}")
        print("\nby type:        " + ", ".join(f"{k}={v}" for k, v in report["by_type"].items()))
        print("by status:      " + ", ".join(f"{k}={v}" for k, v in report["by_status"].items()))
        print("by verification:" + ", ".join(f"{k}={v}" for k, v in report["by_verification"].items()))
        print(f"(report excludes test fixtures; validate still checks them via tests/)")
        a = report["assets"]
        print(f"\nassets: {a['total'] and a['total'] or 0} · " +
              ", ".join(f"{k}={v}" for k, v in a["by_type"].items()))
        print("source grades:  " + ", ".join(f"{k}={v}" for k, v in a["by_source_grade"].items()))
    if args.write_dashboards:
        write_dashboards(cfg, notes, report, warnings)
        print(f"\ndashboards written to '13 - Dashboards/'")
    return 0


def write_dashboards(cfg: Config, notes, report, warnings):
    d = cfg.root / "13 - Dashboards"
    d.mkdir(exist_ok=True)
    today = _dt.date.today().isoformat()
    assets = [n for n in notes if n.type == "asset"]
    by_cat: dict[str, list] = {}
    for n in assets:
        by_cat.setdefault(str(n.meta.get("category") or "uncategorised"), []).append(n)

    lines = ["---", "id: DB-asset-status", "type: dashboard", "title: Asset status dashboard",
             "status: reviewed", f"updated: {today}", "tags: [dashboard, assets]", "source_urls: []", "---",
             "", "# Asset status dashboard", "",
             "_Generated by `python scripts/gamedev_kb.py report --write-dashboards`. Do not hand-edit._", "",
             f"**{len(assets)} candidate asset records.** Every one is `untested`: an ID and a listing are",
             "evidence that the asset exists, never that it plays, is accessible, or is licensed.", "",
             "| Category | Records | Grades |", "|---|---:|---|"]
    for cat in sorted(by_cat):
        sub = by_cat[cat]
        g: dict[str, int] = {}
        for n in sub:
            k = str(n.meta.get("source_grade") or "?")
            g[k] = g.get(k, 0) + 1
        lines.append(f"| {cat} | {len(sub)} | " + ", ".join(f"{k}×{v}" for k, v in sorted(g.items())) + " |")
    (d / "DB-asset-status.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    recent = sorted([n for n in notes if n.type not in ("asset",)], key=lambda n: str(n.meta.get("updated") or ""), reverse=True)[:40]
    lines = ["---", "id: DB-recent", "type: dashboard", "title: Recently updated notes",
             "status: reviewed", f"updated: {today}", "tags: [dashboard]", "source_urls: []", "---", "",
             "# Recently updated", "",
             "_Generated. Sorted by `updated` frontmatter field, newest first._", "",
             "| Updated | Note | Type | Status |", "|---|---|---|---|"]
    for n in recent:
        lines.append(f"| {n.meta.get('updated')} | [[{n.path.stem}]] | {n.type} | {n.meta.get('status')} |")
    (d / "DB-recent.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    projects = [n for n in notes if n.type == "project"]
    lines = ["---", "id: DB-projects", "type: dashboard", "title: Project status",
             "status: reviewed", f"updated: {today}", "tags: [dashboard, projects]", "source_urls: []", "---", "",
             "# Project status", "",
             "_Generated. One row per `project`-type note; milestone counts come from the project's own roadmap._",
             "", "| Project | Status | Notes in folder | Where |", "|---|---|---|---|"]
    for n in sorted(projects, key=lambda x: x.rel):
        folder = str(Path(n.rel).parent).replace("\\", "/")
        siblings = sum(1 for m in notes if str(Path(m.rel).parent).replace("\\", "/") == folder)
        lines.append(f"| [[{n.path.stem}]] | {n.meta.get('status')} | {siblings} | `{folder}/` |")
    lines += ["", f"**{len(projects)} project note(s).** The reusable starter is "
              "`10 - Projects and Experiments/_PROJECT_TEMPLATE/`; worked example: `P-sample-horror-house`."]
    (d / "DB-projects.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    src_notes = [n for n in notes if n.type == "source"]
    today_d = _dt.date.today()
    lines = ["---", "id: DB-sources", "type: dashboard", "title: Source freshness",
             "status: reviewed", f"updated: {today}", "tags: [dashboard, sources]", "source_urls: []", "---", "",
             "# Source freshness", "",
             "_Generated. External sources age: Roblox documentation changes without notice. A source older than "
             "180 days is flagged `needs-review`._", "",
             "| Source | Accessed | Age (days) | State | URL |", "|---|---|---:|---|---|"]
    stale = 0
    for n in sorted(src_notes, key=lambda x: x.rel):
        upd = str(n.meta.get("updated") or "")
        age = ""
        state = "ok"
        try:
            age_d = (today_d - _dt.date.fromisoformat(upd)).days
            age = str(age_d)
            if age_d > 180:
                state = "needs-review"
                stale += 1
        except ValueError:
            state = "unknown-date"
        url = (n.meta.get("source_urls") or [""])
        url = url[0] if isinstance(url, list) and url else ""
        lines.append(f"| [[{n.path.stem}]] | {upd} | {age} | {state} | {url} |")
    lines += ["", f"**{len(src_notes)} source record(s), {stale} needing review.**"]
    (d / "DB-sources.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    lines = ["---", "id: DB-health", "type: dashboard", "title: Vault health",
             "status: reviewed", f"updated: {today}", "tags: [dashboard, quality]", "source_urls: []", "---", "",
             "# Vault health", "", "_Generated from the same data `validate` and `report` print._", "",
             f"- notes: **{report['notes']}**",
             f"- errors: **{report['errors']}** · warnings: **{report['warnings']}** · broken wikilinks: **{report['broken_wikilinks']}**",
             f"- references without sources: **{report['references_without_sources']}**", "",
             "## By verification", "", "| State | Notes |", "|---|---:|"]
    for k, v in report["by_verification"].items():
        lines.append(f"| {k} | {v} |")
    lines += ["", "## Open warnings (first 40)", ""]
    for w in warnings[:40]:
        lines.append(f"- `{w['path']}` — {w['code']} {w['detail']}")
    if not warnings:
        lines.append("- none")
    (d / "DB-health.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main(argv=None):
    ap = argparse.ArgumentParser(prog="gamedev_kb", description="Local search, validation and retrieval for the GameDev knowledge vault.")
    ap.add_argument("--root", default=argparse.SUPPRESS, help="vault root (default: parent of scripts/)")
    ap.add_argument("--json", action="store_true", default=argparse.SUPPRESS, help="machine-readable output")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--json", action="store_true", default=argparse.SUPPRESS, help="machine-readable output")
    common.add_argument("--root", default=argparse.SUPPRESS, help="vault root (also accepted after the command)")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("doctor", parents=[common], help="environment, paths and capability check"); p.set_defaults(fn=cmd_doctor)
    p = sub.add_parser("validate", parents=[common], help="check frontmatter, IDs, enums, links"); p.set_defaults(fn=cmd_validate)
    p = sub.add_parser("index", parents=[common], help="build the local search index"); p.set_defaults(fn=cmd_index)

    p = sub.add_parser("search", parents=[common], help="full-text search with filters")
    p.add_argument("query")
    p.add_argument("--limit", type=int, default=10)
    p.add_argument("--type"); p.add_argument("--category"); p.add_argument("--status")
    p.set_defaults(fn=cmd_search)

    p = sub.add_parser("context", parents=[common], help="assemble source-attributed context for an agent")
    p.add_argument("query"); p.add_argument("--budget", type=int, default=6000)
    p.add_argument("--count", type=int, default=8)
    p.add_argument("--type"); p.add_argument("--category"); p.add_argument("--status")
    p.add_argument("--out", help="write the pack to a file inside the vault")
    p.set_defaults(fn=cmd_context)

    p = sub.add_parser("asset", parents=[common], help="exact asset ID lookup (string-exact)"); p.add_argument("asset_id")
    p.set_defaults(fn=cmd_asset)

    p = sub.add_parser("export", parents=[common], help="export normalized records")
    p.add_argument("--format", choices=["json", "csv"], default="json")
    p.set_defaults(fn=cmd_export)

    p = sub.add_parser("report", parents=[common], help="summary counts and verification states")
    p.add_argument("--write-dashboards", action="store_true")
    p.set_defaults(fn=cmd_report)

    args = ap.parse_args(argv)
    args.json = bool(getattr(args, 'json', False))   # SUPPRESS keeps either position working
    try:
        root = getattr(args, 'root', None)
        cfg = Config(Path(root).resolve() if root else None)
    except SystemExit:
        raise
    return args.fn(cfg, args)


if __name__ == "__main__":
    sys.exit(main())
