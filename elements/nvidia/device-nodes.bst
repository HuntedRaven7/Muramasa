kind: manual
description: Create /dev/nvidia* nodes before the display manager starts.

build-depends:
- core/sandbox-tools.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- nvidia/nvidia-drivers.bst

sources:
- kind: local
  path: files/nvidia-device-nodes

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    install -Dm644 nvidia-device-nodes.service \
      "%{install-root}%{libdir}/systemd/system/nvidia-device-nodes.service"
    install -d "%{install-root}%{libdir}/systemd/system-preset"
    printf 'enable nvidia-device-nodes.service\n' > \
      "%{install-root}%{libdir}/systemd/system-preset/80-nvidia-device-nodes.preset"
