kind: stack
description: |
  Tools needed by `manual` elements' install commands. Kept as an explicit
  element so every static-file layer can depend on it.

depends:
- freedesktop-sdk.bst:components/coreutils.bst
- freedesktop-sdk.bst:components/findutils.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:components/gzip.bst
