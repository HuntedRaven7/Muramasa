kind: manual
description: Muramasa image identity.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/os-release

config:
  install-commands:
  - |
    install -Dm644 os-release "%{install-root}%{prefix}/lib/os-release"
