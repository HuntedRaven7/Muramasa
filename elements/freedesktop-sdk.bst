kind: junction

description: |
  freedesktop-sdk junction. All Muramasa layers are built from FSDK elements;
  the GNOME and Bluefin artifact caches are reusable because they are also
  FSDK-based. x86-64-v3 is enabled for x86_64 builds (aarch64 is unchanged).

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: 'freedesktop-sdk-26.08*'
  exclude:
  - '*dev*'
  ref: '%{fsdk-ref}'

config:
  options:
    target_arch: '%{arch}'
    x86_64_v3: false
    (?):
    - arch == "x86_64" and x86_64_v3:
        x86_64_v3: true
    - arch == "x86_64":
        bootstrap_build_arch: 'x86_64'
    - arch == "aarch64":
        bootstrap_build_arch: 'aarch64'
