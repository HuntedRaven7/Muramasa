kind: meson
description: Pinned source build of gnome-desktop, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gdk-pixbuf.bst
- freedesktop-sdk.bst:components/gtk3.bst
- freedesktop-sdk.bst:components/icu.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst

sources:
- kind: git_repo
  url: github:GNOME/gnome-desktop.git
  track: master
  ref: '%{gnome-desktop-ref}'
