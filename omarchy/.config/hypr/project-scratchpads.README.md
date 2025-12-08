# Project Scratchpads for Hyprland

A workflow system for managing windows across multiple projects using Hyprland special workspaces.

## The Problem

Too many windows open, mixed across different projects. Hard to focus when city-fm windows appear while working on sepa.

## The Solution

Project-specific "drawers" (special workspaces) that slide in/out. Each project gets isolated storage for its windows.

## Keybindings

| Binding | Action |
|---------|--------|
| `Super B` | Toggle current project's scratchpad |
| `Super Alt B` | Send focused window to project scratchpad |
| `Super P` | Fuzzy project picker (walker) |
| `Super Alt Shift Ctrl B` + `1-9` | Quick project switch by number |

## Waybar Indicator

- Shows current project name in center bar (e.g., `city-fm (3)`)
- Number in parentheses = windows stashed in scratchpad
- Hidden by default, appears when switching projects
- Right-click to hide until next switch

## Configuration

Edit `~/.config/hypr/projects.conf`:

```
# Format: project_name or project_name:autostart_commands
# Autostart commands are semicolon-separated, only run if not already running

city-fm:zed ~/projects/city-fm;ghostty --working-directory=~/projects/city-fm
sepa:obsidian
test
```

### Autostart

When switching to a project, autostart commands run automatically (only if the app isn't already running).

## Files

| File | Purpose |
|------|---------|
| `projects.conf` | Project list and autostart config |
| `project-scratchpad` | Main dispatcher script |
| `project-scratchpad-select` | Handles project switching |
| `project-picker` | Walker fuzzy picker integration |
| `project-indicator` | Waybar module script |

## State

- Current project: `~/.local/state/hyprland/current-project`
- Indicator visibility: `~/.local/state/hyprland/project-indicator-visible`

## How It Works

1. Special workspaces are named `special:project:<name>`
2. State files track current project and indicator visibility
3. Walker picker lists projects from config, triggers switch
4. Waybar polls indicator script every second for display
