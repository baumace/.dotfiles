# .dotfiles

Personal configuration files for a Wayland-based Linux desktop environment (Arch), including [Neovim](https://neovim.io/), [Hyprland](https://hyprland.org/), [Waybar](https://github.com/Alexays/Waybar), [Wofi](https://hg.sr.ht/~scoopta/wofi), [zsh](https://www.zsh.org/), and more.

All configs use the [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) color theme.

---

## Initial Setup (Arch Linux)

1. **Clone this repository:**

    ```bash
    git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
    ```

2. **Symlink config files:**

    ```bash
    ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
    ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
    ln -sf ~/.dotfiles/nvim ~/.config/nvim
    ln -sf ~/.dotfiles/hypr ~/.config/hypr
    ln -sf ~/.dotfiles/waybar ~/.config/waybar
    ln -sf ~/.dotfiles/wofi ~/.config/wofi
    ln -sf ~/.dotfiles/mako ~/.config/mako
    ln -sf ~/.dotfiles/ghostty ~/.config/ghostty
    ln -sf ~/.dotfiles/tmux ~/.config/tmux
    sudo ln -sf ~/.dotfiles/greetd/config.toml /etc/greetd/config.toml
    ```

3. **Install Oh My Zsh (if needed):**

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

4. **Install required packages:**

    ```bash
    sudo pacman -S neovim hyprland waybar mako ghostty tmux wofi \
                   playerctl pavucontrol \
                   keychain hyprlock hypridle greetd greetd-tuigreet
    ```

5. **Install Neovim LSP/linters:**

    ```bash
    sudo pacman -S lua-language-server pyright
    npm install -g htmlhint
    ```

6. **Enable greetd** (login screen):

    ```bash
    sudo systemctl enable greetd.service
    ```

7. **Restart your terminal** and launch Hyprland to load your new configs.

---

## Updating

```bash
git -C ~/.dotfiles pull origin main
```

Then reload the relevant tool:

```bash
exec zsh            # Reload shell
hyprctl reload      # Reload Hyprland
killall waybar && waybar &   # Restart Waybar
# Wofi reads config fresh on each launch — no restart needed
# Neovim plugins auto-install on next launch
```

---

## Structure

Each tool has its own directory, symlinked to the standard XDG location:

| Directory | Symlink target |
|-----------|---------------|
| `nvim/` | `~/.config/nvim/` |
| `hypr/` | `~/.config/hypr/` |
| `waybar/` | `~/.config/waybar/` |
| `wofi/` | `~/.config/wofi/` |
| `mako/` | `~/.config/mako/` |
| `ghostty/` | `~/.config/ghostty/` |
| `tmux/` | `~/.config/tmux/` |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` |
| `greetd/` | `/etc/greetd/config.toml` |

---

## Notes

- Adjust symlink commands to match any changes to the directory structure.
- Hyprland config changes can prevent login if invalid — always test before committing.
- If your configs rely on specific plugins or tools, ensure those are installed as well.
