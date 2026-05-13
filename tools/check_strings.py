#!/usr/bin/env python3
"""Check localizable string references against stringtable.xml."""

from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXCLUDED_DIRS = {".git", ".github", ".hemtt", ".hemttout", "docs"}
TEXT_EXTENSIONS = {".sqf", ".ext", ".sqm", ".cpp", ".hpp", ".h"}
LOCALIZE_RE = re.compile(r'\blocalize\s+"(\$?STR_[A-Za-z0-9_]+)"')
STRING_REF_RE = re.compile(r'"\$(STR_[A-Za-z0-9_]+)"')
EXTERNAL_PREFIXES = (
    "STR_A3_",
    "STR_3DEN_",
    "STR_DN_",
    "STR_LIB_",
    "STR_CBA_",
    "STR_ACE_",
)


def is_excluded(path: Path) -> bool:
    return any(part in EXCLUDED_DIRS for part in path.relative_to(ROOT).parts)


def project_files() -> list[Path]:
    return sorted(
        path
        for path in ROOT.rglob("*")
        if path.is_file() and path.suffix.lower() in TEXT_EXTENSIONS and not is_excluded(path)
    )


def read_text(path: Path) -> str | None:
    data = path.read_bytes()
    if b"\x00" in data[:1024]:
        return None
    for encoding in ("utf-8", "cp1251", "latin-1"):
        try:
            return data.decode(encoding)
        except UnicodeDecodeError:
            continue
    raise UnicodeDecodeError("unknown", data, 0, 1, "unsupported text encoding")


def stringtable_keys() -> set[str]:
    keys: set[str] = set()
    for path in ROOT.rglob("stringtable.xml"):
        if is_excluded(path):
            continue
        root = ET.parse(path).getroot()
        keys.update(key.get("ID") for key in root.iter("Key") if key.get("ID"))
    return keys


def normalize(ref: str) -> str:
    return ref[1:] if ref.startswith("$") else ref


def is_external(ref: str) -> bool:
    return ref.startswith(EXTERNAL_PREFIXES)


def main() -> int:
    keys = stringtable_keys()
    missing: list[str] = []
    scanned = 0

    for path in project_files():
        text = read_text(path)
        if text is None:
            continue
        scanned += 1
        refs = {normalize(match.group(1)) for match in LOCALIZE_RE.finditer(text)}
        refs.update(match.group(1) for match in STRING_REF_RE.finditer(text))

        for ref in sorted(refs):
            if is_external(ref):
                continue
            if ref not in keys:
                missing.append(f"{path.relative_to(ROOT)}: missing stringtable key {ref}")

    if missing:
        print("\n".join(missing), file=sys.stderr)
        return 1

    print(f"Checked localized string references in {scanned} files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
