kind: junction

description: |
  GNOME Build Meta junction, pinned to the same ref Dakota uses. Its cached
  SDK artifacts are reused through the GNOME artifact cache so the image does
  not rebuild GNOME-adjacent libraries from scratch.

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 'gnome-51'
  ref: '51.1-36-g8a89846df11e86cee57c728a86a247e61d604b84'
- kind: patch_queue
  path: patches/gnome-build-meta

config:
  options:
    arch: '%{arch}'
    x86_64_v3: false
    (?):
    - arch == "x86_64" and x86_64_v3:
        x86_64_v3: true

  overrides:
    # Use our own junctions, not copies from GNOME Build Meta.
    freedesktop-sdk.bst: freedesktop-sdk.bst
    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
