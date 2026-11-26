kind: autotools
description: intltool, needed by firewalld's autotools build.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/gettext.bst
- freedesktop-sdk.bst:components/perl.bst

sources:
- kind: tar
  url: gnome_downloads:intltool/0.40/intltool-0.40.6.tar.gz
  ref: '%{intltool-sha256}'
