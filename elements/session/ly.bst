kind: manual
description: |
  Ly TUI display manager. Muramasa's login screen is themed with Tokyo Night
  (night variant); the configuration lives in files/ly/config.lua and is
  installed to /etc/ly/config.lua. This element installs no shell configuration.

build-depends:
- core/sandbox-tools.bst
- tooling/zig.bst
- freedesktop-sdk.bst:components/linux-pam.bst
- freedesktop-sdk.bst:bootstrap/ncurses.bst
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:components/xorg-lib-xcb.bst

sources:
- kind: git_repo
  url: github:fairyglade/ly.git
  track: master
  ref: '%{ly-ref}'
- kind: local
  path: files/ly

config:
  install-commands:
  - |
    set -eu
    # Vendor zig-clap: the build sandbox has no network.
    cp build.zig.zon.muramasa build.zig.zon
    mkdir -p clap
    cp -a /clap/. clap/
    zig build -Doptimize=ReleaseSafe --prefix "%{install-root}%{prefix}" install

    # Service and PAM profiles shipped by Ly.
    install -Dm644 res/ly@.service \
      "%{install-root}%{prefix}/lib/systemd/system/ly@.service"
    sed -i \
      -e 's|\$PREFIX_DIRECTORY|%{prefix}|g' \
      -e 's|\$EXECUTABLE_NAME|ly|g' \
      "%{install-root}%{prefix}/lib/systemd/system/ly@.service"
    install -Dm644 res/pam.d/ly-linux "%{install-root}%{sysconfdir}/pam.d/ly"
    install -Dm644 res/pam.d/ly-linux-autologin \
      "%{install-root}%{sysconfdir}/pam.d/ly-autologin"

    # Tokyo Night login configuration.
    install -Dm644 config.lua "%{install-root}%{sysconfdir}/ly/config.lua"

    # Start Ly on tty1 instead of a plain getty.
    install -d "%{install-root}%{sysconfdir}/systemd/system/multi-user.target.wants"
    ln -sfn "%{prefix}/lib/systemd/system/ly@.service" \
      "%{install-root}%{sysconfdir}/systemd/system/multi-user.target.wants/ly@tty1.service"
