kind: cmake
description: |
  Quickshell v0.3.2, built from the upstream source at the signed v0.3.2 tag.
  Upstream git: https://git.outfoxxed.me/quickshell/quickshell
  GitHub mirror: https://github.com/quickshell-mirror/quickshell

  IMPORTANT: this element installs the Quickshell binary and its QML module
  paths only. It deliberately does NOT ship any Quickshell configuration,
  shell QML files, or autostart unit. The image owner supplies those later.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/pipewire.bst
- compositor/qt6-base.bst
- compositor/qt6-declarative.bst
- compositor/qt6-svg.bst

sources:
- kind: git_repo
  url: github:quickshell-mirror/quickshell.git
  track: 'v0.3.*'
  ref: '%{quickshell-ref}'
