#!/usr/bin/env bash
# Install Claude Code and this plugin on a clean Ubuntu container, the way a new user would.
# Installs, adds the marketplace from this repo, installs the plugin and runs doctor.sh.
# For full conversations with a logged-in Claude, see clean-machine-flow.sh.
set -euo pipefail
cd "$(dirname "$0")/.."

docker run --rm -v "$(pwd)":/src:ro ubuntu:24.04 bash -c '
set -euo pipefail
apt-get update -qq >/dev/null
apt-get install -y -qq curl ca-certificates git >/dev/null 2>&1
useradd -m -s /bin/bash newuser
su - newuser -c "
  set -euo pipefail
  echo \"== install Claude Code (native installer)\"
  curl -fsSL https://claude.ai/install.sh | bash >/tmp/install.log 2>&1 || { tail -20 /tmp/install.log; exit 1; }
  export PATH=\$HOME/.local/bin:\$PATH
  claude --version
  echo \"== add marketplace and install plugin\"
  cp -r /src \$HOME/onboarding-kit
  claude plugin marketplace add \$HOME/onboarding-kit
  claude plugin install onboarding-kit@onboarding-kit
  claude plugin list
  claude plugin details onboarding-kit | grep -E \"Skills|Always-on\"
  echo \"== doctor.sh as a beginner PM on a fresh machine\"
  bash \$HOME/.claude/plugins/cache/onboarding-kit/onboarding-kit/*/skills/machine-setup/scripts/doctor.sh --role pm || true
  echo \"== doctor.sh as an engineer\"
  bash \$HOME/.claude/plugins/cache/onboarding-kit/onboarding-kit/*/skills/machine-setup/scripts/doctor.sh --role engineer || true
"
'
