kind: stack
description: |
  NVIDIA flavor only. The driver modules are built against the OGC kernel by
  the FSDK element; this layer adds the userspace libraries and the runtime
  tweaks needed by Mango and gamescope.

depends:
- freedesktop-sdk.bst:components/nvidia-drivers.bst
- freedesktop-sdk.bst:components/nvidia-utils.bst
- files/nvidia.bst
