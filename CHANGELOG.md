# Changelog

## 2025-12-03

- **hyprdynamicmonitors v2** - Simplified to 2 files: single `external.go.tmpl` template + `laptop.conf` fallback
  - Per-profile variables for resolution, refresh rate, scale
  - Fallback profile for automatic laptop-only mode
  - Regex matching on monitor descriptions
- **monitors alias** - Updated to use SIGHUP signal for faster reload

## 2025-12-02

- **tmux** - Configuration with vim-style bindings, tmux-sessionizer for project switching
- **Initial setup** - Omarchy dotfiles with hypr, bash, uwsm configs
