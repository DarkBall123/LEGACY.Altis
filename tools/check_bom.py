#!/usr/bin/env python3
"""Fail the build if any tracked file starts with a UTF-8 BOM."""

from __future__ import annotations

import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXCLUDED_DIRS = {".git", ".github", ".hemtt", ".hemttout", ".vs", "docs"}
EXCLUDED_FILES = {"env"}


def is_excluded(path: Path) -> bool:
    rel = path.relative_to(ROOT)
    return rel.name in EXCLUDED_FILES or any(part in EXCLUDED_DIRS for part in rel.parts)


def main() -> int:
    bom_files: list[str] = []
    for path in ROOT.rglob("*"):
        if not path.is_file() or is_excluded(path):
            continue
        try:
            data = path.read_bytes()
        except OSError:
            continue
        if data.startswith(b"\xef\xbb\xbf"):
            bom_files.append(str(path.relative_to(ROOT)))

    if bom_files:
        print("UTF-8 BOM found in files:", file=sys.stderr)
        for rel in sorted(bom_files):
            print(f"  - {rel}", file=sys.stderr)
        return 1

    print("No UTF-8 BOM found")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
