#!/usr/bin/env bash

_load_bash_topic "atuin" --source-env --deps mise --deps xdg || return 0
eval "$(atuin init bash)"
