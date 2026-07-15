#!/usr/bin/env python3
"""Tests for the Arma 3 Launcher preset parser."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from extract_steam_workshop_links import extract_mods, render, workshop_id


class ExtractSteamWorkshopLinksTests(unittest.TestCase):
    def test_extracts_titles_and_unique_workshop_ids(self) -> None:
        html = """
        <table>
          <tr data-type="ModContainer">
            <td data-type="DisplayName">ACE Test</td>
            <td><a data-type="Link" href="https://steamcommunity.com/sharedfiles/filedetails/?id=463939057">link</a></td>
          </tr>
          <tr data-type="ModContainer">
            <td data-type="DisplayName">Duplicate</td>
            <td><a data-type="Link" href="https://steamcommunity.com/sharedfiles/filedetails/?id=463939057">link</a></td>
          </tr>
        </table>
        """
        with tempfile.TemporaryDirectory() as directory:
            preset = Path(directory) / "preset.html"
            preset.write_text(html, encoding="utf-8")
            mods = extract_mods(preset)

        self.assertEqual(len(mods), 1)
        self.assertEqual(mods[0].title, "ACE Test")
        self.assertEqual(mods[0].id, "463939057")

    def test_rejects_non_workshop_url(self) -> None:
        self.assertIsNone(workshop_id("https://example.com/?id=463939057"))

    def test_renders_ids(self) -> None:
        html = """
        <tr data-type="ModContainer">
          <td data-type="DisplayName">Test</td>
          <td><a href="https://steamcommunity.com/sharedfiles/filedetails/?id=123">link</a></td>
        </tr>
        """
        with tempfile.TemporaryDirectory() as directory:
            preset = Path(directory) / "preset.html"
            preset.write_text(html, encoding="utf-8")
            mods = extract_mods(preset)

        self.assertEqual(render(mods, "ids"), "123")


if __name__ == "__main__":
    unittest.main()
