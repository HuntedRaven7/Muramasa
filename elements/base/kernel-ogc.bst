# Open Gaming Collective kernel. Shared by both image flavors: the NVIDIA
# modules in base/nvidia.bst are compiled against this tree's `build` symlink.
# Recipe adapted from Dakota's core/linux-ogc.bst; config fragments are
# vendored locally so bumps are explicit and reviewable.
kind: make
description: Open Gaming Collective (OGC) Linux kernel

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/cpio.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/bc.bst
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/pahole.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/rsync.bst
- freedesktop-sdk.bst:components/zstd.bst

variables:
  strip-binaries: ''
  kernel-arch: '%{arch}'
  (?):
  - arch == "aarch64":
      kernel-arch: arm64

environment:
  ARCH: '%{kernel-arch}'
  KBUILD_BUILD_TIMESTAMP: 'Thu Nov 10 15:00:00 UTC 2011'
  KBUILD_BUILD_USER: 'muramasa'
  MAXJOBS: '%{max-jobs}'
  (?):
  - arch == "x86_64" and x86_64_v3:
      KCFLAGS: "-march=x86-64-v3 -mtune=skylake"

environment-nocache:
- MAXJOBS

config:
  configure-commands:
  - |
    set -eu
    make defconfig
    # Gaming-critical options are required; the build fails if olddefconfig
    # drops any of them.
    . ./config-utils.sh
    while IFS= read -r line; do
      case "$line" in ''|'#'*) continue ;; esac
      name=${line%%=*}
      val=${line#*=}
      case "$val" in
        y) scripts/config --keep-case -e "$name" ;;
        m) scripts/config --keep-case -m "$name" ;;
        *) scripts/config --keep-case --set-str "$name" "$val" ;;
      esac
    done < ogc.config.set
    while IFS= read -r name; do
      case "$name" in ''|'#'*) continue ;; esac
      scripts/config --keep-case -d "$name"
    done < ogc.config.unset
    scripts/config --keep-case --set-str LOCALVERSION "%{ogc-localversion}"
    scripts/config --keep-case -d LOCALVERSION_AUTO
    make -j1 olddefconfig
    require_config CONFIG_SCHED_CLASS_EXT
    require_config CONFIG_NTSYNC
    require_config CONFIG_CRYPTO_ZSTD

  install-commands:
  - |
    set -eu
    release=$(make -s kernelrelease)
    libdir="%{prefix}/lib"
    install -Dm644 "$(make -s image_name)" \
      "%{install-root}${libdir}/modules/${release}/vmlinuz"
    install -Dm644 System.map \
      "%{install-root}${libdir}/modules/${release}/System.map"
    install -Dm644 .config \
      "%{install-root}${libdir}/modules/${release}/config"
    ZSTD_CLEVEL=19 make -j1 INSTALL_MOD_PATH='%{install-root}%{prefix}' \
      INSTALL_MOD_STRIP=1 modules_install
    # Build tree for out-of-tree modules (NVIDIA).
    install -d "%{install-root}%{prefix}/src/linux-${release}"
    cp -a Makefile Module.symvers .config scripts include \
      "%{install-root}%{prefix}/src/linux-${release}/"
    ln -sr "%{install-root}%{prefix}/src/linux-${release}" \
      "%{install-root}${libdir}/modules/${release}/build"

sources:
- kind: git_repo
  url: github:OpenGamingCollective/linux.git
  track: 'v7.3.*-ogc*'
  ref: '%{ogc-kernel-ref}'
- kind: local
  path: files/kernel/ogc.config.set
- kind: local
  path: files/kernel/ogc.config.unset
- kind: local
  path: files/kernel/config-utils.sh
