# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Refresh monitor detection (useful when switching external monitors)
alias monitors='kill -SIGHUP $(pidof hyprdynamicmonitors) 2>/dev/null || hyprdynamicmonitors run --run-once'

# Note: PATH is set in ~/.config/uwsm/env for session-wide availability
# ~/.local/bin and ~/.cargo/bin are already in PATH from uwsm

# 1Password SSH agent
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

export PATH="/home/kicky/.cache/.bun/bin:$PATH"
alias superset='/home/kicky/dev/superset/apps/desktop/release/superset-0.0.3-x86_64.AppImage'
alias suspend="systemctl suspend"

# Power profile toggle (power-saver ↔ performance)
power() {
    local current=$(powerprofilesctl get)
    case "${1:-toggle}" in
        s|saver)  powerprofilesctl set power-saver ;;
        p|perf)   powerprofilesctl set performance ;;
        b|bal)    powerprofilesctl set balanced ;;
        toggle|t) [[ "$current" == "power-saver" ]] && powerprofilesctl set performance || powerprofilesctl set power-saver ;;
        *)        powerprofilesctl ;;
    esac
    echo "→ $(powerprofilesctl get)"
}

# YOLO aliases - skip permission prompts (use with care)
alias cc='claude --dangerously-skip-permissions'
alias cc-start='claude --dangerously-skip-permissions'
alias cc-continue='claude --dangerously-skip-permissions --continue'
alias codex-start='codex --dangerously-bypass-approvals-and-sandbox'
alias codex-continue='codex --dangerously-bypass-approvals-and-sandbox --continue'

# opcode alias
alias opcode="/home/kicky/Work/tries/2025-12-13-opcode/opcode/src-tauri/target/release/opcode"

# pnpm
export PNPM_HOME="/home/kicky/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Neptune sauna booking script
neptun() {
    local project_dir="$HOME/dev/neptun"
    if [[ $# -eq 0 ]]; then
        echo "Usage: neptun <command>"
        echo ""
        echo "Commands:"
        echo "  run           - Interactive booking (windowed)"
        echo "  run-headless  - Interactive booking (headless)"
        echo "  status        - View current appointments"
        echo "  delete        - Delete appointments"
        echo "  collect       - Collect availability data"
        echo "  db-status     - Show database statistics"
        return 0
    fi
    make -C "$project_dir" "$@"
}

# ============================================
# MODERN CLI TOOLS (mise-managed)
# ============================================
# Replace default commands with better alternatives
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias la='eza -a --icons'
alias lt='eza --tree --icons --level=2'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'

# Keep originals accessible
alias ols='/usr/bin/ls'
alias ocat='/usr/bin/cat'
alias ogrep='/usr/bin/grep'
alias ofind='/usr/bin/find'

# Handy shortcuts
alias lg='lazygit'
alias diff='delta'
alias zed='zeditor'

# ============================================
# FZF CONFIGURATION
# ============================================
# Use fd for faster file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Better fzf appearance
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'

# Load fzf keybindings (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
eval "$(fzf --bash)"

