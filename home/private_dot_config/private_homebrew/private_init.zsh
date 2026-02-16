#!/usr/bin/env zsh

_load_zsh_topic "homebrew" --source-env --deps xdg <<'BLOCK'
  eval "$(brew shellenv)"
BLOCK
