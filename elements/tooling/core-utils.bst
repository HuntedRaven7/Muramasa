kind: stack
description: |
  Curated baseline utilities that a usable desktop needs but FSDK's
  runtime-minimal stack does not guarantee. All names are FSDK elements, so no
  source builds are added here.

depends:
# System and shell
- freedesktop-sdk.bst:components/procps.bst
- freedesktop-sdk.bst:components/iproute2.bst
- freedesktop-sdk.bst:components/iputils.bst
- freedesktop-sdk.bst:components/which.bst
- freedesktop-sdk.bst:components/nano.bst
- freedesktop-sdk.bst:components/vim.bst
- freedesktop-sdk.bst:components/strace.bst
- freedesktop-sdk.bst:components/pciutils.bst
- freedesktop-sdk.bst:components/usbutils.bst
- freedesktop-sdk.bst:components/rsync.bst
- freedesktop-sdk.bst:components/wget2.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/xz.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:components/findutils.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/gawk.bst
# Fonts, icons and small desktop helpers
- freedesktop-sdk.bst:components/fontconfig.bst
- freedesktop-sdk.bst:components/dejavu-fonts.bst
- freedesktop-sdk.bst:components/noto-fonts.bst
- freedesktop-sdk.bst:components/hicolor-icon-theme.bst
- freedesktop-sdk.bst:components/libnotify.bst
- freedesktop-sdk.bst:components/zenity.bst
- freedesktop-sdk.bst:components/flatpak-xdg-utils.bst
