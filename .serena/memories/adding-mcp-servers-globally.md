# Adding MCP Servers Globally in Claude Code

## Overview

MCP servers can be added at three scopes:
- **Local** - Project-specific, private
- **Project** - Shared via `.mcp.json` in project root
- **User (Global)** - Available across ALL projects, stored in `~/.claude.json`

## Adding a Global MCP Server

### Using CLI command with JSON (recommended for complex configs)

```bash
claude mcp add-json <name> '<json-config>' --scope user
```

Example (Linear with bunx):
```bash
claude mcp add-json linear '{
  "command": "bunx",
  "args": ["github:obra/streamlinear"],
  "env": {
    "LINEAR_API_TOKEN": "your-token-here"
  }
}' --scope user
```

### Using CLI command with flags

```bash
# HTTP transport
claude mcp add --transport http <name> <url> --scope user

# Stdio transport
claude mcp add --transport stdio <name> --scope user -- <command> <args...>

# With environment variables
claude mcp add --transport stdio <name> --scope user \
  --env KEY=value \
  -- <command> <args...>
```

## bunx vs npx

- `bunx` doesn't need the `-y` flag (runs without prompts by default)
- Replace `npx -y` with just `bunx` when converting configs

## Managing Global MCP Servers

```bash
claude mcp list          # List all servers
claude mcp get <name>    # Check specific server status
claude mcp remove <name> # Remove a server
/mcp                     # Check status inside Claude Code
```

## Scope Precedence

When same server exists at multiple scopes:
1. Local (highest priority)
2. Project
3. User/Global (lowest priority)

This allows per-project overrides of global servers.

## Storage Location

Global MCP configs are stored in `~/.claude.json` under `mcpServers`.
