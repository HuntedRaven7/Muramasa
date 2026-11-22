kind: stack
description: |
  Gaming userspace. The OGC kernel is already supplied by base/boot.bst;
  this layer adds gamescope and native Steam (x86_64 only).
  aarch64 builds omit Steam because Valve does not publish a native launcher.

depends:
- gaming/gamescope.bst
- (?):
  - arch == "x86_64":
    - gaming/steam.bst
