kind: make
description: |
  Monolithic targeted SELinux policy built from pinned refpolicy. A small
  Muramasa module allows Ly's system-service → user-session transition.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/make.bst
- freedesktop-sdk.bst:components/grep.bst
- freedesktop-sdk.bst:components/sed.bst
- security/checkpolicy.bst

sources:
- kind: git_repo
  url: github:SELinuxProject/refpolicy.git
  track: main
  ref: '%{refpolicy-ref}'
- kind: local
  path: files/selinux

variables:
  strip-binaries: ''

config:
  configure-commands:
  - |
    set -eu
    # Our local module participates in the monolithic policy.
    cp muramasa.te policy/modules/contrib/muramasa.te

  build-commands:
  - |
    set -eu
    make TYPE=targeted MONOLITHIC=y OUTPUT_POLICY=33 \
      CHECKPOLICY=checkpolicy UNK_PERMS=deny policy

  install-commands:
  - |
    set -eu
    make TYPE=targeted MONOLITHIC=y OUTPUT_POLICY=33 \
      CHECKPOLICY=checkpolicy UNK_PERMS=deny \
      DESTDIR="%{install-root}" install
    install -Dm644 selinux-config \
      "%{install-root}%{sysconfdir}/selinux/config"
