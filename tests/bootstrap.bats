#!/usr/bin/env bats

setup() {
  if [[ $EUID -eq 0 ]]; then
    skip 'Bootstrap runs as a normal user'
  fi
  export HOME="$BATS_TEST_TMPDIR/home"
  export BOOTSTRAP_LOG="$BATS_TEST_TMPDIR/commands"
  export BOOTSTRAP_OS=Darwin
  mkdir -p "$HOME" "$BATS_TEST_TMPDIR/bin"
  cp "$BATS_TEST_DIRNAME/../bootstrap" "$BATS_TEST_TMPDIR/bootstrap"
  for tool in bash dirname env ln mkdir mktemp rm; do
    ln -s "$(command -v "$tool")" "$BATS_TEST_TMPDIR/bin/$tool"
  done
  cat >"$BATS_TEST_TMPDIR/bin/stub" <<'EOF'
#!/bin/bash
set -eu
name=${0##*/}
printf '%s %s\n' "$name" "$*" >>"$BOOTSTRAP_LOG"
case "$name" in
uname) echo "$BOOTSTRAP_OS" ;;
git)
  [[ ${FAIL_CLONE:-0} != 1 ]] || exit 1
  mkdir -p "$3"
  printf 'home\n' >"$3/.chezmoiroot"
  ;;
chezmoi)
  case "$*" in
  *packageManager*) echo brew ;;
  *profile*) echo personal ;;
  *email*) echo test@example.com ;;
  esac
  ;;
op) [[ ${FAIL_AUTH:-0} != 1 ]] ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/stub"
  for tool in uname git brew chezmoi op; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  export PATH="$BATS_TEST_TMPDIR/bin"
}

@test "bootstrap clones over HTTPS and applies from the new checkout" {
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"git clone https://aaronmallen.dev/aaron/dotfiles.git $HOME/src/aaronmallen.dev/aaron/dotfiles"* ]]
  [[ "$log" == *"chezmoi init --source $HOME/src/aaronmallen.dev/aaron/dotfiles"* ]]
  [[ "$log" == *"chezmoi apply --source $HOME/src/aaronmallen.dev/aaron/dotfiles"* ]]
}

@test "bootstrap refuses an occupied clone destination before installing anything" {
  mkdir -p "$HOME/src/aaronmallen.dev/aaron/dotfiles"
  printf 'keep\n' >"$HOME/src/aaronmallen.dev/aaron/dotfiles/local-file"
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -ne 0 ]
  [ ! -e "$BOOTSTRAP_LOG" ]
  [ -f "$HOME/src/aaronmallen.dev/aaron/dotfiles/local-file" ]
}

@test "bootstrap reuses a local checkout without cloning or pulling" {
  printf 'home\n' >"$BATS_TEST_TMPDIR/.chezmoiroot"
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" != *"git "* ]]
  [[ "$log" == *"chezmoi apply --source $BATS_TEST_TMPDIR"* ]]
}

@test "bootstrap stops before apply when authentication fails" {
  export FAIL_AUTH=1
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -ne 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" != *"chezmoi apply"* ]]
}

@test "bootstrap stops before init when cloning fails" {
  export FAIL_CLONE=1
  run bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -ne 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" != *"chezmoi init"* ]]
}

@test "bootstrap prepares an APT machine before applying" {
  for tool in apt-get sudo mise; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env BOOTSTRAP_OS=Linux bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"sudo apt-get install -y"* ]]
  [[ "$log" == *"chezmoi apply"* ]]
}

@test "bootstrap prepares an Arch machine before applying" {
  for tool in pacman sudo mise yay; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$tool"
  done
  run env BOOTSTRAP_OS=Linux bash "$BATS_TEST_TMPDIR/bootstrap"
  [ "$status" -eq 0 ]
  log=$(<"$BOOTSTRAP_LOG")
  [[ "$log" == *"sudo pacman -Syu --needed --noconfirm"* ]]
  [[ "$log" == *"chezmoi apply"* ]]
}
