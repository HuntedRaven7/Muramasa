kind: meson
description: Pinned source build of libportal, required by Nautilus. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/meson.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gtk3.bst
- tooling/gtk4.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst

sources:
- kind: git_repo
  url: github:flatpak/libportal.git
  track: main
  ref: '%{libportal-ref}'
