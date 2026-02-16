#!/usr/bin/env zsh

_load_zsh_topic "mise" --source-env --source-aliases --deps rust --deps xdg <<'BLOCK'
  eval "$(${XDG_BIN_HOME}/mise activate zsh)"
BLOCK
