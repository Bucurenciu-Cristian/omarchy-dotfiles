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

. "$HOME/.local/share/../bin/env"
. "$HOME/.cargo/env"
export PATH=$HOME/.local/bin:$PATH

# 1Password SSH agent
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

export PATH="/home/kicky/.cache/.bun/bin:$PATH"
alias superset='/home/kicky/dev/superset/apps/desktop/release/superset-0.0.3-x86_64.AppImage'
alias claude="claude --dangerously-skip-permissions"
alias suspend="systemctl suspend"

# opcode alias
alias opcode="/home/kicky/Work/tries/2025-12-13-opcode/opcode/src-tauri/target/release/opcode"

# pnpm
export PNPM_HOME="/home/kicky/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
