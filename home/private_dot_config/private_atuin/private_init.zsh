#!/usr/bin/env zsh

_load_zsh_topic "atuin" --source-env --deps mise --deps xdg || return 0
eval "$(atuin init zsh)"
