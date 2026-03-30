#!/usr/bin/env bash

_load_bash_topic "atuin" --source-env --deps mise
eval "$(atuin init bash)"
eval "$(atuin ai init)"
