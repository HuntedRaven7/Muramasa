kind: make
description: |
  checkpolicy from the upstream SELinux tools. Needed to compile the monolithic
  refpolicy policy; FSDK 26.08 ships libsepol but not checkpolicy.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:bootstrap/libsepol.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/make.bst

sources:
- kind: git_repo
  url: github:SELinuxProject/selinux.git
  track: main
  ref: '%{selinux-tools-ref}'

config:
  build-commands:
  - |
    set -eu
    ${MAKE:-make} -C checkpolicy
  install-commands:
  - |
    set -eu
    install -Dm755 checkpolicy/checkpolicy \
      "%{install-root}%{prefix}/bin/checkpolicy"
