kind: script
description: |
  Final Muramasa bootc OCI image. The UKI built by base/boot.bst is already
  present under /boot/EFI/Linux in the rootfs, so bootc's composefs backend
  installs it to the ESP automatically.

build-depends:
- core/sandbox-tools.bst
- freedesktop-sdk.bst:components/oci-builder.bst
- freedesktop-sdk.bst:components/libcap.bst
- freedesktop-sdk.bst:components/sbsigntools-maybe.bst
- filename: oci/rootfs.bst
  config:
    location: /rootfs
- filename: files/boot-keys.bst
  config:
    location: /keys

variables:
  strip-binaries: ''
  image-repo: '%{image-name}'

config:
  commands:
  - |
    set -eu
    # Sign the UKI when a key and option are available. The public cert is
    # always shipped so users can enroll it with `ujust enroll-secure-boot-key`.
    if [ -f /keys/private/secure-boot.key ]; then
      sbsign --key /keys/private/secure-boot.key \
        --cert /keys/public/secure-boot.crt \
        --output /tmp/muramasa.efi.signed \
        /rootfs/boot/EFI/Linux/muramasa.efi
      cp /tmp/muramasa.efi.signed /rootfs/boot/EFI/Linux/muramasa.efi
    fi
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
