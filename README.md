# Omarchy Dotfiles

Personal Omarchy configuration managed with GNU Stow.

## Contents

- **Hyprland** (`~/.config/hypr/`) - Window manager configs
- **Waybar** (`~/.config/waybar/`) - Status bar
- **Walker** (`~/.config/walker/`) - Application launcher
- **Ghostty** (`~/.config/ghostty/`) - Terminal
- **UWSM** (`~/.config/uwsm/`) - Session manager
- **Shell** (`~/.bashrc`) - Bash config
- **XCompose** (`~/.XCompose`) - Custom compose sequences

## Installation on New Machine

```bash
# Install Stow
sudo pacman -S stow

# Clone and deploy
git clone https://github.com/Bucurenciu-Cristian/omarchy-dotfiles.git ~/dotfiles
cd ~/dotfiles
stow omarchy
```

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

## System Info

- Distribution: Omarchy (Arch Linux + Hyprland)
- Dotfiles Manager: GNU Stow 2.4.1
- Shell: Bash

---

Last Updated: 2025-12-02
