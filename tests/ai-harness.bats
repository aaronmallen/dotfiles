#!/usr/bin/env bats

load helper

prepare_harness() {
  render work linux apt "$ROOT/home/.chezmoiscripts/run_after_setup-ai-harness.zsh.tmpl" |
    sed '/^if command -v claude /,$d' >"$BATS_TEST_TMPDIR/harness.zsh"
  export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
  export CODEX_HOME="$HOME/.config/codex"
  export MCP_LOG="$BATS_TEST_TMPDIR/mcp.log"
  mkdir -p "$BATS_TEST_TMPDIR/bin" "$CODEX_HOME"
  cat >"$BATS_TEST_TMPDIR/bin/client" <<'EOF'
#!/bin/sh
printf '%s %s\n' "${0##*/}" "$*" >>"$MCP_LOG"
case "$2" in
  remove) exit "${REMOVE_STATUS:-0}" ;;
  add) exit "${ADD_STATUS:-0}" ;;
  list) printf '%s\n' "$CODEX_SERVERS" ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/client"
  ln -s client "$BATS_TEST_TMPDIR/bin/claude"
  ln -s client "$BATS_TEST_TMPDIR/bin/codex"
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
  export WANT='{"type":"stdio","command":"npx","args":["-y","chrome-devtools-mcp@latest"],"env":{"NPM_CONFIG_CACHE":"/cache/npm"}}'
  cat >>"$BATS_TEST_TMPDIR/harness.zsh" <<'EOF'
claude_servers=$CLAUDE_SERVERS
codex_servers=$CODEX_SERVERS
if [[ $CLIENT == claude ]]; then
  claude_server chrome-devtools "$WANT" chrome-devtools --env NPM_CONFIG_CACHE=/cache/npm -- npx -y chrome-devtools-mcp@latest
else
  codex_server chrome-devtools "$WANT" --env NPM_CONFIG_CACHE=/cache/npm -- npx -y chrome-devtools-mcp@latest
fi
EOF
}

@test "MCP setup adds missing entries, replaces stale entries and skips matching entries" {
  prepare_harness
  for client in claude codex; do
    for state in missing stale matching; do
      export CLAUDE_SERVERS='{}' CODEX_SERVERS='[]'
      if [ "$state" != missing ]; then
        saved=$WANT
        [ "$state" != stale ] || saved=$(jq '.env = {}' <<<"$WANT")
        CLAUDE_SERVERS="$(jq -nc --argjson saved "$saved" '{"chrome-devtools": $saved}')"
        CODEX_SERVERS="$(jq -nc --argjson saved "$saved" '[{name: "chrome-devtools", transport: $saved}]')"
      fi
      : >"$MCP_LOG"
      run env CLIENT="$client" zsh "$BATS_TEST_TMPDIR/harness.zsh"
      [ "$status" -eq 0 ]
      case "$state" in
      missing)
        [ "$(wc -l <"$MCP_LOG")" -eq 1 ]
        grep -q "^$client mcp add " "$MCP_LOG"
        ;;
      stale)
        [ "$(wc -l <"$MCP_LOG")" -eq 2 ]
        head -n 1 "$MCP_LOG" | grep -q "^$client mcp remove "
        tail -n 1 "$MCP_LOG" | grep -q "^$client mcp add "
        if [ "$client" = claude ]; then
          grep -Fx 'claude mcp remove --scope user chrome-devtools' "$MCP_LOG"
        fi
        ;;
      matching) [ ! -s "$MCP_LOG" ] ;;
      esac
    done
  done
}

@test "MCP setup stops when removing a stale entry fails" {
  prepare_harness
  for client in claude codex; do
    : >"$MCP_LOG"
    run env CLIENT="$client" REMOVE_STATUS=42 \
      CLAUDE_SERVERS='{"chrome-devtools": {}}' \
      CODEX_SERVERS='[{"name":"chrome-devtools","transport":{}}]' \
      zsh "$BATS_TEST_TMPDIR/harness.zsh"
    [ "$status" -eq 42 ]
    [ "$(wc -l <"$MCP_LOG")" -eq 1 ]
  done
}
