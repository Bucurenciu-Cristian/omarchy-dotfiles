#!/bin/bash
# Post-write hook to format files after Claude creates/edits them
# Adapted for multi-language stack: Python, Go, JS/TS, Bash, etc.

# To test directly:
# echo '{"tool_input": {"file_path": "path/to/file"}}' | .claude/hooks/post-write-format.sh

# Read JSON from stdin and extract file path
FILE=$(jq -r '.tool_input.file_path' 2>/dev/null)

if [ -z "$FILE" ] || [ "$FILE" = "null" ]; then
  exit 0
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
  exit 0
fi

# Format based on file type
case "$FILE" in
  # Python
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      ruff format "$FILE" 2>/dev/null
      ruff check --fix "$FILE" 2>/dev/null
    elif command -v black >/dev/null 2>&1; then
      black "$FILE" 2>/dev/null
    fi
    ;;

  # Go
  *.go)
    if command -v gofmt >/dev/null 2>&1; then
      gofmt -w "$FILE" 2>/dev/null
    fi
    if command -v goimports >/dev/null 2>&1; then
      goimports -w "$FILE" 2>/dev/null
    fi
    ;;

  # Shell scripts
  *.sh|*.bash)
    if command -v shfmt >/dev/null 2>&1; then
      shfmt -w "$FILE" 2>/dev/null
    fi
    ;;

  # JavaScript/TypeScript
  *.js|*.jsx|*.ts|*.tsx)
    if command -v npx >/dev/null 2>&1; then
      npx prettier --write "$FILE" 2>/dev/null
      npx eslint --cache --fix "$FILE" 2>/dev/null
    fi
    ;;

  # JSON (including package.json)
  */package.json)
    if command -v npx >/dev/null 2>&1; then
      npx sort-package-json "$FILE" 2>/dev/null
    fi
    ;;
  *.json)
    if command -v jq >/dev/null 2>&1; then
      # Format JSON in place using jq
      tmp=$(mktemp)
      jq '.' "$FILE" > "$tmp" 2>/dev/null && mv "$tmp" "$FILE"
    elif command -v npx >/dev/null 2>&1; then
      npx prettier --write "$FILE" 2>/dev/null
    fi
    ;;

  # YAML/TOML
  *.yml|*.yaml)
    if command -v npx >/dev/null 2>&1; then
      npx prettier --write "$FILE" 2>/dev/null
    fi
    ;;
  *.toml)
    if command -v taplo >/dev/null 2>&1; then
      taplo format "$FILE" 2>/dev/null
    fi
    ;;

  # Markdown
  *.md|*.mdx)
    if command -v npx >/dev/null 2>&1; then
      npx prettier --write "$FILE" 2>/dev/null
    fi
    ;;

  # Lua (for neovim configs)
  *.lua)
    if command -v stylua >/dev/null 2>&1; then
      stylua "$FILE" 2>/dev/null
    fi
    ;;

  # Rust
  *.rs)
    if command -v rustfmt >/dev/null 2>&1; then
      rustfmt "$FILE" 2>/dev/null
    fi
    ;;
esac

exit 0
