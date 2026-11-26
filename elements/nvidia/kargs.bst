kind: manual
description: Kernel arguments required for NVIDIA + Wayland on a bootc image.

build-depends:
- core/sandbox-tools.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    install -d "%{install-root}/usr/lib/bootc/kargs.d"
    cat > "%{install-root}/usr/lib/bootc/kargs.d/10-nvidia.toml" <<'EOF'
    kargs = [
        "rd.driver.blacklist=nouveau",
        "modprobe.blacklist=nouveau",
        "nvidia-drm.modeset=1",
        "nvidia-drm.fbdev=1",
        "plymouth.use-simpledrm=1",
    ]
    EOF
