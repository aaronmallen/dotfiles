#!/usr/bin/env bash

_load_bash_topic "zoxide" --source-env --deps mise --deps xdg || return 0
eval "$(zoxide init bash)"
