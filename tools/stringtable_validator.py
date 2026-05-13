#!/usr/bin/env python3
"""Validate Arma stringtable.xml files when the mission starts using them."""

from __future__ import annotations

import collections
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXCLUDED_DIRS = {".git", ".github", ".hemtt", ".hemttout", "docs"}


def is_excluded(path: Path) -> bool:
    return any(part in EXCLUDED_DIRS for part in path.relative_to(ROOT).parts)


def stringtables() -> list[Path]:
    return sorted(
        path
        for path in ROOT.rglob("stringtable.xml")
        if path.is_file() and not is_excluded(path)
    )


def main() -> int:
    errors: list[str] = []
    tables = stringtables()

    if not tables:
        print("No stringtable.xml found; skipping stringtable validation")
        return 0

    for path in tables:
        try:
            tree = ET.parse(path)
        except ET.ParseError as exc:
            errors.append(f"{path.relative_to(ROOT)}: XML parse error: {exc}")
            continue

        root = tree.getroot()
        if root.tag != "Project":
            errors.append(f"{path.relative_to(ROOT)}: root element must be <Project>")

        keys = [elem.get("ID") for elem in root.iter("Key")]
        missing_ids = sum(1 for key in keys if not key)
        if missing_ids:
            errors.append(f"{path.relative_to(ROOT)}: {missing_ids} <Key> entries are missing ID")

        duplicates = [key for key, count in collections.Counter(keys).items() if key and count > 1]
        for key in sorted(duplicates):
            errors.append(f"{path.relative_to(ROOT)}: duplicate string key {key}")

        for key in root.iter("Key"):
            languages = [child.tag for child in key if isinstance(child.tag, str)]
            if "English" not in languages:
                errors.append(f"{path.relative_to(ROOT)}: {key.get('ID', '<missing ID>')} has no English text")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print(f"Validated {len(tables)} stringtable.xml files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
