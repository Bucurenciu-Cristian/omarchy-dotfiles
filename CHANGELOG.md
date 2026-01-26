# Changelog

## 2026-01-26

- **Hyprland keybinds** - Reorganize special workspace shortcuts
  - SUPER+E: Telegram web app (was Cursor)
  - SUPER+I: Cursor editor (new binding)
  - SUPER+Z: Use `zeditor` command for Zed
  - Movies workspace: Add SHIFT modifier (SUPER+SHIFT+V)
- **hyprdynamicmonitors** - ASUS profile scale changed to 1.0 (was 1.25)
- **1Password** - SSH agent settings update
  - Enable filesystem bookmark sync
  - Set Ghostty as default terminal

## 2026-01-25

- **hyprdynamicmonitors** - Add 10-bit color depth support
  - New `bitdepth` config option for monitor profiles
  - External template: conditional bitdepth rendering
  - Samsung-ASUS and Samsung-iiyama profiles: hardcoded 10-bit for Samsung display

## 2026-01-23

- **direnv** - Add direnv integration for automatic environment loading
  - mise config: `direnv = "latest"`
  - bashrc: `eval "$(direnv hook bash)"`
- **git worktree** - Streamlined worktree workflow
  - `git wta` alias and `gwta` shell alias for `git-worktree-add`
- **Claude Code plugins** - Enable ralph-loop and ralph-specum for spec-driven development

## 2026-01-22 (night)

- **bashrc** - Add dotfiles sync aliases
  - `dotfiles-sync` / `ds` - Start sync service and follow logs

## 2026-01-22 (evening)

- **Claude Code Hooks** - Auto-format files on Write/Edit
  - New `post-write-format.sh` hook formats Python (ruff/black), Go, JS/TS (prettier/eslint), JSON, YAML, Lua, Rust, and shell scripts
  - Runs automatically after Claude creates or edits files
- **Claude Code Permissions** - Expanded allowlist
  - Tools: uv, uvx, pnpm, cargo, rustc, gh, systemctl, journalctl, stow
  - All superpowers skills pre-approved
  - WebFetch for common documentation sites (Arch Wiki, Hyprland, Payload, Supabase, Next.js, etc.)
  - Added superpowers-dev marketplace (disabled by default)
- **Project Picker** - Major workflow improvements
  - Project status: active (●) vs pending (○) with toggle action
  - Active projects shown first, pending grouped below
  - "No folder yet" option for projects without directories
  - Custom path entry option in directory browser
  - Directory fallback to `~/dev` when path doesn't exist
- **Neovim Plugins** - Update lazy-lock.json (gitsigns, grug-far, neo-tree, treesitter, lspconfig updates; added cobalt2/colorbuddy themes)

## 2026-01-22

- **hyprdynamicmonitors** - Add ASUS + iiyama dual ultrawide profile
  - New `asus-iiyama` profile with ASUS on top, iiyama below
  - Template with stacked positioning and dynamic refresh rates
- **tmux** - Fix continuum auto-save with pane-focus-in hook (PowerKit workaround)
- **Claude Code** - Remove ultrathink hook, add `claude` full alias
- **laptop.conf** - Document all scale options for 2880x1920 panel
- **Serena** - Add Claude Code setup enhancements memory
- **Automation** - Add headless Claude dotfiles sync system
  - `dotfiles-auto-sync` script with changelog updates, commit, push
  - `tmux-auto-save` script for session persistence
  - Systemd timers: daily dotfiles sync (9 PM), tmux save (15 min)
  - Logging to `~/.local/share/dotfiles-sync/sync.log`

## 2026-01-20

- **Claude Code Commands** - Three new slash commands
  - `/careful-review` - Fresh eyes code review using subagent
  - `/find-missing-tests` - Audit and create GitHub issues for missing tests
  - `/session-summary` - Generate session recap with cost and efficiency insights
- **Claude Code Skills** - Three workflow automation skills
  - `releasing-software` - Pre-flight checklist prevents retag-four-times pattern
  - `production-readiness` - Local dev setup, migrations, environment switching
  - `client-feedback-chat` - WhatsApp/messaging tracking in chat.md
- **Claude Code Docs** - Four reference documents
  - `python.md` - uv preferences
  - `docker-uv.md` - Multistage Dockerfile patterns
  - `source-control.md` - Commit message standards
  - `using-uv.md` - Complete uv field manual
- **Git Hooks** - Automated commit workflow
  - `pre-commit` - Runs pre-commit framework if configured
  - `prepare-commit-msg` - LLM-generated commit messages with spinner animation
- **Shell & Environment** - Extended bashrc, mise pnpm, starship prompt updates
- **Omarchy** - Post-update hook for system maintenance
- **Serena** - Migration checklist and environment variables memories

## 2026-01-09

- **System Replication Guide** - Complete documentation for reproducing this setup
  - Theme installation commands for all 7 custom themes
  - Stow deployment instructions
  - Additional setup steps (mise, 1Password, systemd, udev)
- **Terminal configs added to dotfiles**
  - Alacritty with theme integration, font size 9, padding
  - Kitty with remote control, powerline tabs, vim-style copy/paste
  - Btop with vim keys, braille graphs, battery monitoring
- **Git ignore** - Global ignore for `.claude/settings.local.json`

## 2026-01-08

- **Gitignore** - Exclude external Claude skill repos (with source URLs for reference)
- **monitors.conf** - Stop tracking auto-generated file from hyprdynamicmonitors

## 2026-01-07

- **Voxtype** - Voice typing integration with waybar status indicator
- **ostt** - Enable smart_format for better transcription
- **mise** - Pin tool versions (go 1.23, node 22, python 3.12)

## 2025-12-29

- **Idle timeout** - Reduce lock timeout to 151 seconds
- **1Password SSH Agent** - Add SSH_AUTH_SOCK to bashrc
- **Voxtype + 1Password** - Initial configs and SSH agent setup

## 2025-12-22

- **Power management**
  - Battery conservation systemd service
  - Udev rules for automatic power profile switching
  - Power profile switch script

## 2025-12-21

- **hyprsession** - Session persistence for Hyprland
  - Saves window layout/workspaces, restores on restart or reboot
  - Auto-saves every 2 minutes (`--save-interval 120`)
  - `Super F12` manual save before logout/reboot
  - Session stored in `~/.local/share/hyprsession/`
  - To disable: comment out `exec_once` in `custom.conf`, run `pkill hyprsession`

## 2025-12-11

- **Workspace Assignments** - Automatic window-to-workspace routing
  - Workspace 1: Browsers (Brave, Firefox, Chromium)
  - Workspace 2: AI (Claude PWA, Perplexity PWA)
  - Workspace 3: Terminals & TUIs (Ghostty, btop, lazydocker, hyprmon)
  - Workspace 4: Editors (Cursor, Zed)
  - Workspace 5: Social (WhatsApp, Teams, Telegram)
  - Workspace 6: Productivity (Google Calendar, Notion)
- **Hyprland cleanup** - hyprfocus plugin, window rounding, 16:9 aspect ratio
- **Waybar** - Reduced from 10 to 5 persistent workspaces
- **project-scratchpad** - Removed logging feature

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
