kind: manual
description: |
  Image-level session defaults: Mango config, Wayland session entry, and a
  TTY autologin that starts the compositor. No Quickshell files are installed
  here; that configuration is supplied by the image owner later.

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
    install -Dm644 etc/profile.d/00-mango.sh \
      "%{install-root}%{sysconfdir}/profile.d/00-mango.sh"
    install -Dm644 usr/share/wayland-sessions/mango.desktop \
      "%{install-root}%{datadir}/wayland-sessions/mango.desktop"
    install -Dm644 usr/lib/systemd/system/getty@tty1.service.d/override.conf \
      "%{install-root}%{prefix}/lib/systemd/system/getty@tty1.service.d/override.conf"
    install -Dm644 usr/share/muramasa/session.env \
      "%{install-root}%{datadir}/muramasa/session.env"
