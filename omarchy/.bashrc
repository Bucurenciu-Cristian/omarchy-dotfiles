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

export PATH="/home/kicky/.cache/.bun/bin:$PATH"
alias superset='/home/kicky/dev/superset/apps/desktop/release/superset-0.0.3-x86_64.AppImage'
