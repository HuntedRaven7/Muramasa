kind: manual
description: |
  Voxtype v%{voxtype-version} push-to-talk dictation. A signed upstream
  release binary, pinned by the SHA-256 published in the signed SHA256SUMS.txt.
  No model files are baked into the image; `voxtype setup --download` is run
  by the user on first use.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: remote
  ref: '%{voxtype-sums-sha256}'
  filename: SHA256SUMS.txt
  (?):
  - arch == "x86_64":
      url: 'github_releases:peteonrails/voxtype/releases/download/v%{voxtype-version}/SHA256SUMS.txt'
  - arch == "aarch64":
      url: 'github_releases:peteonrails/voxtype/releases/download/v%{voxtype-version}/SHA256SUMS.txt'
- kind: remote
  filename: voxtype
  (?):
  - arch == "x86_64":
      url: 'github_releases:peteonrails/voxtype/releases/download/v%{voxtype-version}/voxtype-%{voxtype-version}-linux-x86_64-avx2'
      ref: '%{voxtype-amd64-sha256}'
  - arch == "aarch64":
      url: 'github_releases:peteonrails/voxtype/releases/download/v%{voxtype-version}/voxtype-%{voxtype-version}-linux-aarch64-cpu'
      ref: '%{voxtype-arm64-sha256}'

config:
  install-commands:
  - |
    set -eu
    # BuildStream verifies the source `ref` above. Cross-check it against the
    # upstream signed manifest as a second independent provenance check.
    expected=$(awk -v v="%{voxtype-version}" -v arch="%{arch}" '
      $2 ~ ("voxtype-" v "-linux-" (arch == "x86_64" ? "x86_64" : "aarch64")) {
        print $1; exit
      }' SHA256SUMS.txt)
    case "%{arch}" in
      x86_64)  pinned='%{voxtype-amd64-sha256}' ;;
      aarch64) pinned='%{voxtype-arm64-sha256}' ;;
    esac
    [ "$expected" = "$pinned" ] || {
      echo "voxtype checksum mismatch against signed SHA256SUMS.txt" >&2
      exit 1
    }
    install -Dm755 voxtype "%{install-root}%{prefix}/bin/voxtype"
    install -d "%{install-root}%{datadir}/muramasa/voxtype"
    cp SHA256SUMS.txt "%{install-root}%{datadir}/muramasa/voxtype/"
