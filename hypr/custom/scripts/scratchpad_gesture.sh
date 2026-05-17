#!/usr/bin/env bash

# Direction: up or down
direction=$1

# Get state
active_window=$(hyprctl activewindow -j)
window_address=$(echo "$active_window" | jq -r '.address // empty')
window_workspace=$(echo "$active_window" | jq -r '.workspace.name // empty')

# Check if a special workspace is visible on the focused monitor
monitor_info=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
special_visible=$(echo "$monitor_info" | jq -r '.specialWorkspace.name // empty')
active_regular=$(echo "$monitor_info" | jq -r '.activeWorkspace.name')

# Function to refresh UI focus if workspace is empty
refresh_ui() {
    # Small delay to let Hyprland update its internal state
    sleep 0.1
    local windows=$(hyprctl activeworkspace -j | jq '.windows')
    if [[ "$windows" -eq 0 ]]; then
        # Only bounce if empty to avoid flicker when windows are present.
        # This forces Quickshell to realize the workspace is empty and show the dock.
        # Using Lua dispatchers for the bounce
        hyprctl --batch "dispatch hl.dsp.focus({ workspace = 'r+1' }); dispatch hl.dsp.focus({ workspace = 'r-1' })"
    fi
}

if [[ "$direction" == "up" ]]; then
    if [[ -n "$special_visible" ]]; then
        # Special workspace is visible.
        # If we are focused on a window in the special workspace, pull it out.
        if [[ "$window_workspace" == special:* ]]; then
            hyprctl dispatch "hl.dsp.window.move({ workspace = '$active_regular' })"
        else
            # If special is visible but we aren't focused on it (e.g. empty special)
            hyprctl dispatch "hl.dsp.workspace.toggle_special('special')"
            refresh_ui
        fi
    else
        # Special workspace is hidden: Open it.
        hyprctl dispatch "hl.dsp.workspace.toggle_special('special')"
    fi
elif [[ "$direction" == "down" ]]; then
    if [[ -n "$special_visible" ]]; then
        # Special workspace is visible: Close it.
        hyprctl dispatch "hl.dsp.workspace.toggle_special('special')"
        refresh_ui
    else
        # Special workspace is hidden: Push the active window to it (if one exists).
        if [[ -n "$window_address" && "$window_address" != "0x" ]]; then
            hyprctl dispatch "hl.dsp.window.move({ workspace = 'special', follow = false })"
            refresh_ui
        fi
    fi
fi
