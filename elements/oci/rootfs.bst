kind: compose
description: |
  Sanitized root filesystem. All image layers converge here; the OCI element
  consumes this exact tree so chunka rechunking does not change content.

depends:
- compositor/session.bst
