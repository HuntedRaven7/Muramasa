kind: manual
description: |
  Flatpark remote, Bazaar preinstall and the supporting systemd units, adapted
  from projectbluefin/common. No GNOME-specific store integration is included.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: files/flatpak

config:
  install-commands:
  - |
    set -eu
    install -Dm644 flatpark.flatpakrepo \
      "%{install-root}%{datadir}/flatpak/remotes.d/flatpark.flatpakrepo"
    install -Dm644 flatpark.filter \
      "%{install-root}%{datadir}/flatpak/flatpark.filter"
    install -Dm644 bazaar.preinstall \
      "%{install-root}%{datadir}/flatpak/preinstall.d/bazaar.preinstall"
    install -Dm644 flatpak-overrides/io.github.kolunmi.Bazaar \
      "%{install-root}%{datadir}/ublue-os/flatpak-overrides/io.github.kolunmi.Bazaar"
    install -Dm644 bazaar-flatpak.conf \
      "%{install-root}%{prefix}/lib/tmpfiles.d/bazaar-flatpak.conf"

    install -Dm644 systemd/system/flatpark-filter-copy.path \
      "%{install-root}%{prefix}/lib/systemd/system/flatpark-filter-copy.path"
    install -Dm644 systemd/system/flatpark-filter-copy.service \
      "%{install-root}%{prefix}/lib/systemd/system/flatpark-filter-copy.service"
    install -Dm644 systemd/system/flatpak-preinstall.service \
      "%{install-root}%{prefix}/lib/systemd/system/flatpak-preinstall.service"
    install -Dm644 systemd/system/flatpak-appstream-refresh.service \
      "%{install-root}%{prefix}/lib/systemd/system/flatpak-appstream-refresh.service"
    install -Dm644 systemd/system/flatpak-appstream-refresh.timer \
      "%{install-root}%{prefix}/lib/systemd/system/flatpak-appstream-refresh.timer"
    install -Dm644 systemd/system-preset/02-flatpak-appstream-refresh.preset \
      "%{install-root}%{prefix}/lib/systemd/system-preset/02-flatpak-appstream-refresh.preset"
    install -Dm644 systemd/user/bazaar.service \
      "%{install-root}%{prefix}/lib/systemd/user/bazaar.service"

    install -Dm644 system-flatpaks.Brewfile \
      "%{install-root}%{datadir}/muramasa/brew/system-flatpaks.Brewfile"

    # New-user Flatpak overrides for VS Code (Wayland + Podman socket) and
    # Chrome (local applications/icons).
    install -Dm644 user-overrides/com.visualstudio.code \
      "%{install-root}%{sysconfdir}/skel/.local/share/flatpak/overrides/com.visualstudio.code"
    install -Dm644 user-overrides/com.google.Chrome \
      "%{install-root}%{sysconfdir}/skel/.local/share/flatpak/overrides/com.google.Chrome"

    # Enable system units and the per-user Bazaar background service.
    install -d "%{install-root}%{sysconfdir}/systemd/system/multi-user.target.wants"
    ln -sfn "%{prefix}/lib/systemd/system/flatpak-preinstall.service" \
      "%{install-root}%{sysconfdir}/systemd/system/multi-user.target.wants/flatpak-preinstall.service"
    install -d "%{install-root}%{sysconfdir}/systemd/system/paths.target.wants"
    ln -sfn "%{prefix}/lib/systemd/system/flatpark-filter-copy.path" \
      "%{install-root}%{sysconfdir}/systemd/system/paths.target.wants/flatpark-filter-copy.path"
    install -d "%{install-root}%{sysconfdir}/skel/.config/systemd/user/default.target.wants"
    ln -sfn "%{prefix}/lib/systemd/user/bazaar.service" \
      "%{install-root}%{sysconfdir}/skel/.config/systemd/user/default.target.wants/bazaar.service"
