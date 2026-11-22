kind: meson
description: rofi, built from source because FSDK 26.08 does not ship it.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gtk3.bst

sources:
- kind: git_repo
  url: github:lbonn/rofi.git
  track: wayland
  ref: '%{rofi-ref}'
