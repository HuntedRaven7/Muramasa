# Architecture

Muramasa is a BuildStream 2 project that exports a bootc OCI image. It follows
the Mjolnir pattern: build everything from a pinned freedesktop-sdk junction,
then compose the final rootfs with `build-oci` and rechunk it in CI.

## Build graph

```
freedesktop-sdk.bst (junction, x86-64-v3)
├── base/runtime.bst        systemd, dbus, CLI tools, firewalld
├── base/kernel-ogc.bst     OGC kernel + local config fragments
├── base/boot.bst           initramfs + systemd-boot + UKI
├── nvidia/                 NVIDIA driver stack, kargs, modprobe and device nodes
├── compositor/mango.bst    Mango, pinned source build
├── compositor/quickshell.bst  Quickshell v0.3.2 source build (binary only)
├── tooling/                WC tooling, brew, Docker, Voxtype, agent defaults
├── gaming/                 gamescope + native Steam + i686 compat stack
└── oci/rootfs.bst -> oci/muramasa.bst (bootc OCI layout)
```

`compositor/session.bst` is the dependency closure; CI builds
`oci/muramasa.bst` directly and BuildStream pulls everything else.

## GPU flavors

Flavors are BuildStream options, not separate branches:

| Flavor | Option | Tags |
| --- | --- | --- |
| Default | `-o nvidia false` | `:testing`, `:stable` |
| NVIDIA | `-o nvidia true` | `:testing-nvidia`, `:stable-nvidia` |

Both share the OGC kernel. `base/nvidia.bst` enables `elements/nvidia/` when the
option is set: the driver userspace and open kernel modules are built from
NVIDIA's pinned `.run` payload against that tree, with kargs, modprobe glue and
device-node creation. `depmod` runs during OCI assembly. The CI build matrix
builds both flavors from the same commit.

## Boot model

- systemd-boot with a Unified Kernel Image at `/boot/EFI/Linux/muramasa.efi`
- The kernel command line is embedded in the UKI
- `containers.bootc=1` label on the OCI image
- `bootc container lint` gates every build

## GNOME Build Meta junction

The GNOME and Bluefin artifact caches are pull-only inputs in `project.conf`.
The FSDK junction mirrors Dakota's `x86_64_v3` boolean conditional and
component overrides, and a pinned `gnome-build-meta.bst` junction provides the
SDK elements those overrides reference. This makes artifact keys match the
published GNOME cache without installing GNOME Shell or GNOME OS in the image.
The junction carries only GNOME Build Meta's SDK elements, not a desktop
session.

## What is deliberately absent

- No Quickshell configuration, QML or autostart unit. Image owner supplies it.
- No wallpaper manager. The shell layer owns wallpapers.
- No preinstalled coding agent CLI. We ship guidance and automation only.
