#!/usr/bin/env zsh

_load_zsh_topic "starship" --source-env --deps mise --deps xdg
eval "$(starship init zsh)"
