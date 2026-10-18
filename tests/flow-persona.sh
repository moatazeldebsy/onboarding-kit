#!/usr/bin/env bash
# Runs inside the clean container as a normal user. Called by clean-machine-flow.sh.
# Usage: flow-persona.sh install   (Claude Code + plugin)
#        flow-persona.sh run       (personas; needs a logged-in Claude)
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

install() {
curl -fsSL https://claude.ai/install.sh | bash >/tmp/install.log 2>&1 || { tail -20 /tmp/install.log; exit 1; }
cp -r /src "$HOME/onboarding-kit"
claude plugin marketplace add "$HOME/onboarding-kit" >/dev/null
claude plugin install onboarding-kit@onboarding-kit >/dev/null
# The official marketplace is what the kit recommends from.
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
}

# say <session file> <message>: one user turn, prints Claude's reply.
say() {
  local sf="$1"; shift
  local resume=()
  [ -s "$sf" ] && resume=(--resume "$(cat "$sf")")
  echo; echo ">>> USER: $*"; echo
  claude -p "$*" ${resume[@]+"${resume[@]}"} --output-format json --dangerously-skip-permissions --max-turns 40 > /tmp/turn.json || true
  python3 -c 'import json,sys; d=json.load(open("/tmp/turn.json")); open(sys.argv[1],"w").write(d.get("session_id","")); print(d.get("result","(no result)"))' "$sf"
}

check() { if eval "$2"; then echo "PASS  $1"; else echo "FAIL  $1"; fi; }

pm() {
  echo "################ beginner product manager ################"
  mkdir -p "$HOME/specs" && cd "$HOME/specs"
  printf "# Checkout redesign\n\nGoals: fewer drop-offs.\n" > checkout-prd.md
  printf "week,signups\n1,120\n2,135\n" > signups.csv
  sf=/tmp/pm.session; : > "$sf"
  say "$sf" "Hi, I am new to Claude Code. Help me get started."
  say "$sf" "I am a product manager and a complete beginner."
  say "$sf" "Yes, go ahead with what you suggested."
  say "$sf" "Yes, continue. This folder is where I keep my specs and data."
  say "$sf" "Yes to that too. Continue to the end."
  echo; echo "=== checks (pm) ==="
  check "profile saved as pm/beginner" "grep -q pm ~/.claude/onboarding-kit-profile.json && grep -q beginner ~/.claude/onboarding-kit-profile.json"
  check "user settings valid JSON" "python3 -m json.tool ~/.claude/settings.json >/dev/null"
  check "user settings deny .env" "grep -q 'Read(.*\.env' ~/.claude/settings.json"
  check "no plugins installed besides the kit" "[ \"\$(claude plugin list 2>/dev/null | grep -c '❯')\" -eq 1 ]"
  check "gh not installed" "! command -v gh >/dev/null"
  check "CLAUDE.md written for the workspace" "[ -f CLAUDE.md ]"
  check "CLAUDE.md under 60 lines" "[ -f CLAUDE.md ] && [ \$(wc -l < CLAUDE.md) -le 60 ]"
  echo "--- ~/.claude/settings.json"; cat ~/.claude/settings.json 2>/dev/null || true
  echo "--- CLAUDE.md"; cat CLAUDE.md 2>/dev/null || true
}

engineer() {
  echo "################ advanced engineer ################"
  rm -f ~/.claude/onboarding-kit-profile.json
  # Seed "existing" user settings without dropping enabledPlugins, which keeps the kit enabled.
  python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.claude/settings.json")
d = json.load(open(p)) if os.path.exists(p) else {}
d["model"] = "opus"
d["permissions"] = {"allow": ["Bash(npm test *)"], "deny": ["Read(./private/**)"]}
json.dump(d, open(p, "w"), indent=2)
PY
  mkdir -p "$HOME/app" && cd "$HOME/app" && git init -q .
  mkdir -p src node_modules/left-pad dist .claude
  echo '{"name":"app","scripts":{"test":"node --test","build":"tsc","lint":"eslint ."}}' > package.json
  echo 'export const add = (a, b) => a + b' > src/add.js
  echo '{"permissions":{"deny":["Read(./secrets/**)"]}}' > .claude/settings.json
  sf=/tmp/eng.session; : > "$sf"
  say "$sf" "Set up Claude Code for me. I am an engineer and an advanced user."
  say "$sf" "Yes to all of that, go ahead."
  say "$sf" "Skip anything that needs sudo. Yes, continue with the rest."
  say "$sf" "Yes, continue to the end."
  echo; echo "=== checks (engineer) ==="
  check "profile saved as engineer/advanced" "grep -q engineer ~/.claude/onboarding-kit-profile.json && grep -q advanced ~/.claude/onboarding-kit-profile.json"
  check "user settings kept model opus" "grep -q '\"opus\"' ~/.claude/settings.json"
  check "user settings kept allow rule" "grep -q 'npm test' ~/.claude/settings.json"
  check "user settings kept deny rule" "grep -q 'private' ~/.claude/settings.json"
  check "user settings backup made" "ls ~/.claude/settings.json.bak-* >/dev/null 2>&1"
  check "project settings kept secrets rule" "grep -q secrets .claude/settings.json"
  check "project denies node_modules and dist" "grep -q node_modules .claude/settings.json && grep -q dist .claude/settings.json"
  check "project has no rules for missing paths" "! grep -qE 'target/|vendor/|\.venv/|coverage/|build/' .claude/settings.json"
  check "project settings backup made" "ls .claude/settings.json.bak-* >/dev/null 2>&1"
  check "package.json unchanged" "[ \"\$(cat package.json)\" = '{\"name\":\"app\",\"scripts\":{\"test\":\"node --test\",\"build\":\"tsc\",\"lint\":\"eslint .\"}}' ]"
  check "source code unchanged" "[ \"\$(cat src/add.js)\" = 'export const add = (a, b) => a + b' ]"
  check "no build or lint config added" "[ ! -e tsconfig.json ] && [ ! -e eslint.config.js ] && [ ! -e .gitignore ]"
  check "nothing staged or committed" "[ -z \"\$(git diff --cached --name-only)\" ] && ! git rev-parse -q --verify HEAD >/dev/null"
  check "CLAUDE.md lists the real test command" "grep -q 'npm test\|node --test' CLAUDE.md"
  echo "--- plugins"; claude plugin list 2>/dev/null | grep -E "❯|Status" || true
  echo "--- ~/.claude/settings.json"; cat ~/.claude/settings.json
  echo "--- .claude/settings.json"; cat .claude/settings.json
  echo "--- CLAUDE.md"; cat CLAUDE.md 2>/dev/null || true
}

if [ "${1:-}" = install ]; then
  install
  exit 0
fi
case "${WHO:-both}" in
  pm) pm ;;
  engineer) engineer ;;
  *) pm; engineer ;;
esac
