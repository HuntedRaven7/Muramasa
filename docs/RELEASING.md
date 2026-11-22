# Releasing

Stable is a **digest promotion**, never a rebuild. Development happens on
`testing`; `stable` is a pointer to a digest that already passed CI on
`testing`.

## Streams

| Branch | Image tags | Purpose |
| --- | --- | --- |
| `testing` | `:testing`, `:testing-nvidia` | Daily builds |
| `stable` | `:stable`, `:stable-nvidia` | Promoted releases |

There is no `next` branch. `testing` is the primary/default branch;
`stable` is the promotion branch — a released digest is never rebuilt.

## Procedure

1. Pick a successful `:testing` digest with passing scan, signing and content
   assertions.
2. `just release` — dry run; prints the candidate and compares it with the
   current `:stable`.
3. `just release --apply` — dispatches `execute-release.yml` on `testing` to
   promote the digest and create a GitHub Release.
4. Both flavors must be promoted together. Verify with:
   ```sh
   skopeo inspect docker://ghcr.io/huntedraven7/muramasa:stable
   skopeo inspect docker://ghcr.io/huntedraven7/muramasa:stable-nvidia
   ```

## Recovery

`just release --apply sha=<40-char-sha>` promotes a specific commit's digest.
If a promoted image regresses, run `rollback-stable.yml` to point `:stable` at
the previous known-good digest. Never delete tags; GHCR cleanup handles old
untagged manifests.

Release notes are generated from Conventional Commits with `git-cliff`
(`cliff.toml`), and include SBOM and provenance links from the signing step.
