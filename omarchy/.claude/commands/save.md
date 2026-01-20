---
name: save
description: "Session lifecycle management with Serena MCP integration for session context persistence"
---

# /save - Save Session Context

Persist session learnings and context for future sessions.

## Steps

1. **Review what was accomplished**:
   - What did we build/fix/discover?
   - What architectural decisions were made?
   - What gotchas did we encounter?

2. **List existing memories** to avoid duplicates:
   ```
   mcp__plugin_serena_serena__list_memories()
   ```

3. **Write new memories** for valuable discoveries:
   ```
   mcp__plugin_serena_serena__write_memory(
     memory_file_name="descriptive-name.md",
     content="## Context\n\n[What and why]\n\n## Details\n\n[Specifics]"
   )
   ```

4. **Update existing memories** if information evolved:
   ```
   mcp__plugin_serena_serena__edit_memory(
     memory_file_name="existing-memory.md",
     needle="old content",
     repl="updated content",
     mode="literal"
   )
   ```

5. **Verify memories are findable**:
   - Read back what you wrote
   - Ensure naming is searchable

## What to Save

| Save | Don't Save |
|------|------------|
| Architecture decisions | Temporary debug notes |
| Project gotchas | Things in git already |
| User preferences discovered | Vague "might be useful" |
| API quirks/workarounds | Raw file dumps |

## Memory Naming Convention

Use descriptive, searchable names:
- `architecture-auth-flow.md`
- `gotcha-sqlite-datetime.md`
- `preference-testing-style.md`
- `decision-api-versioning.md`
