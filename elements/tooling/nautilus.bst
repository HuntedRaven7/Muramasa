kind: meson
description: Nautilus file manager. Built from source; no GNOME Session is installed.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/gtk4.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/libadwaita.bst
- freedesktop-sdk.bst:components/gio.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst

sources:
- kind: git_repo
  url: github:GNOME/nautilus.git
  track: main
  ref: '%{nautilus-ref}'
