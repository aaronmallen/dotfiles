#!/usr/bin/env bash

_load_bash_topic "pitchfork" --deps mise || return 0
eval "$(pitchfork activate bash)"
