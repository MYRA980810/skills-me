# skills-me

Backup of personal Claude Code configuration: skills, settings, MCP configs,
agents, commands and output styles. Lets you reproduce the same Claude Code
setup on a new machine.

## What's in here

- `claude/skills/` — personal skills from `~/.claude/skills/`, **except `gstack`**
  (that's its own git repo, ~1.1GB with `node_modules` and browser binaries —
  see below on how to restore it) **and except the gstack wrapper skills**
  (thin dirs whose `SKILL.md` is just a symlink into `gstack/<name>/SKILL.md` —
  listed in `claude/gstack-wrapper-skills.txt`, recreated by `install.sh` after
  `gstack` is cloned, so no broken symlinks get committed here).

## Platform notes

- **macOS**: uses Homebrew for `bat`/`ripgrep`/`fd`/`sd`/`eza`.
- **Windows (Git Bash)**: `install.sh`/`backup.sh` detect Git Bash (`MINGW*`) and
  use `cp -r` instead of `rsync` (not bundled with Git for Windows), and
  [scoop](https://scoop.sh) instead of Homebrew for the CLI tools. Wrapper
  skills are **copied**, not symlinked — Windows symlinks need admin rights or
  Developer Mode enabled, so copying avoids that entirely. Downside: if you
  later `git pull` inside `~/.claude/skills/gstack`, re-run the "recreate
  wrapper skills" block in `install.sh` to refresh the copies.
- **gstack on Windows is unverified** — it drives a Chromium browser for some
  skills (`/browse`, `/qa`, etc.). Check github.com/garrytan/gstack for
  Windows-specific setup before relying on those.
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
