kind: meson
description: Pinned source build of tinysparql, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/icu.bst
- freedesktop-sdk.bst:components/libxml2.bst
- freedesktop-sdk.bst:components/sqlite.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst

sources:
- kind: git_repo
  url: github:GNOME/tinysparql.git
  track: main
  ref: '%{tinysparql-ref}'
