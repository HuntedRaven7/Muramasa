kind: manual
description: kitty terminal (chosen over Ghostty for FSDK buildability).

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-python.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/freetype.bst
- freedesktop-sdk.bst:components/harfbuzz.bst
- freedesktop-sdk.bst:components/libpng.bst
- freedesktop-sdk.bst:components/libxkbcommon.bst
- freedesktop-sdk.bst:components/wayland.bst

sources:
- kind: git_repo
  url: github:kovidgoyal/kitty.git
  track: master
  ref: '%{kitty-ref}'

config:
  install-commands:
  - |
    set -eu
    python3 setup.py --verbose build
    python3 setup.py --verbose install --root="%{install-root}" --prefix="%{prefix}"
