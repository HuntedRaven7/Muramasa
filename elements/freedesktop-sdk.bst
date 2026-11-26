kind: junction

description: |
  freedesktop-sdk junction, pinned to the same ref Dakota uses. Component
  overrides point at GNOME Build Meta so artifact keys match the GNOME cache.
  x86-64-v3 is a real boolean conditional, as in Dakota, so keys stay stable.

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: 'freedesktop-sdk-26.08*'
  exclude:
  - '*dev*'
  ref: '%{fsdk-ref}'
- kind: patch_queue
  path: patches/freedesktop-sdk
# Dakota's separate queue; required for its ghostscript/ffmpeg artifact keys.
- kind: patch_queue
  path: patches/freedesktop-sdk-dakota

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

  # Same overrides as Dakota. These are the GNOME cache keys the published
  # artifacts were built with; changing them forces a full source rebuild.
  overrides:
    components/at-spi2-core.bst: gnome-build-meta.bst:sdk/at-spi2-core.bst
    components/cairo.bst: gnome-build-meta.bst:sdk/cairo.bst
    components/fcitx5-gtk.bst: gnome-build-meta.bst:sdk/fcitx5-gtk.bst
    components/gcab.bst: gnome-build-meta.bst:sdk/gcab.bst
    components/gdk-pixbuf.bst: gnome-build-meta.bst:sdk/gdk-pixbuf.bst
    components/glib-networking.bst: gnome-build-meta.bst:sdk/glib-networking.bst
    components/glib.bst: gnome-build-meta.bst:sdk/glib.bst
    components/glycin.bst: gnome-build-meta.bst:sdk/glycin.bst
    components/gobject-introspection.bst: gnome-build-meta.bst:sdk/gobject-introspection.bst
    components/python3-gi-docgen.bst: gnome-build-meta.bst:sdk/gi-docgen.bst
    components/graphene.bst: gnome-build-meta.bst:sdk/graphene.bst
    components/gsettings-desktop-schemas.bst: gnome-build-meta.bst:sdk/gsettings-desktop-schemas.bst
    components/gtk3.bst: gnome-build-meta.bst:sdk/gtk+-3.bst
    components/krb5.bst: gnome-build-meta.bst:sdk/krb5.bst
    components/libibus.bst: gnome-build-meta.bst:sdk/libibus.bst
    components/json-glib.bst: gnome-build-meta.bst:sdk/json-glib.bst
    components/libglycin.bst: gnome-build-meta.bst:sdk/libglycin.bst
    components/libnotify.bst: gnome-build-meta.bst:sdk/libnotify.bst
    components/librsvg.bst: gnome-build-meta.bst:sdk/librsvg.bst
    components/libsoup.bst: gnome-build-meta.bst:sdk/libsoup.bst
    components/pango.bst: gnome-build-meta.bst:sdk/pango.bst
    components/pygobject.bst: gnome-build-meta.bst:sdk/pygobject.bst
    components/vala.bst: gnome-build-meta.bst:sdk/vala.bst
    components/libsecret.bst: gnome-build-meta.bst:sdk/libsecret.bst
    components/zenity.bst: gnome-build-meta.bst:void/zenity.bst
    components/systemd.bst: gnome-build-meta.bst:core-deps/systemd.bst
    components/systemd-ukify.bst: gnome-build-meta.bst:core-deps/systemd-ukify.bst
    components/systemd-libs.bst: gnome-build-meta.bst:core-deps/systemd-libs.bst
    components/_private/systemd-base.bst: gnome-build-meta.bst:core-deps/systemd-base.bst
    components/xdg-desktop-portal.bst: gnome-build-meta.bst:core-deps/xdg-desktop-portal.bst
    components/_private/xdg-desktop-portal-base.bst: gnome-build-meta.bst:core-deps/xdg-desktop-portal-base.bst
    components/flatpak.bst: gnome-build-meta.bst:core-deps/flatpak.bst
