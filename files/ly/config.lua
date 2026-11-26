-- Muramasa login theme: Tokyo Night (night variant).
-- Palette: bg #1a1b26, fg #c0caf5, blue #7aa2f7, red #f7768e.

ly = {
    -- Tokyo Night night palette. Colors are 0xSSRRGGBB.
    bg = 0x001a1b26,
    fg = 0x00c0caf5,
    border_fg = 0x007aa2f7,
    error_bg = 0x001a1b26,
    error_fg = 0x01f7768e,
    full_color = true,
    blank_box = true,

    -- Keep the login screen calm and fast.
    animation = "none",
    bigclock = "none",
    clock = "%H:%M",
    box_title = "Muramasa",

    -- Layout.
    box_position_h = 0.5,
    box_position_v = 0.5,
    corner_top_left = "shutdown,restart,britup,britdown,password battery binds",
    corner_top_right = "clock numlock,capslock",
    corner_bottom_left = "version",
    corner_bottom_right = "labels",

    -- No autologin: the compositor session is selected from Ly.
    auto_login_user = nil,
    auto_login_session = nil,
}
