# System Migration Checklist

Comprehensive checklist for migrating to a new Omarchy system, based on the January 2026 migration.

## Pre-Migration: What to Backup

### From Old System
- `~/dotfiles/` - stow-managed configs
- `~/dev/**/.env*` - project environment files (contain secrets, NOT in git)
- `~/.config/uwsm/env` - session environment (PATH additions)
- `~/.config/hypr/projects.conf` - project scratchpad config
- `~/.ssh/config` - SSH host aliases for 1Password

### What's Safe to Clone Fresh
- Git repositories (can re-clone, but copying preserves uncommitted work)
- Cargo packages (reinstall with `cargo install`)

## Post-Migration Checklist

### 1. Run Stow
```bash
cd ~/dotfiles && stow omarchy
```

### 2. Run Setup Scripts
```bash
~/dotfiles/scripts/setup-claude.sh
~/dotfiles/scripts/clone-repos.sh
```

### 3. Enable Services
```bash
systemctl --user enable --now hyprdynamicmonitors
```

### 4. Create State Directories
```bash
mkdir -p ~/.local/state/hyprland
```
State files are runtime data, not config—they're created by scripts but the directory must exist.

### 5. Fix PATH in uwsm
Edit `~/.config/uwsm/env`:
```bash
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$OMARCHY_PATH/bin:$PATH
```
**Requires logout/login to take effect.**

### 6. Copy .env Files
```bash
# If old system is mounted at ~/old-system
find ~/old-system/dev -name ".env*" -type f | while read src; do
  rel="${src#$HOME/old-system/dev/}"
  dest="$HOME/dev/$rel"
  destdir=$(dirname "$dest")
  [[ -d "$destdir" ]] && [[ ! -f "$dest" ]] && cp "$src" "$dest"
done
```

### 7. Verify Keybindings Work
Test these after login:
- `Super+P` - Project picker
- `Super+T` - Project terminal
- `Super+/` - 1Password
- `Ctrl+Alt+1-9` - Quick project switch

## Common Issues & Fixes

### Scripts Not Found from Keybindings
**Symptom**: Keybinding does nothing, but script works in terminal.
**Cause**: `~/.local/bin` not in uwsm session PATH.
**Fix**: Add to `~/.config/uwsm/env` and re-login.
**Workaround**: Use full paths in bindings: `$HOME/.local/bin/script-name`

### Waybar Project Indicator Empty
**Cause**: State directory or current-project file missing.
**Fix**: 
```bash
mkdir -p ~/.local/state/hyprland
echo "your-project" > ~/.local/state/hyprland/current-project
omarchy-restart-waybar
```

### 1Password Not Toggling
**Fix**: Use `1password --toggle` instead of launching new instance.

### hyprdynamicmonitors Not Running
**Fix**: `systemctl --user enable --now hyprdynamicmonitors`

## Scripts That Need Full Paths

When `~/.local/bin` isn't in PATH, these scripts call each other and fail:
- `project-picker` → `project-scratchpad-select`
- `project-terminal` → `project-scratchpad`
- `project-scratchpad-select` → `project-scratchpad`

Either fix PATH in uwsm/env OR update scripts to use `$HOME/.local/bin/` prefix.

## Mounting Old System

If old system is on a separate partition/drive:
```bash
# Create convenient symlink
ln -s /run/media/user/partition/@home/user ~/old-system
```

## Files NOT to Migrate

- `~/.config/environment.d/*.conf` - Omarchy uses uwsm, not raw systemd
- `node_modules/` - Reinstall with npm/pnpm
- `.cache/` directories - Will be regenerated
