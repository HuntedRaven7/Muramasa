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

# Install Steam from Flathub (Steam is intentionally not baked into the image).
install-steam:
    @#!/usr/bin/env bash
    set -euo pipefail
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub com.valvesoftware.Steam
    @echo "Use 'steam' from the application menu, or 'flatpak run com.valvesoftware.Steam'."

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
