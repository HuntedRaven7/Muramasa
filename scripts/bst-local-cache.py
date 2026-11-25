#!/usr/bin/env python3
"""Seed a local BuildStream cache from the published GHCR CAS archive.

Read-only against the registry: this script never pushes. It uses an anonymous
pull token, verifies the archive SHA-256 against the manifest layer digest, and
resumes interrupted downloads with HTTP Range requests.
"""
from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import urllib.request
from pathlib import Path

REPOSITORY = "huntedraven7/muramasa-cache"
REGISTRY = "https://ghcr.io"
SERVICE = "ghcr.io"
MANIFEST_ACCEPT = ", ".join(
    [
        "application/vnd.oci.image.manifest.v1+json",
        "application/vnd.docker.distribution.manifest.v2+json",
    ]
)


def pull_token() -> str:
    url = f"{REGISTRY}/token?scope=repository:{REPOSITORY}:pull&service={SERVICE}"
    with urllib.request.urlopen(url) as response:
        return json.load(response)["token"]


def get_json(path: str, token: str, accept: str | None = None) -> dict:
    headers = {"Authorization": f"Bearer {token}"}
    if accept:
        headers["Accept"] = accept
    request = urllib.request.Request(f"{REGISTRY}/v2/{REPOSITORY}/{path}", headers=headers)
    with urllib.request.urlopen(request) as response:
        return json.load(response)


def manifest_for(tag: str, token: str) -> dict:
    return get_json(f"manifest/{tag}", token, MANIFEST_ACCEPT)


def cache_dir() -> Path:
    return Path(os.environ.get("BST_CACHE_DIR", Path.home() / ".cache/buildstream"))


def cmd_list() -> int:
    token = pull_token()
    tags = get_json("tags/list", token).get("tags") or []
    if not tags:
        print("No published cache tags")
        return 0
    print(f"{'TAG':<70} {'SIZE':>10}  DIGEST")
    for tag in sorted(tags):
        manifest = manifest_for(tag, token)
        layers = manifest.get("layers") or []
        if not layers:
            print(f"{tag:<70} {'?':>10}  no layers")
            continue
        layer = layers[0]
        size = int(layer.get("size", 0))
        print(f"{tag:<70} {size / 2**30:>9.2f}G  {layer['digest']}")
    return 0


def cmd_bootstrap(tag: str) -> int:
    token = pull_token()
    manifest = manifest_for(tag, token)
    layers = manifest.get("layers") or []
    if not layers:
        print("Manifest has no layers", file=sys.stderr)
        return 1
    digest = layers[0]["digest"]
    if not digest.startswith("sha256:"):
        print(f"Unsupported digest {digest}", file=sys.stderr)
        return 1
    expected = digest.split(":", 1)[1]

    target = cache_dir()
    target.mkdir(parents=True, exist_ok=True)
    state_dir = target / ".cas-bootstrap"
    state_dir.mkdir(parents=True, exist_ok=True)
    marker = state_dir / tag.replace("/", "_")
    if marker.exists() and marker.read_text().strip() == digest:
        print(f"Already seeded from {tag}")
        return 0

    archive = state_dir / f"{expected}.tar.zst"
    offset = archive.stat().st_size if archive.exists() else 0
    url = f"{REGISTRY}/v2/{REPOSITORY}/blobs/{digest}"
    headers = {"Authorization": f"Bearer {token}"}
    if offset:
        print(f"Resuming download at {offset / 2**20:.1f} MiB")
        headers["Range"] = f"bytes={offset}-"
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request) as response, archive.open("ab") as out:
        while chunk := response.read(1024 * 1024):
            out.write(chunk)

    actual = hashlib.sha256()
    with archive.open("rb") as stream:
        for chunk in iter(lambda: stream.read(4 * 1024 * 1024), b""):
            actual.update(chunk)
    if actual.hexdigest() != expected:
        print("Archive digest does not match the registry manifest", file=sys.stderr)
        return 1

    print(f"Extracting verified archive into {target} ...")
    subprocess.run(
        ["tar", "--use-compress-program=zstd", "-xf", str(archive), "-C", str(target)],
        check=True,
    )
    marker.write_text(digest + "\n")
    print(f"Seeded local cache from {tag}")
    return 0


def cmd_states() -> int:
    counts: dict[str, int] = {}
    total = 0
    for line in sys.stdin:
        state = line.strip().split("||")[-1]
        if not state:
            continue
        counts[state] = counts.get(state, 0) + 1
        total += 1
    for state, count in sorted(counts.items()):
        print(f"{state}: {count}")
    cached = counts.get("cached", 0)
    print(f"{cached} of {total} elements are cached")
    return 0


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: bst-local-cache.py {list|bootstrap TAG|states}", file=sys.stderr)
        return 2
    action = sys.argv[1]
    if action == "list":
        return cmd_list()
    if action == "bootstrap" and len(sys.argv) == 3:
        return cmd_bootstrap(sys.argv[2])
    if action == "states":
        return cmd_states()
    print(f"unknown action: {action}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
