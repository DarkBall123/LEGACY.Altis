#!/usr/bin/env python3
"""Lightweight Arma config validation for this mission repository."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONFIG_EXTENSIONS = {".ext", ".sqm", ".cpp", ".hpp", ".h"}
EXCLUDED_DIRS = {".git", ".github", ".hemtt", ".hemttout", "docs"}
INCLUDE_RE = re.compile(r'^\s*#include\s+["<]([^">]+)[">]', re.MULTILINE)


def is_excluded(path: Path) -> bool:
    return any(part in EXCLUDED_DIRS for part in path.relative_to(ROOT).parts)


def config_files() -> list[Path]:
    files: list[Path] = []
    for path in ROOT.rglob("*"):
        if path.is_file() and path.suffix.lower() in CONFIG_EXTENSIONS and not is_excluded(path):
            files.append(path)
    return sorted(files)


def decode_text(path: Path) -> tuple[str, str] | None:
    data = path.read_bytes()
    if b"\x00" in data[:1024]:
        print(f"{path.relative_to(ROOT)}: binary/rapified config detected; skipping text checks")
        return None
    if data.startswith(b"\xef\xbb\xbf"):
        raise ValueError("UTF-8 BOM is not allowed")
    for encoding in ("utf-8", "cp1251", "latin-1"):
        try:
            return data.decode(encoding), encoding
        except UnicodeDecodeError:
            continue
    raise ValueError("unsupported text encoding")


def strip_comments_and_strings(text: str) -> str:
    out: list[str] = []
    i = 0
    in_line_comment = False
    in_block_comment = False
    in_string = False
    while i < len(text):
        char = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""

        if in_line_comment:
            if char == "\n":
                in_line_comment = False
                out.append(char)
            else:
                out.append(" ")
            i += 1
            continue

        if in_block_comment:
            if char == "*" and nxt == "/":
                in_block_comment = False
                out.extend("  ")
                i += 2
            else:
                out.append("\n" if char == "\n" else " ")
                i += 1
            continue

        if in_string:
            if char == '"':
                if nxt == '"':
                    out.extend("  ")
                    i += 2
                    continue
                in_string = False
            out.append("\n" if char == "\n" else " ")
            i += 1
            continue

        if char == "/" and nxt == "/":
            in_line_comment = True
            out.extend("  ")
            i += 2
            continue

        if char == "/" and nxt == "*":
            in_block_comment = True
            out.extend("  ")
            i += 2
            continue

        if char == '"':
            in_string = True
            out.append(" ")
            i += 1
            continue

        out.append(char)
        i += 1

    return "".join(out)


def line_col(text: str, index: int) -> tuple[int, int]:
    line = text.count("\n", 0, index) + 1
    last_newline = text.rfind("\n", 0, index)
    col = index + 1 if last_newline == -1 else index - last_newline
    return line, col


def validate_balanced_braces(path: Path, text: str) -> list[str]:
    cleaned = strip_comments_and_strings(text)
    stack: list[int] = []
    errors: list[str] = []

    for index, char in enumerate(cleaned):
        if char == "{":
            stack.append(index)
        elif char == "}":
            if not stack:
                line, col = line_col(cleaned, index)
                errors.append(f"{path.relative_to(ROOT)}:{line}:{col}: unmatched closing brace")
            else:
                stack.pop()

    for index in stack:
        line, col = line_col(cleaned, index)
        errors.append(f"{path.relative_to(ROOT)}:{line}:{col}: unmatched opening brace")

    return errors


def validate_includes(path: Path, text: str) -> list[str]:
    errors: list[str] = []
    for match in INCLUDE_RE.finditer(text):
        include = match.group(1).replace("\\", "/")
        if include.startswith("/") or include.startswith("a3/") or include.startswith("x/"):
            continue
        target = (path.parent / include).resolve()
        try:
            target.relative_to(ROOT)
        except ValueError:
            errors.append(f"{path.relative_to(ROOT)}: include escapes repository: {include}")
            continue
        if not target.exists():
            line, _ = line_col(text, match.start())
            errors.append(f"{path.relative_to(ROOT)}:{line}: missing include: {include}")
    return errors


def main() -> int:
    errors: list[str] = []
    files = config_files()

    for path in files:
        try:
            decoded = decode_text(path)
        except ValueError as exc:
            errors.append(f"{path.relative_to(ROOT)}: {exc}")
            continue
        if decoded is None:
            continue
        text, _encoding = decoded
        errors.extend(validate_balanced_braces(path, text))
        errors.extend(validate_includes(path, text))

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print(f"Validated {len(files)} Arma config files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
