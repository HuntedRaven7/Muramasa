#!/usr/bin/env bash
# Move the local BuildStream CAS to/from a GHCR OCI artifact.
#
# Keys:
#   BST_CACHE_KEY          complete, graph-keyed cache from a successful build
#   BST_CACHE_FALLBACK_KEY immutable snapshot for this run/attempt (partial)
#   BST_CACHE_LATEST_KEY   rolling pointer to the newest partial snapshot
#
# Sources live in GitHub Actions cache, not in the CAS archive. A failed build
# never publishes a complete key; it publishes an immutable snapshot plus the
# rolling pointer. Pull tries exact, newest partial, then this run's snapshot.
set -euo pipefail

CACHE_DIR="${HOME}/.cache/buildstream"
# oras rejects absolute file paths, so keep the archive relative to the workspace.
CACHE_ARCHIVE="buildstream-cache.tar.zst"
ACTION="${1:-}"

: "${BST_CACHE_REF:?BST_CACHE_REF must be set}"

restore_cache() {
  local key="$1"
  local archive_path="${CACHE_DIR}/${CACHE_ARCHIVE}"
  local attempt downloaded

  # A ~28 GB download occasionally stalls and is cut off after ~10 minutes.
  # Retry a few times before giving up on the key; keep stderr visible so the
  # failure is diagnosable in CI logs instead of looking like a missing tag.
  downloaded=0
  for attempt in 1 2 3; do
    rm -f "$archive_path"
    echo "Pulling ${BST_CACHE_REF}:${key} (attempt ${attempt})"
    if oras pull "${BST_CACHE_REF}:${key}" --output "$CACHE_DIR"; then
      downloaded=1
      break
    fi
    echo "Pull of ${key} failed on attempt ${attempt}" >&2
  done
  if [ "$downloaded" -eq 0 ]; then
    echo "No cache for key ${key}; trying next" >&2
    return 1
  fi

  # oras writes named artifact files; it never unpacks tar layers. The archive
  # was created with a top-level buildstream/ directory, so unpack it one level
  # above CACHE_DIR to recreate the original layout. Without this step every
  # build starts with an empty CAS and takes hours instead of minutes.
  if [ ! -f "$archive_path" ]; then
    echo "Cache artifact ${key} is missing ${CACHE_ARCHIVE}; trying next" >&2
    return 1
  fi
  if ! tar --use-compress-program=zstd -xf "$archive_path" -C "$(dirname "$CACHE_DIR")"; then
    echo "Failed to unpack cache artifact ${key}; trying next" >&2
    return 1
  fi
  rm -f "$archive_path"
  echo "Restored cache from ${key}"
}

case "$ACTION" in
  pull)
    keys=()
    [ -n "${BST_CACHE_KEY:-}" ] && keys+=("$BST_CACHE_KEY")
    [ -n "${BST_CACHE_LATEST_KEY:-}" ] && keys+=("$BST_CACHE_LATEST_KEY")
    [ -n "${BST_CACHE_FALLBACK_KEY:-}" ] && keys+=("$BST_CACHE_FALLBACK_KEY")
    if [ "${#keys[@]}" -eq 0 ]; then
      echo "No cache keys configured; starting cold"
      exit 0
    fi
    mkdir -p "$CACHE_DIR"
    restored=0
    for key in "${keys[@]}"; do
      if restore_cache "$key"; then
        restored=1
        break
      fi
    done
    if [ "$restored" -eq 0 ]; then
      echo "No usable cache found; starting cold" >&2
    fi
    ;;

  push)
    if [ ! -d "$CACHE_DIR" ]; then
      echo "No local cache to push" >&2
      exit 0
    fi
    available_kb=$(df -Pk . | awk 'NR==2 {print $4}')
    if [ "${available_kb:-0}" -lt 1048576 ]; then
      echo "Less than 1 GiB free; skipping cache push" >&2
      exit 0
    fi

    if [ -n "${BST_CACHE_KEY:-}" ]; then
      keys=("$BST_CACHE_KEY")
    else
      keys=()
      [ -n "${BST_CACHE_FALLBACK_KEY:-}" ] && keys+=("$BST_CACHE_FALLBACK_KEY")
      [ -n "${BST_CACHE_LATEST_KEY:-}" ] && keys+=("$BST_CACHE_LATEST_KEY")
    fi
    if [ "${#keys[@]}" -eq 0 ]; then
      echo "No cache key configured; skipping cache push"
      exit 0
    fi

    echo "${GH_TOKEN}" | oras login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin
    echo "Cache source: ${CACHE_DIR} ($(du -sh "${CACHE_DIR}" | cut -f1))"
    echo "Creating ${CACHE_ARCHIVE} ..."
    # Exclude sources (cached separately), daemon sockets and volatile scratch.
    tar --use-compress-program=zstd \
      --exclude='sources/*' \
      --exclude='casserver-*.sock' \
      --exclude='cas/tmp/*' \
      --exclude='cas/staging/*' \
      --exclude='tmp/*' \
      --ignore-failed-read \
      --warning=no-file-changed \
      -cf "$CACHE_ARCHIVE" \
      -C "$(dirname "$CACHE_DIR")" "$(basename "$CACHE_DIR")"
    echo "Archive size: $(du -h "${CACHE_ARCHIVE}" | cut -f1)"
    for key in "${keys[@]}"; do
      echo "Pushing ${CACHE_ARCHIVE} to ${BST_CACHE_REF}:${key} ..."
      oras push "${BST_CACHE_REF}:${key}" \
        "${CACHE_ARCHIVE}:application/vnd.muramasa.bst-cache.v1.tar.zst"
      echo "Pushed cache as ${key}"
    done
    rm -f "$CACHE_ARCHIVE"
    ;;

  *)
    echo "usage: $0 {pull|push}" >&2
    exit 2
    ;;
esac
