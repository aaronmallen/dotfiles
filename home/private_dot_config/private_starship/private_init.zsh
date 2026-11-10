#!/usr/bin/env zsh

_load_zsh_topic "starship" --source-env --deps mise --deps xdg || return 0
eval "$(starship init zsh)"
