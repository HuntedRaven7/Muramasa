kind: meson
description: GTK4, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/pango.bst
- freedesktop-sdk.bst:components/cairo.bst
- freedesktop-sdk.bst:components/freetype.bst
- freedesktop-sdk.bst:components/libpng.bst
- freedesktop-sdk.bst:components/wayland.bst

sources:
- kind: git_repo
  url: github:GNOME/gtk.git
  track: main
  ref: '%{gtk4-ref}'
