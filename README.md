# .dotfiles

Personal configuration files for a lightweight coding setup in WSL (Ubuntu), including [Neovim](https://neovim.io/), [zsh](https://www.zsh.org/), and [tmux](https://github.com/tmux/tmux).

Neovim uses the Catppuccin Macchiato color theme.

---

## Initial Setup (WSL / Ubuntu)

1. **Clone this repository:**

    ```bash
    git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
    ```

2. **Install required packages:**

    ```bash
    sudo apt install -y zsh tmux
    ```

    Neovim on Ubuntu's apt repos is typically too old for this config (it uses `vim.pack`,
    which needs Neovim 0.12+). Install the latest release directly instead:

    ```bash
    mkdir -p ~/.local/share ~/.local/bin
    curl -sLO --output-dir ~/.local/share \
      https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzf ~/.local/share/nvim-linux-x86_64.tar.gz -C ~/.local/share
    rm ~/.local/share/nvim-linux-x86_64.tar.gz
    ln -sf ~/.local/share/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
    ```

3. **Symlink config files:**

    ```bash
    ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
    ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
    ln -sf ~/.dotfiles/nvim ~/.config/nvim
    ln -sf ~/.dotfiles/tmux ~/.config/tmux
    ```

4. **Install Oh My Zsh (if needed):**

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

5. **Set zsh as your default shell:**

    ```bash
    chsh -s $(which zsh)
    ```

6. **Restart your terminal.** New shells attach straight into a shared tmux session
   (see `zsh/.zshrc`); Neovim plugins auto-install via `vim.pack` on first launch.

---

## Updating

```bash
git -C ~/.dotfiles pull origin main
```

Then reload the relevant tool:

```bash
exec zsh             # Reload shell (re-attaches to tmux)
tmux source-file ~/.config/tmux/tmux.conf   # Reload tmux config in place
# Neovim plugins/config are read fresh on next launch
```

---

## Structure

Each tool has its own directory, symlinked to the standard XDG location:

| Directory | Symlink target |
|-----------|---------------|
| `nvim/` | `~/.config/nvim/` |
| `tmux/` | `~/.config/tmux/` |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` |

---

## Notes

- `zsh/.zshrc` auto-attaches every new interactive shell to a shared tmux session named
  `main` (`tmux new-session -A -s main`), so opening a new WSL terminal drops you straight
  into tmux. Multiple terminal windows share and mirror the same session.
- `zsh/.zprofile` loads SSH keys from `~/.ssh/` into the systemd-managed `ssh-agent`
  (`systemctl --user status ssh-agent.socket`) once per login shell.
- If your configs rely on specific plugins or tools, ensure those are installed as well.
