kind: meson
description: libadwaita, required by modern Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/gtk3.bst
- tooling/gtk4.bst

sources:
- kind: git_repo
  url: github:GNOME/libadwaita.git
  track: main
  ref: '%{libadwaita-ref}'
