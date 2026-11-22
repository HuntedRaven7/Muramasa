kind: meson
description: |
  xdg-desktop-portal-wlr provides screenshot, screen-share and remote-desktop
  portals for wlroots compositors such as Mango. FSDK 26.08 does not ship it,
  so it is built from a pinned source.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/pipewire.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/inih.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/systemd.bst

sources:
- kind: git_repo
  url: github:emersion/xdg-desktop-portal-wlr.git
  track: master
  ref: '%{xdg-desktop-portal-wlr-ref}'
