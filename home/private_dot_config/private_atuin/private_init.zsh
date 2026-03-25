#!/usr/bin/env zsh

_load_zsh_topic "atuin" --source-env --deps mise
eval "$(atuin init zsh)"
eval "$(atuin ai init)"
