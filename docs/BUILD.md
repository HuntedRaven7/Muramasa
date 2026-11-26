# Building

## Prerequisites

- `podman` (rootful storage recommended in CI; `PODMAN="sudo podman"` locally)
- `just`
- `python3` with `pyyaml` for pin checks
- `cosign`, `oras`, `skopeo` for publishing (CI installs these via
  `projectbluefin/actions/bootc-build/setup-runner`)

BuildStream itself runs in the pinned FSDK `bst2` image, so no host install is
needed. The image digest is set by `BST2_IMAGE` in the `Justfile`. The `bst`
recipe marks restored git source directories as safe, since a seeded cache can
contain files owned by another uid.

## Local build

```sh
just validate
just build                    # rootfs -> OCI layout -> podman image
just lint
just test
just test-image
```

For the NVIDIA flavor use `just flavor-build nvidia`. Build outputs go to
`.build-out/` and are gitignored.

To avoid a cold local build, seed the BuildStream cache from CI first:

```sh
just cache-list                    # published archives, sizes and digests
just bootstrap-cache               # verify, resume and extract the newest partial
just cache-status                  # how many elements of the final target are cached
```

`bootstrap-cache` uses an anonymous GHCR pull token, verifies the archive
SHA-256 against the registry manifest, resumes interrupted downloads and never
pushes. Set `BST_CACHE_DIR` to seed a non-default cache directory. Stray
untracked files inside `files/`, `include/`, `elements/` or `patches/` change
BuildStream local-source keys, so `just test` fails on them; set
`ALLOW_STRAY_LOCAL_SOURCES=1` only when you know what you are doing.

## CI pipeline

CI jobs run on `ubuntu-26.04` hosted runners.

`.github/workflows/build.yml` runs on pushes and PRs to `testing`:

1. `validate` — pin checks, static element checks and the BuildStream graph
2. For each flavor (`base`, `nvidia`):
   - restore the GHCR cache (`just cache-pull`)
   - build and export the image
   - content assertions and `bootc container lint`
   - Trivy scan (`projectbluefin/actions/bootc-build/scan-image`)
   - rechunk with `chunka`
   - push `:testing` / `:testing-nvidia` and capture the digest
   - keyless cosign signing with SBOM + SLSA provenance
   - prune old GHCR tags
   - save the cache (`just cache-push`)

PRs run everything up to and including the scan, but do not push or sign.

## Updating sources

`just track` re-tracks mutable sources and prints the changes to
`include/versions.yml`. Review and commit the diff; a weekly workflow opens a
PR automatically. Never hand-edit a hash without verifying its origin.

## Known prerequisites for a first green build

The element graph is structured after Dakota and Mjolnir. On a fresh checkout,
some FSDK component paths may need to be adjusted to the exact set exported by
the pinned FSDK revision. Run `just bst show oci/muramasa.bst` first: it
validates every dependency name before any source is downloaded.
