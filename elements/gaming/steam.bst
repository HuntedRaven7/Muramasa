kind: manual
description: |
  Steam launcher. The image ships a tiny launcher that runs the Flathub build
  installed by `ujust install-steam`. This keeps the base image free of Steam's
  fast-moving bootstrap tarball while still providing the game-mode workflow.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/gaming

config:
  install-commands:
  - |
    set -eu
    install -Dm755 steam "%{install-root}%{prefix}/bin/steam"
    install -Dm644 gamescope-steam.desktop \
      "%{install-root}%{datadir}/applications/gamescope-steam.desktop"
