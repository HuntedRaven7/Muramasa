#!/usr/bin/env bash
# Move the local BuildStream cache to/from a GHCR OCI artifact.
#
# GitHub Actions cache has a 10 GB per-repository cap and evicts aggressively;
# an FSDK cache is many GB. GHCR artifacts are free and uncapped, so the cache
# travels as an OCI artifact attached to ghcr.io/huntedraven7/muramasa-cache.
#
# Required env (CI sets these):
#   BST_CACHE_REF   e.g. ghcr.io/huntedraven7/muramasa-cache
#   BST_CACHE_KEY   graph key; unset on a failed build so partial caches are
#                   never advertised as complete
#   GH_TOKEN        GitHub token with packages:write
#   GITHUB_ACTOR    registry user
set -euo pipefail

CACHE_DIR="${HOME}/.cache/buildstream"
CACHE_ARCHIVE="${CACHE_DIR}.tar.zst"
ACTION="${1:-}"

: "${BST_CACHE_REF:?BST_CACHE_REF must be set}"

case "$ACTION" in
  pull)
    if [ -z "${BST_CACHE_KEY:-}" ]; then
      echo "BST_CACHE_KEY unset; skipping cache pull"
      exit 0
    fi
    mkdir -p "$CACHE_DIR"
    echo "Pulling ${BST_CACHE_REF}:${BST_CACHE_KEY}"
    if oras pull "${BST_CACHE_REF}:${BST_CACHE_KEY}" --output "$CACHE_DIR" 2>/dev/null; then
      echo "Cache restored"
    else
      echo "No cache for key ${BST_CACHE_KEY}; starting cold" >&2
    fi
    ;;

  push)
    if [ -z "${BST_CACHE_KEY:-}" ]; then
      echo "BST_CACHE_KEY unset; skipping cache push (partial build)"
      exit 0
    fi
    [ -d "$CACHE_DIR" ] || { echo "No local cache to push" >&2; exit 0; }
    echo "${GH_TOKEN}" | oras login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin
    tar --use-compress-program=zstd -cf "$CACHE_ARCHIVE" -C "$(dirname "$CACHE_DIR")" "$(basename "$CACHE_DIR")"
    oras push "${BST_CACHE_REF}:${BST_CACHE_KEY}" \
      "${CACHE_ARCHIVE}:application/vnd.muramasa.bst-cache.v1.tar.zst"
    echo "${BST_CACHE_KEY}" > "${CACHE_DIR}/cache-key"
    ;;

  *)
    echo "usage: $0 {pull|push}" >&2
    exit 2
    ;;
esac
