#!/usr/bin/env bats
# shellcheck disable=SC2016

load helper

@test "bash and zsh load topic functions once and mkfile preserves existing contents" {
  mkdir -p "$XDG_CONFIG_HOME/system"
  cp "$ROOT/home/private_dot_config/private_system/private_functions.sh" "$XDG_CONFIG_HOME/system/functions.sh"
  printf '\nFUNCTION_LOADS=$(( ${FUNCTION_LOADS:-0} + 1 ))\n' >>"$XDG_CONFIG_HOME/system/functions.sh"

  for shell in bash zsh; do
    sed '/^# Load zsh-completions/,$d; /^# Source bash completions/,$d; /^\[\[ \$- ==/d' \
      "$ROOT/home/private_dot_config/private_${shell}/private_dot_${shell}rc" >"$BATS_TEST_TMPDIR/loader"
    run "$shell" -c '
      source "$1"
      loader="_load_${2}_topic"
      "$loader" system
      ! typeset -f mkfile >/dev/null || exit 1
      BASH_LOADED_TOPICS=""
      ZSH_LOADED_TOPICS=""
      "$loader" system --source-functions || exit 1
      ! "$loader" system --source-functions || exit 1
      [[ $FUNCTION_LOADS == 1 ]] || exit 1
      "$loader" missing --source-functions || exit 1
      cd "$HOME" || exit 1
      mkfile "nested dir/$2/file.txt" || exit 1
      [[ -f "nested dir/$2/file.txt" ]] || exit 1
      printf keep >"nested dir/$2/file.txt"
      mkfile "nested dir/$2/file.txt" || exit 1
      [[ $(cat "nested dir/$2/file.txt") == keep ]] || exit 1
      ! mkfile || exit 1
      ! mkfile "" || exit 1
      ! mkfile one two || exit 1
      ! mkfile "nested dir/$2/file.txt/child" || exit 1
    ' _ "$BATS_TEST_TMPDIR/loader" "$shell"
    [ "$status" -eq 0 ]
  done
}
