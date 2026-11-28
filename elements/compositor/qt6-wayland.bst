kind: manual
description: |
  Qt 6 Wayland client module. Quickshell enables WAYLAND by default and, on
  Qt 6.9+, requires the explicit QuickPrivate and WaylandClientPrivate CMake
  components. QuickPrivate comes from qtdeclarative; WaylandClientPrivate comes
  from this module. Built from the same release tag as the rest of Qt6.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/ninja.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/cmake.bst
- freedesktop-sdk.bst:components/gcc.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- compositor/qt6-base.bst

sources:
- kind: git_repo
  url: github:qt/qtwayland.git
  track: 'v%{qt6-version}'
  ref: '%{qt6-wayland-ref}'

config:
  configure-commands:
  - |
    set -eu
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="%{prefix}" \
      -DCMAKE_PREFIX_PATH="%{prefix}" \
      -DFEATURE_wayland_server=OFF \
      -DFEATURE_xcb=OFF
  build-commands:
  - cmake --build build --parallel "%{max-jobs}"
  install-commands:
  - cmake --install build --prefix "%{install-root}%{prefix}"
