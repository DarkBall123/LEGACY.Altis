#!/usr/bin/env python3
"""Unit tests for FTP mission deployment helpers."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from deploy_mission_ftp import prune_backups, stage_upload, verify_tls_certificate


class FakeFtp:
    def __init__(self, files: dict[str, bytes] | None = None) -> None:
        self.files = files or {}

    def delete(self, name: str) -> None:
        del self.files[name]

    def nlst(self) -> list[str]:
        return list(self.files)

    def size(self, name: str) -> int:
        if name not in self.files:
            from ftplib import error_perm

            raise error_perm("550 file unavailable")
        return len(self.files[name])

    def storbinary(self, command: str, source, blocksize: int = 8192) -> None:
        _verb, name = command.split(" ", 1)
        self.files[name] = source.read()


class FakeTlsFtp:
    sock = None

    def __init__(self, certificate: bytes) -> None:
        self.certificate = certificate
        self.sock = self

    def getpeercert(self, binary_form: bool = False) -> bytes:
        if not binary_form:
            raise AssertionError("certificate must be requested in binary form")
        return self.certificate


class DeployMissionFtpTests(unittest.TestCase):
    def test_stage_upload_replaces_same_sized_staged_file(self) -> None:
        ftp = FakeFtp({"mission.pbo.uploading": b"olddata"})
        with tempfile.TemporaryDirectory() as directory:
            local = Path(directory) / "mission.pbo"
            local.write_bytes(b"newdata")
            size = stage_upload(ftp, local, "mission.pbo.uploading")

        self.assertEqual(size, 7)
        self.assertEqual(ftp.files["mission.pbo.uploading"], b"newdata")

    def test_stage_upload_replaces_wrong_sized_file(self) -> None:
        ftp = FakeFtp({"mission.pbo.uploading": b"old"})
        with tempfile.TemporaryDirectory() as directory:
            local = Path(directory) / "mission.pbo"
            local.write_bytes(b"replacement")
            size = stage_upload(ftp, local, "mission.pbo.uploading")

        self.assertEqual(size, 11)
        self.assertEqual(ftp.files["mission.pbo.uploading"], b"replacement")

    def test_prune_backups_keeps_newest_backups_only(self) -> None:
        ftp = FakeFtp(
            {
                "LEGACY.Altis.pbo.20260715T120000Z.bak": b"newest",
                "LEGACY.Altis.pbo.20260714T120000Z.bak": b"middle",
                "LEGACY.Altis.pbo.20260713T120000Z.bak": b"oldest",
                "unrelated.pbo.20260701T120000Z.bak": b"other",
            }
        )

        prune_backups(ftp, "LEGACY.Altis.pbo", keep=2)

        self.assertNotIn("LEGACY.Altis.pbo.20260713T120000Z.bak", ftp.files)
        self.assertIn("LEGACY.Altis.pbo.20260715T120000Z.bak", ftp.files)
        self.assertIn("unrelated.pbo.20260701T120000Z.bak", ftp.files)

    def test_prune_backups_rejects_negative_keep(self) -> None:
        with self.assertRaisesRegex(ValueError, "zero or greater"):
            prune_backups(FakeFtp(), "LEGACY.Altis.pbo", keep=-1)

    def test_tls_certificate_pin_accepts_matching_certificate(self) -> None:
        certificate = b"arkhoster test certificate"
        fingerprint = (
            "726229923a1dcd30fe35414f18441f13"
            "3a7499ee9362617dd79b9644e550db06"
        )
        with patch.dict(
            "os.environ", {"DEPLOY_FTP_TLS_CERT_SHA256": fingerprint}, clear=False
        ):
            verify_tls_certificate(FakeTlsFtp(certificate))

    def test_tls_certificate_pin_rejects_mismatch(self) -> None:
        with patch.dict(
            "os.environ", {"DEPLOY_FTP_TLS_CERT_SHA256": "0" * 64}, clear=False
        ):
            with self.assertRaisesRegex(Exception, "fingerprint mismatch"):
                verify_tls_certificate(FakeTlsFtp(b"unexpected certificate"))


if __name__ == "__main__":
    unittest.main()
