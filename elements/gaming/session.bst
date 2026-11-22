kind: stack
description: |
  Gaming userspace. The OGC kernel is already supplied by base/boot.bst;
  this layer adds gamescope and, on x86_64, native Steam.

depends:
- gaming/gamescope.bst

# Valve publishes no native launcher for aarch64.
(?):
- arch == "x86_64":
    depends:
      (>):
      - gaming/steam.bst
