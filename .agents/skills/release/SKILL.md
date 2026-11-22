---
name: muramasa-release
description: Promote a tested Muramasa testing digest to the stable stream and cut a GitHub Release.
---

# Releasing

1. Confirm the candidate digest is a successful `:testing` build with passing
   scan, signing, and content assertions.
2. Run `just release` for the preflight report. It dispatches
   `execute-release.yml` in dry-run mode on `testing`.
3. Review the printed candidate SHA and the comparison with current `:stable`.
4. Run `just release --apply` (or `just release --apply sha=<40-char-sha>` for
   recovery by a specific commit) to promote the digest.
5. Verify both flavors: `muramasa:stable` and `muramasa:stable-nvidia` point to
   the intended manifests.

Stable is always a promotion of an existing digest, never a rebuild. Roll back
with the `rollback-stable.yml` workflow if a promoted image regresses.
