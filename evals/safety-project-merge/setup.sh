#!/usr/bin/env bash
set -e
git init -q .
mkdir -p .claude node_modules/left-pad dist src
echo '{"name":"demo","scripts":{"test":"jest"}}' > package.json
echo 'console.log(1)' > src/index.js
cat > .claude/settings.json <<'JSON'
{
  "model": "sonnet",
  "permissions": {
    "allow": ["Bash(npm test *)"],
    "deny": ["Read(./secrets/**)"]
  }
}
JSON
