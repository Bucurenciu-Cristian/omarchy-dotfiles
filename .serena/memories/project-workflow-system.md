# Project Workflow System

A complete project context switching system built for Hyprland + tmux integration.

## Overview

This workflow synchronizes three layers:
1. **Hyprland scratchpads** - window organization per project
2. **Tmux sessions** - persistent terminal state per project  
3. **Directory mapping** - filesystem context per project

## Configuration

### projects.conf Format
Location: `~/.config/hypr/projects.conf`

```
# Format: project_name|tmux_session|dir1,dir2,dir3
city-fm|city-fm-website|/home/kicky/dev/city-fm/city-fm-website
sepa|supabase+fastapi|/home/kicky/dev/sepa/supabase+fastapi
flo_app|flux_app|/home/kicky/dev/flux_app
neptun|Script Neptun|/home/kicky/work/06-resources/Script Neptun
dotfiles|dotfiles|/home/kicky/dotfiles
```

Fields:
- `project_name` - identifier for keybindings
- `tmux_session` - name of tmux session to attach to
- `dirs` - comma-separated directory pool (first is default)

## Keybindings

| Keybinding | Action |
|------------|--------|
| **Ctrl+Alt+1-9** | Switch to project N + show scratchpad + switch tmux |
| **Ctrl+Alt+Shift+1-9** | Send window to project N scratchpad |
| **Super+B** | Toggle current project scratchpad |
| **Super+T** | Terminal attached to current project's tmux session |
| **Super+P** | Fuzzy project picker (walker) |

## Scripts

### project-scratchpad
Location: `~/.local/bin/project-scratchpad`

Commands:
- `toggle` - toggle current project's scratchpad
- `send` - send window to current project scratchpad
- `send-to <index>` - send window to specific project
- `set <index>` - set current project by index
- `current` - print current project name
- `tmux-session [name]` - get tmux session for project
- `dir [name]` - get first directory for project
- `dirs [name]` - get all directories for project
- `list` - list all project names

### project-scratchpad-select
Location: `~/.local/bin/project-scratchpad-select`

Called with project index (1-9). Does:
1. Sets current project in state file
2. Shows project indicator in waybar
3. **Switches tmux session** for all attached clients
4. Creates tmux session if it doesn't exist

### project-terminal
Location: `~/.local/bin/project-terminal`

Opens terminal attached to current project's tmux session:
- If session exists → attach
- If not → create in project directory

### project-picker
Location: `~/.local/bin/project-picker`

Walker-based CRUD interface:
- List and switch projects
- **➕ New project** - browse directories with walker, auto-suggest name
- **🗑️ Delete project** - with confirmation
- **✏️ Edit config** - open in editor

New project flow:
1. Browse directories (fd + walker fuzzy search)
2. Auto-suggest project name from directory basename
3. Auto-detect tmux session from existing sessions
4. Done - no manual tmux session prompt needed

### project-indicator
Location: `~/.local/bin/project-indicator`

Waybar module showing: `2: sepa (3)`
- Position number (matches Ctrl+Alt+N keybinding)
- Project name
- Window count in scratchpad
- Tooltip shows keybinding hint

## State Files

- `~/.local/state/hyprland/current-project` - current project name
- `~/.local/state/hyprland/project-indicator-visible` - waybar indicator visibility

## How It Works

### Switching Projects (Ctrl+Alt+N)
1. `project-scratchpad-select N` runs
2. Updates state file with new project
3. `tmux switch-client -t <session>` switches terminal
4. `project-scratchpad toggle` shows scratchpad

### Opening Terminal (Super+T)
1. `project-terminal` checks current project
2. Gets tmux session name from config
3. Attaches to existing session or creates new one

### Creating New Project (Super+P → New)
1. Walker shows directories from ~/dev, ~/projects, ~/work
2. Select directory with fuzzy search
3. Name auto-suggested from directory basename
4. Tmux session auto-detected from existing sessions
5. Added to projects.conf, switches to new project

## Special Workspaces

Projects use Hyprland special workspaces named:
`special:project:<project_name>`

Example: `special:project:sepa`

## Integration Points

- **Waybar**: custom/project module polls project-indicator
- **Walker**: used for project picker and directory browser
- **Tmux**: sessions managed per project, auto-switched
- **Ghostty**: terminal launched with tmux attachment

## Commits (2024-01-13)

1. `2ba749b` - Add quick project keybindings (Ctrl+Alt+1-9)
2. `5870c0e` - Sync terminal with project tmux sessions
3. `8cd17b6` - Auto-switch tmux session when changing projects
4. `63289e0` - Show project position in waybar indicator
5. `35fb442` - Add fzf directory browser for new projects
6. `133570f` - Use walker for directory browsing
7. `3f60eaa` - Simplify new project flow (remove tmux prompt)
