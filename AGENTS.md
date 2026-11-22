# Muramasa — contributor guide

Muramasa is an FSDK-based bootc OCI image for Wayland-compositor desktops.
Mango is the compositor; Quickshell v0.3.2 is provided as a binary only. The
image owner supplies all shell configuration after installation — **never add
shell configuration files to this repository**.

## Ground rules

- Never add a Quickshell config, QML file, or shell autostart unit. Source build
  recipes named `elements/compositor/quickshell.bst` are the only exception.
- Every third-party artifact is pinned in `include/versions.yml`. Use
  `just track`, review the diff, then open a PR. No mutable refs in elements.
- Both GPU flavors are built from this one tree: `nvidia=false` (default) and
  `nvidia=true`. Never fork the element graph for a flavor.
- `testing` is the development branch. `stable` is a digest promotion, never a
  rebuild. `main` is a historical pointer.

## Layout

| Path | Purpose |
| --- | --- |
| `elements/` | BuildStream element graph (FSDK junction, base, compositor, tooling, gaming, OCI) |
| `files/` | Static configuration installed by `files/*.bst` elements |
| `include/` | Aliases, pins and flavor variables included by `project.conf` |
| `scripts/` | Cache transport, pin checks, image diff helpers |
| `tests/` | Content assertions run in CI |
| `.agents/skills/` | Task-specific guidance for coding agents |
| `.github/workflows/` | Build, quality, cache cleanup, release automation |

## Build and test

```sh
just doctor            # host prerequisites (optional)
just validate          # pin check + BuildStream graph
just build             # build and export oci/muramasa.bst
just flavor-build nvidia
just lint              # bootc container lint
just test              # host-side static checks
just test-image        # image content assertions
```

BuildStream runs inside the pinned FSDK `bst2` container. BST is not installed
on the host. Set `PODMAN=sudo podman` if your user needs elevated storage.

## Cache

The BuildStream cache is stored as an OCI artifact in
`ghcr.io/huntedraven7/muramasa-cache`. Upstream FSDK artifacts are pulled from
the GNOME (`gbm.gnome.org`) and Bluefin (`cache.projectbluefin.io`) caches
declared in `project.conf`. See `docs/CACHE.md`.

## Pull requests

- Use Conventional Commits titles (`feat:`, `fix:`, `chore:`, `docs:`).
- Run `just validate` and `just test` before pushing.
- Update `include/versions.yml` and `docs/` together when a pin changes.
- Do not commit generated artifacts (`.build-out/`, `sbom_out/`, raw images).

## Releases

`just release` dispatches `execute-release.yml` on `testing` in dry-run mode;
`just release --apply` promotes the reviewed digest to `:stable` and cuts a
GitHub Release. See `docs/RELEASING.md`.
