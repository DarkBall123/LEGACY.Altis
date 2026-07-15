#!/usr/bin/env python3
"""Extract unique Steam Workshop mods from an Arma 3 Launcher preset."""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import parse_qs, urlparse


@dataclass(frozen=True)
class WorkshopMod:
    title: str
    id: str
    url: str


def workshop_id(url: str) -> str | None:
    parsed = urlparse(url)
    if parsed.netloc.lower() not in {"steamcommunity.com", "www.steamcommunity.com"}:
        return None
    if parsed.path.rstrip("/") != "/sharedfiles/filedetails":
        return None
    values = parse_qs(parsed.query).get("id", [])
    if len(values) != 1 or not values[0].isdigit():
        return None
    return values[0]


class ArmaPresetParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.mods: list[WorkshopMod] = []
        self._in_mod = False
        self._capture_title = False
        self._title_parts: list[str] = []

    def handle_starttag(
        self, tag: str, attributes: list[tuple[str, str | None]]
    ) -> None:
        attrs = dict(attributes)
        if tag == "tr" and attrs.get("data-type") == "ModContainer":
            self._in_mod = True
            self._title_parts = []
            return
        if not self._in_mod:
            return
        if tag == "td" and attrs.get("data-type") == "DisplayName":
            self._capture_title = True
            return
        if tag != "a":
            return

        url = (attrs.get("href") or "").strip()
        mod_id = workshop_id(url)
        if mod_id is None:
            return
        title = " ".join("".join(self._title_parts).split())
        self.mods.append(WorkshopMod(title=title, id=mod_id, url=url))

    def handle_data(self, data: str) -> None:
        if self._capture_title:
            self._title_parts.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag == "td" and self._capture_title:
            self._capture_title = False
        elif tag == "tr" and self._in_mod:
            self._in_mod = False
            self._capture_title = False


def extract_mods(path: Path) -> list[WorkshopMod]:
    parser = ArmaPresetParser()
    parser.feed(path.read_text(encoding="utf-8-sig"))

    unique: dict[str, WorkshopMod] = {}
    for mod in parser.mods:
        unique.setdefault(mod.id, mod)
    return list(unique.values())


def render(mods: list[WorkshopMod], output_format: str) -> str:
    if output_format == "links":
        return "\n".join(mod.url for mod in mods)
    if output_format == "ids":
        return "\n".join(mod.id for mod in mods)
    return json.dumps(
        [asdict(mod) for mod in mods], ensure_ascii=False, indent=2
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract Steam Workshop links from an Arma 3 Launcher HTML preset."
    )
    parser.add_argument("preset", type=Path, help="Path to the exported HTML preset")
    parser.add_argument(
        "--format",
        choices=("links", "ids", "json"),
        default="links",
        help="Output format (default: links)",
    )
    parser.add_argument("--output", type=Path, help="Write output to this file")
    args = parser.parse_args()

    if not args.preset.is_file():
        parser.error(f"preset does not exist: {args.preset}")

    mods = extract_mods(args.preset)
    if not mods:
        print("No Steam Workshop mods found", file=sys.stderr)
        return 1

    result = render(mods, args.format) + "\n"
    if args.output:
        args.output.write_text(result, encoding="utf-8")
        print(f"Wrote {len(mods)} unique mods to {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
