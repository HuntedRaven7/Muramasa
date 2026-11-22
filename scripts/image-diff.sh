#!/usr/bin/env bash
# Compare the published stream image with the local build for PR comments.
set -euo pipefail

old="${1:?usage: image-diff.sh OLD NEW OUTPUT}"
new="${2:?usage: image-diff.sh OLD NEW OUTPUT}"
out="${3:?usage: image-diff.sh OLD NEW OUTPUT}"
podman="${PODMAN:-sudo podman}"

{
  echo "## Image diff"
  echo
  echo '```text'
  "$podman" image diff "$old" "$new" 2>/dev/null || echo "(old image not available locally)"
  echo '```'
} > "$out"

echo "wrote $out"
