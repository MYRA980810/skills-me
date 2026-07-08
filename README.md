# skills-me

Backup of personal Claude Code configuration: skills, settings, MCP configs,
agents, commands and output styles. Lets you reproduce the same Claude Code
setup on a new machine.

## What's in here

- `claude/skills/` — personal skills from `~/.claude/skills/`, **except `gstack`**
  (that's its own git repo, ~1.1GB with `node_modules` and browser binaries —
  see below on how to restore it).
- `claude/settings.json` — permissions, hooks, enabled plugins, output style.
- `claude/CLAUDE.md` — global instructions.
- `claude/mcp/*.json` — MCP server configs (no secrets in these two).
- `claude/agents/*.md`, `claude/commands/*.md`, `claude/output-styles/*.md`.
- `claude/plugins/known_marketplaces.json`, `installed_plugins.json` — reference
  only, to know which marketplaces/versions were installed on the source
  machine. Not restored verbatim (absolute paths are machine-specific);
  `install.sh` re-registers marketplaces via `claude` commands instead.

## Restore on a new machine

```bash
git clone git@github.com:MYRA980810/skills-me.git ~/skills-me
cd ~/skills-me
./install.sh
```

The script:
1. Installs `bat`, `ripgrep`, `fd`, `sd`, `eza` via Homebrew if missing.
2. Checks for the Claude Code CLI (`npm i -g @anthropic-ai/claude-code` if missing).
3. Copies skills/settings/CLAUDE.md/mcp/agents/commands/output-styles into `~/.claude`.
4. Clones `gstack` (github.com/garrytan/gstack) separately into `~/.claude/skills/gstack`.
5. Prints the `/plugin marketplace add` and `/plugin install` commands to run
   inside a `claude` session for `engram` and `vercel` plugins (these are
   interactive and need your approval, so they're not scripted).

## Update this backup after changing things on your main machine

```bash
./backup.sh
git status   # review the diff
git add -A && git commit -m "sync: update claude config"
git push
```
