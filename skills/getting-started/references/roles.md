# Roles

What each role usually does with Claude Code. Use it to pick examples, required tools, the CLAUDE.md template and the first task to suggest.

| Role | Typical work | git + gh | CLAUDE.md template | Good first task |
|---|---|---|---|---|
| Engineer | Write, debug, refactor and review code; run tests; open PRs | Required | `CLAUDE.md.code.tmpl` | "Explain how this repo is structured, then find where X is handled" |
| QA / SDET | Write and fix automated tests, find flaky tests, reproduce bugs | Required | `CLAUDE.md.code.tmpl` | "List the untested functions in src/ and write a test for one" |
| Engineering manager | Review PRs, summarise what changed, standups, incident write-ups, planning docs | Recommended (to read repos) | code if inside a repo, else workspace | "Summarise the commits from the last 7 days by area" |
| Product manager | PRDs, specs, user stories, release notes, research summaries, triaging tickets | Optional | `CLAUDE.md.workspace.tmpl` | "Turn these meeting notes into a one-page spec with open questions" |
| Designer | UI prototypes, HTML mockups, design-system docs, copy review | Optional | workspace, or code if they prototype in a repo | "Build a clickable HTML mockup of this screen" |
| Analyst / data | Clean CSVs, write SQL and Python, explain metrics, make charts | Optional | `CLAUDE.md.workspace.tmpl` | "Load data.csv, check it for missing values, and chart the weekly trend" |
| Writer / other | Docs, guides, editing, organising notes and files | Optional | `CLAUDE.md.workspace.tmpl` | "Read the files in this folder and propose a clearer structure" |

## Non-engineer notes

- Say "folder" before "repo", and explain terms like terminal and commit the first time they come up.
- The Desktop app or the VS Code extension is often easier than the terminal for a first session; mention both.
- Never push git, gh or Node on someone who doesn't need them. Offer them, say why, and accept a no.
- Explain permission prompts: Claude asks before running commands or editing files, and "always allow" can be set per command.
