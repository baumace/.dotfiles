# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a lightweight coding setup inside WSL (Ubuntu),
migrated from a prior Arch Linux/Hyprland desktop setup (see `windows_migration.md` for
history). Configuration files are organized by tool, intended to be symlinked to their
standard locations (`~/.config/` or home directory). Currently covers Neovim, zsh, and tmux
only.

## Setup Commands

**Initial setup (from README.md):**
```bash
# Clone and symlink configs
git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/tmux ~/.config/tmux

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh and tmux via apt; Neovim via the official release tarball (apt's
# version is generally too old for vim.pack) — see README.md for exact commands
chsh -s $(which zsh)
```

**Update configs:**
```bash
git -C ~/.dotfiles pull origin main
```

**Reload configurations:**
```bash
exec zsh                                          # Reload shell (re-attaches to tmux)
tmux source-file ~/.config/tmux/tmux.conf         # Reload tmux config in place
```

## Architecture

### Symlink-Based Structure
The repository uses a modular design where each tool has its own directory. Configs are symlinked to standard XDG locations:
- `~/.dotfiles/nvim/` → `~/.config/nvim/`
- `~/.dotfiles/tmux/` → `~/.config/tmux/`
- `~/.dotfiles/zsh/.zshrc` → `~/.zshrc`
- `~/.dotfiles/zsh/.zprofile` → `~/.zprofile`

### Key Configuration Files

**Neovim** (`nvim/init.lua`):
- Requires Neovim 0.12+ — uses the native `vim.pack.add()` package manager
- Plugins managed via `nvim-pack-lock.json` lock file
- LSP configured for Lua (`lua_ls`), Python (`pyright`), and TypeScript (`ts_ls`)
- Linting via `nvim-lint` (`htmlhint`, `eslint_d`, `pug-lint`)
- Formatting via `conform.nvim` (`prettier`)
- Telescope for fuzzy finding and live grep
- `nvim-colorizer.lua` for inline CSS color previews
- Leader key: Space
- Theme: Catppuccin Macchiato with transparency

**Tmux** (`tmux/tmux.conf`):
- File must be named `tmux.conf` (no leading dot) — tmux's XDG lookup is
  `$XDG_CONFIG_HOME/tmux/tmux.conf`, unlike the dotted `~/.tmux.conf` fallback
- Mouse mode enabled
- Catppuccin Macchiato status bar/pane border theme
- `zsh/.zshrc` auto-attaches every new interactive shell to a shared session named
  `main` via `tmux new-session -A -s main`, guarded by `[[ -z "$TMUX" && $- == *i* ]]`
  so nested shells inside tmux panes don't recurse

**Zsh** (`zsh/.zshrc`, `zsh/.zprofile`):
- `.zprofile` runs on login: auto-discovers and loads all SSH private keys (any file in
  `~/.ssh/` with a matching `.pub`) into the systemd-managed `ssh-agent`. New key pairs
  are picked up automatically. Requires WSL's systemd support (`systemd=true` in
  `/etc/wsl.conf`) and reads the socket at `$XDG_RUNTIME_DIR/openssh_agent` — Ubuntu's
  `ssh-agent.socket` unit names the socket `openssh_agent`, not `ssh-agent.socket`.
- Uses Oh My Zsh framework with `robbyrussell` theme
- NVM and Pyenv initialization for Node/Python version management (pyenv init is guarded
  with `command -v pyenv` since it isn't installed by default)
- Editor: `nvim` (local), `vim` (SSH)

## Common Development Patterns

### Neovim Plugin Management
Plugins are added via `vim.pack.add()` calls in `init.lua`. The lock file (`nvim-pack-lock.json`) tracks exact commits. To add a new plugin:
1. Add `vim.pack.add({ source = "author/plugin-name" })` in init.lua
2. Restart Neovim - it will auto-fetch the plugin
3. Configure the plugin after the `vim.pack.add` call

### Theme Consistency
The repository uses the Catppuccin Macchiato theme. Color palette:
- Base: `#24273a` (backgrounds)
- Surface0: `#363a4f` (inputs, selected items)
- Surface1: `#494d64` (borders)
- Overlay0: `#6e738d` (dimmed/placeholder text)
- Text: `#cad3f5` (primary text)
- Mauve: `#c6a0f6` (accents, highlights)

Themed tools:
- Neovim: `catppuccin-macchiato` flavor
- Tmux: Catppuccin Macchiato via `tmux.conf`

When making theme changes, maintain consistency across both configs.

## Dependencies

**Required system packages (apt):**
- `zsh`, `tmux`
- Neovim: install from the official GitHub release tarball, not apt (see README.md)

**Neovim LSP/Linters (install separately, e.g. via npm/pip):**
- `lua-language-server` (lua_ls)
- `pyright` (Python LSP)
- `typescript-language-server` (ts_ls)
- `htmlhint`, `eslint_d` (JS/TS/HTML linting)
- `prettier` (formatting)

**Version managers:** `nvm`, `pyenv` (optional — `.zshrc` guards for their absence)

## File Editing Guidelines

When modifying configuration files:
- **Neovim**: Changes to `init.lua` take effect on next launch. Lock file auto-updates when plugins change.
- **Tmux**: Run `tmux source-file ~/.config/tmux/tmux.conf` to apply changes to a running session, or restart tmux.
- **Zsh**: Run `exec zsh` to reload without restarting terminal.
