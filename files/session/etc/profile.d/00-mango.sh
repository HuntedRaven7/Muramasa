#!/bin/sh
# Start the Mango session automatically on the first virtual terminal.
# Guarded so SSH logins and non-tty shells are unaffected.
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_CURRENT_DESKTOP=Mango
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=mango
    exec /usr/bin/mango
fi
