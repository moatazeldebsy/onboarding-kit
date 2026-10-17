# Cheat sheets

Give the one for the user's level (and the ones below it if they ask). Source: `docs/research/2026-10-17-docs-factcheck.md`.

## Beginner

| Do this | How |
|---|---|
| Ask for help | `/help` |
| Start fresh between tasks | `/clear` |
| Plan before changing things | Shift+Tab until it says plan mode, or `/plan <task>` |
| Stop Claude mid-answer | Esc |
| New line without sending | Shift+Enter (run `/terminal-setup` if it doesn't work in VS Code, Cursor, Zed or Alacritty) |
| See your usage | `/usage` |
| Check your setup | `/doctor` |
| Sign in / out | `/login`, `/logout` |

## Intermediate

| Do this | How |
|---|---|
| See what fills the context | `/context` |
| Shrink a long conversation | `/compact <what to keep>` |
| Switch model | `/model sonnet`, `/model opus`, `/model opusplan` |
| Think less / more | `/effort low`, `/effort high` |
| Edit project memory | `/memory` or edit `CLAUDE.md` |
| Change settings | `/config` |
| Manage plugins | `/plugin` |
| Manage MCP servers | `/mcp` |
| Name and come back to a session | `/rename`, `/resume` |
| Status line with context % | `/statusline show model and context used percent` |

## Advanced

| Do this | How |
|---|---|
| One-shot in scripts or CI | `claude -p "<task>" --output-format json` |
| Parallel work in isolation | `claude --worktree <name>` |
| GitHub Actions | `/install-github-app`, action `anthropics/claude-code-action@v1` |
| Hooks | `hooks` in settings.json; events like PreToolUse, PostToolUse, Stop (https://code.claude.com/docs/en/hooks) |
| Subagents | `.claude/agents/<name>.md` with `name` and `description` frontmatter |
| Own skills | `.claude/skills/<name>/SKILL.md`; the `skill-creator` plugin helps |
| Plugin cost | `claude plugin details <name>` |
| Package and share | a plugin with `.claude-plugin/plugin.json`, checked with `claude plugin validate .` |
