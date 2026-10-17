---
name: machine-setup
description: Check and fix the local machine for Claude Code. Runs a read-only health check of the Claude Code install, version, install method, duplicate installs, login, git, GitHub CLI and Node, then offers fixes one at a time. Use when someone asks if their Claude Code setup is OK, wants to check their machine, has login or install problems, wants to move from an npm install to the native installer, or asks how to get the VS Code, JetBrains or desktop app.
---

# Machine setup

## 1. Check

Read the role from `~/.claude/onboarding-kit-profile.json` if it exists (default `other`), then run:

```bash
bash "<this skill's directory>/scripts/doctor.sh" --role <role>
```

Each line is `status<TAB>check<TAB>detail<TAB>fix`, status `ok | warn | fail | info`. It changes nothing. Exit code 1 just means at least one `fail`.

On native Windows without bash, run `claude --version`, `claude auth status` and `claude doctor` instead and read their output.

## 2. Report

Show a short table: what's fine, what needs fixing. Explain each `fail` and `warn` in one plain sentence. Mention `info` lines only when they matter to this user (for example `api_key`: usage goes to an API bill, not their plan).

## 3. Fix, one at a time

For each `fail`, then each `warn` the user wants fixed: say what the command does, ask, run it only after a yes. Never use `sudo` without saying why. If a fix needs the user (a browser login, a password, a restart), tell them exactly what to type; suggest the `!` prefix so the output lands in the chat, e.g. `! gh auth login`.

Known fixes (from https://code.claude.com/docs/en/setup):

| Check | Fix |
|---|---|
| `claude` missing | `curl -fsSL https://claude.ai/install.sh \| bash` (Homebrew alternative: `brew install --cask claude-code`, no auto-update) |
| npm install | Install native (above), confirm `claude --version` works from the new path, then `npm uninstall -g @anthropic-ai/claude-code` |
| Duplicate install | `type -a claude`; keep the native one, remove the others |
| Not logged in | Start `claude` and run `/login` |
| git missing | macOS `xcode-select --install`; Debian/Ubuntu `sudo apt install git` |
| gh missing / logged out | `brew install gh` or https://cli.github.com; then `gh auth login` |
| Search broken | Install ripgrep, set `"env": {"USE_BUILTIN_RIPGREP": "0"}` |

Only push git and gh on roles that need them (engineer, qa). For others, offer once with the reason and accept a no.

## 4. Optional extras

Offer what fits the user, don't push:
- VS Code / Cursor: extension `anthropic.claude-code` (VS Code 1.94+). JetBrains: "Claude Code [Beta]" plugin. Then `/ide` to connect.
- Desktop app (easier for non-engineer beginners): https://code.claude.com/docs/en/desktop-quickstart
- Shift+Enter for new lines: `/terminal-setup` (VS Code, Cursor, Zed, Alacritty; iTerm2 and Apple Terminal need manual steps).

## 5. Confirm

Run `doctor.sh` again and `claude doctor`, and show the final status.
