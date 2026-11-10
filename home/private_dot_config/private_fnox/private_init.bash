#!/usr/bin/env bash

_load_bash_topic "fnox" --deps mise || return 0
command -v fnox >/dev/null && eval "$(fnox activate bash)"
