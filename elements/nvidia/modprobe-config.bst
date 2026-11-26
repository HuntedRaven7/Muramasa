kind: manual
description: |
  Modprobe glue for NVIDIA on Wayland. Enables KMS and fbdev and blacklists
  nouveau so the proprietary driver can claim the framebuffer.

build-depends:
- core/sandbox-tools.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    set -eu
    install -d "%{install-root}/etc/modprobe.d" "%{install-root}/etc/modules-load.d"
    cat > "%{install-root}/etc/modprobe.d/nvidia.conf" <<'EOF'
    options nvidia-drm modeset=1 fbdev=1
    options nvidia NVreg_OpenRmEnableUnsupportedGpus=0
    options nvidia NVreg_EnableGpuFirmware=1
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp
    EOF
    cat > "%{install-root}/etc/modules-load.d/nvidia.conf" <<'EOF'
    nvidia
    nvidia-modeset
    nvidia-drm
    nvidia-uvm
    EOF
    cat > "%{install-root}/etc/modprobe.d/blacklist-nouveau.conf" <<'EOF'
    blacklist nouveau
    options nouveau modeset=0
    EOF
