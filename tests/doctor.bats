#!/usr/bin/env bats
# Tests for skills/machine-setup/scripts/doctor.sh using stub binaries on a minimal PATH.

DOCTOR="$BATS_TEST_DIRNAME/../skills/machine-setup/scripts/doctor.sh"

setup() {
  TMP="$(mktemp -d)"
  BIN="$TMP/bin"
  mkdir -p "$BIN" "$TMP/home/.claude"
  # Only the system tools doctor.sh needs, so git/gh/node/claude are absent unless stubbed.
  for tool in bash uname sw_vers grep sed sort head readlink basename; do
    p="$(command -v "$tool" 2>/dev/null)" && ln -s "$p" "$BIN/$tool"
  done
  export HOME="$TMP/home"
  export LOGGED_IN=true
}

teardown() {
  rm -rf "$TMP"
}

# make_claude <real path> [link dir]: stub claude at <real path>, symlinked into <link dir> (default $BIN).
make_claude() {
  mkdir -p "$(dirname "$1")"
  cat > "$1" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  --version) echo "9.9.9 (Claude Code)" ;;
  auth) printf '{\n  "loggedIn": %s,\n  "authMethod": "claude.ai"\n}\n' "$LOGGED_IN" ;;
esac
EOF
  chmod +x "$1"
  ln -s "$1" "${2:-$BIN}/claude"
}

make_native_claude() {
  make_claude "$TMP/home/.local/share/claude/versions/9.9.9"
}

# stub <name> <exit code> [output]
stub() {
  printf '#!/usr/bin/env bash\necho "%s"\nexit %s\n' "${3:-$1 stub}" "$2" > "$BIN/$1"
  chmod +x "$BIN/$1"
}

run_doctor() {
  run env PATH="$BIN" "$BASH" "$DOCTOR" "$@"
}

line() {
  printf '%s\n' "$output" | grep "^$1	$2	"
}

@test "missing claude fails with the installer command" {
  run_doctor
  [ "$status" -eq 1 ]
  line fail claude | grep -q "code.claude.com/docs/en/setup"
}

@test "native install, logged in, tools present: all ok, exit 0" {
  make_native_claude
  stub git 0 "git version 2.0"
  stub gh 0
  run_doctor --role engineer
  [ "$status" -eq 0 ]
  line ok claude | grep -q "9.9.9"
  line ok install_method | grep -q native
  line ok login | grep -q "claude.ai"
  line ok git
  line ok gh
  printf '%s\n' "$output" | tail -1 | grep -q "0 fail"
}

@test "npm install is a warning with a switch command" {
  make_claude "$TMP/lib/node_modules/@anthropic-ai/claude-code/cli.js"
  run_doctor
  line warn install_method | grep -q "native installer"
}

@test "two different claude binaries on PATH warn" {
  make_native_claude
  mkdir -p "$TMP/bin2"
  make_claude "$TMP/lib/node_modules/@anthropic-ai/claude-code/cli.js" "$TMP/bin2"
  run env PATH="$BIN:$TMP/bin2" "$BASH" "$DOCTOR"
  line warn duplicate_install
}

@test "not logged in fails" {
  make_native_claude
  LOGGED_IN=false run_doctor
  [ "$status" -eq 1 ]
  line fail login | grep -q "/login"
}

@test "missing git fails for an engineer" {
  make_native_claude
  stub gh 0
  run_doctor --role engineer
  [ "$status" -eq 1 ]
  line fail git
}

@test "missing git and gh are only info for a product manager" {
  make_native_claude
  run_doctor --role pm
  [ "$status" -eq 0 ]
  line info git
  line info gh
}

@test "gh present but logged out warns for an engineer" {
  make_native_claude
  stub git 0
  stub gh 1
  run_doctor --role engineer
  line warn gh | grep -q "gh auth login"
}

@test "WSL is detected from /proc/version" {
  [ "$(uname -s)" = Linux ] || skip "Linux only"
  echo "Linux version 5.15 microsoft-standard-WSL2" > "$TMP/version"
  PROC_VERSION_FILE="$TMP/version" run_doctor
  line ok os | grep -q WSL
}

@test "unknown argument exits 2" {
  run_doctor --bogus
  [ "$status" -eq 2 ]
}
