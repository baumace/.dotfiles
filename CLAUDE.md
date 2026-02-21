# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a Wayland-based Linux desktop environment (Arch). Configuration files are organized by tool, intended to be symlinked to their standard locations (`~/.config/` or home directory).

## Setup Commands

**Initial setup (from README.md):**
```bash
# Clone and symlink configs
git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Neovim
sudo pacman -S neovim
```

**Update configs:**
```bash
git -C ~/.dotfiles pull origin main
```

**Reload configurations:**
```bash
exec zsh                          # Reload shell
# Neovim plugins auto-install via native package manager
hyprctl reload                    # Reload Hyprland
killall waybar && waybar &        # Restart Waybar
```

## Architecture

### Symlink-Based Structure
The repository uses a modular design where each tool has its own directory. Configs are symlinked to standard XDG locations:
- `~/.dotfiles/nvim/` → `~/.config/nvim/`
- `~/.dotfiles/zsh/.zshrc` → `~/.zshrc`
- `~/.dotfiles/hypr/` → `~/.config/hypr/`
- Similar for waybar, ghostty, mako, tmux

### Key Configuration Files

**Neovim** (`nvim/init.lua`):
- Uses native Neovim package management (`vim.pack.add`)
- Plugins managed via `nvim-pack-lock.json` lock file
- LSP configured for Lua (`lua_ls`) and Python (`pyright`)
- Linting via `nvim-lint` (includes `htmlhint` for HTML)
- Telescope for fuzzy finding and live grep
- Leader key: Space
- Theme: Catppuccin Macchiato with transparency

**Hyprland** (`hypr/hyprland.conf`):
- Main window manager config
- Dwindle layout (tiling), Vim-style navigation (hjkl)
- Super key as modifier
- Autostart applications defined at end of config (mako, waybar)

**Zsh** (`zsh/.zshrc`):
- Uses Oh My Zsh framework with `robbyrussell` theme
- NVM and Pyenv initialization for Node/Python version management
- Custom SSH auth socket configuration
- Editor: `nvim` (local), `vim` (SSH)

**Waybar** (`waybar/config.jsonc` and `waybar/style.css`):
- Left: workspaces, scratchpad, media player
- Center: window title
- Right: system info (audio, network, CPU, memory, temp, battery, clock, power)
- Color-coded thresholds for system metrics
- Style uses custom classes in CSS for theming

## Common Development Patterns

### Neovim Plugin Management
Plugins are added via `vim.pack.add()` calls in `init.lua`. The lock file (`nvim-pack-lock.json`) tracks exact commits. To add a new plugin:
1. Add `vim.pack.add({ source = "author/plugin-name" })` in init.lua
2. Restart Neovim - it will auto-fetch the plugin
3. Configure the plugin after the `vim.pack.add` call

### Hyprland Keybindings
All keybindings use the Super (Windows/Cmd) key as the primary modifier:
- `Super+T`: Terminal (ghostty)
- `Super+Q`: Application launcher (wofi)
- `Super+HJKL`: Navigate windows
- `Super+Shift+HJKL`: Move windows
- `Super+[1-0]`: Switch workspaces
- `Super+Shift+[1-0]`: Move window to workspace
- `Super+S`: Toggle scratchpad

### Theme Consistency
The repository will use the Catppuccin theme across tools:
- Neovim: `catppuccin-macchiato` flavor
- Other tools still need styling

When making theme changes, maintain consistency across all configs.

## Dependencies

**Required system packages:**
- Core: `zsh`, `neovim`, `hyprland`, `waybar`, `mako`, `ghostty`, `tmux`
- Utilities: `wofi`, `playerctl`, `wpctl`, `brightnessctl`, `pavucontrol`
- Version managers: `nvm`, `pyenv`

**Neovim LSP/Linters:**
- `lua-language-server` (lua_ls)
- `pyright` (Python LSP)
- `htmlhint` (HTML linter)

Install via system package manager.

## File Editing Guidelines

When modifying configuration files:
- **Neovim**: Changes to `init.lua` take effect on next launch. Lock file auto-updates when plugins change.
- **Hyprland**: Run `hyprctl reload` after changes, or restart Hyprland for major changes.
- **Waybar**: Kill and restart the process to see changes immediately.
- **Zsh**: Run `exec zsh` to reload without restarting terminal.

Always test configuration changes before committing, especially for Hyprland (invalid config can prevent login).
