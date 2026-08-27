#!/usr/bin/env zsh

_load_zsh_topic "zoxide" --source-env --deps mise --deps xdg || return 0
eval "$(zoxide init zsh)"
