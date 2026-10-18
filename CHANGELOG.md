# Changelog

## 0.1.1 (2026-10-18)

- Directory review fixes: `doctor.sh` no longer checks API-key or login-token environment variables; the full-conversation test no longer reads or passes a token (you log in inside the container)
- The machine-setup skill gives the user the native installer command instead of running a downloaded script itself
- Plugin icon

## 0.1.0 (2026-10-18)

- Repo scaffold: plugin and marketplace manifests, README
- Content: token playbook, role guide, role × level plugin matrix, settings and CLAUDE.md templates, docs fact-check
- `doctor.sh`: read-only, role-aware machine health check, with bats tests (macOS + Ubuntu container)
- Skills: `getting-started`, `machine-setup`, `project-setup`, `token-saver`, with 12 trigger / no-trigger eval cases
- Entry point is `/onboarding-kit:getting-started` (no separate command file)
- Safety and persona evals; fixed: "just do it" no longer installs plugins without showing the list, no retrying installs from other sources, mandatory backup command and exact existing-path check in project-setup
- Clean-machine tests (`tests/clean-machine.sh`, `tests/clean-machine-flow.sh`): install from the marketplace on Ubuntu and full conversations as a beginner PM and an advanced engineer; fixed: the kit no longer changes project code, dependencies, build config or git history; doctor.sh recognises token logins
