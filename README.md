# Dotfiles Setup

These are my personal configuration files for [Neovim](https://neovim.io/) and [zsh](https://www.zsh.org/) (using [Oh My Zsh](https://ohmyz.sh/)).

## Initial Setup (Fedora Linux)

1. **Clone this repository:**

    ```bash
    git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
    ```

2. **Symlink config files:**

    ```bash
    ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
    ln -sf ~/.dotfiles/nvim ~/.config/nvim
    ```

3. **Install Oh My Zsh (if needed):**

    ```bash
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

4. **Install Neovim (if needed):**

    ```bash
    sudo dnf install neovim
    ```

5. **Install plugins:**
    - For Neovim, follow plugin manager's install instructions (e.g., open nvim and run `:PlugInstall` or as documented in your config).

6. **Restart your terminal and Neovim** to load your new configs.

---

## Updating or Replacing an Existing Setup

1. **Backup your current configs if necessary.**
2. **Update the repository:**

    ```bash
    cd ~/.dotfiles
    git pull origin main
    ```

    Or, for a fresh clone:

    ```bash
    rm -rf ~/.dotfiles
    git clone git@github.com:baumace/.dotfiles.git ~/.dotfiles
    ```

3. **Re-run the symlink steps above** to ensure everything points to the latest configs.
4. **Restart your terminal and Neovim.**

---

## Notes

- Adjust the symlink commands above to match any changes you make to the directory structure.
- If your configs rely on specific plugins or tools, ensure those are installed as well.
