#!/usr/bin/env bash

setup() {
  ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
  export HOME="$BATS_TEST_TMPDIR/home"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_CACHE_HOME="$HOME/.cache"
  export PATH="$ROOT/tests/stubs:$PATH"
  mkdir -p "$HOME"
  cat >"$BATS_TEST_TMPDIR/chezmoi.toml" <<'EOF'
[data]
fullName = "Dotfiles Test"
email = "test@example.com"
packageManager = "apt"
profile = "container"
EOF
}

cm() {
  command chezmoi --config "$BATS_TEST_TMPDIR/chezmoi.toml" \
    --source "$ROOT" --destination "$HOME" \
    --cache "$BATS_TEST_TMPDIR/cache" \
    --persistent-state "$BATS_TEST_TMPDIR/state.boltdb" --no-tty "$@"
}

data() {
  jq -nc --arg profile "$1" --arg os "$2" --arg manager "$3" \
    '{profile: $profile, packageManager: $manager, chezmoi: {os: $os, osRelease: {id: "ubuntu", versionID: "24.04"}}}'
}

render() {
  cm --override-data "$(data "$1" "$2" "$3")" execute-template --file "$4"
}
