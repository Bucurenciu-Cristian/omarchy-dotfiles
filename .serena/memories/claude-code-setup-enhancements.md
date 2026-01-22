## Context

Session on 2026-01-20: Enhanced Claude Code setup by borrowing ideas from Harper Reed's dotfiles.

## What Was Added

### ~/.claude/ Structure

**Docs** (referenced via @~/.claude/docs/...):
- `python.md` - uv preferences
- `source-control.md` - commit message standards
- `using-uv.md` - uv field manual
- `docker-uv.md` - multistage Docker + uv

**Commands**:
- `/load` - Load project context with Serena MCP
- `/save` - Save session context with Serena MCP
- `/careful-review` - Fresh eyes code review with subagent
- `/session-summary` - Create session documentation
- `/find-missing-tests` - Audit test coverage, create GH issues

**Skills**:
- `releasing-software` - Pre-release checklist to avoid retag failures

**Hooks**:
- `append_ultrathink.py` - End prompts with `-u` for deep thinking mode

### Git Hooks (~/.dotfiles/.git_hooks/)

- `pre-commit` - Runs pre-commit framework if configured
- `prepare-commit-msg` - LLM-powered commit message generation

Prompts at `~/.config/prompts/`:
- `commit-system-prompt.txt`
- `pr-title-prompt.txt`
- `pr-body-prompt.txt`

Global hooks path: `git config --global core.hooksPath ~/dotfiles/.git_hooks`

### Bash Aliases (YOLO mode)

```bash
alias cc='claude --dangerously-skip-permissions'
alias cc-start='claude --dangerously-skip-permissions'
alias cc-continue='claude --dangerously-skip-permissions --continue'
alias codex-start='codex --dangerously-bypass-approvals-and-sandbox'
alias codex-continue='codex --dangerously-bypass-approvals-and-sandbox --continue'
```

### Tmux Enhancements

Added to `~/.config/tmux/tmux.conf`:
- SSH agent forwarding (`update-environment`)
- 20k history limit
- Focus events for editors
- `Ctrl-a Tab` for last-window toggle

## Tools Installed

- `llm` CLI (via `uv tool install llm`) - for commit message generation

## Notes Files

- `~/dotfiles/notes/harper-dotfiles-gems.md` - Documents interesting things from Harper's setup
- `~/dotfiles/notes/todo-asus-dual-monitors.md` - Pending monitor setup task
