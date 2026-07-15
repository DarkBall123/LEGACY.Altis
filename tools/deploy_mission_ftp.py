#!/usr/bin/env python3
"""Upload a mission PBO over FTP using a checked temporary file."""

from __future__ import annotations

import argparse
import ftplib
import hashlib
import hmac
import os
import posixpath
import ssl
from datetime import datetime, timezone
from pathlib import Path

from env_config import env_bool, load_env, required_env
from package_mission import ROOT
from package_mission_pbo import get_mission_name


class MissionPboLockedError(RuntimeError):
    """The hosting provider cannot mutate the active mission PBO."""


class SessionReuseFTP_TLS(ftplib.FTP_TLS):
    """FTPS client for servers that require control-channel TLS session reuse."""

    def ntransfercmd(self, cmd: str, rest: str | None = None):
        connection, size = ftplib.FTP.ntransfercmd(self, cmd, rest)
        if self._prot_p:
            connection = self.context.wrap_socket(
                connection,
                server_hostname=self.host,
                session=self.sock.session,
            )
        return connection, size


def verify_tls_certificate(ftp: ftplib.FTP_TLS) -> None:
    expected = os.environ.get("DEPLOY_FTP_TLS_CERT_SHA256", "")
    if not expected.strip():
        return

    fingerprint = expected.replace(":", "").strip().lower()
    if len(fingerprint) != 64 or any(
        character not in "0123456789abcdef" for character in fingerprint
    ):
        raise ValueError("DEPLOY_FTP_TLS_CERT_SHA256 must be a SHA-256 fingerprint")

    certificate = ftp.sock.getpeercert(binary_form=True)
    actual = hashlib.sha256(certificate).hexdigest()
    if not hmac.compare_digest(actual, fingerprint):
        raise ssl.SSLError(
            f"FTPS certificate fingerprint mismatch: expected {fingerprint}, got {actual}"
        )


def connect() -> ftplib.FTP:
    host = required_env("DEPLOY_HOST")
    port = int(os.environ.get("DEPLOY_PORT", "21"))
    user = required_env("DEPLOY_USER")
    password = required_env("DEPLOY_PASSWORD")
    tls_mode = os.environ.get("DEPLOY_FTP_TLS", "off").strip().lower()

    if tls_mode not in {"off", "try", "require"}:
        raise ValueError("DEPLOY_FTP_TLS must be off, try, or require")

    def open_connection(use_tls: bool) -> ftplib.FTP:
        if use_tls:
            verify = env_bool("DEPLOY_FTP_TLS_VERIFY", True)
            context = ssl.create_default_context()
            if not verify:
                context.check_hostname = False
                context.verify_mode = ssl.CERT_NONE
            ftp: ftplib.FTP = SessionReuseFTP_TLS(context=context)
        else:
            ftp = ftplib.FTP()

        ftp.connect(host, port, timeout=30)
        if isinstance(ftp, ftplib.FTP_TLS):
            ftp.auth()
            verify_tls_certificate(ftp)
        ftp.login(user, password)
        ftp.set_pasv(env_bool("DEPLOY_FTP_PASSIVE", True))
        if isinstance(ftp, ftplib.FTP_TLS):
            ftp.prot_p()
        return ftp

    if tls_mode == "off":
        return open_connection(False)
    try:
        return open_connection(True)
    except (OSError, ssl.SSLError, ftplib.Error) as error:
        if tls_mode == "require":
            raise
        print(f"FTPS unavailable ({error.__class__.__name__}); falling back to FTP")
        return open_connection(False)


def remote_exists(ftp: ftplib.FTP, path: str) -> bool:
    try:
        ftp.size(path)
        return True
    except ftplib.error_perm as error:
        if not str(error).startswith("550"):
            raise
        return False


def delete_existing(ftp: ftplib.FTP, path: str) -> None:
    if not remote_exists(ftp, path):
        return
    ftp.delete(path)
    if remote_exists(ftp, path):
        raise RuntimeError(f"FTP server did not delete {path}")


def upload_verified(ftp: ftplib.FTP, local_path: Path, remote_name: str) -> int:
    local_size = local_path.stat().st_size
    with local_path.open("rb") as source:
        ftp.storbinary(f"STOR {remote_name}", source, blocksize=1024 * 1024)

    remote_size = ftp.size(remote_name)
    if remote_size != local_size:
        delete_existing(ftp, remote_name)
        raise RuntimeError(
            f"Remote size mismatch for {remote_name}: expected {local_size}, got {remote_size}"
        )
    return remote_size


def stage_upload(ftp: ftplib.FTP, local_path: Path, remote_name: str) -> int:
    if remote_exists(ftp, remote_name):
        delete_existing(ftp, remote_name)
    return upload_verified(ftp, local_path, remote_name)


def prune_backups(ftp: ftplib.FTP, target_name: str, keep: int) -> None:
    if keep < 0:
        raise ValueError("DEPLOY_BACKUP_KEEP must be zero or greater")

    prefix = f"{target_name}."
    backups = sorted(
        (
            posixpath.basename(name)
            for name in ftp.nlst()
            if posixpath.basename(name).startswith(prefix)
            and posixpath.basename(name).endswith(".bak")
        ),
        reverse=True,
    )
    for backup in backups[keep:]:
        ftp.delete(backup)
        print(f"Removed old mission backup {backup}")


def locked_pbo_error(
    target_name: str, temporary_name: str, error: ftplib.error_perm
) -> MissionPboLockedError:
    return MissionPboLockedError(
        f"Cannot replace {target_name}: {error}. The running Arma 3 server "
        f"is likely locking the active mission PBO. The new PBO is safely "
        f"staged as {temporary_name}. Stop the server in ArkHoster, then "
        "re-run the failed GitHub Actions jobs."
    )


def main() -> int:
    load_env(ROOT / ".env")

    parser = argparse.ArgumentParser()
    parser.add_argument("--pbo", type=Path)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    mission_name = get_mission_name()
    pbo = args.pbo or Path(
        os.environ.get("MISSION_OUTPUT_DIR", ".hemttout")
    ) / f"{mission_name}.pbo"
    if not pbo.is_absolute():
        pbo = ROOT / pbo
    if not pbo.is_file():
        raise FileNotFoundError(f"Mission PBO not found: {pbo}")

    remote_dir = os.environ.get(
        "DEPLOY_REMOTE_MISSIONS_DIR", "/MPMissions"
    ).rstrip("/") or "/"
    target_name = f"{mission_name}.pbo"
    target = posixpath.join(remote_dir, target_name)
    temporary_name = f"{target_name}.uploading"
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup_name = f"{target_name}.{timestamp}.bak"
    backup_keep = int(os.environ.get("DEPLOY_BACKUP_KEEP", "3"))
    if backup_keep < 0:
        raise ValueError("DEPLOY_BACKUP_KEEP must be zero or greater")

    if args.dry_run:
        print(f"Would upload {pbo.name} ({pbo.stat().st_size} bytes) to {target}")
        return 0

    ftp = connect()
    try:
        ftp.cwd(remote_dir)
        remote_size = stage_upload(ftp, pbo, temporary_name)

        if remote_exists(ftp, target_name):
            try:
                if env_bool("DEPLOY_BACKUP_EXISTING", True):
                    ftp.rename(target_name, backup_name)
                    print(f"Backed up previous mission PBO as {backup_name}")
                else:
                    delete_existing(ftp, target_name)
            except ftplib.error_perm as error:
                raise locked_pbo_error(
                    target_name, temporary_name, error
                ) from error

        try:
            ftp.rename(temporary_name, target_name)
        except ftplib.error_perm as error:
            raise locked_pbo_error(target_name, temporary_name, error) from error
        print(f"Published {pbo.name} to {target} ({remote_size} bytes)")
        if env_bool("DEPLOY_BACKUP_EXISTING", True):
            try:
                prune_backups(ftp, target_name, backup_keep)
            except ftplib.Error as error:
                print(f"Warning: could not prune old mission backups: {error}")
    finally:
        try:
            ftp.quit()
        except (OSError, ftplib.Error):
            ftp.close()

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except MissionPboLockedError as error:
        print(f"::error title=Active mission PBO is locked::{error}")
        raise SystemExit(1) from None
