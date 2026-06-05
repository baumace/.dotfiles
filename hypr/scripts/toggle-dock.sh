#!/usr/bin/env bash
# Toggle between laptop and docked monitor configurations.
# Usage: toggle-dock.sh [docked|laptop]
#   No argument: auto-detect current state and toggle
#   docked:      force docked mode
#   laptop:      force laptop mode

WALLPAPER="/home/jawb/media/pictures/wallpapers/sunset.jpg"

# Check if eDP-1 is disabled (more reliable than checking if DP-4 is active,
# since external monitors may be connected but not yet initialized)
is_docked() {
    hyprctl monitors all | awk '/Monitor eDP-1/{f=1} f && /disabled:/{print; exit}' | grep -q "true"
}

enable_docked() {
    # Enable external monitors first — do NOT disable laptop screen yet
    hyprctl keyword monitor "DP-4,preferred,auto,auto"
    hyprctl keyword monitor "DP-6,preferred,auto,auto"

    # Wait for DP-4 to negotiate its DisplayPort link (up to 15s)
    for attempt in $(seq 1 5); do
        sleep 3
        hyprctl monitors | grep -q "^Monitor DP-4" && break
        hyprctl keyword monitor "DP-4,preferred,auto,auto"
    done

    if ! hyprctl monitors | grep -q "^Monitor DP-4"; then
        echo "External monitors did not initialize — staying in laptop mode"
        hyprctl keyword monitor "DP-4,disabled"
        hyprctl keyword monitor "DP-6,disabled"
        exit 1
    fi

    # DP-6 may need additional time after DP-4 — retry until it appears
    for attempt in $(seq 1 5); do
        hyprctl monitors | grep -q "^Monitor DP-6" && break
        hyprctl keyword monitor "DP-6,preferred,auto,auto"
        sleep 2
    done

    # Set workspace rules before disabling eDP-1 so Hyprland knows where to
    # migrate windows when the source monitor disappears
    for i in $(seq 1 9); do
        hyprctl keyword workspace "$i, monitor:DP-4"
    done
    hyprctl keyword workspace "10, monitor:DP-6"

    hyprctl keyword monitor "eDP-1,disabled"

    # Apply wallpaper to external monitors
    hyprctl hyprpaper wallpaper "DP-4,$WALLPAPER"
    hyprctl hyprpaper wallpaper "DP-6,$WALLPAPER"
}

enable_laptop() {
    hyprctl keyword monitor "eDP-1,preferred,auto,auto"

    # Set workspace rules before disabling external monitors so Hyprland knows
    # where to migrate windows when the source monitors disappear
    for i in $(seq 1 10); do
        hyprctl keyword workspace "$i, monitor:eDP-1"
    done

    hyprctl keyword monitor "DP-4,disabled"
    hyprctl keyword monitor "DP-6,disabled"
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
