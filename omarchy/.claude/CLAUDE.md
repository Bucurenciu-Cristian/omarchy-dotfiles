# CLAUDE.md

## System: Omarchy (Arch Linux + Hyprland)

This is an [Omarchy](https://omarchy.org/) system - a modern Arch Linux distribution with Hyprland compositor.

### Critical Safety Rules

**NEVER modify `~/.local/share/omarchy/`** - managed by git, changes lost on update.

**Safe to edit:** `~/.config/` for all customizations.

### Key Config Locations

| Component | Config Path |
|-----------|-------------|
| Hyprland (WM) | `~/.config/hypr/` |
| Waybar (bar) | `~/.config/waybar/` |
| Walker (launcher) | `~/.config/walker/` |
| Terminals | `~/.config/{alacritty,kitty,ghostty}/` |

### Reload Behavior

- **Hyprland**: Auto-reloads on config save
- **Waybar**: MUST run `omarchy-restart-waybar` after changes
- **Walker**: MUST run `omarchy-restart-walker` after changes

### Common Commands

```bash
omarchy-theme-set <name>     # Apply theme
omarchy-restart-waybar       # Restart waybar after config changes
omarchy-refresh-<app>        # Reset config to defaults (backs up first)
omarchy-debug --no-sudo --print  # Debug info (always use these flags)
```

### Before Editing Configs

1. Read the current config first
2. For keybindings: check `omarchy-menu-keybindings --print` and add `unbind` before rebinding existing keys
3. For window rules: fetch current syntax from Hyprland wiki (syntax changes frequently)

### Dotfiles Location

This system uses stow-managed dotfiles at `~/dotfiles/omarchy/` which are symlinked to `~/.config/`.
