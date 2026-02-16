#!/usr/bin/env zsh

_load_zsh_topic "starship" --source-env --deps mise --deps xdg <<'BLOCK'
  eval "$(starship init zsh)"
BLOCK
