# Muramasa Strategy

## Vision

<!-- vision: author-approved 2026-11-22 -->

`Muramasa` exists so that a Wayland desktop can be assembled from upstream sources and shipped as an immutable bootc image without inheriting a desktop environment it does not use.
It serves people who want a compositor-first desktop with agent-friendly tooling and a predictable supply chain.
It turns pinned FSDK elements and a small set of source-built components into two bootable image flavors.
It owns exactly one thing: the contract for what goes into the Muramasa bootc image and how that image is verified.

### Source-built, pinned, cache-aware

Every third-party artifact enters through `include/versions.yml` with a checked ref or digest.
Elements reference `%{variable}` pins and never carry mutable tags as refs.
A prebuilt binary is acceptable only when its own upstream project publishes it with a checksum.
Distro-packaged binaries are out of scope.
Every pin change is reviewed by a human before merge, and auto-merge is not used.
The image is assembled from a pinned freedesktop-sdk junction with x86-64-v3 enabled on x86_64.
GNOME and Bluefin artifact caches are pull-only inputs because they are FSDK-based.
The project cache travels as an OCI artifact in GHCR and a failed build never publishes a partial key.
Components absent from FSDK are added as local source elements with their own pins rather than by widening the base to a full desktop.
A missing toolchain is fixed at the root, as with checkpolicy and refpolicy, rather than by disabling the control that needed it.

### Compositor owns the session

Mango is the compositor and the only session the image promises.
Selectable alternative compositors are out of scope.
GNOME Shell is not part of the image, is not reintroduced through a junction and is not added for test coverage.
No wallpaper manager ships in the base image.
Wallpaper is owned by the shell layer and will be implemented in Quickshell by the image owner.
Quickshell is installed as a pinned binary with its module paths, and no shell configuration is written by this repository today.
A shell configuration authored by the image owner may be added later through the same PR and review process.
Ly provides the login screen, and its Tokyo Night night palette is the only image-level theme decision.
Theming outside Ly remains with the user.

### One graph, two flavors

The NVIDIA and non-NVIDIA images are options on one BuildStream graph.
Both flavors share the OGC kernel and the same element definitions.
A flavor never gets its own fork of the tree.
Driver source divergence is handled inside the shared graph, not by duplicating the element tree.
Native Steam is x86_64 only, and aarch64 omits it rather than substituting a different launcher.

### Secure by construction

Changes land through pull requests, and direct pushes to testing and stable are blocked.
Required checks cover validation, both image flavors, pre-commit, CodeQL and Scorecard.
Stable is a promoted digest, never a rebuild.
A `:latest` alias is an anti-pattern here, and the only streams are testing and stable.
The UKI is signed when a key is available, and the public certificate ships for enrollment.
SELinux is not optional because current bootc versions require it.
SELinux boots enforcing with a compiled targeted policy.
Every image is scanned, signed keylessly and published with an SBOM and provenance.

### Tests are part of the contract

The shared projectbluefin testsuite supplies the portable common suite.
Mango-specific smoke checks live in this repository because the upstream GUI suites assume GNOME Shell.
Image content assertions refuse wallpaper managers and shell configuration as well as requiring compositor tooling.
A change that affects image, CI, tests or workflow updates the relevant docs in the same PR.

### Scope

Muramasa is not a GNOME image, not a general-purpose desktop and not a configuration framework.
It is not a CI system and not a theme repository.
It ships fast, and an lts stream or a slow update cadence is out of scope.
Personal shell configuration stays with the image owner until they choose to contribute it.
Other sections of STRATEGY.md belong to their own writers.

A change aligns when it preserves a pinned source graph, keeps Mango as the only session, leaves wallpaper and shell ownership with the owner, works through a reviewed PR with passing checks, boots with SELinux enforcing and is documented in the same change.
A change should be resisted when it adds a wallpaper manager, a GNOME desktop for any reason, shell configuration the owner did not author, a mutable source ref, a distro binary, a direct push to a protected branch, a second element graph for a GPU flavor, an lts stream, a `:latest` alias, or a security control that is disabled instead of fixed.
