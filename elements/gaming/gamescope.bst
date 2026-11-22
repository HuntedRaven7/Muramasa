kind: cmake
description: |
  gamescope, the Valve games compositor. Kept alongside Mango rather than
  replacing it: the gaming session is launched explicitly via the desktop
  entry installed by gaming/session.bst.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/xwayland.bst
- freedesktop-sdk.bst:components/libdrm.bst
- freedesktop-sdk.bst:components/vulkan-icd-loader.bst
- freedesktop-sdk.bst:extensions/mesa/mesa.bst
- freedesktop-sdk.bst:components/pixman.bst
- compositor/wlroots.bst

sources:
- kind: git_repo
  url: github:ValveSoftware/gamescope.git
  track: master
  ref: '%{gamescope-ref}'
