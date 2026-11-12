#!/usr/bin/env bats

load helper

@test "Rex and sshpick are only installed on macOS" {
  run render personal linux apt "$ROOT/home/.chezmoiignore"
  [ "$status" -eq 0 ]
  [[ "$output" == *$'\n.config/rex\n'* ]]
  run render personal linux apt "$ROOT/home/.chezmoiexternals/sshpick.toml.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" != *"sshpick"* ]]
  run render personal darwin brew "$ROOT/home/.chezmoiexternals/sshpick.toml.tmpl"
  [ "$status" -eq 0 ]
  [[ "$output" == *'[".local/share/sshpick/sshpick"]'* ]]
  [[ "$output" == *'[".config/rex/sshpick.lua"]'* ]]
}
