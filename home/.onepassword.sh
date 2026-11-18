#!/usr/bin/env bash

set -euo pipefail

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

exec op "$@"
