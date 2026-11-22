# Desktop components

## Session

Mango is the only compositor in the default session. `/etc/mango/mango.conf`
provides image-level defaults; users override it in `~/.config/mango/`.
A `wayland-sessions/mango.desktop` entry is installed for display managers.

The display manager is [Ly](https://github.com/fairyglade/ly), enabled on
`tty1` as `ly@tty1.service`. Its login screen is themed with Tokyo Night
(night variant) from `/etc/ly/config.lua`; see `DESKTOP.md` below. No shell
configuration is shipped.

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
| Audio | PipeWire + WirePlumber |
| Portals | xdg-desktop-portal + xdg-desktop-portal-wlr (pinned source build) |
| Credentials | polkit |
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

## Login theme

Ly is configured with Tokyo Night **night** palette: background `#1a1b26`,
foreground `#c0caf5`, accents `#7aa2f7` and `#f7768e`. Animations are disabled
for a calm, fast login. The theme applies to Ly only; application themes are
left to the user or a future image-level default.

## Portals and file manager

`xdg-desktop-portal-wlr` is built from pinned source alongside FSDK's
`xdg-desktop-portal`, so screenshots and screen sharing work with Mango.
GTK4 and libadwaita are also built from pinned sources for Nautilus.
Because FSDK 26.08 carries neither a compositor stack nor Qt6, Mango's
dependencies (`wlroots` 0.20, `scenefx` 0.5, cJSON) and Quickshell's Qt6 modules
(qtbase, qtdeclarative, qtsvg) are built from pinned upstream sources in
`elements/compositor/`.
