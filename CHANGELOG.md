# Changelog

## 0.1.0 (unreleased)

- Repo scaffold: plugin and marketplace manifests, README
- Content: token playbook, role guide, role × level plugin matrix, settings and CLAUDE.md templates, docs fact-check
- `doctor.sh`: read-only, role-aware machine health check, with bats tests (macOS + Ubuntu container)
- Skills: `getting-started`, `machine-setup`, `project-setup`, `token-saver`, with 12 trigger / no-trigger eval cases
- Entry point is `/onboarding-kit:getting-started` (no separate command file)
- Safety and persona evals; fixed: "just do it" no longer installs plugins without showing the list, no retrying installs from other sources, mandatory backup command and exact existing-path check in project-setup
