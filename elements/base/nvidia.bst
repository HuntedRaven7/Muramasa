kind: stack
description: |
  NVIDIA flavor only. The driver stack is not available as an FSDK element in
  26.08; when that junction is added, its elements belong here. For now the
  flavor contributes only its runtime configuration.

(?):
- nvidia == true:
    depends:
    - files/nvidia.bst
