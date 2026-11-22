kind: manual
description: Desktop defaults (mime handlings, portal config, env).

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/wc-tools

config:
  install-commands:
  - |
    set -eu
    cp -a etc/. "%{install-root}%{sysconfdir}/"
    cp -a usr/. "%{install-root}%{prefix}/"
