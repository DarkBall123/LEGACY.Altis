#!/usr/bin/env python3
"""Upload a mission PBO over FTP using a checked temporary file."""

from __future__ import annotations

import argparse
import ftplib
import os
import posixpath
import ssl
from datetime import datetime, timezone
from pathlib import Path

from env_config import env_bool, load_env, required_env
from package_mission import ROOT
from package_mission_pbo import get_mission_name


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
            ftp: ftplib.FTP = ftplib.FTP_TLS(context=context)
        else:
            ftp = ftplib.FTP()

        ftp.connect(host, port, timeout=30)
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
    target = posixpath.join(remote_dir, f"{mission_name}.pbo")
    temporary = f"{target}.uploading"
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup = f"{target}.{timestamp}.bak"

    if args.dry_run:
        print(f"Would upload {pbo.name} ({pbo.stat().st_size} bytes) to {target}")
        return 0

    ftp = connect()
    try:
        ftp.cwd(remote_dir)
        if remote_exists(ftp, temporary):
            ftp.delete(temporary)

        with pbo.open("rb") as source:
            ftp.storbinary(f"STOR {temporary}", source, blocksize=1024 * 1024)

        remote_size = ftp.size(temporary)
        if remote_size != pbo.stat().st_size:
            ftp.delete(temporary)
            raise RuntimeError(
                f"Remote size mismatch: expected {pbo.stat().st_size}, got {remote_size}"
            )

        if remote_exists(ftp, target):
            if env_bool("DEPLOY_BACKUP_EXISTING", True):
                ftp.rename(target, backup)
                print(f"Backed up previous mission PBO as {posixpath.basename(backup)}")
            else:
                ftp.delete(target)

        ftp.rename(temporary, target)
        print(f"Published {pbo.name} to {target} ({remote_size} bytes)")
    finally:
        try:
            ftp.quit()
        except (OSError, ftplib.Error):
            ftp.close()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
