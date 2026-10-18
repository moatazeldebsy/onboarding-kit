#!/usr/bin/env bash
# Run shellcheck and the bats suite inside a clean Ubuntu container.
set -euo pipefail
cd "$(dirname "$0")/.."
docker run --rm -v "$(pwd)":/src:ro -w /src ubuntu:24.04 bash -c '
  apt-get update -qq >/dev/null &&
  apt-get install -y -qq bats shellcheck >/dev/null &&
  shellcheck skills/machine-setup/scripts/doctor.sh &&
  shellcheck -s bash tests/doctor.bats &&
  bats tests/doctor.bats &&
  echo "--- doctor.sh on a bare machine (expected: claude fail) ---" &&
  { bash skills/machine-setup/scripts/doctor.sh --role engineer || true; }
'
