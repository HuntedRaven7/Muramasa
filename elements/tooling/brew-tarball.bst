kind: manual
description: Prebuilt Homebrew tarball for both architectures (Dakota pattern).

sources:
# The docker source pins the per-architecture manifest digest, not the
# multi-arch index digest; track with
# `just bst -o arch <arch> source track tooling/brew-tarball.bst`.
- kind: docker
  url: ghcr:ublue-os/brew
  track: latest
  (?):
  - arch == "x86_64":
      ref: '%{brew-tarball-amd64-sha256}'
  - arch == "aarch64":
      ref: '%{brew-tarball-arm64-sha256}'

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

runtime-depends:
- tooling/brew.bst

variables:
  strip-binaries: ""

config:
  install-commands:
  - install -Dm644 system_files/usr/share/homebrew.tar.zst \
      "%{install-root}%{datadir}/homebrew.tar.zst"
  - "%{install-extra}"
