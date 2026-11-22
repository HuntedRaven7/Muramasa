# Small compatibility symlinks for Debian/Ubuntu-style SONAMEs expected by
# Valve's 32-bit Steam client packages. Ported from Dakota.
kind: manual

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    set -eu
    mkdir -p "%{install-root}/usr/lib/i386-linux-gnu"
    ln -sfn libbz2.so.1 "%{install-root}/usr/lib/i386-linux-gnu/libbz2.so.1.0"

    # The i686 Vulkan loader searches GL/vulkan/icd.d via EXTRASYSCONFDIR.
    mkdir -p "%{install-root}/usr/lib/i386-linux-gnu/GL"
    ln -sfn default/vulkan "%{install-root}/usr/lib/i386-linux-gnu/GL/vulkan"

    # pressure-vessel discovers ICDs on standard Khronos XDG paths.
    mkdir -p "%{install-root}/etc/vulkan/icd.d"
    for icd in intel_hasvk_icd.i686.json intel_icd.i686.json \
               lvp_icd.i686.json nouveau_icd.i686.json \
               radeon_icd.i686.json virtio_icd.i686.json; do
      ln -sfn "/usr/lib/i386-linux-gnu/GL/default/lib/vulkan/icd.d/${icd}" \
        "%{install-root}/etc/vulkan/icd.d/${icd}"
    done

public:
  bst:
    split-rules:
      runtime:
        (>):
        - /usr/lib/i386-linux-gnu/libbz2.so.1.0
        - /usr/lib/i386-linux-gnu/GL/vulkan
        - /etc/vulkan/icd.d/**
