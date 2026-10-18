# onboarding-kit

A Claude Code plugin that takes you from "just installed" to a working, low-cost setup in one guided conversation. It adapts to your role (engineer, QA, engineering manager, product manager, designer, analyst, writer) and your level (beginner, intermediate, advanced).

Nothing on your machine is installed or changed without your yes.

## Install

Inside Claude Code:

```
/plugin marketplace add moatazeldebsy/onboarding-kit
/plugin install onboarding-kit@onboarding-kit
```

Restart Claude Code so the plugin loads. Don't have Claude Code yet? Install it first:

```bash
curl -fsSL https://claude.ai/install.sh | bash     # macOS, Linux, WSL
```

## Quick start

Open Claude Code in the folder you'll work in (a code repo, or a folder of docs or data), then either type:

```
/onboarding-kit:getting-started
```

or just say **"help me get started with Claude Code"**.

## What happens

1. **Two questions:** your role and your level. Saved to `~/.claude/onboarding-kit-profile.json` so you're not asked again.
2. **Machine check:** a read-only health check of your Claude Code install, login, git and GitHub CLI. Problems come with the fix command; nothing runs until you say yes. git and gh are only pushed for engineers and QA.
3. **Your settings:** safe defaults merged into `~/.claude/settings.json`: Claude can't read `.env` files, private keys, SSH keys or cloud credentials. Your existing settings are kept and backed up first.
4. **This folder:** rules so Claude doesn't waste tokens reading `node_modules`, build output and lock files (only for folders that exist), plus a short `CLAUDE.md` that tells Claude what the folder is for. An existing `CLAUDE.md` is never rewritten.
5. **Plugins:** at most three picks for your role and level, each with what it does and what it costs in tokens. Beginners get none on purpose.
6. **Token habits:** the five that matter most at your level.
7. **Cheat sheet** and a good first task for your role.

At the end you get a list of what changed and where the backups are. You approve once for the whole list, or pick items by number.

## How it adapts

| Level | What you get |
|---|---|
| Beginner | One step at a time, plain language. Install, login, first prompt, `/clear`, plan mode, approving actions. No plugins. |
| Intermediate | Shorter explanations. CLAUDE.md, permissions, `/compact`, `/context`, `/model`, `/effort`, a few workflow plugins. |
| Advanced | Status table and diffs. Hooks, subagents, MCP servers, your own skills, `claude -p` in CI, worktrees. |

Role changes the examples, which tools are required, which `CLAUDE.md` template is used (code repo or non-code workspace) and which plugins are offered. See [the plugin list](skills/getting-started/references/recommended-plugins.md).

## Use one part on its own

You don't have to run the whole flow. Each part has its own command, or just ask in your own words:

| Command | Ask something like |
|---|---|
| `/onboarding-kit:machine-setup` | "Is my Claude Code install healthy?", "I installed it with npm, should I switch?" |
| `/onboarding-kit:project-setup` | "Create a CLAUDE.md for this folder", "Stop Claude reading my .env files" |
| `/onboarding-kit:token-saver` | "I keep hitting my usage limit", "My context fills up too fast" |
| `/onboarding-kit:getting-started` | "Set up Claude Code for me" |

The machine check also works without Claude: `bash skills/machine-setup/scripts/doctor.sh --role engineer`.

## What it will and won't do

- **Asks first.** Every install and every file write is listed and approved, even if you say "just do it".
- **Merges, never replaces.** Existing settings and `CLAUDE.md` are kept; a timestamped `.bak-` copy is made before any change.
- **Stays in its lane.** It sets up Claude Code only. It won't change your project's code, dependencies, build config or git history; it mentions problems it spots and leaves them to you.
- **Doesn't retry around failures.** If an install fails, it tells you and stops that step.

Note that `Read(...)` deny rules stop Claude's file reading, not every shell command. See the [permissions docs](https://code.claude.com/docs/en/permissions).

## Turn it off when you're done

The kit adds a few hundred tokens to every session (`claude plugin details onboarding-kit` shows the exact number). Once you're set up:

```bash
claude plugin disable onboarding-kit     # turn back on with: claude plugin enable onboarding-kit
```

Update: `claude plugin marketplace update onboarding-kit`. Remove: `claude plugin uninstall onboarding-kit`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `/onboarding-kit:...` not found | Restart Claude Code after installing; check `/plugin` shows it enabled |
| Machine check says "not logged in" but Claude works | You probably sign in with a token or API key from your environment; ignore it |
| A settings change looks wrong | Restore the backup: `cp ~/.claude/settings.json.bak-<time> ~/.claude/settings.json` |
| Native Windows (not WSL) | Claude Code works, but the machine check script needs bash; the kit falls back to `claude doctor` |

## For contributors

```bash
claude plugin validate .                      # manifests
npx bats tests/doctor.bats                     # machine-check tests
tests/linux.sh                                 # same, in a clean Ubuntu container (Docker)
claude plugin eval . --ablation none           # trigger, safety and persona evals
tests/clean-machine.sh                         # install from the marketplace on clean Ubuntu
tests/clean-machine-flow.sh both               # full conversations; interactive, you /login inside the container
```

Every command and setting the kit mentions is checked against the docs in [docs/research](docs/research/2026-10-17-docs-factcheck.md). Re-check on new Claude Code releases.

## License

MIT
