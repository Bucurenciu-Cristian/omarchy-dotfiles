# Gems from Harper Reed's Dotfiles

Explored on 2026-01-20. Source: https://github.com/harperreed/dotfiles

## Claude Projects Sync Script

Location in Harper's repo: `.config/bin/sync-claude-projects`

**What it does:** Bidirectional additive sync of `~/.claude/projects/` across multiple machines using rsync.

**How it works:**
1. Pulls from all configured remote machines first
2. Then pushes to all remotes
3. Optionally backs up to iCloud
4. Never deletes anything (additive only)
5. Auto-skips current host

**Key features:**
- `--dry-run` / `-n` to preview changes
- `--quiet` / `-q` for silent operation
- Gracefully handles unreachable machines

**Configuration:**
```bash
REMOTES=(
    "machine1:~/.claude/projects/"
    "machine2:~/.claude/projects/"
)
LOCAL_BACKUP="$HOME/path/to/backup/"
```

**Use case:** If you work across multiple machines and want Claude Code project context synced everywhere.

---

## YOLO Aliases (Dangerous Mode)

Harper has convenience aliases that bypass safety prompts:

### Claude Code
```bash
# Skip permission prompts
alias cc-start='claude --dangerously-skip-permissions'
alias cc-continue='claude --dangerously-skip-permissions --continue'
```

### OpenAI Codex
```bash
# Skip approvals and sandbox
alias codex-start='codex --dangerously-bypass-approvals-and-sandbox'
alias codex-continue='codex --dangerously-bypass-approvals-and-sandbox --continue'
```

**Warning:** These skip safety checks. Use when you trust what you're doing and want speed over caution.

---

## Other Notable Items

- **LLM commit messages:** `prepare-commit-msg` hook that uses `llm` CLI to auto-generate commits
- **mise tasks:** LLM-powered code review, README generation, missing tests finder
- **Machine-specific tmux emojis:** Different emoji per hostname in `tm` script
- **SSH agent stabilization:** Stable socket symlink for tmux sessions
