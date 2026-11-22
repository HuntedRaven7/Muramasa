kind: manual
description: |
  Qt 6 base, required by Quickshell. FSDK 26.08 has no Qt6, so it is built from
  a pinned upstream source. Wayland is enabled; X11/printing are disabled to
  keep the build small for a compositor-only desktop.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/cmake.bst
- freedesktop-sdk.bst:components/gcc.bst
- freedesktop-sdk.bst:components/openssl.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/libxkbcommon.bst
- freedesktop-sdk.bst:components/fontconfig.bst
- freedesktop-sdk.bst:components/freetype.bst
- freedesktop-sdk.bst:components/libpng.bst
- freedesktop-sdk.bst:components/zlib.bst
- freedesktop-sdk.bst:bootstrap/pcre2.bst
- freedesktop-sdk.bst:components/dbus.bst

sources:
- kind: git_repo
  url: github:qt/qtbase.git
  track: 'v%{qt6-version}'
  ref: '%{qt6-base-ref}'

config:
  configure-commands:
  - |
    set -eu
    cmake -S . -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="%{prefix}" \
      -DFEATURE_wayland=ON \
      -DFEATURE_xcb=OFF \
      -DFEATURE_xlib=OFF \
      -DFEATURE_cups=OFF \
      -DFEATURE_gif=OFF \
      -DFEATURE_jpeg=OFF \
      -DFEATURE_system_zlib=ON \
      -DFEATURE_openssl=ON \
      -DINPUT_gui=ON \
      -DINPUT_widgets=ON
  build-commands:
  - cmake --build build --parallel "%{max-jobs}"
  install-commands:
  - cmake --install build --prefix "%{install-root}%{prefix}"
