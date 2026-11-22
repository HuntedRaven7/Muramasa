kind: stack
description: |
  Baseline Wayland-compositor tooling. No wallpaper manager is included:
  that responsibility belongs to the shell layer added by the image owner.
  FSDK 26.08 does not carry these desktop tools, so they are built from
  pinned sources in this project.

depends:
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/pipewire.bst
- freedesktop-sdk.bst:components/wireplumber.bst
- freedesktop-sdk.bst:components/xdg-desktop-portal.bst
- tooling/xdg-desktop-portal-wlr.bst
- freedesktop-sdk.bst:components/gsettings-desktop-schemas.bst
- freedesktop-sdk.bst:components/desktop-file-utils.bst
- freedesktop-sdk.bst:components/shared-mime-info.bst
- tooling/rofi.bst
- tooling/wl-clipboard.bst
- tooling/wtype.bst
- tooling/mako.bst
- tooling/swayosd.bst
- tooling/playerctl.bst
- tooling/grim.bst
- tooling/slurp.bst
- tooling/kitty.bst
- tooling/nautilus.bst
- tooling/voxtype.bst
- files/wc-tools.bst
