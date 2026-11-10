#!/usr/bin/env zsh

_load_zsh_topic "fnox" --deps mise || return 0
command -v fnox > /dev/null && eval "$(fnox activate zsh)"
