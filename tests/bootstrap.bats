#!/usr/bin/env bats

setup() {
  if [[ $EUID -eq 0 ]]; then
    skip 'Bootstrap runs as a normal user'
  fi
  export HOME="$BATS_TEST_TMPDIR/home"
  export BOOTSTRAP_LOG="$BATS_TEST_TMPDIR/commands"
  export BOOTSTRAP_OS=Darwin
  mkdir -p "$HOME" "$BATS_TEST_TMPDIR/bin"
  cp "$BATS_TEST_DIRNAME/../home/.bootstrap.sh" "$BATS_TEST_TMPDIR/bootstrap"
  cat >"$BATS_TEST_TMPDIR/.install-password-manager.sh" <<'EOF'
echo password-manager >>"$BOOTSTRAP_LOG"
EOF
  for tool in bash dirname env ln mkdir mktemp rm sh; do
    ln -s "$(command -v "$tool")" "$BATS_TEST_TMPDIR/bin/$tool"
  done
  cat >"$BATS_TEST_TMPDIR/bin/stub" <<'EOF'
#!/bin/bash
set -eu
name=${0##*/}
printf '%s %s\n' "$name" "$*" >>"$BOOTSTRAP_LOG"
case "$name" in
uname) echo "$BOOTSTRAP_OS" ;;
curl)
  printf 'ln -s "%s/bin/stub" "%s/bin/mise"\n' "$BATS_TEST_TMPDIR" "$BATS_TEST_TMPDIR" >"$4"
  ;;
brew) [[ ${FAIL_INSTALL:-0} != 1 ]] ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/stub"
  for tool in uname git brew mise curl; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  export PATH="$BATS_TEST_TMPDIR/bin"
}

@test "bootstrap installs prerequisites before the password manager" {
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *$'brew install git gnupg zsh\n'* ]]
  [[ "$log" == *$'mise install jq@latest\npassword-manager' ]]
  [[ "$log" != *"chezmoi "* ]]
  [[ "$log" != *"git clone"* ]]
}

@test "bootstrap skips installed prerequisites" {
  for tool in gpg zsh jq; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" != *"brew "* ]]
  [[ "$log" != *"mise "* ]]
  [[ "$log" == *"password-manager"* ]]
}

@test "bootstrap installs mise directly when missing" {
  rm "$BATS_TEST_TMPDIR/bin/mise"
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"curl -fsSL https://mise.run -o "* ]]
  [[ "$log" == *"mise install jq@latest"* ]]
}

@test "bootstrap stops when prerequisites fail" {
  run env FAIL_INSTALL=1 bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -ne 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" != *"password-manager"* ]]
}

@test "bootstrap prepares an APT machine" {
  for tool in apt-get sudo; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env BOOTSTRAP_OS=Linux bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"sudo apt-get install -y"* ]]
  [[ "$log" == *"password-manager"* ]]
}

@test "bootstrap prepares an Arch machine" {
  for tool in pacman sudo yay; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env BOOTSTRAP_OS=Linux bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"sudo pacman -Syu --needed --noconfirm"* ]]
  [[ "$log" == *"password-manager"* ]]
}
