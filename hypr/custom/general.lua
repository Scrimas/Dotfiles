--  hyprlang noerror false
--  Put general config stuff here
--  Here's a list of every variable: https://wiki.hyprland.org/Configuring/Variables/

hl.monitor({
    output = "eDP-1",
    mode = "2880x1800@120",
    position = "auto",
    scale = "1.5",
    icc = "/home/scrimas/ICC Profiles/sRGB Color Space Profile.icm"
})

-- Window and Workspace Gestures
hl.gesture({ fingers = 4, direction = "swipe", action = "move" })
hl.gesture({ fingers = 4, direction = "pinch", action = "float" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Custom Script Executions
hl.gesture({
    fingers = 3,
    direction = "up",
    action = function()
        hl.exec_cmd("bash " .. HOME .. "/.config/hypr/custom/scripts/scratchpad_gesture.sh up")
    end
})

hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        hl.exec_cmd("bash " .. HOME .. "/.config/hypr/custom/scripts/scratchpad_gesture.sh down")
    end
})

hl.config({
    gestures = {
        workspace_swipe_direction_lock = false
    }
})
hl.config({
    decoration = {
        blur = {
            enabled = true,
            xray = false,
            popups = true
        },
        shadow = {
            enabled = true,
            range = 50,
            offset = "0 4",
            color = "rgba" .. "(" .. "00000027)"
        }
    }
})
hl.config({
    input = {
        kb_layout = "fr",
        scroll_factor = 0.10,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.150000,
            clickfinger_behavior = false,
        },
        touchdevice = {
            enabled = true
        }
    }
})
hl.config({
    misc = {
        vrr = true
    }
})
hl.config({
    binds = {
        scroll_event_delay = 250
    }
})
--  unscale XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})
