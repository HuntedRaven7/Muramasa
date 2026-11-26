kind: manual
description: |
  Staging element for the Secure Boot keys. The private key is gitignored and
  supplied locally or by CI secrets; only the public certificate is committed.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/boot-keys

config:
  install-commands:
  - |
    set -eu
    mkdir -p "%{install-root}/private" "%{install-root}/public"
    if [ -d private ]; then cp -a private/. "%{install-root}/private/"; fi
    cp -a public/. "%{install-root}/public/"
