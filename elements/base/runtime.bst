kind: stack
description: |
  Minimal bootc runtime. Deliberately no desktop session here: Mango is added
  by the compositor layer so non-graphical consumers can reuse this base.

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:components/ca-certificates.bst
- freedesktop-sdk.bst:components/tzdata.bst
- freedesktop-sdk.bst:components/openssl.bst
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/jq.bst
- freedesktop-sdk.bst:components/less.bst
- freedesktop-sdk.bst:components/sudo.bst
- freedesktop-sdk.bst:components/shadow.bst
- freedesktop-sdk.bst:components/linux-pam.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:components/audit.bst
- freedesktop-sdk.bst:components/bluez.bst
- freedesktop-sdk.bst:components/bluez-libs.bst
- freedesktop-sdk.bst:components/xdg-user-dirs.bst
- freedesktop-sdk.bst:bootstrap/libselinux.bst
- freedesktop-sdk.bst:components/networkmanager.bst
- freedesktop-sdk.bst:components/openssh.bst
- files/runtime.bst
