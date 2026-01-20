---
name: load
description: "Session lifecycle management with Serena MCP integration for project context loading"
---

# /load - Load Project Context

Load project context and memories for a new session.

## Steps

1. **Activate the project** (if not already active):
   ```
   mcp__plugin_serena_serena__activate_project(project=".")
   ```

2. **Check onboarding status**:
   ```
   mcp__plugin_serena_serena__check_onboarding_performed()
   ```
   If not performed, run `mcp__plugin_serena_serena__onboarding()`.

3. **List available memories**:
   ```
   mcp__plugin_serena_serena__list_memories()
   ```

4. **Read relevant memories** based on current task:
   - Architecture decisions
   - Project gotchas
   - Previous session context
   - User preferences

5. **Get symbols overview** for key files if needed:
   ```
   mcp__plugin_serena_serena__get_symbols_overview(relative_path="src/main.py")
   ```

6. **Report loaded context** to user:
   - Project status
   - Memories loaded
   - Ready to proceed

## Quick Load (Most Sessions)

```
1. activate_project → 2. list_memories → 3. read relevant ones → 4. report ready
```
