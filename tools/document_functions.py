#!/usr/bin/env python3
"""Validate CfgFunctions declarations against mission function files."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DESCRIPTION = ROOT / "description.ext"
CLASS_RE = re.compile(r"^\s*class\s+([A-Za-z_][A-Za-z0-9_]*)\s*\{[^{}]*\};", re.MULTILINE)


def strip_line_comments(text: str) -> str:
    lines: list[str] = []
    for line in text.splitlines():
        if "//" in line:
            line = line.split("//", 1)[0]
        lines.append(line)
    return "\n".join(lines)


def registered_functions() -> set[str]:
    text = strip_line_comments(DESCRIPTION.read_text(encoding="utf-8"))
    marker = "class CfgFunctions"
    start = text.find(marker)
    if start == -1:
        return set()
    brace_start = text.find("{", start)
    if brace_start == -1:
        return set()

    depth = 0
    end = len(text)
    for index in range(brace_start, len(text)):
        char = text[index]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                end = index + 1
                break

    return {match.group(1) for match in CLASS_RE.finditer(text[brace_start:end])}


def first_meaningful_line(path: Path) -> str:
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped:
            return stripped
    return ""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--debug", action="store_true")
    args = parser.parse_args()

    errors: list[str] = []
    warnings: list[str] = []
    registered = registered_functions()
    function_files = {path.stem.removeprefix("fn_"): path for path in (ROOT / "functions").glob("fn_*.sqf")}

    for name in sorted(registered):
        if name not in function_files:
            errors.append(f"description.ext: CfgFunctions declares {name}, but functions/fn_{name}.sqf is missing")

    for name, path in sorted(function_files.items()):
        if name not in registered:
            warnings.append(f"{path.relative_to(ROOT)}: file is not declared in description.ext CfgFunctions")
        header = first_meaningful_line(path)
        if not header.startswith("/*") and not header.startswith("//") and args.debug:
            warnings.append(f"{path.relative_to(ROOT)}: no comment header before code")

    if warnings and args.debug:
        print("\n".join(warnings))

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print(f"Validated {len(function_files)} mission function declarations")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
