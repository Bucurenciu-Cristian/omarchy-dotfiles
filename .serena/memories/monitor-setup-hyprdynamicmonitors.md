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
| lg-asus-iiyama | LG\|RGT + VG34VQ + PL3481WQ | Triple: LG vertical left, stacked ultrawides right |
| samsung-asus | Samsung + VG34VQ | Dual external: Samsung left, ASUS right |
| asus-iiyama | VG34VQ + PL3481WQ | Dual external: ASUS top, iiyama below |
| samsung-iiyama | Samsung + PL3481WQ | Dual external |
| iiyama | PL3481WQ | Single ultrawide |
| asus | VG34VQ | Single ultrawide |
| arzopa | ARZOPA | Portable monitor |
| samsung | Samsung | Single Samsung |
| laptop | (fallback) | No external connected |

**Note:** LG monitor may report as "RGT 0x5211" due to EDID quirks - regex `LG|RGT` handles both.

## Triple Monitor Setup (lg-asus-iiyama)

Layout:
```
┌─────────┐ ┌─────────────────────────────────┐
│         │ │           ASUS                  │
│   LG    │ │       3440x1440 @ 100Hz         │
│  1080x  │ │       workspaces 1-5            │
│  2560   │ ├─────────────────────────────────┤
│ rotated │ │          iiyama                 │
│  90°    │ │       3440x1440 @ 180Hz         │
│         │ │       workspaces 6-10           │
│ special │ │                                 │
│ :chat   │ └─────────────────────────────────┘
│:telegram│
│ :movies │
└─────────┘
```

- LG: 2560x1080 rotated (transform 1), position 0x0
- ASUS: 3440x1440, scale 1.25, position 1080x128 (centered with stacked height)
- iiyama: 3440x1440 @ 180Hz, scale 1.25, position 1080x1280
- Laptop: disabled
- Special workspaces on LG: `movies`, `chat` (WhatsApp), `telegram`

### Messaging Apps on LG

Keybindings use `focus-monitor-then-run` wrapper to focus LG before opening:
- `Super+Shift+G`: WhatsApp (special:chat)
- `Super+E`: Telegram (special:telegram)

The wrapper (`~/.local/bin/focus-monitor-then-run`) finds monitor by description pattern ("LG") and focuses it before running command. Falls back gracefully when LG not connected.

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
