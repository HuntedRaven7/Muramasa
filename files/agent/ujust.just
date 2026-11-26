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

# Capture system state, review it, and file a user-reviewed issue.
report:
    @#!/usr/bin/env bash
    set -euo pipefail
    command -v gh >/dev/null 2>&1 || { echo "gh is required for reporting" >&2; exit 1; }
    body=$(mktemp)
    {
        echo "## Image"; ujust status || true
        echo; echo "## Kernel"; uname -a
        echo; echo "## Failed units"; systemctl --failed --no-pager || true
        echo; echo "## Compositor"; command -v mango || true
    } > "$body"
    echo "--- report preview ---"; cat "$body"; echo "----------------------"
    read -r -p "Publish this as a GitHub issue? [y/N] " answer
    [ "$answer" = "y" ] || { echo "Aborted"; exit 0; }
    gh issue create --repo HuntedRaven7/Muramasa \
      --title "Muramasa report: $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      --body-file "$body"
    rm -f "$body"

# Add a hardware fingerprint to an existing issue.
confirm issue:
    @#!/usr/bin/env bash
    set -euo pipefail
    { echo "Confirmed on:"; ujust status || true; uname -a; } \
      | gh issue comment "{{issue}}" --repo HuntedRaven7/Muramasa --body-file -

# Confirm a fix works after a nightly update.
verify issue:
    @#!/usr/bin/env bash
    set -euo pipefail
    { echo "Verified on:"; ujust status || true; uname -a; } \
      | gh issue comment "{{issue}}" --repo HuntedRaven7/Muramasa --body-file -

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
