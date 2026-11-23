kind: stack
description: |
  Complete desktop dependency closure. This is the single element CI builds
  before composing the OCI image.

depends:
- base/runtime.bst
- base/boot.bst
- compositor/mango.bst
- compositor/quickshell.bst
- tooling/wc-tools.bst
- tooling/brew.bst
- tooling/brew-tarball.bst
- tooling/docker.bst
- gaming/session.bst
- agent/agent.bst
- files/session.bst
- files/os-release.bst
- files/secure-boot.bst
- files/flatpak.bst
- session/ly.bst
- security/selinux-policy.bst
- base/nvidia.bst
