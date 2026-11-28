# Muramasa testsuite

Two layers of testing cover the image:

1. **Shared E2E suite** — `.github/workflows/testsuite.yml` calls
   [`projectbluefin/testsuite`](https://github.com/projectbluefin/testsuite)
   `e2e.yml@v1` with the portable `common` suite (SSH health, portals, polkit,
   immutability, Flatpak). The upstream GUI suites assume GNOME Shell and are
   deliberately not used: Muramasa's session is Mango.
2. **Mango smoke checks** — `smoke.sh` runs read-only assertions inside the
   exported image: compositor/session files, WC tooling, native Steam, the
   absence of wallpaper managers and shell config, boot assets and identity.
   `features/mango-smoke.feature` documents the intent in behave style.

Neither job is a required status check yet. Once both have a stable green
history, add `testsuite / Shared common suite` and
`testsuite / Mango desktop smoke` to `required_status_checks.contexts` in
`.github/branch-protection/testing.json` and re-run the protection workflow.

## Run locally

```sh
IMAGE=ghcr.io/huntedraven7/muramasa:testing ./testsuite/smoke.sh
```

Requires `podman` and a pulled image. `PODMAN=podman` overrides the default
`sudo podman`.

## CI flow

`testsuite.yml` triggers after a successful `build` workflow run on `testing`,
or via `workflow_dispatch`. It always pulls the published `:testing` image, so
it tests exactly the artifact an installer would fetch.
