#!/usr/bin/env bats
# shellcheck disable=SC2016

load helper

@test "noninteractive shells load topic dependencies once without interactive setup" {
  cm apply --parent-dirs --exclude scripts,externals "$HOME/.config/zsh/.zshenv" \
    "$HOME/.config/zsh/topics.zsh" \
    "$HOME/.config/xdg/env.sh" "$HOME/.config/agents/env.sh" \
    "$HOME/.config/rust/env.sh" "$HOME/.config/npm/env.sh" "$HOME/.config/mise/env.sh" \
    "$HOME/.config/copilot" "$HOME/.config/gnupg/env.sh" "$HOME/.config/bash"
  for topic in xdg agents rust npm mise gnupg; do
    cm apply --exclude scripts,externals "$HOME/.config/$topic/init.zsh" "$HOME/.config/$topic/init.bash"
  done
  mkdir -p "$HOME/.config/a-dependent" "$HOME/.config/z-dependency"
  printf 'export DEPENDENCY_HOME="${XDG_DATA_HOME}/dependency"\nDEPENDENCY_LOADS=$(( ${DEPENDENCY_LOADS:-0} + 1 ))\n' >"$HOME/.config/z-dependency/env.sh"
  cat >>"$HOME/.config/z-dependency/env.sh" <<'EOF'
CHILD_LOADING_ENV=$(/bin/bash -c 'printf "%s" "${DOTFILES_LOADING_ENV:-missing}"')
EOF
  printf '_load_zsh_topic z-dependency --source-env --deps xdg || return 0\necho "interactive setup ran"\n' >"$HOME/.config/z-dependency/init.zsh"
  printf 'export NEW_TOPIC_HOME="${DEPENDENCY_HOME}/new-topic"\n' >"$HOME/.config/a-dependent/env.sh"
  printf '_load_zsh_topic a-dependent --source-env --source-aliases --source-functions --deps z-dependency || return 0\necho "interactive setup ran"\n' >"$HOME/.config/a-dependent/init.zsh"
  printf 'echo "aliases loaded"\n' >"$HOME/.config/a-dependent/aliases.sh"
  printf 'echo "functions loaded"\n' >"$HOME/.config/a-dependent/functions.sh"
  for topic in a-dependent z-dependency; do
    sed s/_load_zsh_topic/_load_bash_topic/g "$HOME/.config/$topic/init.zsh" >"$HOME/.config/$topic/init.bash"
  done
  for shell in zsh bash; do
    run env -i HOME="$HOME" ZDOTDIR="$HOME/.config/zsh" BASH_ENV="$HOME/.config/bash/bashenv" "/bin/$shell" -eu -c '
    [[ $MCP_REMOTE_CONFIG_DIR == "$HOME/.config/mcp-auth" ]] &&
    [[ $COPILOT_HOME == "$HOME/.config/copilot" ]] &&
    [[ $RUSTUP_HOME == "$HOME/.local/share/rustup" ]] &&
    [[ $CARGO_HOME == "$HOME/.local/share/cargo" ]] &&
    [[ $NPM_CONFIG_USERCONFIG == "$HOME/.config/npm/npmrc" ]] &&
    [[ $MISE_RUSTUP_HOME == "$RUSTUP_HOME" ]] &&
    [[ $MISE_CARGO_HOME == "$CARGO_HOME" ]] &&
    [[ $NEW_TOPIC_HOME == "$HOME/.local/share/dependency/new-topic" ]] &&
    [[ $DEPENDENCY_LOADS == 1 ]] &&
    [[ $CHILD_LOADING_ENV == 1 ]] &&
    [[ -z ${GPG_TTY:-} ]] &&
    [[ $BASH_ENV == "$HOME/.config/bash/bashenv" ]] &&
    [[ -z ${DOTFILES_LOADING_ENV:-} ]]
  ' </dev/null
    [ "$status" -eq 0 ]
    [ -z "$output" ]
  done
  [ "$(readlink "$HOME/.config/copilot/copilot-instructions.md")" = ../agents/AGENTS.md ]
  [ "$(readlink "$HOME/.config/copilot/skills")" = ../agents/skills ]
}
