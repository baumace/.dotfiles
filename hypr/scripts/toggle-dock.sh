#!/usr/bin/env bash
# Toggle between laptop and docked monitor configurations.
# Usage: toggle-dock.sh [docked|laptop]
#   No argument: auto-detect current state and toggle
#   docked:      force docked mode
#   laptop:      force laptop mode

WALLPAPER="/home/jawb/media/pictures/wallpapers/sunset.jpg"

is_docked() {
    hyprctl monitors | grep -q "^Monitor DP-4"
}

enable_docked() {
    hyprctl keyword monitor "eDP-1,disabled"
    hyprctl keyword monitor "DP-4,preferred,auto,auto"
    hyprctl keyword monitor "DP-6,preferred,auto,auto"

    # Workspace assignments: 1-9 on DP-4, 10 on DP-6
    for i in $(seq 1 9); do
        hyprctl keyword workspace "$i, monitor:DP-4"
    done
    hyprctl keyword workspace "10, monitor:DP-6"

    # Apply wallpaper to external monitors
    hyprctl hyprpaper wallpaper "DP-4,$WALLPAPER"
    hyprctl hyprpaper wallpaper "DP-6,$WALLPAPER"
}

enable_laptop() {
    hyprctl keyword monitor "eDP-1,preferred,auto,auto"
    hyprctl keyword monitor "DP-4,disabled"
    hyprctl keyword monitor "DP-6,disabled"

    # Clear workspace pinning back to eDP-1
    for i in $(seq 1 10); do
        hyprctl keyword workspace "$i, monitor:eDP-1"
    done
}

case "${1:-}" in
    docked)
        enable_docked
        ;;
    laptop)
        enable_laptop
        ;;
    *)
        if is_docked; then
            enable_laptop
        else
            enable_docked
        fi
        ;;
esac
