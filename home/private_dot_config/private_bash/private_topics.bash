#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

_bash_debug() {
  [[ "${BASH_DEBUG:-}" == "true" ]] && printf "%s\n" "$1"
  return 0
}

BASH_LOADED_TOPICS=""

_load_bash_topic() {
  local topic=$1
  shift

  [[ ":${BASH_LOADED_TOPICS}:" == *":${topic}:"* ]] && return 1

  _bash_debug "initializing: ${topic}"

  local source_env="" source_aliases="" source_functions=""
  local -a deps=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --source-env)
      source_env=1
      shift
      ;;
    --source-aliases)
      source_aliases=1
      shift
      ;;
    --source-functions)
      source_functions=1
      shift
      ;;
    --deps)
      deps+=("$2")
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local dep
  for dep in ${deps[@]+"${deps[@]}"}; do
    if [[ ":${BASH_LOADED_TOPICS}:" != *":${dep}:"* ]]; then
      local init_file="${XDG_CONFIG_HOME:-$HOME/.config}/${dep}/init.bash"
      [[ -f "$init_file" ]] && _bash_debug "sourcing: ${init_file}" && source "${init_file}"
    fi
  done

  if [[ -n "$source_env" ]]; then
    local env_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/env.sh"
    [[ -f "$env_file" ]] && _bash_debug "sourcing: ${env_file}" && source "$env_file"
  fi

  BASH_LOADED_TOPICS="${BASH_LOADED_TOPICS}${topic}:"
  [[ $- == *i* ]] || return 1

  if [[ -n "$source_aliases" ]]; then
    local alias_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/aliases.sh"
    [[ -f "$alias_file" ]] && _bash_debug "sourcing: ${alias_file}" && source "$alias_file"
  fi

  if [[ -n "$source_functions" ]]; then
    local functions_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/functions.sh"
    [[ -f "$functions_file" ]] && _bash_debug "sourcing: ${functions_file}" && source "$functions_file"
  fi

  return 0
}
