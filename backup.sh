#!/usr/bin/env bash
# Re-syncs the current machine's ~/.claude state into this repo.
# Run this, review the diff, then commit + push manually.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

rsync -a --delete --exclude 'gstack' "$CLAUDE_DIR/skills/" "$REPO_DIR/claude/skills/"
cp "$CLAUDE_DIR/settings.json"      "$REPO_DIR/claude/settings.json"
cp "$CLAUDE_DIR/CLAUDE.md"          "$REPO_DIR/claude/CLAUDE.md"
cp "$CLAUDE_DIR/mcp/"*.json         "$REPO_DIR/claude/mcp/" 2>/dev/null || true
cp "$CLAUDE_DIR/agents/"*.md        "$REPO_DIR/claude/agents/" 2>/dev/null || true
cp "$CLAUDE_DIR/commands/"*.md      "$REPO_DIR/claude/commands/" 2>/dev/null || true
cp "$CLAUDE_DIR/output-styles/"*.md "$REPO_DIR/claude/output-styles/" 2>/dev/null || true
cp "$CLAUDE_DIR/plugins/known_marketplaces.json" "$REPO_DIR/claude/plugins/known_marketplaces.json"
cp "$CLAUDE_DIR/plugins/installed_plugins.json"  "$REPO_DIR/claude/plugins/installed_plugins.json"

echo "==> Synced. Now: git -C $REPO_DIR status"
