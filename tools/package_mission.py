#!/usr/bin/env python3
"""Create a clean mission-folder artifact for GitHub Actions."""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MISSION_FILES = [
    "description.ext",
    "initPlayerLocal.sqf",
    "initServer.sqf",
    "mission.sqm",
    "Alfa",
    "functions",
    "scripts",
]


def copy_entry(source: Path, target: Path) -> None:
    if source.is_dir():
        shutil.copytree(source, target, dirs_exist_ok=True)
    else:
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    output = args.output
    if not output.is_absolute():
        output = ROOT / output
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)

    for item in MISSION_FILES:
        source = ROOT / item
        if source.exists():
            copy_entry(source, output / item)

    print(f"Packaged mission folder at {output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
