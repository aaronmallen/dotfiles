#!/usr/bin/env bash

set -euo pipefail

command -v fnox >/dev/null || exit 0
fnox get OP_HEADLESS_SERVICE_ACCOUNT_TOKEN >/dev/null 2>&1 && exit 0

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work"
op read "op://Private/b52yw2gu2ej27odkdrf354sd3m/headless service account token" |
  fnox set OP_HEADLESS_SERVICE_ACCOUNT_TOKEN --provider keychain >/dev/null
