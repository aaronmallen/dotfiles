#!/usr/bin/env bash

set -euo pipefail

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

if token=$(fnox get OP_HEADLESS_SERVICE_ACCOUNT_TOKEN 2>/dev/null) && [[ -n $token ]]; then
  [[ ${1:-} == signin ]] && exit 0
  export OP_SERVICE_ACCOUNT_TOKEN=$token
fi

exec op "$@"
