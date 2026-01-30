## Focus Monitor Helper Script

### Location
`~/.local/bin/focus-monitor-then-run`

### Purpose
Focuses a specific monitor before running a command. Used to ensure special workspaces (like messaging apps) open on the correct monitor.

### Usage
```bash
focus-monitor-then-run MONITOR_PATTERN COMMAND [args...]
```

### How It Works
1. Takes monitor pattern as first argument (can be monitor name like "DP-3" or description pattern like "LG")
2. Finds monitor by matching name OR description (case-insensitive regex)
3. If found, focuses that monitor via `hyprctl dispatch focusmonitor`
4. If not found (e.g., laptop-only mode), skips focusing
5. Executes the remaining command

### Example
```bash
# Focus LG monitor before opening Telegram
focus-monitor-then-run LG omarchy-launch-or-focus-special-workspace Telegram telegram omarchy-launch-webapp "https://web.telegram.org/"
```

### Why Needed
Special workspaces in Hyprland appear on the **currently focused monitor** when toggled, regardless of `workspace = special:name,monitor:X` rules. The `monitor:` rule only sets association, not where the workspace actually appears.

By focusing the target monitor first, the special workspace opens there.

### Graceful Fallback
When the target monitor isn't connected (laptop-only mode), the script simply runs the command without focusing - normal behavior preserved.

### Used By
- `Super+Shift+G` (WhatsApp) - focuses LG, opens `special:chat`
- `Super+E` (Telegram) - focuses LG, opens `special:telegram`

Both defined in `~/.config/hypr/custom.conf`.
