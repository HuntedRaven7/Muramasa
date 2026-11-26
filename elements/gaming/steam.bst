# Native Steam launcher/bootstrap from Valve's Debian package, Dakota-style.
#
# This is not an RPM import: we extract Valve's distro-neutral launcher payload
# into the immutable host image so /usr/bin/steam, desktop actions, icons, MIME
# handlers, the bootstrap runtime tarball, and Steam Input/VR udev rules are
# present like a native install. The Steam client itself self-updates into the
# user's home directory on first launch.
kind: manual

# The CDN's client/installer/steam.deb is an unversioned URL: Valve has changed
# its content under a pinned checksum before. The apt pool serves the identical
# payload at a versioned path, so pin that instead.
sources:
- kind: remote
  url: 'steam-repo:steam/pool/steam/s/steam/steam-launcher_%{steam-launcher-version}_amd64.deb'
  ref: '%{steam-launcher-deb-sha256}'
  filename: steam-launcher_%{steam-launcher-version}_amd64.deb

build-depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/binutils.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:bootstrap/xz.bst
- freedesktop-sdk.bst:components/python3.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/diffutils.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:bootstrap/xz.bst
- freedesktop-sdk.bst:cross-compilers/standard-libs-i686.bst
- gaming/steam-libs-i686.bst
- freedesktop-sdk.bst:components/vulkan-icd-loader.bst
- freedesktop-sdk.bst:components/compat-vulkan-link.bst
- freedesktop-sdk.bst:components/libpulse.bst
- freedesktop-sdk.bst:components/alsa-plugins.bst
- freedesktop-sdk.bst:components/openal.bst
- freedesktop-sdk.bst:components/libusb.bst
- freedesktop-sdk.bst:components/libgudev.bst
- freedesktop-sdk.bst:components/libevdev.bst
- freedesktop-sdk.bst:components/xorg-lib-x11.bst
- freedesktop-sdk.bst:components/xorg-lib-xcursor.bst
- freedesktop-sdk.bst:components/xorg-lib-xdamage.bst
- freedesktop-sdk.bst:components/xorg-lib-xext.bst
- freedesktop-sdk.bst:components/xorg-lib-xfixes.bst
- freedesktop-sdk.bst:components/xorg-lib-xi.bst
- freedesktop-sdk.bst:components/xorg-lib-xinerama.bst
- freedesktop-sdk.bst:components/xorg-lib-xrandr.bst
- freedesktop-sdk.bst:components/xorg-lib-xrender.bst
- freedesktop-sdk.bst:components/xorg-lib-xscrnsaver.bst
- freedesktop-sdk.bst:components/xorg-lib-xtst.bst
- freedesktop-sdk.bst:components/xorg-lib-xxf86vm.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    set -eu
    mkdir -p deb data "%{install-root}"
    cd deb
    ar x ../steam-launcher_*_amd64.deb
    cd ..
    tar -xf deb/data.tar.xz -C data

    # Install the immutable host launcher payload.
    cp -a data/usr/. "%{install-root}/usr/"

    # Valve's deb carries udev rules in /lib for Debian usr-merge; FSDK uses
    # /usr/lib/udev as the canonical location.
    if [ -d data/lib/udev/rules.d ]; then
      mkdir -p "%{install-root}/usr/lib/udev/rules.d"
      cp -a data/lib/udev/rules.d/. "%{install-root}/usr/lib/udev/rules.d/"
    fi

    # No dpkg/apt database in this image. Keep a no-op steamdeps command so
    # Valve's launcher does not emit python-apt noise before continuing.
    rm -rf "%{install-root}/etc/apt"
    cat > "%{install-root}/usr/lib/steam/bin_steamdeps.py" <<'EOF'
    #!/usr/bin/env sh
    exit 0
    EOF
    chmod 755 "%{install-root}/usr/lib/steam/bin_steamdeps.py"

    # Make steam-runtime/run.sh see the host 32-bit library path. Without this,
    # the bundled scout runtime can load an older libxcb.so.1 before our
    # matching libxcb-shm.so.0 and fail with undefined symbols.
    cat > "%{install-root}/etc/ld.so.conf.d/00-i386-linux-gnu.conf" <<'EOF'
    /usr/lib/i386-linux-gnu/GL/default/lib
    /usr/lib/i386-linux-gnu
    EOF

    python3 - <<'PY'
    from pathlib import Path
    p = Path('%{install-root}/usr/lib/steam/bin_steam.sh')
    text = p.read_text()
    old = 'cd "$LAUNCHSTEAMDIR"\n\nexec "$LAUNCHSTEAMDIR/$STEAMBOOTSTRAP" ${log_opened+-srt-logger-opened} "$@"\n'
    new = '''cd "$LAUNCHSTEAMDIR"

    # Prefer the host 32-bit runtime slice over Steam scout's older libraries.
    export LD_LIBRARY_PATH="/usr/lib/i386-linux-gnu/GL/default/lib:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    exec "$LAUNCHSTEAMDIR/$STEAMBOOTSTRAP" ${log_opened+-srt-logger-opened} "$@"
    '''
    if old not in text:
        raise SystemExit('failed to locate Steam bootstrap exec block')
    p.write_text(text.replace(old, new))
    PY

    # Ensure Valve's /usr/lib/steam/steam.desktop symlink survived extraction.
    ln -sfn ../../share/applications/steam.desktop \
      "%{install-root}/usr/lib/steam/steam.desktop"
