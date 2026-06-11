#!/usr/bin/env python3
"""Build an unbinarized, unsigned Arma 3 mission PBO with HEMTT."""

from __future__ import annotations

import argparse
import os
import re
import shlex
import shutil
import subprocess
import tempfile
from pathlib import Path

from env_config import load_env
from package_mission import ROOT, package_mission


PROJECT_TOML = """\
name = "SOF Campaign Mission PBO"
prefix = "mission"
author = "DarkBall123"

[version]
major = 0
minor = 1
patch = 0
build = 0

[lints.sqf.banned_commands]
options.ignore = ["addPublicVariableEventHandler"]
"""
ADDON_TOML = """\
ignore_pboprefix = true

[binarize]
enabled = false

[rapify]
enabled = false

[files]
exclude = ["**/*.sqfc"]
"""


def get_mission_name() -> str:
    mission_name = os.environ.get("MISSION_PBO_NAME", "LEGACY.Altis")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+", mission_name):
        raise ValueError(
            "MISSION_PBO_NAME may contain only letters, numbers, dots, underscores, and hyphens"
        )
    return mission_name


def main() -> int:
    load_env(ROOT / ".env")

    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--hemtt")
    args = parser.parse_args()

    mission_name = get_mission_name()
    output = args.output
    if output is None:
        output_dir = Path(os.environ.get("MISSION_OUTPUT_DIR", ".hemttout"))
        output = output_dir / f"{mission_name}.pbo"
    if not output.is_absolute():
        output = ROOT / output
    output.parent.mkdir(parents=True, exist_ok=True)

    hemtt = args.hemtt or os.environ.get("HEMTT_BIN", "hemtt")
    build_args = shlex.split(os.environ.get("HEMTT_BUILD_ARGS", "--no-bin --no-rap"))

    with tempfile.TemporaryDirectory(prefix="mission-pbo-", dir=output.parent) as temp:
        project = Path(temp)
        addon = project / "addons" / "package"
        package_mission(addon)

        metadata = project / ".hemtt"
        metadata.mkdir(parents=True)
        (metadata / "project.toml").write_text(PROJECT_TOML, encoding="utf-8")
        (addon / "$PBOPREFIX$").write_text(f"{mission_name}\n", encoding="utf-8")
        (addon / "addon.toml").write_text(ADDON_TOML, encoding="utf-8")

        subprocess.run(
            [hemtt, "build", *build_args],
            cwd=project,
            check=True,
        )

        pbo_files = list((project / ".hemttout" / "build" / "addons").glob("*.pbo"))
        if len(pbo_files) != 1:
            raise RuntimeError(f"Expected one PBO, found {len(pbo_files)}")
        shutil.copy2(pbo_files[0], output)

    print(f"Packaged mission PBO at {output.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
