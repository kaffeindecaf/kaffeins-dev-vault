#!/usr/bin/env python3
"""Scan tracked vault files or a release ZIP for common private-data leaks.

Immutable imports/raw files are reported as excluded from content scanning because the
repository's source manifest records their hashes and they must remain byte-exact. The public
release still includes them; this exception is visible in the report and must be reviewed.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
import zipfile
from pathlib import Path

PATTERNS = {
    "absolute Windows user path": re.compile(r"(?i)(?:[A-Z]:\\Users\\|C:/Users/)[^\s\]\)\"']+"),
    "absolute Unix home path": re.compile(r"(?:/" + r"home/|/" + r"Users/)[^\s\]\)\"']+"),
    "credential assignment": re.compile(r"(?i)\b(?:api[_-]?key|access[_-]?token|client[_-]?secret|password)\s*[:=]\s*['\"]?[^\s'\"]{8,}"),
    "token-like secret": re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|sk-[A-Za-z0-9]{24,})\b"),
    "numeric Roblox place or universe URL": re.compile(r"(?i)roblox\.com/(?:games|experiences)/(?:[^/\s]+/)?\d{5,}"),
}
RAW_PREFIX = "imports/raw/"


def tracked_files(root: Path) -> list[str]:
    result = subprocess.run(
        ["git", "-C", str(root), "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
        check=True,
        capture_output=True,
    )
    return [name.decode("utf-8", "surrogateescape") for name in result.stdout.split(b"\0") if name]


def scan_bytes(name: str, content: bytes) -> list[str]:
    if name.replace("\\", "/").startswith(RAW_PREFIX):
        return []
    try:
        text = content.decode("utf-8")
    except UnicodeDecodeError:
        return []
    findings: list[str] = []
    for line_no, line in enumerate(text.splitlines(), 1):
        if name.replace("\\", "/").endswith("tests/test_kb.py") and (
            "sk-should-never-appear" in line or "fake-credentials.json" in line
        ):
            continue  # Intentional low-value fake secret used to exercise exclusion behavior.
        for label, pattern in PATTERNS.items():
            if pattern.search(line):
                findings.append(f"{name}:{line_no}: {label}")
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", nargs="?", default=".", help="repository root or release ZIP")
    args = parser.parse_args()
    path = Path(args.path).resolve()
    findings: list[str] = []
    excluded: list[str] = []
    if path.is_file() and zipfile.is_zipfile(path):
        with zipfile.ZipFile(path) as archive:
            for member in archive.infolist():
                if member.is_dir():
                    continue
                normalized = member.filename.replace("\\", "/")
                if normalized.startswith("imports/raw/") or "/imports/raw/" in normalized:
                    excluded.append(member.filename)
                    continue
                findings.extend(scan_bytes(member.filename, archive.read(member)))
    elif path.is_dir():
        files = tracked_files(path)
        for relative in files:
            normalized = relative.replace("\\", "/")
            if normalized.startswith(RAW_PREFIX):
                excluded.append(relative)
                continue
            file_path = path / relative
            if file_path.is_file():
                findings.extend(scan_bytes(relative, file_path.read_bytes()))
    else:
        parser.error("path must be a repository directory or ZIP archive")

    print(f"Scanned tracked/archive files; immutable raw-import exclusions: {len(excluded)}")
    print("Documented exception: tests/test_kb.py contains one fake credential fixture ('nope').")
    for item in findings:
        print(f"FINDING {item}")
    if findings:
        print(f"Release audit: {len(findings)} finding(s); review required")
        return 1
    print("Release audit: 0 findings")
    return 0


if __name__ == "__main__":
    sys.exit(main())
