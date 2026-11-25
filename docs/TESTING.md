# Testing

Muramasa combines the shared Bluefin E2E suite with Mango-specific checks.

## Shared suite

`.github/workflows/testsuite.yml` calls the reusable
`projectbluefin/testsuite/.github/workflows/e2e.yml@v1` workflow with the
portable `common` suite. It boots the published `:testing` image in QEMU and
checks SSH health, portals, polkit, immutability and Flatpak support.

The upstream `smoke`/`developer`/`dx` suites are not enabled: they drive GNOME
Shell through dogtail/qecore, and Muramasa ships no GNOME Shell.

## Mango smoke checks

`testsuite/smoke.sh` runs inside the exported OCI image via `podman run` and
asserts:

- Mango binary, default config and Wayland session entry
- WC tooling (rofi, wl-clipboard, wtype, mako, swayosd, playerctl, grim, slurp,
  kitty, Nautilus, Voxtype)
- native Steam launcher and its 32-bit runtime slice
- firewalld, `ujust`, agent guidance
- UKI boot asset and recorded OGC kernel version
- no wallpaper manager and no shell configuration
- Ly service, Tokyo Night config, tty1 enablement and the Secure Boot certificate
- the wlroots portal backend

The intent is also documented as behave scenarios in
`testsuite/features/mango-smoke.feature`.

## Running and gating

```sh
just e2e                       # local Mango smoke against a local image
IMAGE=... ./testsuite/smoke.sh # point at a published image
```

`testsuite.yml` runs after successful `build` runs on `testing`, and on manual
dispatch. It is a post-merge gate rather than a PR check: a PR build takes hours,
so waiting for its image inside a PR check is impractical. A protected branch
requires only the fast checks (`validate`, both image jobs, pre-commit, CodeQL
and Scorecard); the testsuite guards promotion instead.
