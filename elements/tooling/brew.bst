kind: manual
description: Homebrew framework files, adapted from Dakota.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: git_repo
  url: github:ublue-os/brew.git
  track: main
  ref: '%{brew-ref}'

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ""

config:
  install-commands:
  - cp -r system_files/usr/ "%{install-root}%{prefix}/"
  - cp -r system_files/etc/ "%{install-root}%{sysconfdir}/"
  - "%{install-extra}"
