#!/usr/bin/env zsh

_load_zsh_topic "zoxide" --source-env --deps mise --deps xdg <<'BLOCK'
  eval "$(zoxide init zsh)"
BLOCK
