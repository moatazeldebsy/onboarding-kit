---
name: token-saver
description: Cut Claude Code token use and cost. Teaches the habits that matter most (clearing between tasks, compacting, picking the right model and effort, plan mode, short CLAUDE.md, fewer plugins and MCP servers) and audits the current setup for waste. Use when someone asks about tokens, cost, usage limits, hitting their limit too fast, the context window filling up, long sessions getting slow, or how to make Claude Code cheaper.
---

# Token saver

Playbook: `references/token-playbook.md`. Level from `~/.claude/onboarding-kit-profile.json` if present; otherwise guess from how they talk and say your guess.

## 1. Teach (short)

Give the top 5 habits for their level from the playbook, not all of them, each as one line with the command. Beginners: items 1–5. Intermediate: 1–2 recap plus 6–12. Advanced: 13–18 plus anything in their setup that's wasteful.

Subscribers (Pro, Max, Team) watch plan usage bars in `/usage`; API users see an estimated dollar cost. Don't talk about dollars to subscribers.

## 2. Audit (read-only, offer it)

Run the checks in the playbook's "Setup audit" table:

```bash
wc -l ~/.claude/CLAUDE.md ./CLAUDE.md ./.claude/CLAUDE.md ./CLAUDE.local.md 2>/dev/null
claude plugin list
claude mcp list
```

For each enabled plugin, `claude plugin details <name>` gives its always-on token cost. Also check whether the project denies reads of build and dependency folders that exist.

Report as a table: finding, cost, suggested fix. Biggest saving first.

## 3. Fix (only with a yes)

- Disable a plugin: `claude plugin disable <name>` (re-enable any time).
- Remove an MCP server they don't use: show `claude mcp remove <name>` and let them decide.
- CLAUDE.md too long or missing deny rules: use the `project-setup` skill.
- Status line: tell them to run `/statusline show model and context used percent`.
