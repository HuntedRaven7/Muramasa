kind: script
description: |
  Final Muramasa bootc OCI image. The UKI built by base/boot.bst is already
  present under /boot/EFI/Linux in the rootfs, so bootc's composefs backend
  installs it to the ESP automatically.

build-depends:
- base/sandbox-tools.bst
- freedesktop-sdk.bst:components/oci-builder.bst
- freedesktop-sdk.bst:components/libcap.bst
- filename: oci/rootfs.bst
  config:
    location: /rootfs

variables:
  strip-binaries: ''
  image-repo: '%{image-name}'

config:
  commands:
  - |
    set -eu
    cd "%{install-root}"
    build-oci <<'EOF'
    mode: oci
    gzip: disabled
    images:
    - os: linux
      architecture: "%{go-arch}"
      layer: /rootfs
      comment: "Import Muramasa layer"
      config:
        Labels:
          'containers.bootc': '1'
          'org.opencontainers.image.title': 'Muramasa'
          'org.opencontainers.image.description': '%{image-description}'
          'org.opencontainers.image.vendor': 'Muramasa'
          'org.opencontainers.image.licenses': 'Apache-2.0'
      index-annotations:
        'org.opencontainers.image.ref.name': '%{image-registry}/%{image-name}:%{branch}'
    EOF
