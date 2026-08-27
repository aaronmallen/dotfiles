#!/usr/bin/env bash

_load_bash_topic "homebrew" --source-env --deps xdg || return 0
eval "$(brew shellenv)"
