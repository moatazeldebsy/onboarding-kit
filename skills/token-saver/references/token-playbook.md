# Token playbook

Roughly in order of impact. Every item is backed by `docs/research/2026-10-17-docs-factcheck.md` (main source: https://code.claude.com/docs/en/costs).

## Everyone (beginner)

1. **`/clear` between unrelated tasks.** Old conversation is re-read on every turn. A fresh start costs nothing; dragging a finished task along costs every message.
2. **Be specific.** Name the file, function or folder and say what "done" looks like. "Fix the date bug in `src/billing/invoice.ts`" beats "look around and fix bugs".
3. **Plan before big changes.** Press Shift+Tab to reach plan mode (or `/plan <task>`). Agreeing on the plan first means the edits happen once instead of three times.
4. **Stop early when it goes wrong.** Press Esc to interrupt, then correct or rewind. Don't let a wrong direction run for ten steps.
5. **Check where you stand.** `/usage` shows plan usage (subscribers) or estimated cost (API). `/context` shows what's filling the window.

## Intermediate

6. **`/compact <focus>` on long tasks.** For example `/compact keep the failing test output and the plan`. Auto-compact happens anyway; compacting yourself keeps what you choose.
7. **Pick the model for the job.** `/model sonnet` for everyday work, `/model opus` for hard design or debugging, `opusplan` to plan with Opus and execute with Sonnet. `haiku` suits simple subagents.
8. **Lower effort for routine work.** `/effort low` or `medium` for renames, formatting and small edits; raise it for hard problems.
9. **Keep CLAUDE.md short.** It loads in every session. Aim well under 200 lines. Move long, task-specific instructions into skills, which load only when used. `@imports` don't save tokens.
10. **Block noisy files.** Deny reads of generated and vendored files (`node_modules`, `dist`, `build`, lockfiles, large data dumps) in `.claude/settings.json`. `.claudeignore` does nothing.
11. **Turn off what you don't use.** Each enabled plugin adds tokens to every session; check with `claude plugin details <name>` and disable with `/plugin`. Disable unused MCP servers with `/mcp`.
12. **Add a status line with context %.** `/statusline show model and context used percent` so you see the window filling before it hurts.

## Advanced

13. **Send big searches to a subagent.** A subagent reads the 40 files and returns a summary; your main context stays small.
14. **Prefer CLI tools to MCP** where both exist (`gh` vs a GitHub MCP server). The docs recommend it.
15. **Trim command output with hooks.** A PostToolUse hook can cut long test or build logs down to the failures.
16. **Use `claude -p` for one-shot jobs** in scripts and CI, with `--output-format json`, so no chat history builds up.
17. **Name and resume sessions.** `/rename` then `/resume` returns to a task without re-explaining it.
18. **Measure.** `/usage` breaks spend down by skill, subagent, plugin and MCP server on paid plans; the `session-report` plugin shows the most expensive prompts.

## Setup audit (what the skill checks)

| Check | How | Flag when |
|---|---|---|
| CLAUDE.md size | `wc -l` on `~/.claude/CLAUDE.md`, `./CLAUDE.md`, `./.claude/CLAUDE.md`, `./CLAUDE.local.md` | any file > 200 lines, or total > 300 |
| Enabled plugins | `enabledPlugins` in user and project settings, `claude plugin details` per plugin | total always-on > ~3,000 tokens, or a plugin unused in the last month |
| MCP servers | `claude mcp list` | servers the user doesn't recognise or use |
| Read deny rules | project `.claude/settings.json` | build output or dependency folders exist and aren't denied |
| Status line | `statusLine` in user settings | missing |
