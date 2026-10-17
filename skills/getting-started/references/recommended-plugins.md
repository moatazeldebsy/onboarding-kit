# Recommended plugins by role and level

Last checked: 2026-10-17, against the `claude-plugins-official` marketplace (Claude Code 2.1.302).

## Rules for this list

- Only plugins from `claude-plugins-official`, the marketplace Claude Code ships with, so no extra `marketplace add` step is needed.
- At most 3 per cell. Offer them; never install without a yes.
- **Beginners get none by default.** Fewer moving parts and less context while learning the basics. Offer the optional pick only if the user asks for more.
- Connector plugins (Jira, Linear, Notion, Figma, GitHub) are offered only if the user says their team already uses that tool.
- Token cost is the "always-on" figure from `claude plugin details <name>`: tokens added to every session just by having the plugin enabled. Skills cost more each time they run.
- **MCP** means the plugin connects an MCP server. Its tool definitions load at runtime and are not in the figure; check `/context` after enabling it.
- **Hooks** run outside the model and add no context, but some (like `security-guidance`) call the model themselves and use tokens when they fire.

Install: `/plugin install <name>@claude-plugins-official`. Turn off later with `/plugin` (disable) if unused.

## Matrix

| Role | Beginner | Intermediate | Advanced |
|---|---|---|---|
| Engineer | none (optional: `explanatory-output-style`) | `commit-commands`, `code-review`, `claude-md-management` | `skill-creator`, `plugin-dev`, `hookify` |
| QA / SDET | none (optional: `explanatory-output-style`) | `playwright`, `code-review`, `commit-commands` | `playwright`, `security-guidance`, `hookify` |
| Engineering manager | none | `code-review`, `github`*, `linear`* or `atlassian`* | `claude-code-setup`, `session-report`, `receipts` |
| Product manager | none | `atlassian`*, `linear`* or `notion`*, `project-artifact` | `project-artifact`, `skill-creator`, `session-report` |
| Designer | none | `frontend-design`, `figma`* | `frontend-design`, `playground`, `figma`* |
| Analyst / data | none | `claude-md-management`, your warehouse's plugin* | `skill-creator`, `session-report`, your warehouse's plugin* |
| Writer / other | none | `claude-md-management`, `notion`* | `skill-creator`, `session-report` |

\* Connector: offer only if the team uses that tool.

## Plugin notes

| Plugin | What it gives you | Always-on cost |
|---|---|---|
| `explanatory-output-style` | Claude explains why it made each choice. Good for learning, wordier answers | ~0 (hook adds text at session start) |
| `commit-commands` | `/commit`, `/commit-push-pr`, branch cleanup | ~105 |
| `code-review` | Multi-agent PR review with confidence scoring | ~22 |
| `claude-md-management` | Audit and update CLAUDE.md files | ~177 |
| `claude-code-setup` | Looks at a codebase and suggests hooks, skills, MCP servers | ~141 |
| `skill-creator` | Write, test and tune your own skills | ~114 |
| `plugin-dev` | Toolkit for building plugins (hooks, commands, agents, MCP) | not measured |
| `hookify` | Turn "never do X" rules into hooks | ~294 |
| `playwright` | Browser automation through MCP | ~0 + MCP |
| `security-guidance` | Warnings on risky edits, review on stop | ~0 (hooks, call the model when they fire) |
| `github` | GitHub issues and PRs through MCP | ~0 + MCP |
| `linear` / `atlassian` / `notion` / `figma` | Connect the team's tracker, wiki or design tool | MCP |
| `project-artifact` | Shareable living project status page | ~312 |
| `frontend-design` | Better-looking UI output | ~80 |
| `playground` | Single-file interactive HTML explorers | not measured |
| `session-report` | HTML report of where your tokens went | ~72 |
| `receipts` | Personal impact report of what Claude Code helped ship | ~213 |

Plugins that cost a lot to keep on and are best enabled only when needed: `pr-review-toolkit` (~2,035), `superpowers` (~848 plus a session-start hook), `mcp-server-dev` (~504).
