kind: script
description: |
  Boot assets: OGC kernel, initramfs, systemd-boot and a Unified Kernel Image
  stored under /boot/EFI/Linux so bootc's composefs backend picks it up.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/systemd.bst
- filename: base/kernel-ogc.bst
  config:
    location: /kernel

config:
  commands:
  - |
    set -eu
    release=$(basename /kernel%{prefix}/lib/modules/*)
    kver=${release}

    install -d %{install-root}/boot/EFI/Linux
    install -d %{install-root}/usr/lib/kernel
    install -d %{install-root}/usr/lib/systemd/boot/efi
    install -d %{install-root}/usr/share/muramasa

    cp /kernel%{prefix}/lib/modules/${kver}/vmlinuz \
       %{install-root}/usr/lib/kernel/vmlinuz
    cp /kernel%{prefix}/lib/modules/${kver}/config \
       %{install-root}/usr/share/muramasa/kernel.config

    dracut --force --kver "${kver}" --no-hostonly \
      --add "systemd systemd-networkd" /tmp/muramasa.initramfs

    printf '%s\n' \
      'rd.systemd.show_status=auto' \
      'systemd.show_status=auto' \
      'quiet' \
      'splash' \
      'selinux=0' \
      > /tmp/muramasa.cmdline

    # The kernel command line is embedded in the UKI. bootc install will
    # place the resulting .efi on the EFI System Partition.
    ukify build \
      --linux %{install-root}/usr/lib/kernel/vmlinuz \
      --initrd /tmp/muramasa.initramfs \
      --cmdline @/tmp/muramasa.cmdline \
      --output %{install-root}/boot/EFI/Linux/muramasa.efi

    printf '%s\n' "${kver}" > %{install-root}/usr/share/muramasa/kernel-version
