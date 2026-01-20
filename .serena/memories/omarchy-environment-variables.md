# Omarchy Environment Variables

## Overview

Omarchy uses **uwsm** (Universal Wayland Session Manager) to start Hyprland, not raw systemd. This affects how session-wide environment variables are set.

## Correct Location for PATH Modifications

**Use `~/.config/uwsm/env`** - NOT `~/.config/environment.d/`

```bash
# ~/.config/uwsm/env
export OMARCHY_PATH=$HOME/.local/share/omarchy
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$OMARCHY_PATH/bin:$PATH
```

Changes require a **logout/login** to take effect.

## Environment File Hierarchy

| File | Purpose | When to Use |
|------|---------|-------------|
| `~/.config/uwsm/env` | Session-wide environment | PATH, custom exports needed by all apps |
| `~/.config/uwsm/default` | Default terminal/editor | TERMINAL, EDITOR variables |
| `~/.config/hypr/envs.conf` | Hyprland-specific | Wayland flags, cursor size, XDG vars |

## Why This Matters

When Hyprland keybindings execute commands via `exec`, they inherit the PATH from the uwsm session environment. If scripts in `~/.local/bin` aren't found, it's because that directory wasn't in the uwsm env PATH.

## Common Issue: Scripts Not Found from Keybindings

**Symptom**: Keybindings like `exec, my-script` fail silently, but running `my-script` in terminal works.

**Cause**: `~/.local/bin` not in uwsm session PATH.

**Fix**: Add to `~/.config/uwsm/env`:
```bash
export PATH=$HOME/.local/bin:$PATH
```

Then logout/login.

## Quick Workaround (No Restart)

Use full paths in Hyprland bindings:
```
bindd = SUPER, P, My script, exec, $HOME/.local/bin/my-script
```

Or import PATH to current session:
```bash
/usr/bin/systemctl --user import-environment PATH
```

## Do NOT Use

- `~/.config/environment.d/` - This is for pure systemd sessions, uwsm doesn't read it
- `env =` in Hyprland config for PATH - Only affects Hyprland process, not exec'd commands
