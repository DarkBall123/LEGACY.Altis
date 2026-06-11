#!/usr/bin/env python3
"""Send a command through the BattlEye RCon protocol."""

from __future__ import annotations

import argparse
import binascii
import os
import socket
import struct
from pathlib import Path

from env_config import load_env, required_env
from package_mission import ROOT


def packet(payload: bytes) -> bytes:
    checksum = binascii.crc32(payload) & 0xFFFFFFFF
    return b"BE" + struct.pack("<I", checksum) + b"\xff" + payload


def payload_from(data: bytes) -> bytes:
    if len(data) < 8 or data[:2] != b"BE" or data[6] != 0xFF:
        raise RuntimeError("Invalid BattlEye RCon packet")
    payload = data[7:]
    expected = struct.unpack("<I", data[2:6])[0]
    if binascii.crc32(payload) & 0xFFFFFFFF != expected:
        raise RuntimeError("BattlEye RCon checksum mismatch")
    return payload


class RCon:
    def __init__(self, host: str, port: int, password: str, timeout: float) -> None:
        self.address = (host, port)
        self.password = password
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.socket.settimeout(timeout)
        self.sequence = 0

    def close(self) -> None:
        self.socket.close()

    def exchange(self, payload: bytes, expected_type: int) -> bytes:
        request = packet(payload)
        last_error: Exception | None = None
        for _ in range(3):
            self.socket.sendto(request, self.address)
            try:
                while True:
                    data, address = self.socket.recvfrom(65535)
                    if address[0] != socket.gethostbyname(self.address[0]):
                        continue
                    response = payload_from(data)
                    if response[0] == 0x02:
                        self.socket.sendto(packet(response[:2]), self.address)
                        continue
                    if response[0] == expected_type:
                        return response
            except socket.timeout as error:
                last_error = error
        raise TimeoutError("BattlEye RCon did not respond") from last_error

    def login(self) -> None:
        response = self.exchange(
            b"\x00" + self.password.encode("ascii"), expected_type=0x00
        )
        if len(response) < 2 or response[1] != 0x01:
            raise PermissionError("BattlEye RCon authentication failed")

    def command(self, command: str) -> str:
        sequence = self.sequence
        self.sequence = (self.sequence + 1) % 256
        response = self.exchange(
            b"\x01" + bytes([sequence]) + command.encode("ascii"),
            expected_type=0x01,
        )
        if len(response) < 2 or response[1] != sequence:
            raise RuntimeError("BattlEye RCon sequence mismatch")
        return response[2:].decode("utf-8", errors="replace")


def main() -> int:
    load_env(ROOT / ".env")

    parser = argparse.ArgumentParser()
    parser.add_argument("command", nargs="?", default="players")
    parser.add_argument("--timeout", type=float, default=5)
    args = parser.parse_args()

    host = os.environ.get("RCON_HOST") or required_env("DEPLOY_HOST")
    port = int(required_env("RCON_PORT"))
    password = required_env("RCON_PASSWORD")

    client = RCon(host, port, password, args.timeout)
    try:
        client.login()
        response = client.command(args.command)
    finally:
        client.close()

    print(response.strip() or "RCon command accepted")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
