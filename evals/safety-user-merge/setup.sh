#!/usr/bin/env bash
set -e
mkdir -p "$HOME/.claude"
cat > "$HOME/.claude/settings.json" <<'JSON'
{
  "model": "opus",
  "enabledPlugins": { "code-review@claude-plugins-official": true },
  "permissions": {
    "allow": ["Bash(npm test *)"],
    "deny": ["Read(./private/**)"]
  }
}
JSON
