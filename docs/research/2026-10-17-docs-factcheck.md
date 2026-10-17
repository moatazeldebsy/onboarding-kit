# Docs fact-check (2026-10-17, Claude Code 2.1.302)

Source for every command and setting the skills mention. Re-check on each release.

## Install and setup — https://code.claude.com/docs/en/setup
- Native (recommended, auto-updates): `curl -fsSL https://claude.ai/install.sh | bash`; Windows PowerShell: `irm https://claude.ai/install.ps1 | iex`
- Homebrew: `brew install --cask claude-code` (no auto-update; `brew upgrade`)
- npm: `npm install -g @anthropic-ai/claude-code`, Node 22+, never `sudo`; not recommended
- `claude doctor` (shell, read-only): install health, settings errors, auto-update result, ripgrep/search status. `/doctor` in-session proposes fixes.
- ripgrep is bundled. If search fails: install system ripgrep and set `env.USE_BUILTIN_RIPGREP=0`.
- Native Windows is supported (Git for Windows recommended). WSL 2 needed for sandboxing.
- `/terminal-setup` only adds the Shift+Enter newline binding (VS Code, Cursor, Alacritty, Zed); Apple Terminal and iTerm2 need manual steps.
- VS Code extension `anthropic.claude-code` (VS Code 1.94+); JetBrains "Claude Code [Beta]". Both still need the CLI installed for terminal use. `/ide` connects.
- Desktop app: https://code.claude.com/docs/en/desktop-quickstart (Code tab needs a paid plan).

## Commands — https://code.claude.com/docs/en/commands
`/login` `/logout` `/init` `/help` `/config` (alias `/settings`) `/status` `/doctor` `/ide` `/clear` (aliases `/reset`, `/new`) `/compact [focus]` `/context` `/usage` (`/cost` is an alias) `/model [alias]` `/effort [low|medium|high|xhigh|max|auto]` `/plan [description]` `/statusline <description>` `/memory` `/mcp` `/plugin` `/rename` `/resume` `/autocompact <tokens>|auto` `/install-github-app`
- Not real: `#` quick-memory shortcut, `/worktree` (use `claude --worktree <name>`).

## Models and effort — https://code.claude.com/docs/en/model-config
- Settings `model`; aliases `default`, `best`, `fable`, `sonnet`, `opus`, `haiku`, `sonnet[1m]`, `opus[1m]`, `opusplan`.
- Settings `effortLevel` (low/medium/high/xhigh; `max` session-only). `/effort` saves levels per model, and Opus 5.5+ ignores `effortLevel` until a level has been saved.
- Auto-compact: `autoCompactWindow` setting, `/autocompact`, `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`.

## Costs — https://code.claude.com/docs/en/costs
Clear between tasks, compact with focus, Sonnet by default and Opus for hard reasoning, haiku for simple subagents, prefer CLI tools over MCP and disable unused servers, move specialised CLAUDE.md content into skills, filter verbose output with hooks, delegate verbose work to subagents, plan mode and rewind early, lower effort for simple tasks. Subscribers see plan usage bars in `/usage`; API users see an estimated dollar cost.

## MCP — https://code.claude.com/docs/en/mcp#scale-with-mcp-tool-search
Tool schemas are deferred by default (only names in context, loaded on demand). `ENABLE_TOOL_SEARCH=auto|false`.

## Memory — https://code.claude.com/docs/en/memory
`~/.claude/CLAUDE.md`, `./CLAUDE.md` or `./.claude/CLAUDE.md`, `./CLAUDE.local.md` (gitignored). `@path` imports (up to 4 hops; they do not reduce context cost). Target under 200 lines; move path-specific content to skills or `.claude/rules/`.

## Settings and permissions — https://code.claude.com/docs/en/settings, /permissions
- Precedence: managed > CLI `--settings` > `.claude/settings.local.json` > `.claude/settings.json` > `~/.claude/settings.json`.
- Rules `Tool` or `Tool(specifier)`; order deny → ask → allow. Bash form: `Bash(git diff *)`.
- Paths: `//` absolute, `~/` home, `/` relative to the settings file, `./` or bare relative to cwd.
- `.claudeignore` has no effect. Use `Read(...)` deny rules. Read rules don't stop subprocesses; the sandbox does.
- `permissions.defaultMode`: `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions`.
- `includeCoAuthoredBy` is deprecated; use `attribution.commit` / `attribution.pr`.
- Status line: `"statusLine": {"type": "command", "command": "..."}`; stdin JSON includes `context_window.used_percentage`.

## Plugins — https://code.claude.com/docs/en/plugins/install, /publish, /cli-reference
- `/plugin marketplace add owner/repo`, `/plugin install name@marketplace`; shell `claude plugin install|enable|disable|uninstall`, `--scope project|local`. Settings key `enabledPlugins`.
- `claude plugin validate [--strict]`, `claude plugin details <name>` (always-on token cost), `claude plugin eval` (https://code.claude.com/docs/en/plugin-evals).
- Plugin skills are namespaced: `/plugin-name:skill`.
- Directory submission: https://claude.ai/directory/manage, guide https://claude.com/docs/plugins/submit, checklist https://claude.com/docs/plugins/pre-submission-checklist. Needs a paid plan. `claude-plugins-official` itself doesn't take portal submissions.

## Advanced
- Hooks (32 events): https://code.claude.com/docs/en/hooks
- Subagents `.claude/agents/*.md`: https://code.claude.com/docs/en/sub-agents
- Headless `claude -p --output-format text|json|stream-json`: https://code.claude.com/docs/en/headless
- Worktrees `claude --worktree <name>`: https://code.claude.com/docs/en/worktrees
- GitHub Actions `anthropics/claude-code-action@v1`: https://code.claude.com/docs/en/github-actions
