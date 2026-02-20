#!/usr/bin/env bash

_load_bash_topic "mise" --source-env --source-aliases --deps rust --deps xdg
eval "$(${XDG_BIN_HOME}/mise activate bash)"
