#!/usr/bin/env bats

load helper

@test "Rex config is ignored on Linux" {
  run render personal linux apt "$ROOT/home/.chezmoiignore"
  [ "$status" -eq 0 ]
  [[ "$output" == *$'\n.config/rex\n'* ]]
}

@test "Raycast Rex source and build are only installed on macOS" {
  for file in .chezmoiexternals/raycast-rex-sessions.toml.tmpl .chezmoiscripts/run_onchange_after_setup-raycast-rex.zsh.tmpl; do
    run render personal linux apt "$ROOT/home/$file"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    run render personal darwin brew "$ROOT/home/$file"
    [ "$status" -eq 0 ]
    [[ "$output" == *"rex-sessions"* ]]
  done
}
