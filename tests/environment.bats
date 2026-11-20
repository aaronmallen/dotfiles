#!/usr/bin/env bats
# shellcheck disable=SC2016

load helper

@test "switching to app removes stale pitchfork startup hooks" {
  hooks=("$HOME/.config/pitchfork/init.bash" "$HOME/.config/pitchfork/init.zsh")
  for profile in personal app; do
    cm --override-data "$(data "$profile" linux apt)" apply --parent-dirs "${hooks[@]}"
    for hook in "${hooks[@]}"; do
      if [[ "$profile" == personal ]]; then
        [ -s "$hook" ]
      else
        [ ! -s "$hook" ]
      fi
    done
  done
}

@test "zsh login shells keep Homebrew ahead of system commands" {
  cm --override-data '{"packageManager":"brew"}' apply --parent-dirs --exclude scripts,externals \
    "$HOME/.config/zsh/.zshenv" "$HOME/.config/zsh/.zprofile" "$HOME/.config/zsh/topics.zsh" \
    "$HOME/.config/xdg/env.sh" "$HOME/.config/xdg/init.zsh" \
    "$HOME/.config/homebrew/env.sh" "$HOME/.config/homebrew/init.zsh"
  for mode in -c -lc; do
    run env -i HOME="$HOME" ZDOTDIR="$HOME/.config/zsh" PATH=/usr/bin:/bin /bin/zsh "$mode" '
      [[ ${path[(i)/opt/homebrew/bin]} -lt ${path[(i)/usr/bin]} ]]
    '
    [ "$status" -eq 0 ]
  done
}

@test "noninteractive shells load topic dependencies once without interactive setup" {
  cm apply --parent-dirs --exclude scripts,externals "$HOME/.config/zsh/.zshenv" \
    "$HOME/.config/zsh/topics.zsh" \
    "$HOME/.config/xdg/env.sh" "$HOME/.config/agents/env.sh" \
    "$HOME/.config/rust/env.sh" "$HOME/.config/npm/env.sh" "$HOME/.config/mise/env.sh" "$HOME/.config/matplotlib/env.sh" \
    "$HOME/.config/copilot" "$HOME/.config/gnupg/env.sh" "$HOME/.config/bash"
  for topic in xdg agents rust npm mise gnupg matplotlib; do
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
    [[ $NPM_CONFIG_CACHE == "$XDG_CACHE_HOME/javascript/npm" ]] &&
    [[ $MPLCONFIGDIR == "$XDG_CACHE_HOME/matplotlib" ]] &&
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
