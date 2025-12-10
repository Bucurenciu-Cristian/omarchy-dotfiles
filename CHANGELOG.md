# Changelog

## 2025-12-10

- **Neovim** - Full LazyVim configuration with custom plugins
  - Theme hotreload for Omarchy theme switching
  - Animated scrolling disabled, transparency support
  - Custom keymaps and autocmds
- **ostt** - Speech-to-text integration
  - Deepgram-powered transcription config
  - Hyprland floating window launcher (`Super R`)
  - Alacritty float styling for minimal overlay
- **Zed** - Editor settings with MCP Docker integration
- **mise** - Development tool version management (bun, node, python)
- **Hyprland updates** - ostt keybind, project scratchpad logging

## 2025-12-08

- **Project Scratchpads** - Window management system for multi-project workflows
  - Project-specific special workspaces as "drawers" for stashing windows
  - `Super B` toggle scratchpad, `Super Alt B` send window, `Super P` fuzzy picker
  - Waybar indicator with window count, auto-hide/show on project switch
  - Per-project autostart commands in `projects.conf`
  - Walker integration for fuzzy project selection

## 2025-12-03

- **hyprdynamicmonitors v2** - Simplified to 2 files: single `external.go.tmpl` template + `laptop.conf` fallback
  - Per-profile variables for resolution, refresh rate, scale
  - Fallback profile for automatic laptop-only mode
  - Regex matching on monitor descriptions
- **monitors alias** - Updated to use SIGHUP signal for faster reload

## 2025-12-02

- **tmux** - Configuration with vim-style bindings, tmux-sessionizer for project switching
- **Initial setup** - Omarchy dotfiles with hypr, bash, uwsm configs
