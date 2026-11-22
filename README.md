# Muramasa

A Bootc Image Of Myth — an FSDK-based, Wayland-compositor desktop built around
[Mango](https://github.com/mangowm/mango).

Muramasa takes the BuildStream approach of Bluefin Dakota and replaces the GNOME
desktop with a compositor-first stack. It is assembled entirely from source with
[freedesktop-sdk](https://freedesktop-sdk.freedesktop.org/), and reuses the GNOME
and Bluefin artifact caches because they are FSDK-based too.

> The shell layer is intentionally not configured in this repository.
> Quickshell v0.3.2 is installed as a binary; its configuration is supplied by
> the image owner after installation. There is deliberately no wallpaper manager
> in the base image.

## What ships

- **Compositor:** Mango, pinned to a reviewed upstream commit
- **Shell runtime:** Quickshell v0.3.2, built from the signed upstream tag
- **WC tooling:** rofi, wl-clipboard, wtype, mako, swayosd, playerctl, grim +
  slurp, PipeWire/WirePlumber, portals, polkit, GNOME Keyring
- **Applications:** kitty, Nautilus, Voxtype (signed prebuilt AVX2/CPU binary)
- **System:** OGC kernel, systemd-boot + signed-ready UKI, firewalld,
  x86-64-v3 builds on x86_64
- **Container tooling:** Homebrew (Dakota-style) with Docker available through
  `ujust install-docker`; podman remains available for daemonless workflows
- **Gaming:** gamescope and native Steam from Valve's pinned launcher `.deb`
  (with Dakota's full 32-bit compatibility stack), plus NVIDIA and non-NVIDIA
  image flavors from a single source tree
- **Agent-focused defaults:** `AGENTS.md`, task skills and `ujust` automation
- **PR-only workflow:** protected `testing` (primary) and `stable` (promotion)
  branches, required CI checks, squash merges and linear history

## Image streams

| Tag | Stream | What it is |
| --- | --- | --- |
| `:testing` | Dev | Daily builds from the `testing` branch |
| `:testing-nvidia` | Dev | Same stream with the NVIDIA flavor |
| `:stable` | Stable | Promoted from a tested `:testing` digest |
| `:stable-nvidia` | Stable | NVIDIA flavor of the stable stream |

Images are published to `ghcr.io/huntedraven7/muramasa`. The BuildStream cache
lives at `ghcr.io/huntedraven7/muramasa-cache`.

## Build locally

BuildStream runs inside a pinned FSDK `bst2` container through `just`; it is not
installed on the host.

```sh
just validate                 # pins + element graph
just build                    # default flavor
just flavor-build nvidia      # NVIDIA flavor
just lint                     # bootc container lint
just test                     # host-side checks
just test-image               # image content assertions
```

See [docs/BUILD.md](docs/BUILD.md) for prerequisites and the full pipeline.

## Repository layout

```
elements/     BuildStream elements
files/        Static configuration installed by file elements
include/      Source aliases, pins, flavor variables
scripts/      Cache transport and helper scripts
tests/        Image content assertions
.github/      CI workflows
docs/         Architecture, build, cache and release guides
```

## License

Apache-2.0. See [LICENSE](LICENSE).
