Feature: Mango desktop smoke
  A Muramasa image boots into a Mango Wayland session with the expected
  compositor tooling, and leaves shell configuration to the image owner.

  Scenario: Compositor and session are installed
    Given a built Muramasa image
    When the image contents are inspected
    Then /usr/bin/mango exists
    And /usr/share/wayland-sessions/mango.desktop exists
    And /etc/mango/mango.conf exists
    And the tty1 autologin starts Mango

  Scenario: WC tooling is present
    Given a built Muramasa image
    When the image contents are inspected
    Then rofi, wl-clipboard, wtype, mako, swayosd and playerctl exist
    And grim, slurp, kitty, Nautilus and Voxtype exist
    And native Steam and firewalld exist

  Scenario: Shell responsibilities are not baked in
    Given a built Muramasa image
    When the image contents are inspected
    Then no wallpaper manager is installed
    And no shell configuration is installed

  Scenario: Boot assets and identity
    Given a built Muramasa image
    When the image contents are inspected
    Then a Unified Kernel Image exists in /boot/EFI/Linux
    And the OGC kernel version is recorded
    And os-release identifies Muramasa
