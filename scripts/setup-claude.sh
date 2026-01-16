#!/bin/bash
# Set up Claude Code configuration symlinks
# Run after: stow omarchy

set -e

DOTFILES=~/dotfiles/omarchy/.claude
CLAUDE_DIR=~/.claude

echo "Setting up Claude Code configuration..."

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Symlink config files (skip credentials - those are created on login)
for file in CLAUDE.md settings.json settings.local.json statusline.sh; do
  if [ -f "$DOTFILES/$file" ]; then
    if [ -L "$CLAUDE_DIR/$file" ]; then
      echo "  $file: Already symlinked"
    elif [ -f "$CLAUDE_DIR/$file" ]; then
      echo "  $file: Backing up existing to $file.bak"
      mv "$CLAUDE_DIR/$file" "$CLAUDE_DIR/$file.bak"
      ln -s "$DOTFILES/$file" "$CLAUDE_DIR/$file"
    else
      ln -s "$DOTFILES/$file" "$CLAUDE_DIR/$file"
      echo "  $file: Linked"
    fi
  fi
done

# Symlink directories
for dir in commands docs skills; do
  if [ -d "$DOTFILES/$dir" ]; then
    if [ -L "$CLAUDE_DIR/$dir" ]; then
      echo "  $dir/: Already symlinked"
    elif [ -d "$CLAUDE_DIR/$dir" ]; then
      echo "  $dir/: Backing up existing to $dir.bak"
      mv "$CLAUDE_DIR/$dir" "$CLAUDE_DIR/$dir.bak"
      ln -s "$DOTFILES/$dir" "$CLAUDE_DIR/$dir"
    else
      ln -s "$DOTFILES/$dir" "$CLAUDE_DIR/$dir"
      echo "  $dir/: Linked"
    fi
  fi
done

# Symlink hookify rules
for file in "$DOTFILES"/hookify.*.md; do
  [ -f "$file" ] || continue
  fname=$(basename "$file")
  if [ -L "$CLAUDE_DIR/$fname" ]; then
    echo "  $fname: Already symlinked"
  elif [ -f "$CLAUDE_DIR/$fname" ]; then
    mv "$CLAUDE_DIR/$fname" "$CLAUDE_DIR/$fname.bak"
    ln -s "$file" "$CLAUDE_DIR/$fname"
  else
    ln -s "$file" "$CLAUDE_DIR/$fname"
    echo "  $fname: Linked"
  fi
done

echo ""
echo "Done! Claude Code config is ready."
echo "Note: You'll need to log in to Claude Code to create credentials."
