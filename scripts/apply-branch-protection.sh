#!/usr/bin/env bash
# Apply the branch protection payloads in .github/branch-protection/ via the
# GitHub REST API. GITHUB_TOKEN cannot change branch protection, so this needs
# a PAT with admin:repo_hook/repo scope (or a GitHub App token with
# "administration: write"). The apply workflow reads secrets.ADMIN_TOKEN.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROTECTION_DIR="${ROOT}/.github/branch-protection"

if [ -n "${ADMIN_TOKEN:-}" ]; then
  export GH_TOKEN="${ADMIN_TOKEN}"
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required" >&2
  exit 1
fi
if [ -z "${GH_TOKEN:-}" ]; then
  echo "Set ADMIN_TOKEN (or GH_TOKEN) to a token with repository administration rights" >&2
  exit 1
fi

REPO="${REPOSITORY:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}"
echo "Applying branch protection to ${REPO}"

for branch in testing stable; do
  payload="${PROTECTION_DIR}/${branch}.json"
  [ -f "$payload" ] || { echo "missing ${payload}" >&2; exit 1; }
  echo "== ${branch}"
  gh api --method PUT \
    -H 'Accept: application/vnd.github+json' \
    -H 'X-GitHub-Api-Version: 2022-11-28' \
    "repos/${REPO}/branches/${branch}/protection" \
    --input "$payload" >/dev/null
done

echo "Branch protection applied. Re-run with the same token after any payload change."
