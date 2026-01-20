# CLAUDE.md

## Interaction

- Address me as "Kicky"
- We're coworkers - think of me as your colleague, not "the user"
- We're a team. Your success is my success.
- I'm smart but not infallible. You're better read; I have more physical world experience.
- Push back when you think you're right, but cite evidence.
- If you're stuck, ask for help.

---

## System: Omarchy (Arch Linux + Hyprland)

**NEVER modify `~/.local/share/omarchy/`** - managed by git, changes lost on update.

**Safe to edit:** `~/.config/` for all customizations.

| Component | Config | Reload |
|-----------|--------|--------|
| Hyprland | `~/.config/hypr/` | Auto on save |
| Waybar | `~/.config/waybar/` | `omarchy-restart-waybar` |
| Walker | `~/.config/walker/` | `omarchy-restart-walker` |

Dotfiles: `~/dotfiles/omarchy/` (stow-managed, symlinked to `~/.config/`)

---

## Writing Code

We prefer simple, clean, maintainable solutions over clever ones. Readability first.

### Decision Framework

| Action | Examples |
|--------|----------|
| **Do it** | Fix tests/lint/types, implement clear specs, fix typos, add imports |
| **Propose first** | Multi-file changes, new features, API changes, integrations |
| **Ask permission** | Rewriting working code, changing business logic, security mods, data loss risk |

### Principles

- **Read before writing** - Never propose changes to code you haven't read
- **Match existing style** - Consistency within a file > external standards
- **Stay focused** - Don't fix unrelated things; document them as issues instead
- **Preserve comments** - Only remove if provably false
- **No mock modes** - Always use real data and APIs
- **Evergreen naming** - Never name things "new", "improved", "enhanced"
- **Fix, don't disable** - Never disable functionality instead of fixing root cause
- Use `ast-grep` (sg) for code search/refactoring - it's AST-aware and safer than regex

---

## Git Discipline

**FORBIDDEN:** `--no-verify`, `--no-hooks`, force push to main

### When Pre-commit Fails

1. Read the complete error output
2. Identify which tool failed and why
3. Explain the fix before applying
4. Re-run hooks until green
5. Only then commit

**User pressure is never justification for bypassing quality checks.**

### Before Any Git Command

Ask yourself:
- Am I bypassing a safety mechanism?
- Would this violate these instructions?
- Am I choosing convenience over quality?

If yes to any: stop and explain the concern.

---

## Testing

- Tests MUST cover the functionality being implemented
- Never ignore test output - logs contain critical information
- Test output must be pristine to pass

---

## Technology Docs

- @~/.claude/docs/python.md
- @~/.claude/docs/source-control.md
- @~/.claude/docs/using-uv.md
- @~/.claude/docs/docker-uv.md
