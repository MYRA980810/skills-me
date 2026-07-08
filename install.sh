#!/usr/bin/env bash
# Restores this repo's snapshot into ~/.claude on a fresh machine.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Checking CLI dependencies (bat, ripgrep, fd, sd, eza)"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first: https://brew.sh"
  exit 1
fi
brew list bat      >/dev/null 2>&1 || brew install bat
brew list ripgrep  >/dev/null 2>&1 || brew install ripgrep
brew list fd       >/dev/null 2>&1 || brew install fd
brew list sd       >/dev/null 2>&1 || brew install sd
brew list eza      >/dev/null 2>&1 || brew install eza

echo "==> Checking Claude Code CLI"
if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code not found. Install it with: npm i -g @anthropic-ai/claude-code"
  echo "(requires Node — this machine used nvm with Node v24)"
  exit 1
fi

mkdir -p "$CLAUDE_DIR"/{skills,mcp,agents,commands,output-styles,plugins}

echo "==> Restoring personal skills"
rsync -a "$REPO_DIR/claude/skills/" "$CLAUDE_DIR/skills/"

echo "==> Restoring settings.json, CLAUDE.md, mcp configs, agents, commands, output-styles"
cp "$REPO_DIR/claude/settings.json"      "$CLAUDE_DIR/settings.json"
cp "$REPO_DIR/claude/CLAUDE.md"          "$CLAUDE_DIR/CLAUDE.md"
cp "$REPO_DIR/claude/mcp/"*.json         "$CLAUDE_DIR/mcp/" 2>/dev/null || true
cp "$REPO_DIR/claude/agents/"*.md        "$CLAUDE_DIR/agents/" 2>/dev/null || true
cp "$REPO_DIR/claude/commands/"*.md      "$CLAUDE_DIR/commands/" 2>/dev/null || true
cp "$REPO_DIR/claude/output-styles/"*.md "$CLAUDE_DIR/output-styles/" 2>/dev/null || true

echo "==> Cloning gstack (its own repo, not vendored here — ~1.1GB with deps)"
if [ ! -d "$CLAUDE_DIR/skills/gstack/.git" ]; then
  git clone https://github.com/garrytan/gstack.git "$CLAUDE_DIR/skills/gstack"
  echo "    -> cd $CLAUDE_DIR/skills/gstack && follow its own setup (bun install, .env from .env.example)"
else
  echo "    -> already present, skipping"
fi

echo "==> Recreating gstack wrapper skills (thin symlink dirs pointing into gstack/)"
while IFS= read -r name; do
  [ -z "$name" ] && continue
  mkdir -p "$CLAUDE_DIR/skills/$name"
  for entry in "$CLAUDE_DIR/skills/gstack/$name"/*; do
    [ -e "$entry" ] || continue
    ln -sf "$entry" "$CLAUDE_DIR/skills/$name/$(basename "$entry")"
  done
done < "$REPO_DIR/claude/gstack-wrapper-skills.txt"

echo "==> Re-registering plugin marketplaces and plugins"
echo "    Run these manually inside a 'claude' session (interactive, needs approval):"
echo "      /plugin marketplace add Gentleman-Programming/engram"
echo "      /plugin marketplace add anthropics/claude-plugins-official"
echo "      /plugin install engram@engram"
echo "      /plugin install vercel@claude-plugins-official"
echo "    (settings.json already lists them under enabledPlugins/extraKnownMarketplaces,"
echo "     but the plugin *code* under ~/.claude/plugins/cache is not vendored here and"
echo "     must be fetched via the commands above.)"

echo "==> Done. Reference file claude/plugins/installed_plugins.json shows the exact"
echo "    versions that were installed on the source machine, for comparison only."
