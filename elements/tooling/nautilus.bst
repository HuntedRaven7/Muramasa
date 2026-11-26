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
- freedesktop-sdk.bst:components/gdk-pixbuf.bst
- freedesktop-sdk.bst:components/libxml2.bst
- freedesktop-sdk.bst:components/icu.bst
- tooling/glycin.bst
- tooling/gnome-autoar.bst
- tooling/gnome-desktop.bst
- tooling/libgxdp.bst
- tooling/libportal.bst
- tooling/tinysparql.bst
- tooling/blueprint-compiler.bst

sources:
- kind: git_repo
  url: github:GNOME/nautilus.git
  track: main
  ref: '%{nautilus-ref}'
