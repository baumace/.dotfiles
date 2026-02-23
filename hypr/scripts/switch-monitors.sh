#!/bin/bash
# Detects docked/laptop state and applies the appropriate monitor configuration.
# Called from ~/.zprofile before Hyprland starts (symlink only) and via keybinding
# mid-session (symlink + reload). Safe to call in either context.

HYPR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"

is_docked() {
    grep -ql "^connected$" /sys/class/drm/card*-DP-4/status 2>/dev/null || \
    grep -ql "^connected$" /sys/class/drm/card*-DP-6/status 2>/dev/null
}

if is_docked; then
    target="monitors-docked.conf"
else
    target="monitors-laptop.conf"
fi

current=$(readlink "$HYPR_CONFIG_DIR/monitors.conf" 2>/dev/null)

if [[ "$current" != "$target" ]]; then
    ln -sf "$target" "$HYPR_CONFIG_DIR/monitors.conf"
    # Only reload if a Hyprland session is running; at pre-launch the symlink
    # update alone is enough since Hyprland hasn't read the config yet.
    if hyprctl monitors > /dev/null 2>&1; then
        hyprctl reload
    fi
fi
