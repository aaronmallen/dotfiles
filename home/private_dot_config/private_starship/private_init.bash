#!/usr/bin/env bash

_load_bash_topic "starship" --source-env --deps mise --deps xdg
eval "$(starship init bash)"
