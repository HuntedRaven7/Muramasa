kind: meson
description: |
  scenefx 0.5, required by Mango's screencopy/layer-shell effects. FSDK 26.08
  has no scenefx element, so it is built from a pinned upstream tag.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/pixman.bst
- compositor/wlroots.bst

sources:
- kind: git_repo
  url: github:wlrfx/scenefx.git
  track: '0.5'
  ref: '%{scenefx-ref}'
