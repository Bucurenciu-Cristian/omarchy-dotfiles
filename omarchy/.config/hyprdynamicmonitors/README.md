# HyprDynamicMonitors Configuration

Automatic monitor profile switching for Hyprland using [hyprdynamicmonitors](https://hyprdynamicmonitors.filipmikina.com/).

## Architecture

```
~/.config/hyprdynamicmonitors/
├── config.toml          # Profile definitions with per-profile variables
└── hyprconfigs/
    ├── laptop.conf      # Static fallback (no external connected)
    └── external.go.tmpl # Single template for all external monitors
```

## Profiles

| Profile | Match Regex | Resolution | AC Hz | Battery Hz | Scale |
|---------|-------------|------------|-------|------------|-------|
| iiyama | PL3481WQ | 3440x1440 | 180 | 60 | 1.25 |
| asus | VG34VQ | 3440x1440 | 100 | 60 | 1.25 |
| arzopa | ARZOPA | 1920x1080 | 60 | 60 | 1.0 |
| samsung | Samsung | 1920x1080 | 120 | 60 | 1.0 |
| laptop | (fallback) | 2880x1920 | 60 | 60 | 2.0 |

## Behavior

- **External connected** → Profile matched by regex, laptop disabled, all workspaces on external
- **No external** → Fallback to laptop profile
- **Power state change** → Refresh rate adjusts (AC = high, battery = 60Hz)

## Commands

```bash
# Force re-detection (when hot-swapping monitors)
monitors

# Service management
systemctl --user status hyprdynamicmonitors
systemctl --user restart hyprdynamicmonitors
journalctl --user -u hyprdynamicmonitors -f
```

## Adding a New Monitor

1. Get the description: `hyprctl monitors`
2. Add profile to `config.toml`:
```toml
[profiles.mymonitor]
config_file = "hyprconfigs/external.go.tmpl"
config_file_type = "template"
[profiles.mymonitor.static_template_values]
res = "1920x1080"
refresh_ac = "144"
refresh_bat = "60"
scale = "1.0"
[[profiles.mymonitor.conditions.required_monitors]]
description = "PARTIAL_MATCH"
match_description_using_regex = true
monitor_tag = "external"
```
3. Restart service: `systemctl --user restart hyprdynamicmonitors`
