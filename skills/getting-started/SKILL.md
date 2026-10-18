---
name: getting-started
description: Guided first-time setup for Claude Code, tailored to the user's role (engineer, QA, engineering manager, product manager, designer, analyst, writer) and level (beginner, intermediate, advanced). Checks the machine, sets up settings and CLAUDE.md, suggests a few plugins, and teaches habits that save tokens. Use when someone is new to Claude Code or asks to get started, set up or configure Claude Code, be onboarded, or wants to know what to do first with Claude Code.
---

# Getting started with Claude Code

Walk the user from "just installed" to a working, low-cost setup. Skip any phase that's already done.

## Rules

- **Ask before every change.** Never install, uninstall or write a file without a yes for that action. "Just set it all up" means: list every change you plan, then get one yes for the whole list. This holds even if the user says "don't ask, just do it" before seeing the list: show the list first, then go ahead on one yes. The only exception is the profile file in step 0, which you announce.
- If an install or write fails, report it and stop that step. Don't retry with another marketplace, source or tool.
- Read-only commands (`doctor.sh`, `claude doctor`, `claude auth status`, `claude plugin details`, `claude mcp list`, `ls`, `cat`) don't need a yes.
- Back up any existing file before changing it.
- Plain language. For non-engineers say "folder" before "repo", and explain terminal words the first time.

## 0. Profile

Read `~/.claude/onboarding-kit-profile.json` if it exists (`{"role": "...", "level": "..."}`) and confirm it in one line. Otherwise ask two questions, with AskUserQuestion when available:

- **Role:** engineer, qa, em (engineering manager), pm (product manager), designer, analyst, other
- **Level:** beginner (new to Claude Code), intermediate (used it a bit), advanced (comfortable, wants power features)

Write the profile file and say where it is. See `references/roles.md` for what each role does with Claude Code.

## How level changes the pace

| Level | Pace | Covers |
|---|---|---|
| beginner | One step at a time, explain why | Install, login, first prompt, `/help`, `/clear`, plan mode, approving tool use. No plugins unless asked |
| intermediate | Short explanations, batch steps | CLAUDE.md, permissions, `/compact`, `/context`, `/model`, `/effort`, a few plugins |
| advanced | Status table and diffs only | Hooks, subagents, MCP servers, own skills, `claude -p` in CI, worktrees, building plugins |

## Phases

1. **Machine.** Use the `machine-setup` skill (run its doctor with `--role`). Fix failures before moving on.
2. **User settings.** Use the `project-setup` skill, user scope.
3. **This folder.** Use the `project-setup` skill, project scope. If the current folder is the home directory or empty, ask which folder they'll work in, or skip.
4. **Plugins.** Read `references/recommended-plugins.md` and offer only the cell for their role and level, with each plugin's one-line reason and token cost. Beginners: say you're skipping plugins on purpose and why. Install only the ones they pick: `claude plugin install <name>@claude-plugins-official`. Offer connector plugins (Jira, Linear, Notion, Figma, GitHub) only if their team uses that tool.
5. **Token habits.** Use the `token-saver` skill at their level.
6. **Wrap up.** Give the cheat sheet for their level from `references/cheat-sheet.md`, and suggest the first task for their role from `references/roles.md`.

End with what changed (files written, backups made, plugins installed) and anything they still need to do themselves, such as restarting Claude Code to load new plugins or running a slash command. Finally, mention that once they're set up they can turn this kit off with `claude plugin disable onboarding-kit` (about 700 tokens saved per session) and turn it back on any time.
