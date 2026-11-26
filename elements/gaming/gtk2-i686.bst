# Minimal 32-bit GTK2 runtime libraries for Steam's ubuntu12_32 UI.
# FSDK no longer ships GTK2, so the two legacy libraries are imported from
# Debian's i386 package and their dependency closure comes from the i686
# components in steam-libs-i686-compose.bst.
kind: manual

sources:
- kind: remote
  url: debian:pool/main/g/gtk+2.0/libgtk2.0-0_2.24.33-2+deb12u1_i386.deb
  ref: '%{gtk2-i386-deb-sha256}'
  filename: libgtk2.0-0_2.24.33-2+deb12u1_i386.deb

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/binutils.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:bootstrap/xz.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    set -eu
    mkdir -p deb data "%{install-root}/usr/lib/i386-linux-gnu"
    cd deb
    ar x ../libgtk2.0-0_*_i386.deb
    cd ..
    tar -xf deb/data.tar.xz -C data
    cp -a data/usr/lib/i386-linux-gnu/libgtk-x11-2.0.so* \
      "%{install-root}/usr/lib/i386-linux-gnu/"
    cp -a data/usr/lib/i386-linux-gnu/libgdk-x11-2.0.so* \
      "%{install-root}/usr/lib/i386-linux-gnu/"

public:
  bst:
    split-rules:
      runtime:
        (>):
        - /usr/lib/i386-linux-gnu/libgtk-x11-2.0.so*
        - /usr/lib/i386-linux-gnu/libgdk-x11-2.0.so*
