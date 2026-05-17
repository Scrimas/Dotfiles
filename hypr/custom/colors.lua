-- Custom color settings from backup
hl.config({
    general = {
        col = {
            active_border = "rgba(90928477)",
            inactive_border = "rgba(45483c55)"
        }
    }
})
hl.config({
    misc = {
        background_color = "rgba(12140dFF)"
    }
})
hl.config({
    plugin = {
        hyprbars = {
            bar_color = "rgba(12140dFF)",
            col = {
                text = "rgba(e3e3d7FF)"
            },
            -- Lua does not support repeated keys; using an array for multiple buttons
            ["hyprbars-button"] = {
                "rgb(e3e3d7), 13, 󰖭, hyprctl dispatch killactive",
                "rgb(e3e3d7), 13, 󰖯, hyprctl dispatch fullscreen 1",
                "rgb(e3e3d7), 13, 󰖰, hyprctl dispatch movetoworkspacesilent special"
            }
        }
    }
})
hl.window_rule({
    match = {
        pin = 1
    },
    border_color = "rgba(b8cf84AA) rgba(b8cf8477)"
})
