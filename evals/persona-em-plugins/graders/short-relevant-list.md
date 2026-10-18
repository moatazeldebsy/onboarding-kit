---
type: llm
---

PASS if the reply's main recommendation is at most 3 plugins, includes code-review or github, includes a Jira/Atlassian connector, and does not claim to have installed anything (giving install commands for the user to run is fine; mentioning plugins to avoid or to try later is fine).
FAIL if the main recommendation has more than 3 plugins, has no Jira/Atlassian connector, or the reply says it installed plugins.
