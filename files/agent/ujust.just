# Muramasa ujust commands. Installed to /usr/share/ujust/ujust.just.
# User overrides belong in ~/.config/muramasa/ujust.just and are sourced by
# `ujust user` when present.

# Show all available commands.
default:
    @just --justfile /usr/share/ujust/ujust.just --list

# Print image provenance and current stream.
status:
    @echo "Image: $(grep PRETTY_NAME /etc/os-release)"
    @echo "Kernel: $(uname -r)"
    @cat /usr/share/muramasa/kernel-version 2>/dev/null || true

# Install the Homebrew extras (including Docker) from the system Brewfile.
install-docker:
    @#!/usr/bin/env bash
    set -euo pipefail
    brew bundle --file /etc/muramasa/brew/Brewfile
    sudo systemctl enable --now docker-brew.service
    @echo "Docker installed. Add your user to the 'docker' group and re-login."

# List the Brewfile that will be installed.
brew-list:
    @cat /etc/muramasa/brew/Brewfile

# Start the Mango session manually (normally started from tty1 autologin).
start-mango:
    @exec /usr/bin/mango

# Enroll the Muramasa development Secure Boot key (requires MOK management).
enroll-secure-boot-key:
    @#!/usr/bin/env bash
    set -euo pipefail
    cert=/usr/share/muramasa/secure-boot/secure-boot.crt
    if command -v mokutil >/dev/null 2>&1; then
        mokutil --import "$cert"
        echo "Reboot and complete MOK enrollment in the firmware UI."
    else
        echo "mokutil is unavailable; copy $cert to your firmware key store manually."
    fi

# Install the default system Flatpaks (Bazaar) from the Brewfile.
install-system-flatpaks:
    @#!/usr/bin/env bash
    set -euo pipefail
    brew bundle --file /usr/share/muramasa/brew/system-flatpaks.Brewfile

# Verify the native Steam launcher installed in the image.
verify-steam:
    @#!/usr/bin/env bash
    set -euo pipefail
    test -x /usr/bin/steam
    test -x /usr/lib/steam/steam.sh
    @echo "Native Steam launcher is installed. The client self-updates on first launch."

# Download the configured Voxtype model (models are not shipped in the image).
setup-voxtype:
    @voxtype setup --download

# Show the agent contributor guidance shipped in the image.
agent-docs:
    @cat /usr/share/muramasa/agent/AGENTS.md

# Apply user-level overrides if present.
user:
    @#!/usr/bin/env bash
    set -euo pipefail
    f="${HOME}/.config/muramasa/ujust.just"
    if [ -f "$f" ]; then exec just --justfile "$f" --list; fi
    echo "No user overrides at $f"
