kind: manual
description: |
  Docker Engine through Homebrew, the way Dakota consumes brew extras. The
  Brewfile is installed system-wide; `ujust install-docker` performs the
  one-time brew install and enables the daemon. A native podman installation
  remains available for daemonless workflows.

build-depends:
- core/sandbox-tools.bst
- tooling/brew.bst

runtime-depends:
- tooling/brew-tarball.bst

sources:
- kind: local
  path: files/docker

config:
  install-commands:
  - |
    set -eu
    install -Dm644 Brewfile "%{install-root}%{sysconfdir}/muramasa/brew/Brewfile"
    install -Dm644 docker-brew.service \
      "%{install-root}%{prefix}/lib/systemd/system/docker-brew.service"
    install -d "%{install-root}%{datadir}/muramasa/docker"
