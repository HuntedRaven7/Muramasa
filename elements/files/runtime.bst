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
