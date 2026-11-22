# Desktop components

## Session

Mango is the only compositor in the default session. `/etc/mango/mango.conf`
provides image-level defaults; users override it in `~/.config/mango/`.
The tty1 autologin starts Mango, and a `wayland-sessions/mango.desktop` entry
is installed for display managers.

No wallpaper tool is present: `swww`, `swaybg`, `hyprpaper`, `nitrogen` and
`feh` are intentionally excluded. Wallpaper handling belongs to the shell
layer added by the image owner.

## Shell layer

Quickshell v0.3.2 is built from the signed upstream tag and installed as a
binary with its QML module paths. **No configuration is shipped.** After the
first boot, place your shell configuration in your own config directory and
start it from your Mango config if desired.

## Tooling

| Area | Components |
| --- | --- |
| Launcher | rofi |
| Clipboard | wl-clipboard |
| Typing | wtype |
| Notifications | mako |
| OSD | swayosd |
| Media keys | playerctl |
| Screenshots | grim + slurp |
| Audio | PipeWire + WirePlumber + alsa-utils |
| Portals | xdg-desktop-portal + xdg-desktop-portal-wlr |
| Credentials | polkit + GNOME Keyring |
| Terminal | kitty |
| Files | Nautilus |
| Voice | Voxtype (signed AVX2 prebuilt) |

## Gaming

The OGC kernel is shared by both flavors. gamescope and native Steam are
installed in the image: `/usr/bin/steam` comes from Valve's pinned launcher
`.deb`, backed by the full 32-bit i686 compatibility slice ported from Dakota
(X11, GLVND/Mesa, Vulkan ICDs, GLib, GTK2). The Steam client self-updates into
the user's home directory on first launch. The `Steam (Gamescope)` desktop
entry runs Steam inside a nested gamescope session.

Native Steam is x86_64 only; aarch64 builds omit it because Valve does not
publish a native launcher for that architecture.
