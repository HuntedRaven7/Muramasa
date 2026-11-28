kind: autotools
description: |
  firewalld, built from the pinned upstream release. Uses nftables as its
  backend and ships the systemd service with a system preset.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:components/autoconf.bst
- freedesktop-sdk.bst:components/automake.bst
- freedesktop-sdk.bst:components/libtool.bst
- freedesktop-sdk.bst:components/gettext.bst
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/nftables.bst
- freedesktop-sdk.bst:components/iptables.bst
- freedesktop-sdk.bst:components/dbus.bst
- tooling/intltool.bst

sources:
- kind: git_repo
  url: github:firewalld/firewalld.git
  track: 'v2.5.*'
  ref: '%{firewalld-ref}'

config:
  configure-commands:
  - ./autogen.sh
  - |
    ./configure --prefix="%{prefix}" \
      --sysconfdir="%{sysconfdir}" \
      --libdir="%{libdir}" \
      --enable-nftables \
      --without-dbus-python
  install-commands:
  - |
    set -eu
    make install DESTDIR="%{install-root}"
    install -d "%{install-root}%{libdir}/systemd/system-preset"
    printf 'enable firewalld.service\n' > \
      "%{install-root}%{libdir}/systemd/system-preset/80-firewalld.preset"
