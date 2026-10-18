---
name: project-setup
description: Set up Claude Code settings and a CLAUDE.md for a user or a folder. Merges safe defaults into ~/.claude/settings.json (block reading secrets like .env and SSH keys), adds project rules that stop Claude reading generated or vendored files, and writes a short CLAUDE.md for a code repo or a non-code folder of docs, specs or data. Use when someone asks to configure Claude Code settings or permissions (user-level ~/.claude/settings.json or a project's .claude/settings.json), create or improve a CLAUDE.md, set up a project or folder for Claude Code, or make sure Claude never reads .env files, private keys, SSH keys, or dependency and build folders (node_modules, dist, build).
---

# Project setup

Two scopes: **user** (`~/.claude/settings.json`, every project) and **project** (the current folder). Do the one asked for, or both in that order.

## Rules for every file

1. Read the existing file first. **Merge, never replace:** keep every existing key and rule, add only what's missing, de-duplicate lists.
2. Show the change as a diff (or the full file if new) and ask. If the user already said yes to this specific change, show the diff and go ahead without asking again. A general "do everything" is not a yes to a specific file.
3. On yes, before the first Edit or Write to an existing file, run `cp <file> "<file>.bak-$(date +%Y%m%d-%H%M%S)"`. No backup, no write.
4. Validate JSON after writing (`python3 -m json.tool <file>` if python3 is available); restore the backup if it fails.

Settings facts: `.claudeignore` does nothing; use `Read(...)` deny rules. Deny beats allow. `defaultMode` lives under `permissions`. `includeCoAuthoredBy` is deprecated; use `attribution`. Read deny rules stop Claude's Read tool, not shell commands. Details: https://code.claude.com/docs/en/permissions

## User scope

Start from `templates/settings.user.json`: deny reading `.env` files, keys and cloud credentials; allow read-only git commands without a prompt. For intermediate and advanced users, also offer:
- a status line showing context use: tell them to run `/statusline show model and context used percent`
- a default model (`"model": "sonnet"` for everyday work, or `"opusplan"`) only if they want one

## Project scope

1. **Folder type.** Code repo (has `package.json`, `go.mod`, `pyproject.toml`, `pom.xml`, `Cargo.toml`, `Makefile`, `.git`, ...) or workspace (docs, specs, notes, CSVs).
2. **Deny rules.** Find which of the template's paths exist here:
   ```bash
   ls -d node_modules dist build out coverage .next target vendor .venv __pycache__ package-lock.json yarn.lock pnpm-lock.yaml poetry.lock Cargo.lock go.sum 2>/dev/null
   ```
   Add the `templates/settings.project.json` rule only for each path this prints. Nothing else. Write to `.claude/settings.json` (shared with the team via git). Personal tweaks go in `.claude/settings.local.json`.
3. **CLAUDE.md.**
   - Already exists: don't rewrite. Check length (`wc -l`); over ~200 lines, suggest moving task-specific parts into skills. Offer small fixes as a diff.
   - Code repo, none yet: fill `templates/CLAUDE.md.code.tmpl` from what's really there (scripts in `package.json`, `Makefile` targets, test config, top-level folders). Or suggest the user runs `/init`. Never invent commands; leave out sections you can't fill.
   - Workspace, none yet: ask what the folder is for, who reads the output and the preferred style, then fill `templates/CLAUDE.md.workspace.tmpl`.
   - Keep it short (aim for under 60 lines). It loads into every session, so every line costs tokens.
