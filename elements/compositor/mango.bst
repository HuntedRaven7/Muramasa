kind: meson
description: |
  Mango Wayland compositor (mangowm/mango). Pinned to a reviewed commit.
  No compositor configuration is shipped by this element; the image-level
  defaults live in files/session and can be overridden by the user.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/pango.bst
- freedesktop-sdk.bst:components/pixman.bst
- freedesktop-sdk.bst:components/xwayland.bst
- compositor/wlroots.bst
- compositor/scenefx.bst
- compositor/cjson.bst

sources:
- kind: git_repo
  url: github:mangowm/mango.git
  track: main
  ref: '%{mango-ref}'
