#!/usr/bin/env bash
# Re-syncs the current machine's ~/.claude state into this repo.
# Run this, review the diff, then commit + push manually.
# Works under bash on macOS/Linux, and under Git Bash on Windows.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Refreshing manifest of gstack wrapper skills (symlink-only dirs)"
: > "$REPO_DIR/claude/gstack-wrapper-skills.txt"
for d in "$CLAUDE_DIR"/skills/*/; do
  name="$(basename "$d")"
  [ -L "$d/SKILL.md" ] && echo "$name" >> "$REPO_DIR/claude/gstack-wrapper-skills.txt"
done
sort -o "$REPO_DIR/claude/gstack-wrapper-skills.txt" "$REPO_DIR/claude/gstack-wrapper-skills.txt"

echo "==> Syncing skills (excluding gstack itself and its wrapper dirs)"
rm -rf "$REPO_DIR/claude/skills"
mkdir -p "$REPO_DIR/claude/skills"
for d in "$CLAUDE_DIR"/skills/*/; do
  name="$(basename "$d")"
  [ "$name" = "gstack" ] && continue
  grep -qx "$name" "$REPO_DIR/claude/gstack-wrapper-skills.txt" && continue
  cp -r "$d" "$REPO_DIR/claude/skills/$name"
done

cp "$CLAUDE_DIR/settings.json"      "$REPO_DIR/claude/settings.json"
cp "$CLAUDE_DIR/CLAUDE.md"          "$REPO_DIR/claude/CLAUDE.md"
cp "$CLAUDE_DIR/mcp/"*.json         "$REPO_DIR/claude/mcp/" 2>/dev/null || true
cp "$CLAUDE_DIR/agents/"*.md        "$REPO_DIR/claude/agents/" 2>/dev/null || true
cp "$CLAUDE_DIR/commands/"*.md      "$REPO_DIR/claude/commands/" 2>/dev/null || true
cp "$CLAUDE_DIR/output-styles/"*.md "$REPO_DIR/claude/output-styles/" 2>/dev/null || true
cp "$CLAUDE_DIR/plugins/known_marketplaces.json" "$REPO_DIR/claude/plugins/known_marketplaces.json"
cp "$CLAUDE_DIR/plugins/installed_plugins.json"  "$REPO_DIR/claude/plugins/installed_plugins.json"

echo "==> Synced. Now: git -C $REPO_DIR status"
