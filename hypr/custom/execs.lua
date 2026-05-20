--  hyprlang noerror false
--  You can make apps auto-start here
--  Relevant Hyprland wiki section: https://wiki.hyprland.org/Configuring/Keywords/#executing
--  Input method
--  exec-once = fcitx5

hl.on("hyprland.start", function()
    -- Kill existing instances
    hl.exec_cmd("killall wl-paste wl-clip-persist 2>/dev/null")

    -- Start wl-clip-persist to retain clipboard contents after apps exit (with delay for Wayland display readiness)
    hl.exec_cmd("sleep 1.5 && wl-clip-persist --clipboard both")

    -- Start cliphist watchers with quickshell integration
    hl.exec_cmd("sleep 1.5 && wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("sleep 1.5 && wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("sleep 1.5 && wl-paste --type text/uri-list --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
end)
