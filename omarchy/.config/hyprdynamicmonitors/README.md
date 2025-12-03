# HyprDynamicMonitors Configuration

Automatic monitor profile switching for Hyprland using [hyprdynamicmonitors](https://hyprdynamicmonitors.filipmikina.com/).

## Monitors

| Tag | Monitor | Resolution | Notes |
|-----|---------|------------|-------|
| laptop | California Institute of Technology 0x1319 | 2880x1920 | Framework 13 built-in, scale 2 |
| iiyama | Iiyama North America PL3481WQ | 3440x1440@180Hz | Primary home monitor, scale 1.25 |
| asus | ASUSTek COMPUTER INC VG34VQEL1A | 3440x1440@100Hz | Secondary ultrawide |
| lg | LG Electronics LG ULTRAWIDE | 2560x1080 | Portrait mode (270 rotation) |
| arzopa | ARZOPA | 1920x1080 | Portable monitor |
| samsung | Samsung | 1920x1080@120Hz | TV |

## Profiles (Priority Order)

Profiles are alphabetically prefixed for priority (first match wins):

1. **a-home-iiyama-primary** - Laptop + LG + Iiyama connected, only Iiyama active
2. **b-triple** - LG + Iiyama + ASUS triple monitor setup
3. **c-dual-iiyama** - Laptop + Iiyama, only Iiyama active
4. **d-dual-asus** - Laptop + ASUS, only ASUS active
5. **e-dual-lg** - Laptop + LG portrait layout
6. **f-iiyama** - Iiyama only
7. **g-asus** - ASUS only
8. **h-lg** - LG portrait only
9. **i-arzopa** - Laptop + ARZOPA portable
10. **j-samsung** - Samsung TV only
11. **z-laptop** - Laptop only (fallback)

## Power-Aware Refresh Rates

Templates use `{{if isOnAC}}` conditionals for power-aware refresh rates:
- On AC: Full refresh rate (180Hz for Iiyama, 100Hz for ASUS, etc.)
- On battery: 60Hz to save power

## Running as Systemd Service

```bash
# Enable services
systemctl --user enable --now hyprdynamicmonitors.service
systemctl --user enable hyprdynamicmonitors-prepare.service

# Check status
systemctl --user status hyprdynamicmonitors

# View logs
journalctl --user -u hyprdynamicmonitors -f
```

## Manual Refresh

When switching between external monitors, the daemon may not detect the new monitor if the current profile has it disabled. Use the alias to force detection:

```bash
monitors  # alias for: hyprdynamicmonitors run --run-once
```
