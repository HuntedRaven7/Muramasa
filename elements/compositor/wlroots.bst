kind: meson
description: |
  wlroots 0.20, required by Mango. FSDK 26.08 does not carry wlroots, so it is
  built from the upstream pinned tag.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/libdrm.bst
- freedesktop-sdk.bst:components/libinput.bst
- freedesktop-sdk.bst:components/libxkbcommon.bst
- freedesktop-sdk.bst:components/pixman.bst

sources:
- kind: git_repo
  url: freedesktop:wlroots/wlroots.git
  track: '0.20.*'
  ref: '%{wlroots-ref}'
