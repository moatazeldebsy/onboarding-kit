#!/usr/bin/env bash
# Run the getting-started flow end to end on a clean Ubuntu container, as two personas,
# then check what actually changed on the "machine".
#
# Interactive: after installing, it opens Claude Code inside the container. Type /login,
# finish signing in, then /exit. No credential is read or passed by this script; the login
# lives only in the throwaway container.
#
# Usage: tests/clean-machine-flow.sh [pm|engineer|both]
set -euo pipefail
cd "$(dirname "$0")/.."
WHO="${1:-both}"

docker run --rm -it -e WHO="$WHO" -v "$PWD":/src:ro ubuntu:24.04 bash -c '
set -euo pipefail
apt-get update -qq >/dev/null
apt-get install -y -qq curl ca-certificates git python3 >/dev/null 2>&1
useradd -m -s /bin/bash newuser
cd /home/newuser
as_user() { runuser -u newuser -- env HOME=/home/newuser USER=newuser WHO="$WHO" "$@"; }
as_user bash /src/tests/flow-persona.sh install
echo
echo ">>> Log in now: type /login, finish signing in, then type /exit."
as_user bash -c "cd ~ && ~/.local/bin/claude"
as_user bash /src/tests/flow-persona.sh run
'
