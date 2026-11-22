kind: stack
description: |
  Baseline Wayland-compositor tooling. No wallpaper manager is included:
  that responsibility belongs to the shell layer added by the image owner.

depends:
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/rofi.bst
- freedesktop-sdk.bst:components/wl-clipboard.bst
- freedesktop-sdk.bst:components/wtype.bst
- freedesktop-sdk.bst:components/mako.bst
- freedesktop-sdk.bst:components/swayosd.bst
- freedesktop-sdk.bst:components/playerctl.bst
- freedesktop-sdk.bst:components/grim.bst
- freedesktop-sdk.bst:components/slurp.bst
- freedesktop-sdk.bst:components/pipewire.bst
- freedesktop-sdk.bst:components/wireplumber.bst
- freedesktop-sdk.bst:components/alsa-utils.bst
- freedesktop-sdk.bst:components/xdg-desktop-portal.bst
- freedesktop-sdk.bst:components/xdg-desktop-portal-wlr.bst
- freedesktop-sdk.bst:components/gnome-keyring.bst
- freedesktop-sdk.bst:components/gsettings-desktop-schemas.bst
- freedesktop-sdk.bst:components/desktop-file-utils.bst
- freedesktop-sdk.bst:components/shared-mime-info.bst
- tooling/kitty.bst
- tooling/nautilus.bst
- tooling/voxtype.bst
- files/wc-tools.bst
