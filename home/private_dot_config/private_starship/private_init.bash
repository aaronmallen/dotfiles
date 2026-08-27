#!/usr/bin/env bash

_load_bash_topic "starship" --source-env --deps mise --deps xdg || return 0
eval "$(starship init bash)"
