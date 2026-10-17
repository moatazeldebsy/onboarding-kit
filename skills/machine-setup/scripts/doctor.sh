#!/usr/bin/env bash
# Read-only health check for a Claude Code setup. Changes nothing.
#
# Usage: doctor.sh [--role engineer|qa|em|pm|designer|analyst|other]
#
# Prints one tab-separated line per check:  status<TAB>id<TAB>detail<TAB>fix
#   status is ok | warn | fail | info
# Last line:  summary<TAB><fails> fail<TAB><warns> warn
# Exits 1 if any check failed, else 0.

set -u

ROLE="other"
while [ $# -gt 0 ]; do
  case "$1" in
    --role) ROLE="${2:-other}"; shift 2 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

PROC_VERSION_FILE="${PROC_VERSION_FILE:-/proc/version}"
FAILS=0
WARNS=0

report() {
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "${4:-}"
  case "$1" in
    fail) FAILS=$((FAILS + 1)) ;;
    warn) WARNS=$((WARNS + 1)) ;;
  esac
}

# Severity for a missing developer tool, by role.
dev_tool_severity() {
  case "$ROLE" in
    engineer|qa) echo fail ;;
    em) echo warn ;;
    *) echo info ;;
  esac
}

resolve() {
  readlink -f "$1" 2>/dev/null || echo "$1"
}

# --- OS and shell ---
os="$(uname -s)"
case "$os" in
  Darwin) report ok os "macOS $(sw_vers -productVersion 2>/dev/null)" ;;
  Linux)
    if grep -qi microsoft "$PROC_VERSION_FILE" 2>/dev/null; then
      report ok os "Linux (WSL)"
    else
      report ok os "Linux"
    fi ;;
  *) report warn os "$os is not tested by this kit" "Use macOS, Linux or WSL" ;;
esac
report info shell "$(basename "${SHELL:-unknown}")"

# --- Claude Code install ---
if ! command -v claude >/dev/null 2>&1; then
  report fail claude "claude not found on PATH" "curl -fsSL https://claude.ai/install.sh | bash"
else
  claude_path="$(command -v claude)"
  version="$(claude --version 2>/dev/null | head -1)"
  report ok claude "${version:-unknown version} at $claude_path"

  real="$(resolve "$claude_path")"
  case "$real" in
    *node_modules*) report warn install_method "npm install (no auto-update, needs Node 22+)" \
                      "Switch to the native installer: curl -fsSL https://claude.ai/install.sh | bash, then npm uninstall -g @anthropic-ai/claude-code" ;;
    *Caskroom*|*Cellar*|*homebrew*|*linuxbrew*) report info install_method "Homebrew (update with: brew upgrade claude-code)" ;;
    *.local/share/claude*|*.claude/local*) report ok install_method "native (auto-updates)" ;;
    *) report info install_method "unknown ($real)" ;;
  esac

  # Distinct binaries named claude on PATH, after resolving symlinks.
  count="$(type -a -p claude 2>/dev/null | while read -r p; do resolve "$p"; done | sort -u | grep -c .)"
  if [ "${count:-0}" -gt 1 ]; then
    report warn duplicate_install "$count different claude binaries on PATH" "Keep one install; run: type -a claude"
  fi

  auth="$(claude auth status 2>/dev/null)"
  if printf '%s' "$auth" | grep -q '"loggedIn": *true'; then
    method="$(printf '%s' "$auth" | sed -n 's/.*"authMethod": *"\([^"]*\)".*/\1/p' | head -1)"
    report ok login "logged in${method:+ ($method)}"
  else
    report fail login "not logged in" "Run claude, then /login"
  fi
fi

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  report info api_key "ANTHROPIC_API_KEY is set: usage is billed to the API key, not a subscription" \
    "Unset it if you meant to use a Pro/Max/Team plan"
fi

if [ -d "$HOME/.claude" ]; then
  report ok claude_dir "$HOME/.claude exists"
else
  report info claude_dir "$HOME/.claude not created yet (appears after first run)"
fi

# --- Developer tools ---
if command -v git >/dev/null 2>&1; then
  report ok git "$(git --version)"
else
  report "$(dev_tool_severity)" git "git not installed" "macOS: xcode-select --install   Linux: sudo apt install git"
fi

if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    report ok gh "GitHub CLI installed and logged in"
  else
    sev="$(dev_tool_severity)"; [ "$sev" = fail ] && sev=warn
    report "$sev" gh "GitHub CLI installed but not logged in" "gh auth login"
  fi
else
  report "$(dev_tool_severity)" gh "GitHub CLI not installed" "macOS: brew install gh   Linux: see https://cli.github.com"
fi

if command -v node >/dev/null 2>&1; then
  report info node "node $(node --version 2>/dev/null) (only needed for npm installs and some MCP servers)"
else
  report info node "node not installed (only needed for npm installs and some MCP servers)"
fi

printf 'summary\t%s fail\t%s warn\n' "$FAILS" "$WARNS"
[ "$FAILS" -eq 0 ]
