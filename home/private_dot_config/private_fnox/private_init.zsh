#!/usr/bin/env zsh

_load_zsh_topic "fnox" --deps mise || return 0
[[ -z "$SSH_CONNECTION" ]] && command -v fnox > /dev/null && eval "$(fnox activate zsh)"
