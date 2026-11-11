#!/usr/bin/env bats

setup() {
  export INSTALL_LOG="$BATS_TEST_TMPDIR/commands"
  export INSTALL_OS=Darwin
  SCRIPT="$BATS_TEST_DIRNAME/../home/.install-password-manager.sh"
  mkdir -p "$BATS_TEST_TMPDIR/bin"
  for tool in bash env ln mktemp rm; do
    ln -s "$(command -v "$tool")" "$BATS_TEST_TMPDIR/bin/$tool"
  done
  cat >"$BATS_TEST_TMPDIR/bin/stub" <<'EOF'
#!/bin/bash
set -eu
name=${0##*/}
printf '%s %s\n' "$name" "$*" >>"$INSTALL_LOG"
case "$name" in
uname) echo "$INSTALL_OS" ;;
dpkg) echo arm64 ;;
brew | sudo | paru | yay) exit "${FAIL_INSTALL:-0}" ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/stub"
  for tool in uname brew; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  export PATH="$BATS_TEST_TMPDIR/bin"
}

@test "password manager hook exits without running commands when op exists" {
  ln -s stub "$BATS_TEST_TMPDIR/bin/op"
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [ ! -e "$INSTALL_LOG" ]
}

@test "password manager hook installs with Homebrew and propagates failure" {
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ $(<"$INSTALL_LOG") == *"brew install --cask 1password-cli"* ]]
  run env FAIL_INSTALL=1 bash "$SCRIPT"
  [ "$status" -ne 0 ]
}

@test "password manager hook sets up the signed APT repository before installing" {
  for tool in apt-get sudo curl gpg dpkg; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env INSTALL_OS=Linux bash "$SCRIPT"
  [ "$status" -eq 0 ]
  log=$(<"$INSTALL_LOG")
  [[ "$log" == *"sudo install -m 644"*"/usr/share/keyrings/1password-archive-keyring.gpg"*"sudo apt-get install -y 1password-cli"* ]]
}

@test "password manager hook uses an installed AUR helper" {
  for tool in pacman paru; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env INSTALL_OS=Linux bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ $(<"$INSTALL_LOG") == *"paru -S --needed 1password-cli"* ]]
}

@test "password manager hook rejects unsupported systems" {
  run env INSTALL_OS=FreeBSD bash "$SCRIPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Installing 1Password CLI supports"* ]]
}
