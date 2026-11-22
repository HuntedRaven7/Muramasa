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
- freedesktop-sdk.bst:components/xorg-lib-xcb.bst
- freedesktop-sdk.bst:components/xorg-lib-xrandr.bst
- freedesktop-sdk.bst:components/xcb-util-wm.bst
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/cairo.bst
- freedesktop-sdk.bst:bootstrap/pcre2.bst
- freedesktop-sdk.bst:components/libxkbcommon.bst
- freedesktop-sdk.bst:extensions/mesa/mesa.bst
- compositor/wlroots.bst
- compositor/scenefx.bst
- compositor/cjson.bst

sources:
- kind: git_repo
  url: github:mangowm/mango.git
  track: main
  ref: '%{mango-ref}'
