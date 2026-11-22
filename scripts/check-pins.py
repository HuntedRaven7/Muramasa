#!/usr/bin/env python3
"""Fail fast on placeholder pins and mismatched release metadata.

Run by `just test` and by the validate workflow. Kept deliberately simple so
it can run on the host without BuildStream installed.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERSIONS = ROOT / "include" / "versions.yml"
ELEMENTS = ROOT / "elements"

PLACEHOLDER = re.compile(r"REPLACE_ME|FIXME|TODO\(\)")
SHA256 = re.compile(r"\b[0-9a-f]{64}\b")
SHA1 = re.compile(r"\b[0-9a-f]{40}\b")


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)


def main() -> int:
    errors = 0
    versions = VERSIONS.read_text(encoding="utf-8")

    if PLACEHOLDER.search(versions):
        fail("include/versions.yml contains a placeholder pin")
        errors += 1

    # Every pin that claims to be a checksum must have the right shape.
    for name, value in re.findall(r'^\s{2}([\w-]+):\s*"?([^"\n]+)"?', versions, re.M):
        if "sha256" in name and not SHA256.fullmatch(value):
            fail(f"{name} is not a 64-character sha256: {value!r}")
            errors += 1
        if name.endswith("-ref") and "ref" in name and name not in {
            "fsdk-ref",
            "buildstream-plugins-ref",
            "buildstream-plugins-community-ref",
            "bst-sbom-ref",
            "brew-ref",
            "ogc-kernel-ref",
        } and not (SHA1.fullmatch(value) or SHA256.fullmatch(value)):
            fail(f"{name} is not a pinned commit: {value!r}")
            errors += 1

    # The Quickshell tag must dereference to the pinned commit recorded here.
    tag = re.search(r'quickshell-tag-ref:\s*"([0-9a-f]+)"', versions)
    commit = re.search(r'quickshell-ref:\s*"([0-9a-f]+)"', versions)
    if not tag or not commit:
        fail("Quickshell tag/ref missing from versions.yml")
        errors += 1
    elif tag.group(1) == commit.group(1):
        fail("Quickshell tag object sha and commit sha must differ")
        errors += 1

    # No Quickshell configuration of any kind may be committed to the repo.
    forbidden = [p for p in ROOT.rglob("*") if p.is_file() and "quickshell" in p.name.lower()]
    for path in forbidden:
        # Elements named quickshell.bst are the source build recipe, allowed.
        if path.suffix == ".bst":
            continue
        fail(f"unexpected Quickshell configuration file: {path.relative_to(ROOT)}")
        errors += 1

    # Every element referenced by a local source must exist.
    for element in ELEMENTS.rglob("*.bst"):
        text = element.read_text(encoding="utf-8")
        for rel in re.findall(r"path:\s*(files/[^\s]+)", text):
            if not (ROOT / rel).exists():
                fail(f"{element.relative_to(ROOT)} references missing {rel}")
                errors += 1

    if errors:
        print(f"{errors} pin/metadata error(s)", file=sys.stderr)
        return 1
    print("pins OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
