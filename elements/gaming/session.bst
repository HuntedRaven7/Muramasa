kind: stack
description: |
  Gaming userspace. The OGC kernel is already supplied by base/boot.bst;
  this layer adds gamescope and the Steam launcher.

depends:
- gaming/gamescope.bst
- gaming/steam.bst
