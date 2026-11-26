#!/usr/bin/env python3
"""Recompute pinned git refs in include/versions.yml from upstream remotes.

Adapted from the pin-update pattern in projectbluefin/Mjolnir. Renovate or the
scheduled workflow moves a track; this script resolves the newest matching ref
and rewrites every dependent pin. BuildStream still sees only fixed refs.

Usage:
  python3 scripts/update-pins.py [--check]
"""
from __future__ import annotations

import argparse
import fnmatch
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERSIONS = ROOT / "include" / "versions.yml"
TIMEOUT = 120

# key: (url, kind, track, mode)
#   kind:  tag or branch
#   mode:  describe -> "<tag>-0-g<sha>"; commit -> "<sha>"
SOURCES: dict[str, tuple[str, str, str, str]] = {
    "fsdk-ref": ("https://gitlab.com/freedesktop-sdk/freedesktop-sdk.git", "tag", "freedesktop-sdk-26.08*", "describe"),
    "buildstream-plugins-ref": ("https://github.com/apache/buildstream-plugins.git", "tag", "*.*.*", "describe"),
    "quickshell-ref": ("https://github.com/quickshell-mirror/quickshell.git", "tag", "v0.3.*", "commit"),
    "mango-ref": ("https://github.com/mangowm/mango.git", "branch", "main", "commit"),
    "kitty-ref": ("https://github.com/kovidgoyal/kitty.git", "branch", "master", "commit"),
    "nautilus-ref": ("https://github.com/GNOME/nautilus.git", "branch", "main", "commit"),
    "rofi-ref": ("https://github.com/lbonn/rofi.git", "branch", "wayland", "commit"),
    "wl-clipboard-ref": ("https://github.com/bugaevc/wl-clipboard.git", "branch", "master", "commit"),
    "wtype-ref": ("https://github.com/atenart/wtype.git", "branch", "master", "commit"),
    "mako-ref": ("https://github.com/emersion/mako.git", "branch", "master", "commit"),
    "swayosd-ref": ("https://github.com/ErikReider/SwayOSD.git", "branch", "main", "commit"),
    "playerctl-ref": ("https://github.com/altdesktop/playerctl.git", "branch", "main", "commit"),
    "grim-ref": ("https://github.com/emersion/grim.git", "branch", "master", "commit"),
    "slurp-ref": ("https://github.com/emersion/slurp.git", "branch", "master", "commit"),
    "xdg-desktop-portal-wlr-ref": ("https://github.com/emersion/xdg-desktop-portal-wlr.git", "branch", "master", "commit"),
    "cjson-ref": ("https://github.com/DaveGamble/cJSON.git", "branch", "master", "commit"),
    "scenefx-ref": ("https://github.com/wlrfx/scenefx.git", "tag", "0.5", "commit"),
    "wlroots-ref": ("https://gitlab.freedesktop.org/wlroots/wlroots.git", "tag", "0.20.*", "commit"),
    "qt6-base-ref": ("https://github.com/qt/qtbase.git", "tag", "v6.11.*", "commit"),
    "qt6-declarative-ref": ("https://github.com/qt/qtdeclarative.git", "tag", "v6.11.*", "commit"),
    "qt6-svg-ref": ("https://github.com/qt/qtsvg.git", "tag", "v6.11.*", "commit"),
    "qt6-wayland-ref": ("https://github.com/qt/qtwayland.git", "tag", "v6.11.*", "commit"),
    "ly-ref": ("https://github.com/fairyglade/ly.git", "branch", "master", "commit"),
    "firewalld-ref": ("https://github.com/firewalld/firewalld.git", "tag", "v2.5.*", "commit"),
    "zig-clap-ref": ("https://github.com/Hejsil/zig-clap.git", "branch", "master", "commit"),
    "gtk4-ref": ("https://github.com/GNOME/gtk.git", "branch", "main", "commit"),
    "libadwaita-ref": ("https://github.com/GNOME/libadwaita.git", "branch", "main", "commit"),
    "glycin-ref": ("https://github.com/GNOME/glycin.git", "branch", "main", "commit"),
    "gnome-autoar-ref": ("https://github.com/GNOME/gnome-autoar.git", "branch", "main", "commit"),
    "gnome-desktop-ref": ("https://github.com/GNOME/gnome-desktop.git", "branch", "master", "commit"),
    "libgxdp-ref": ("https://github.com/GNOME/libgxdp.git", "branch", "main", "commit"),
    "libportal-ref": ("https://github.com/flatpak/libportal.git", "branch", "main", "commit"),
    "tinysparql-ref": ("https://github.com/GNOME/tinysparql.git", "branch", "main", "commit"),
    "blueprint-compiler-ref": ("https://github.com/GNOME/blueprint-compiler.git", "branch", "main", "commit"),
}


def sh(cmd: list[str]) -> str:
    return subprocess.run(
        cmd, check=True, capture_output=True, text=True, timeout=TIMEOUT
    ).stdout.strip()


def version_key(tag: str) -> tuple:
    return tuple(int(p) if p.isdigit() else p for p in re.split(r"(\d+)", tag))


def resolve(url: str, kind: str, track: str, mode: str) -> str:
    if kind == "branch":
        refs = sh(["git", "ls-remote", "--refs", url, f"refs/heads/{track}"])
        lines = refs.splitlines()
        if not lines:
            raise RuntimeError(f"branch {track} not found in {url}")
        sha = lines[-1].split()[0]
        return sha

    output = sh(["git", "ls-remote", "--tags", url])
    peeled: dict[str, str] = {}
    tags: list[str] = []
    for line in output.splitlines():
        sha, ref = line.split("\t", 1)
        if ref.endswith("^{}"):
            peeled[ref[:-3]] = sha
        elif ref.startswith("refs/tags/"):
            tags.append(ref[len("refs/tags/") :])

    matches = [t for t in tags if fnmatch.fnmatchcase(t, track) and "*" not in t]
    if not matches:
        raise RuntimeError(f"no tag matching {track} in {url}")
    tag = sorted(matches, key=version_key)[-1]
    sha = peeled.get(f"refs/tags/{tag}")
    if sha is None:
        for line in output.splitlines():
            value, ref = line.split("\t", 1)
            if ref == f"refs/tags/{tag}":
                sha = value
                break
    if not sha:
        raise RuntimeError(f"could not resolve commit for tag {tag} in {url}")
    if mode == "describe":
        return f"{tag}-0-g{sha}"
    return sha


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="fail if any pin would change")
    args = parser.parse_args()

    text = VERSIONS.read_text(encoding="utf-8")
    updated = text
    changes: list[str] = []

    for key, (url, kind, track, mode) in SOURCES.items():
        current_match = re.search(rf'^  {re.escape(key)}:\s*"([^"]*)"', updated, re.M)
        if not current_match:
            print(f"skip: {key} is not in versions.yml", file=sys.stderr)
            continue
        current = current_match.group(1)
        try:
            newest = resolve(url, kind, track, mode)
        except (subprocess.CalledProcessError, RuntimeError) as exc:
            print(f"warn: {key}: {exc}", file=sys.stderr)
            continue
        if newest == current:
            continue
        updated = re.sub(
            rf'^(  {re.escape(key)}:\s*)"[^"]*"',
            lambda m: f'{m.group(1)}"{newest}"',
            updated,
            count=1,
            flags=re.M,
        )
        changes.append(f"{key}: {current} -> {newest}")

    for line in changes:
        print(line)
    if not changes:
        print("all pins up to date")
        return 0
    if args.check:
        print(f"{len(changes)} pin(s) are out of date", file=sys.stderr)
        return 1
    VERSIONS.write_text(updated, encoding="utf-8")
    print(f"updated {len(changes)} pin(s) in {VERSIONS}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
