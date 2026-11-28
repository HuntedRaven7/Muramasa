kind: manual
description: Qt 6 SVG module, required by Quickshell.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/ninja.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/cmake.bst
- freedesktop-sdk.bst:components/gcc.bst
- compositor/qt6-base.bst

sources:
- kind: git_repo
  url: github:qt/qtsvg.git
  track: 'v%{qt6-version}'
  ref: '%{qt6-svg-ref}'

config:
  configure-commands:
  - |
    set -eu
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="%{prefix}" \
      -DCMAKE_PREFIX_PATH="%{prefix}"
  build-commands:
  - cmake --build build --parallel "%{max-jobs}"
  install-commands:
  - cmake --install build --prefix "%{install-root}%{prefix}"
