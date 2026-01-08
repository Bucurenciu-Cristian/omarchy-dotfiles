# Omarchy Dotfiles

Personal Omarchy configuration managed with GNU Stow.

## Contents

### Window Manager & Desktop
- **Hyprland** (`~/.config/hypr/`) - Window manager, keybindings, monitors, project scratchpads, workspace assignments
- **Waybar** (`~/.config/waybar/`) - Status bar with project indicator, voxtype status
- **Walker** (`~/.config/walker/`) - Application launcher

### Terminals
- **Ghostty** (`~/.config/ghostty/`) - Primary terminal
- **Alacritty** (`~/.config/alacritty/`) - Secondary terminal with theme integration
- **Kitty** (`~/.config/kitty/`) - Alternative terminal with remote control

### Editors & Dev Tools
- **Neovim** (`~/.config/nvim/`) - LazyVim config with Omarchy theme hotreload
- **Zed** (`~/.config/zed/`) - Editor settings with MCP Docker
- **Git** (`~/.config/git/`) - Git config and global ignore patterns
- **mise** (`~/.config/mise/`) - Pinned tool versions (go 1.23, node 22, python 3.12)

### Utilities
- **Tmux** (`~/.config/tmux/`) - Terminal multiplexer with TPM plugins
- **Tmux-Sessionizer** (`~/.local/bin/`) - Project session manager with fzf
- **Btop** (`~/.config/btop/`) - System monitor with vim keys
- **ostt** (`~/.config/ostt/`) - Speech-to-text (Deepgram)
- **Voxtype** (`~/.config/voxtype/`) - Voice typing

### System
- **1Password** (`~/.config/1Password/`) - SSH agent configuration
- **UWSM** (`~/.config/uwsm/`) - Session manager
- **Systemd** (`~/.config/systemd/user/`) - Battery conservation service
- **Udev** (`~/.config/udev/`) - Power profile switching rules
- **Shell** (`~/.bashrc`) - Bash config with aliases

## Installation on New Machine

```bash
# Install Stow
sudo pacman -S stow

# Clone and deploy
git clone https://github.com/Bucurenciu-Cristian/omarchy-dotfiles.git ~/dotfiles
cd ~/dotfiles/omarchy
stow -t ~ .
```

For complete system replication including themes, see **[docs/SYSTEM-REPLICATION.md](docs/SYSTEM-REPLICATION.md)**.

## Managing Configs

### Edit Files
Edit files in `~/dotfiles/omarchy/` or through symlinks (same thing):
```bash
vim ~/dotfiles/omarchy/.config/hypr/hyprland.conf
# OR
vim ~/.config/hypr/hyprland.conf  # Through symlink
```

### Commit Changes
```bash
cd ~/dotfiles
git add -u
git commit -m "Describe your changes"
git push
```

### Add New Config File
```bash
# Move file to dotfiles
mkdir -p ~/dotfiles/omarchy/.config/new-app
mv ~/.config/new-app/config ~/dotfiles/omarchy/.config/new-app/

# Restow to update symlinks
cd ~/dotfiles
stow -R omarchy

# Commit
git add .
git commit -m "Add new-app config"
```

## Useful Commands

| Command | Description |
|---------|-------------|
| `stow omarchy` | Create symlinks |
| `stow -D omarchy` | Remove symlinks |
| `stow -R omarchy` | Restow (update) |
| `stow -nv omarchy` | Dry run |

## Troubleshooting

### Stow Reports Conflict
File already exists - move it to dotfiles first:
```bash
mv ~/.config/problematic-file ~/dotfiles/omarchy/.config/
stow -R omarchy
```

### Restore from Backup
```bash
cd ~/dotfiles
stow -D omarchy
cp -r ~/config-backup-YYYYMMDD-HHMMSS/* ~/
```

### Check What Stow Would Do
```bash
cd ~/dotfiles
stow -nv omarchy  # Dry run with verbose output
```

## Tmux Setup

### Installing TPM (Tmux Plugin Manager)
The tmux config uses TPM for plugins. Install it with:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then inside tmux, press `Ctrl-a + I` (capital I) to install plugins.

### Tmux-Sessionizer
Quick project session switching with fzf:
- **Keybinding in tmux**: `Ctrl-a + f`
- **Shell command**: `tmux-sessionizer`
- **Config**: `~/.config/tmux-sessionizer/tmux-sessionizer.conf`

Configure search paths by editing the config file.

## Workspace Layout

Apps automatically open on their assigned workspace:

| Workspace | Purpose | Apps |
|-----------|---------|------|
| 1 | Browsers | Brave, Firefox, Chromium |
| 2 | AI | Claude, Perplexity |
| 3 | Terminals | Ghostty, TUIs (btop, lazydocker, hyprmon) |
| 4 | Editors | Cursor, Zed |
| 5 | Social | WhatsApp, Teams, Telegram |
| 6 | Productivity | Google Calendar, Notion |

Configured via `windowrulev2` in `~/.config/hypr/custom.conf`.

## System Info

- Distribution: Omarchy (Arch Linux + Hyprland)
- Dotfiles Manager: GNU Stow 2.4.1
- Shell: Bash
- Terminal Multiplexer: Tmux with TPM

---

Last Updated: 2026-01-09
