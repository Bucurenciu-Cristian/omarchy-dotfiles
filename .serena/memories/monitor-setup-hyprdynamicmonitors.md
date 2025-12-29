# Monitor Setup with HyprDynamicMonitors

## Overview

Monitor configuration uses **hyprdynamicmonitors** - a daemon that automatically switches Hyprland monitor profiles based on connected displays. It detects monitors by description regex and applies the matching profile.

## Architecture

```
~/.config/hyprdynamicmonitors/
├── config.toml              # Profile definitions with conditions
└── hyprconfigs/
    ├── laptop.conf          # Fallback when no external connected
    ├── external.go.tmpl     # Template for single external monitor
    └── samsung-asus.go.tmpl # Template for dual external (Samsung + ASUS)
```

Output is written to: `~/.config/hypr/monitors.conf` (sourced by Hyprland)

## Key Concepts

### Profile Matching
- Profiles checked top-to-bottom, first match wins
- Each profile has `conditions.required_monitors` - ALL must be present
- Monitors matched by `description` regex (from `hyprctl monitors`)
- `monitor_tag` labels monitors for use in templates (e.g., "external", "samsung", "asus")

### Templates (Go templates)
- Access monitors by tag: `{{$ext := index .MonitorsByTag "external"}}`
- Monitor properties: `{{$ext.Name}}` (DP-4, HDMI-A-1), `{{$ext.Description}}`
- Power state: `{{.PowerState}}`, `{{if isOnAC}}...{{end}}`
- Static values from config: `{{.res}}`, `{{.refresh_ac}}`, etc.

## Current Profiles

| Profile | Condition | Use Case |
|---------|-----------|----------|
| samsung-asus | Samsung + VG34VQ | Dual external: Samsung left, ASUS right |
| iiyama | PL3481WQ | Single ultrawide |
| asus | VG34VQ | Single ultrawide |
| arzopa | ARZOPA | Portable monitor |
| samsung | Samsung | Single Samsung |
| laptop | (fallback) | No external connected |

## Dual Monitor Setup (samsung-asus)

Layout:
```
┌─────────────────┬─────────────────────────────────┐
│    Samsung      │           ASUS                  │
│  1920x1080      │       3440x1440                 │
│  HDMI (left)    │       DP (right)                │
│ special:movies  │     workspaces 1-10             │
└─────────────────┴─────────────────────────────────┘
```

- Samsung: 1920x1080 @ 120Hz (AC) / 60Hz (battery), position 0x0
- ASUS: 3440x1440 @ 100Hz (AC) / 60Hz (battery), scale 1.25, position 1920x0
- Laptop (eDP-1): disabled
- Movies workspace on Samsung: `Super+V` toggle, `Super+Alt+V` send window

## Commands

```bash
# Check current monitors
hyprctl monitors

# Force re-detection
monitors

# Service management
systemctl --user status hyprdynamicmonitors
systemctl --user restart hyprdynamicmonitors
journalctl --user -u hyprdynamicmonitors -f
```

## Adding New Monitor Profiles

1. Get description: `hyprctl monitors`
2. Add profile to `config.toml` with regex match
3. Use existing template or create new one
4. For multi-monitor: add multiple `[[profiles.name.conditions.required_monitors]]` with different tags
5. Restart: `systemctl --user restart hyprdynamicmonitors`

## Related Files

- `~/.config/hypr/custom.conf` - Keybindings including movies workspace toggles
- `~/.config/hyprdynamicmonitors/README.md` - Quick reference
