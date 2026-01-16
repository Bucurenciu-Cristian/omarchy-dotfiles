---
name: block-omarchy-edits
enabled: true
event: file
action: block
conditions:
  - field: file_path
    operator: contains
    pattern: .local/share/omarchy
---

**BLOCKED: Omarchy managed directory**

You attempted to edit a file in `~/.local/share/omarchy/`.

**Why this is blocked:**
- This directory is managed by git and updated automatically
- Any changes you make here will be **lost on the next omarchy update**
- This is explicitly prohibited in the global CLAUDE.md

**What to do instead:**
- Edit files in `~/.config/` for customizations
- For Hyprland: `~/.config/hypr/`
- For Waybar: `~/.config/waybar/`
- For Walker: `~/.config/walker/`
- For terminals: `~/.config/{alacritty,kitty,ghostty}/`

All omarchy components read from `~/.config/` for user customizations.
