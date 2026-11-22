#!/usr/bin/env python3
"""Assertions over the exported Muramasa image.

Usage: python3 tests/test_image_contents.py [image]
Requires podman and a built image. Runs read-only commands inside the image.
"""
from __future__ import annotations

import subprocess
import sys

IMAGE = sys.argv[1] if len(sys.argv) > 1 else "localhost/muramasa:latest"
PODMAN = ["podman", "run", "--rm", "--entrypoint", "/bin/sh", IMAGE, "-c"]

REQUIRED_BINARIES = [
    "mango",
    "quickshell",
    "rofi",
    "wl-copy",
    "wtype",
    "mako",
    "playerctl",
    "grim",
    "slurp",
    "kitty",
    "nautilus",
    "voxtype",
    "steam",
    "firewall-cmd",
    "ujust",
    "just",
]

FORBIDDEN_PACKAGES = [
    # Wallpaper management belongs to the shell layer, not the base image.
    "swww",
    "swaybg",
    "hyprpaper",
    "nitrogen",
    "feh",
]

FORBIDDEN_PATHS = [
    # No Quickshell configuration is shipped by this repository.
    "/etc/xdg/quickshell",
    "/usr/share/quickshell/shell.qml",
]


def run(script: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(PODMAN + [script], capture_output=True, text=True, check=False)


def main() -> int:
    errors = 0

    for binary in REQUIRED_BINARIES:
        result = run(f"command -v {binary} >/dev/null 2>&1")
        if result.returncode != 0:
            print(f"FAIL: missing binary {binary}", file=sys.stderr)
            errors += 1

    for binary in FORBIDDEN_PACKAGES:
        result = run(f"command -v {binary} >/dev/null 2>&1")
        if result.returncode == 0:
            print(f"FAIL: forbidden wallpaper tool present: {binary}", file=sys.stderr)
            errors += 1

    for path in FORBIDDEN_PATHS:
        result = run(f"test -e {path}")
        if result.returncode == 0:
            print(f"FAIL: forbidden path present: {path}", file=sys.stderr)
            errors += 1

    result = run("grep -q 'ID=muramasa' /usr/lib/os-release")
    if result.returncode != 0:
        # os-release is supplied by FSDK; accept a Muramasa NAME as fallback.
        result = run("grep -qi 'muramasa' /usr/lib/os-release")
        if result.returncode != 0:
            print("FAIL: os-release does not identify Muramasa", file=sys.stderr)
            errors += 1

    result = run("test -x /usr/lib/steam/steam.sh")
    if result.returncode != 0:
        print("FAIL: native Steam launcher payload missing", file=sys.stderr)
        errors += 1

    result = run("test -f /boot/EFI/Linux/muramasa.efi")
    if result.returncode != 0:
        print("FAIL: missing UKI in /boot/EFI/Linux", file=sys.stderr)
        errors += 1

    result = run("test -d /usr/share/ujust || test -f /usr/share/ujust/ujust.just")
    if result.returncode != 0:
        print("FAIL: ujust recipes missing", file=sys.stderr)
        errors += 1

    if errors:
        print(f"{errors} image assertion(s) failed", file=sys.stderr)
        return 1
    print("image contents OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
