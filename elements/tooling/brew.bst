kind: manual
description: Homebrew framework files, adapted from Dakota.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: git_repo
  url: github:ublue-os/brew.git
  track: main
  ref: '%{brew-ref}'
- kind: local
  path: files/brew

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ""

config:
  install-commands:
  - cp -r system_files/usr/ "%{install-root}%{prefix}/"
  - cp -r system_files/etc/ "%{install-root}%{sysconfdir}/"
  - "%{install-extra}"
  - |
    set -eu
    # Content-addressed preinstall of the image-managed Brewfile set.
    install -Dm755 brew-preinstall "%{install-root}%{prefix}/libexec/brew-preinstall"
    install -Dm755 brew-preinstall-wrapper "%{install-root}%{prefix}/bin/brew-preinstall"
    install -Dm644 preinstall.d/cli.Brewfile \
      "%{install-root}%{datadir}/muramasa/brew/preinstall.d/cli.Brewfile"
    install -Dm644 systemd/user/brew-preinstall.service \
      "%{install-root}%{prefix}/lib/systemd/user/brew-preinstall.service"
    install -Dm644 systemd/user-preset/01-brew-preinstall.preset \
      "%{install-root}%{prefix}/lib/systemd/user-preset/01-brew-preinstall.preset"
