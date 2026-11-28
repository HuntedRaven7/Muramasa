kind: manual
description: |
  Hardware enablement udev rules and modprobe quirks from
  projectbluefin/common. The NVIDIA-specific quirk ships in files/nvidia.bst.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/hardware

config:
  install-commands:
  - |
    set -eu
    install -d "%{install-root}%{prefix}/lib/udev/rules.d"
    cp -a udev/. "%{install-root}%{prefix}/lib/udev/rules.d/"
    install -Dm644 modprobe.d/amd-legacy.conf \
      "%{install-root}%{prefix}/lib/modprobe.d/amd-legacy.conf"
