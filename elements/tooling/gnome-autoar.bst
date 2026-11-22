kind: meson
description: Pinned source build of gnome-autoar, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst

sources:
- kind: git_repo
  url: github:GNOME/gnome-autoar.git
  track: main
  ref: '%{gnome-autoar-ref}'
