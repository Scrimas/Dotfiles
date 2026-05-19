--  hyprlang noerror false
--  See https://wiki.hyprland.org/Configuring/Binds/
-- !
-- #! User
-- bind = Ctrl+Super, Slash, exec, xdg-open ~/.config/illogical-impulse/config.json # Edit shell config
-- bind = Ctrl+Super+Alt, Slash, exec, xdg-open ~/.config/hypr/custom/keybinds.conf # Edit extra keybinds
--  Add stuff here
--  Use #! to add an extra column on the cheatsheet
--  Use ##! to add a section in that column
--  Add a comment after a bind to add a description, like above

--  Screenshot
hl.bind("Print",
    hl.dsp.exec_cmd(
        "mkdir -p $(xdg-user-dir PICTURES)/Screenshots && hyprshot -m region -o $(xdg-user-dir PICTURES)/Screenshots -f \"Screenshot - $(date '+%d %B %Y - %Hh %Mm %Ss').png\" --freeze --silent"))

-- Screenshot region >> clipboard & file
hl.bind("CTRL + Print",
    hl.dsp.exec_cmd(
        "mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" $(xdg-user-dir PICTURES)/Screenshots/\"Screenshot - $(date '+%d %B %Y - %Hh %Mm %Ss').png\""),
    { locked = true, non_consuming = true })

-- Toggle Cheatsheet
hl.bind("SUPER + KP_Divide", hl.dsp.global("quickshell:cheatsheetToggle"))
hl.bind("SUPER + colon", hl.dsp.global("quickshell:cheatsheetToggle"))


-- Right sidebar
hl.bind("SUPER + A", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Shell: Toggle right sidebar" })
hl.bind("SUPER + ALT + A", hl.dsp.global("quickshell:sidebarRightToggleDetach"))
hl.bind("SUPER + B", hl.dsp.global("quickshell:sidebarLeftToggle"))
hl.bind("SUPER + O", hl.dsp.global("quickshell:sidebarLeftToggle"))
hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Shell: Toggle right sidebar" })
