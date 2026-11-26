kind: meson
description: Pinned source build of blueprint-compiler, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/ninja.bst
- freedesktop-sdk.bst:components/glib.bst

sources:
- kind: git_repo
  url: github:GNOME/blueprint-compiler.git
  track: main
  ref: '%{blueprint-compiler-ref}'
