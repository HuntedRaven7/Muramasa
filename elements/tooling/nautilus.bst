kind: meson
description: Nautilus file manager. Built from source; no GNOME Session is installed.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/gtk3.bst
- freedesktop-sdk.bst:components/pango.bst
- freedesktop-sdk.bst:components/cairo.bst
- freedesktop-sdk.bst:components/wayland.bst
- tooling/gtk4.bst
- tooling/libadwaita.bst

sources:
- kind: git_repo
  url: github:GNOME/nautilus.git
  track: main
  ref: '%{nautilus-ref}'
