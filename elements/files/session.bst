kind: manual
description: |
  Image-level session defaults: Mango config and Wayland session entry.
  Login is handled by Ly (elements/session/ly.bst). No shell configuration is
  installed here; no Quickshell config of any kind is shipped.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/session

config:
  install-commands:
  - |
    set -eu
    install -Dm644 etc/mango/mango.conf \
      "%{install-root}%{sysconfdir}/mango/mango.conf"
    install -Dm644 usr/share/wayland-sessions/mango.desktop \
      "%{install-root}%{datadir}/wayland-sessions/mango.desktop"
    install -Dm644 usr/share/muramasa/session.env \
      "%{install-root}%{datadir}/muramasa/session.env"
