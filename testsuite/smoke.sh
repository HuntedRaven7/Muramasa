#!/usr/bin/env bash
# Mango-specific smoke checks for a built Muramasa image.
# Runs read-only commands inside the image; no VM required. The shared
# projectbluefin/testsuite `common` suite covers SSH/portal/immutability E2E.
set -uo pipefail

IMAGE="${IMAGE:-localhost/muramasa:latest}"
PODMAN="${PODMAN:-sudo podman}"
failures=0

run() {
  "$PODMAN" run --rm --entrypoint /bin/sh "$IMAGE" -c "$1" >/dev/null 2>&1
}

check() {
  local desc="$1" script="$2"
  if run "$script"; then
    printf 'PASS  %s\n' "$desc"
  else
    printf 'FAIL  %s\n' "$desc" >&2
    failures=$((failures + 1))
  fi
}

echo "== Muramasa image smoke: ${IMAGE}"

for bin in mango quickshell rofi wl-copy wtype mako swayosd playerctl \
           grim slurp kitty nautilus voxtype steam firewall-cmd ujust just; do
  check "binary ${bin}" "command -v ${bin} >/dev/null 2>&1"
done

check "Mango default config" 'test -f /etc/mango/mango.conf'
check "Mango wayland session" 'test -f /usr/share/wayland-sessions/mango.desktop'
check "tty1 autologin" 'test -f /usr/lib/systemd/system/getty@tty1.service.d/override.conf'
check "UKI present" 'test -f /boot/EFI/Linux/muramasa.efi'
check "OGC kernel version recorded" 'test -s /usr/share/muramasa/kernel-version'
check "Steam launcher payload" 'test -x /usr/lib/steam/steam.sh'
check "32-bit Steam runtime" 'test -d /usr/lib/i386-linux-gnu'
check "ujust recipes" 'test -f /usr/share/ujust/ujust.just'
check "agent guidance" 'test -f /usr/share/muramasa/agent/AGENTS.md'
check "firewalld enabled" 'test -f /usr/lib/systemd/system/firewalld.service'
check "muramasa identity" 'grep -qi muramasa /usr/lib/os-release'

# The shell layer owns wallpapers and shell config; neither belongs here.
for bin in swww swaybg hyprpaper nitrogen feh; do
  check "no wallpaper tool ${bin}" "! command -v ${bin} >/dev/null 2>&1"
done
for path in /etc/xdg/quickshell /usr/share/quickshell/shell.qml; do
  check "no shell config at ${path}" "test ! -e ${path}"
done

if [ "$failures" -ne 0 ]; then
  printf '%d smoke check(s) failed\n' "$failures" >&2
  exit 1
fi
echo "All Mango smoke checks passed"
