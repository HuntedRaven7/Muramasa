#!/usr/bin/env bash
# Move the local BuildStream cache to/from a GHCR OCI artifact.
#
# GitHub Actions cache has a 10 GB per-repository cap and evicts aggressively;
# an FSDK cache is many GB. GHCR artifacts are free and uncapped for public
# projects, so the cache travels as an OCI artifact attached to
# ghcr.io/huntedraven7/muramasa-cache.
#
# Two keys are used:
#   BST_CACHE_KEY          complete, graph-keyed cache from a successful build
#   BST_CACHE_FALLBACK_KEY rolling "partial" cache from failed/timed-out builds
#
# A failed build must never be advertised as complete, but its artifacts are
# still valid and make the next attempt much faster. Pull tries the complete
# key first, then the rolling partial key. Push uses the complete key on
# success and the partial key otherwise.
set -euo pipefail

CACHE_DIR="${HOME}/.cache/buildstream"
# oras rejects absolute file paths unless --disable-path-validation is used.
# Keep the archive relative to the working directory (the CI workspace).
CACHE_ARCHIVE="buildstream-cache.tar.zst"
ACTION="${1:-}"

: "${BST_CACHE_REF:?BST_CACHE_REF must be set}"

case "$ACTION" in
  pull)
    keys=()
    [ -n "${BST_CACHE_KEY:-}" ] && keys+=("$BST_CACHE_KEY")
    [ -n "${BST_CACHE_FALLBACK_KEY:-}" ] && keys+=("$BST_CACHE_FALLBACK_KEY")
    if [ "${#keys[@]}" -eq 0 ]; then
      echo "No cache keys configured; starting cold"
      exit 0
    fi
    mkdir -p "$CACHE_DIR"
    restored=0
    for key in "${keys[@]}"; do
      echo "Pulling ${BST_CACHE_REF}:${key}"
      if oras pull "${BST_CACHE_REF}:${key}" --output "$CACHE_DIR" 2>/dev/null; then
        echo "Restored cache from ${key}"
        restored=1
        break
      fi
      echo "No cache for key ${key}; trying next" >&2
    done
    if [ "$restored" -eq 0 ]; then
      echo "No usable cache found; starting cold" >&2
    fi
    ;;

  push)
    key="${BST_CACHE_KEY:-${BST_CACHE_FALLBACK_KEY:-}}"
    if [ -z "$key" ]; then
      echo "No cache key configured; skipping cache push"
      exit 0
    fi
    if [ ! -d "$CACHE_DIR" ]; then
      echo "No local cache to push" >&2
      exit 0
    fi
    echo "${GH_TOKEN}" | oras login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin
    echo "Cache source: ${CACHE_DIR} ($(du -sh "${CACHE_DIR}" | cut -f1))"
    echo "Creating ${CACHE_ARCHIVE} ..."
    # Exclude volatile scratch state: the cache-server socket, FUSE mounts and
    # staging directories. These are recreated on restore and can be unreadable
    # or still changing while tar runs.
    tar --use-compress-program=zstd \
      --exclude='casserver-*.sock' \
      --exclude='cas/tmp/*' \
      --exclude='cas/staging/*' \
      --exclude='tmp/*' \
      --ignore-failed-read \
      --warning=no-file-changed \
      --checkpoint=50 \
      --checkpoint-action=echo='  archived %{r} records' \
      -cf "$CACHE_ARCHIVE" \
      -C "$(dirname "$CACHE_DIR")" "$(basename "$CACHE_DIR")"
    echo "Archive size: $(du -h "${CACHE_ARCHIVE}" | cut -f1)"
    echo "Pushing ${CACHE_ARCHIVE} to ${BST_CACHE_REF}:${key} ..."
    oras push "${BST_CACHE_REF}:${key}" \
      "${CACHE_ARCHIVE}:application/vnd.muramasa.bst-cache.v1.tar.zst"
    rm -f "$CACHE_ARCHIVE"
    echo "Pushed cache as ${key}"
    ;;

  *)
    echo "usage: $0 {pull|push}" >&2
    exit 2
    ;;
esac
