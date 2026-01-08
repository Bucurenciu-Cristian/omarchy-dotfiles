# System Replication Guide

Quick steps to replicate this Omarchy setup on a fresh install.

## 1. Install Omarchy

Follow [omarchy.org](https://omarchy.org/) installation instructions.

## 2. Clone and Stow Dotfiles

```bash
cd ~
git clone <your-dotfiles-repo> dotfiles
cd dotfiles/omarchy
stow -t ~ .
```

## 3. Install Custom Themes

Run these commands to reinstall the custom themes:

```bash
omarchy-theme-install https://github.com/Wheel-Smith/awesome-omarchy
omarchy-theme-install https://github.com/HANCORE-linux/omarchy-blackgold-theme
omarchy-theme-install https://github.com/hoblin/omarchy-cobalt2-theme
omarchy-theme-install https://github.com/somerocketeer/omarchy-nagai-poolside-theme
omarchy-theme-install https://github.com/RiO7MAKK3R/omarchy-omacarchy-theme
omarchy-theme-install https://github.com/HANCORE-linux/omarchy-shadesofjade-theme
omarchy-theme-install https://github.com/tahayvr/omarchy-sunset-drive-theme
```

Then set your preferred theme:
```bash
omarchy-theme-set cobalt2
```

## 4. Additional Setup

### Tools via mise
The tool versions are pinned in `~/.config/mise/config.toml`. Run:
```bash
mise install
```

### 1Password SSH Agent
The SSH agent socket is configured in `.bashrc`. Ensure 1Password is installed and SSH agent is enabled in 1Password settings.

### Battery Conservation Service
Enable the systemd service:
```bash
systemctl --user enable battery-conservation.service
systemctl --user start battery-conservation.service
```

### Udev Rules (power profile switching)
Copy the udev rules to the system location:
```bash
sudo cp ~/.config/udev/90-power-profile-switch.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

## Stowed Configs Checklist

| Component | Config | Notes |
|-----------|--------|-------|
| Hyprland | `~/.config/hypr/*` | Window manager, keybindings, monitors |
| Waybar | `~/.config/waybar/*` | Status bar |
| Walker | `~/.config/walker/*` | App launcher |
| Ghostty | `~/.config/ghostty/config` | Terminal |
| Alacritty | `~/.config/alacritty/alacritty.toml` | Terminal |
| Kitty | `~/.config/kitty/kitty.conf` | Terminal |
| Btop | `~/.config/btop/btop.conf` | System monitor |
| Neovim | `~/.config/nvim/*` | LazyVim config |
| Git | `~/.config/git/*` | Git config + ignore |
| Starship | `~/.config/starship.toml` | Prompt |
| Tmux | `~/.config/tmux/*` | Terminal multiplexer |
| Zed | `~/.config/zed/*` | Editor |
| Mise | `~/.config/mise/*` | Tool version manager |
| 1Password | `~/.config/1Password/*` | SSH agent config |
| Voxtype | `~/.config/voxtype/*` | Voice typing |
| OSTT | `~/.config/ostt/*` | Speech to text |

## Custom Scripts

Located in `~/.local/bin/`:
- `omarchy-emergency-laptop` - Emergency laptop mode
- `omarchy-launch-or-focus-special-workspace` - Workspace management
- `omarchy-power-profile-switch` - Power profile automation
- `ostt-float` - Floating speech-to-text window
- `project-*` - Project scratchpad/picker scripts
- `tmux-sessionizer` - Tmux session management
- `toplex` - Custom utility
