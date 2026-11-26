kind: manual
description: Static runtime configuration and ujust command definitions.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/runtime

config:
  install-commands:
  - |
    install -d %{install-root}%{sysconfdir}
    cp -a etc/. "%{install-root}%{sysconfdir}/"
    install -d %{install-root}%{datadir}/muramasa
    cp -a share/. "%{install-root}%{datadir}/muramasa/"
    install -Dm644 usr/lib/systemd/user/xdg-user-dirs.service \
      "%{install-root}%{prefix}/lib/systemd/user/xdg-user-dirs.service"
    install -Dm644 usr/lib/systemd/user-preset/10-xdg-user-dirs.preset \
      "%{install-root}%{prefix}/lib/systemd/user-preset/10-xdg-user-dirs.preset"
