kind: cmake
description: libcjson, required by Mango. Not present in FSDK 26.08.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/cmake.bst

sources:
- kind: git_repo
  url: github:DaveGamble/cJSON.git
  track: master
  ref: '%{cjson-ref}'
