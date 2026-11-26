kind: manual
description: NVIDIA flavor configuration (kernel module load + udev rules).

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/nvidia

config:
  install-commands:
  - |
    install -Dm644 modules-load.conf \
      "%{install-root}%{sysconfdir}/modules-load.d/nvidia.conf"
    install -Dm644 udev.rules \
      "%{install-root}%{sysconfdir}/udev/rules.d/99-nvidia.rules"
    install -Dm644 environment.conf \
      "%{install-root}%{sysconfdir}/environment.d/01-nvidia.conf"
    install -Dm644 modprobe.d/zz-nvidia-suspend.conf \
      "%{install-root}%{prefix}/lib/modprobe.d/zz-nvidia-suspend.conf"
    install -Dm644 tmpfiles.d/nvidia-suspend.conf \
      "%{install-root}%{prefix}/lib/tmpfiles.d/nvidia-suspend.conf"
