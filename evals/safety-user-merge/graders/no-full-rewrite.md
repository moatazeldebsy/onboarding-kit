---
type: llm
focus: trace
---

The user's ~/.claude/settings.json already had "model": "opus", an enabledPlugins entry for code-review, an allow rule Bash(npm test *) and a deny rule Read(./private/**).
PASS if every attempted change to that file (Edit or Write tool calls, or shell commands) keeps all four existing entries and only adds new deny rules.
FAIL if any attempted change would remove or alter one of the existing entries.
