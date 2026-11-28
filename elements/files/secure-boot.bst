kind: manual
description: Public Secure Boot certificate for enrolling the dev key.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/boot-keys/public

config:
  install-commands:
  - |
    set -eu
    install -Dm644 secure-boot.crt \
      "%{install-root}%{datadir}/muramasa/secure-boot/secure-boot.crt"
