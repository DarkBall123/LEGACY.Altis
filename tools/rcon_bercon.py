#!/usr/bin/env python3
"""Minimal BattlEye RCon client (UDP) for one-shot server commands.

Protocol reference: BattlEye "BERConProtocol" spec. Packet layout:
  'B' 'E' <crc32 LE of payload> <payload>
  payload = 0xFF <type> <data>
  type 0x00 = login (data: plain-text password), reply data: 0x01 ok / 0x00 fail
  type 0x01 = command (data: seq byte + command string)
  type 0x02 = server message (data: seq byte + text), must be acked back

Usage:
  python3 tools/rcon_bercon.py "#restartserver"
  (connection settings come from DEPLOY_RCON_HOST/PORT/PASSWORD env vars
   or the repository .env)
"""

from __future__ import annotations

import os
import socket
import sys
import zlib
from pathlib import Path

from env_config import load_env, required_env


class RConError(RuntimeError):
    pass


def _packet(payload: bytes) -> bytes:
    return b"BE" + zlib.crc32(payload).to_bytes(4, "little") + payload


def _payload(packet: bytes) -> bytes:
    if len(packet) < 7 or packet[:2] != b"BE":
        raise RConError(f"Malformed RCon packet: {packet!r}")
    crc = int.from_bytes(packet[2:6], "little")
    payload = packet[6:]
    if zlib.crc32(payload) != crc:
        raise RConError("RCon packet CRC mismatch")
    if payload[:1] != b"\xff":
        raise RConError(f"Unexpected RCon payload start: {payload!r}")
    return payload


class BERCon:
    def __init__(self, host: str, port: int, password: str, timeout: float = 5.0):
        self.host = host
        self.port = port
        self.password = password
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.settimeout(timeout)

    def close(self) -> None:
        self.sock.close()

    def _send(self, payload: bytes) -> None:
        self.sock.sendto(_packet(payload), (self.host, self.port))

    def _recv(self) -> bytes:
        data, _ = self.sock.recvfrom(4096)
        return _payload(data)

    def login(self) -> None:
        self._send(b"\xff\x00" + self.password.encode("ascii"))
        payload = self._recv()
        if payload[1:2] != b"\x00":
            raise RConError(f"Expected login response, got type {payload[1]:#x}")
        if payload[2:3] != b"\x01":
            raise RConError("RCon login failed: wrong password")

    def command(self, text: str, wait_reply: float = 2.0) -> str:
        """Send one command. Returns reply text ('' if the server stayed
        silent — expected for #shutdown/#restartserver, which may kill the
        process before the ack goes out)."""
        self._send(b"\xff\x01\x00" + text.encode("utf-8"))

        self.sock.settimeout(wait_reply)
        reply = ""
        try:
            while True:
                payload = self._recv()
                kind = payload[1]
                if kind == 0x01:  # command response (maybe multi-part)
                    body = payload[3:]
                    if body[:1] == b"\x00" and len(body) >= 3:
                        body = body[3:]  # multi-part header: 0x00 total index
                    reply += body.decode("utf-8", "replace")
                elif kind == 0x02:  # server message: ack and ignore
                    self._send(b"\xff\x02" + payload[2:3])
        except socket.timeout:
            pass
        return reply


def main() -> int:
    load_env(Path(__file__).resolve().parent.parent / ".env")

    if len(sys.argv) < 2:
        print(__doc__)
        return 2

    host = os.environ.get("DEPLOY_RCON_HOST", "").strip() or required_env("DEPLOY_HOST")
    port = int(required_env("DEPLOY_RCON_PORT"))
    password = required_env("DEPLOY_RCON_PASSWORD")

    rcon = BERCon(host, port, password)
    try:
        rcon.login()
        reply = rcon.command(" ".join(sys.argv[1:]))
        if reply:
            print(reply)
        print("RCon command sent")
    finally:
        rcon.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
