#!/usr/bin/env bash
# Run the getting-started flow end to end on a clean Ubuntu container, as two personas,
# then check what actually changed on the "machine".
#
# Needs a Claude login token, read from the file in $TOKEN_FILE
# (default ~/.config/onboarding-kit/test-token, created with `claude setup-token`).
# The token is passed to the container as an environment variable and never printed.
#
# Usage: tests/clean-machine-flow.sh [pm|engineer|both]
set -euo pipefail
cd "$(dirname "$0")/.."

TOKEN_FILE="${TOKEN_FILE:-$HOME/.config/onboarding-kit/test-token}"
[ -r "$TOKEN_FILE" ] || { echo "No token file at $TOKEN_FILE" >&2; exit 2; }
CLAUDE_CODE_OAUTH_TOKEN="$(tr -d '[:space:]' < "$TOKEN_FILE")"
export CLAUDE_CODE_OAUTH_TOKEN
WHO="${1:-both}"

docker run --rm -e CLAUDE_CODE_OAUTH_TOKEN -e WHO="$WHO" -v "$PWD":/src:ro ubuntu:24.04 bash -c '
set -euo pipefail
apt-get update -qq >/dev/null
apt-get install -y -qq curl ca-certificates git python3 >/dev/null 2>&1
useradd -m -s /bin/bash newuser
cd /home/newuser
# runuser keeps the environment, so the token reaches the user without appearing on a command line.
runuser -u newuser -- env HOME=/home/newuser USER=newuser bash /src/tests/flow-persona.sh
'
