#!/usr/bin/env zsh

_load_zsh_topic "pitchfork" --deps mise || return 0
eval "$(pitchfork activate zsh)"
