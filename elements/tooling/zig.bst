kind: manual
description: |
  Zig 0.17 release toolchain, required to build Ly. FSDK 26.08 has no Zig
  element, so the upstream release tarball is pinned by SHA-256.

sources:
- kind: remote
  filename: zig.tar.xz
  (?):
  - arch == "x86_64":
      url: 'ziglang:%{zig-version}/zig-x86_64-linux-%{zig-version}.tar.xz'
      ref: '%{zig-amd64-sha256}'
  - arch == "aarch64":
      url: 'ziglang:%{zig-version}/zig-aarch64-linux-%{zig-version}.tar.xz'
      ref: '%{zig-arm64-sha256}'

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:bootstrap/xz.bst

config:
  install-commands:
  - |
    set -eu
    mkdir -p "%{install-root}/opt/zig"
    tar -xf zig.tar.xz -C "%{install-root}/opt/zig" --strip-components=1
    mkdir -p "%{install-root}%{prefix}/bin"
    ln -sf /opt/zig/zig "%{install-root}%{prefix}/bin/zig"
