# Plan: `onboarding-kit` plugin

## Goal

A Claude Code plugin that gets a new user from "just installed" to a productive, cheap-to-run setup in one guided session, published on a GitHub-hosted marketplace so anyone can install it with two commands.

**Done means:**
- `claude plugin validate .` passes.
- On a clean machine, a user runs `/plugin marketplace add <owner>/onboarding-kit`, installs the plugin, says "help me get started with Claude Code", and ends with: a healthy machine, sensible user settings, a project `CLAUDE.md`, a short list of recommended plugins installed, and the token-saving habits explained.
- Nothing on the machine is installed or changed without the user saying yes first.

## Decisions I made (override any of them)

| Decision | My call | Why |
|---|---|---|
| Name | `onboarding-kit` | Says what it does |
| Format | One plugin, 4 skills (each runnable as `/onboarding-kit:<skill>`), plain shell scripts | Skills trigger on their own topics; no runtime dependencies |
| OS support | macOS + Linux; Windows via WSL for v0.1 | Claude Code itself supports native Windows, but `doctor.sh` is bash; a PowerShell version is a v0.2 candidate |
| Audience | Anyone new to Claude Code: engineers, engineering managers, product managers, QA, designers, analysts, writers | Your call |
| Personalisation | Flow asks **role** and **level** (beginner / intermediate / advanced) up front and tailors checks, templates and plugin picks | Your call |
| Recommended plugins | Minimal and neutral; official-marketplace plugins first, no personal picks | Your call |
| Hosting | Public GitHub repo `moatazeldebsy/onboarding-kit`, which is its own marketplace | Your call (owner); official directory submission comes after |
| License | MIT | Standard for plugins |
| Changes to the machine | Read-only checks by default; every install or settings write is shown as a diff, backed up, then confirmed | A starter tool that breaks someone's setup kills trust |

## Repo layout

```
onboarding-kit/
├── .claude-plugin/
│   ├── plugin.json            # name, version, author, keywords, skills path
│   └── marketplace.json       # lists this one plugin, source "./"
├── skills/
│   ├── getting-started/       # orchestrator: checks state, runs phases in order
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── recommended-plugins.md   # level × role matrix
│   │       └── roles.md                 # what each role uses Claude Code for
│   ├── machine-setup/         # prerequisites, install, auth, terminal, IDE
│   │   ├── SKILL.md
│   │   └── scripts/doctor.sh  # read-only health check, prints JSON-ish report
│   ├── project-setup/         # CLAUDE.md, settings.json, permissions
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── CLAUDE.md.code.tmpl      # code repos
│   │       ├── CLAUDE.md.workspace.tmpl # docs / specs / data folders (PM, EM, analyst)
│   │       ├── settings.user.json
│   │       └── settings.project.json
│   └── token-saver/           # habits + config that cut token use
│       ├── SKILL.md
│       └── references/token-playbook.md
├── evals/                     # trigger + behaviour tests for each skill
├── tests/doctor.bats          # shell tests for doctor.sh
├── README.md
├── CHANGELOG.md
└── LICENSE
```

## What each skill does

### 1. `getting-started` (orchestrator)
Triggers on "get started / set up / onboard / new to Claude Code". Starts with two questions, then runs `doctor.sh`, shows a one-screen status, and walks the phases in order, skipping any already done:
0. **Who are you?** Role (engineer, QA/SDET, engineering manager, product manager, designer, analyst/data, writer/other) and level (beginner, intermediate, advanced). Saved to `~/.claude/onboarding-kit-profile.json` so later runs and the other skills reuse it.
1. Machine ready → hands to `machine-setup`
2. User-level settings → `project-setup` (user scope)
3. Current project or workspace → `project-setup` (project scope)
4. Recommended plugins → shows only the picks for their level and role from `recommended-plugins.md`, installs only the ones they choose
5. Token habits → `token-saver`, depth matched to level
6. Prints a one-page cheat sheet for their role and level

**How level changes the flow:**

| Level | Pace | Covers |
|---|---|---|
| Beginner | Explains each step, one at a time | Install, login, first prompt, `/help`, `/clear`, plan mode, approving tool use, 0–2 plugins |
| Intermediate | Shorter explanations, batches steps | `CLAUDE.md`, permissions, `/compact`, `/context`, model switching, slash commands, a few workflow plugins |
| Advanced | Status table and diffs only | Hooks, subagents, MCP servers, custom skills, headless `claude -p` in CI, worktrees, building/publishing their own plugins |

**`recommended-plugins.md`: level × role matrix.** Neutral rules for what goes in:
- Official marketplace (`claude-plugins-official`) first; community plugins only if widely used and maintained
- At most 3 per cell, each with a one-line "why" and its rough context cost
- Nothing that needs a paid third-party account unless the role clearly uses that tool (e.g. a Jira/Linear connector for PMs and EMs)
- Every entry checked against the live marketplace at build time; the file shows a "last checked" date

Example shape (final picks decided in build step 2):

| | Beginner | Intermediate | Advanced |
|---|---|---|---|
| Engineer | none, or 1 code-review plugin | commit/PR workflow, CLAUDE.md upkeep | skill/plugin authoring, MCP server dev, hooks |
| QA / SDET | none | test-generation / browser automation | e2e in CI, headless runs |
| Eng manager | none | PR review, standup summaries | issue-tracker connector, scheduled agents |
| Product manager | none | doc writing, issue-tracker connector | research, scheduled agents |
| Designer | none | frontend design | design-system tooling |
| Analyst / data | none | data/notebook helpers | MCP to their data sources |

Beginners get no plugins by default on purpose: fewer moving parts and less context used while they learn the basics.

### 2. `machine-setup`
- `doctor.sh` checks, without changing anything: OS/shell, `claude` on PATH and version, install method (native vs npm), `git`, `gh` + auth status, `node` (only flagged if they use npm install or MCP servers that need it), `ripgrep`, login status, `~/.claude` presence, conflicting duplicate installs.
- Role decides which checks are required: git/gh are required for engineers and QA, optional for EM/PM/designer/analyst (explained in plain words, never pushed); Desktop app and IDE extension are suggested as easier entry points for non-engineer beginners.
- For each failing check, the skill explains the fix and runs it only after a yes (native installer, `brew`/`apt` for git/gh, `/login`, `/terminal-setup`, IDE extension pointer).
- Ends by running `claude doctor` and doctor.sh again to confirm.

### 3. `project-setup`
- **User scope** (`~/.claude/settings.json`): proposes a merged settings file (never overwrites): default model, status line showing context use, sensible `permissions.allow` for read-only commands, `permissions.deny` for secrets (`.env*`, `**/*.pem`, `~/.ssh/**`). Backs up the old file to `settings.json.bak-<date>`.
- **Project scope**: for a code repo, detects the stack (package.json, go.mod, pyproject, etc.), then either runs `/init` or fills `CLAUDE.md.code.tmpl` with build/test/lint commands. For a non-code folder (specs, roadmaps, meeting notes, CSVs), uses `CLAUDE.md.workspace.tmpl`: what's in the folder, writing style, who reads the output, what not to touch. Keeps it under ~100 lines, since the file is loaded into every session. Adds project `.claude/settings.json` with deny rules for `node_modules`, `dist`, `build`, lockfiles, vendored code.
- Shows every file as a diff before writing.

### 4. `token-saver`
Triggers on "save tokens / cost / context full / usage / expensive". Content in `token-playbook.md`, roughly in order of impact:
- `/clear` between unrelated tasks; `/compact` with a focus hint on long tasks
- `/context` to see what fills the window; `/cost` / usage to track spend
- Pick the model per task: smaller model for simple edits and questions, larger for planning and hard bugs; lower effort for routine work
- Keep `CLAUDE.md` short; move details to files it links to
- Turn off MCP servers and plugins you don't use (their tool lists cost context every turn)
- Deny reads of generated/vendored files
- Give file paths and exact asks instead of "look around the repo"
- Use plan mode before large changes so the edits happen once
- Send broad searches to a subagent so the main context stays small
- Optional: offers to run an audit of the current setup (counts MCP servers, enabled plugins, CLAUDE.md size) and suggests cuts.

Every command and setting named here gets checked against current Claude Code docs during build (step 2 below), since these change between releases.

## Build steps

1. **Scaffold repo** — layout above, `plugin.json`, `marketplace.json`, README stub.
   → verify: `claude plugin validate .` passes.
2. **Fact-check content** — confirm each command, setting key, and install command against current Claude Code docs (via the `claude-code-guide` agent). Write `token-playbook.md`, `roles.md`, templates, and fill the `recommended-plugins.md` matrix from the live marketplace.
   → verify: every command in the playbook has a docs link or was run locally; every plugin in the matrix exists in `claude-plugins-official` (actual installs are tested in step 7, on clean machines, so the author's own setup isn't changed).
3. **`doctor.sh`** — write it read-only, POSIX-ish bash, `shellcheck`-clean; bats tests with faked PATHs for missing/old/duplicate installs.
   → verify: `shellcheck` + `bats tests/` pass on macOS and in an Ubuntu container.
4. **Write the 4 SKILL.md files** — short bodies, details pushed to `references/` so the skill itself stays cheap to load. Use `skill-creator` for descriptions that trigger reliably.
   → verify: trigger evals (should-trigger and should-not-trigger prompts per skill) succeed in at least 90% of runs.
5. **Slash command** — dropped: plugin commands are a legacy format and always namespaced, and each skill already runs as `/onboarding-kit:<skill>`. Entry point is `/onboarding-kit:getting-started`.
6. **Safety evals** — prompts like "just set everything up" must still stop for confirmation before installs and settings writes; existing settings must survive a merge.
   → verify: `claude plugin eval` suite green.
   Add persona evals: at least beginner PM, intermediate EM, advanced engineer. Check that each gets the right checks, template and plugin picks, and that a beginner PM is never asked to install `gh`.
7. **Clean-machine run** — fresh macOS user account and an Ubuntu container: install from the marketplace and run the full flow end to end, once as a beginner non-engineer and once as an advanced engineer.
   → verify: all "done means" items above hold; time it (target under 15 minutes).
8. **Publish** — push to GitHub, tag `v0.1.0`, README with the two install commands:
   ```
   /plugin marketplace add moatazeldebsy/onboarding-kit
   /plugin install onboarding-kit@onboarding-kit
   ```
   → verify: install works from a second machine using only the README.
9. **Official directory (optional, later)** — submit to Anthropic's plugin directory once a few people have used it and the evals are stable.

## Out of scope for v0.1
- Native Windows (non-WSL)
- Team/enterprise managed settings
- Building custom MCP servers
- Auto-updating the recommended-plugins list from the network

- Role-specific workflow tutorials beyond the cheat sheet (candidate for v0.2)
