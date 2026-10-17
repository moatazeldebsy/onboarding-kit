# onboarding-kit

A Claude Code plugin that takes you from "just installed" to a working, low-cost setup in one guided session, whatever your role (engineer, QA, engineering manager, product manager, designer, analyst) and level (beginner, intermediate, advanced).

> Status: under construction (v0.1.0). See [the plan](docs/plans/2026-10-17-onboarding-kit.md).

## Install

```
/plugin marketplace add moatazeldebsy/onboarding-kit
/plugin install onboarding-kit@onboarding-kit
```

Then run `/starter`, or just say "help me get started with Claude Code".

## What it does

- **Machine check**: a read-only health check of your install, login and tools, with fixes offered one at a time
- **Settings and CLAUDE.md**: sensible defaults merged into your existing files, shown as a diff before anything is written
- **Plugin picks**: a short, neutral list matched to your role and level
- **Token habits**: the commands and settings that keep usage and cost down

Nothing is installed or changed without your confirmation.

## License

MIT
