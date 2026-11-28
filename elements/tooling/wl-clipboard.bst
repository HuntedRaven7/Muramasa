kind: meson
description: wl-clipboard, built from source because FSDK 26.08 does not ship it.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/cairo.bst
- freedesktop-sdk.bst:components/pango.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gtk3.bst

sources:
- kind: git_repo
  url: github:bugaevc/wl-clipboard.git
  track: master
  ref: '%{wl-clipboard-ref}'
