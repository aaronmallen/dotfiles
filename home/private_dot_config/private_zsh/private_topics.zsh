#!/usr/bin/env zsh

_zsh_debug() {
  [[ "${ZSH_DEBUG:-}" == "true" ]] && printf "%s\n" "$1"
  return 0
}

ZSH_LOADED_TOPICS=""

_load_zsh_topic() {
  local topic=$1; shift

  [[ ":${ZSH_LOADED_TOPICS}:" == *":${topic}:"* ]] && return 1

  _zsh_debug "initializing: ${topic}"

  local -a deps=() source_env=() source_aliases=() source_functions=()
  zparseopts -D -E -source-env=source_env -source-aliases=source_aliases -source-functions=source_functions -deps+:=deps

  deps=(${deps:#--deps})
  local dep
  for dep in $deps; do
    if [[ ":${ZSH_LOADED_TOPICS}:" != *":${dep}:"* ]]; then
      local init_file="${XDG_CONFIG_HOME:-$HOME/.config}/$dep/init.zsh"
      [[ -f $init_file ]] && _zsh_debug "sourcing: ${init_file}" && source "${init_file}"
    fi
  done

  if [[ -n $source_env ]]; then
    local env_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/env.sh"
    [[ -f $env_file ]] && _zsh_debug "sourcing: ${env_file}" && source "$env_file"
  fi

  ZSH_LOADED_TOPICS="${ZSH_LOADED_TOPICS}${topic}:"
  [[ -o interactive ]] || return 1

  if [[ -n $source_aliases ]]; then
    local alias_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/aliases.sh"
    [[ -f $alias_file ]] && _zsh_debug "sourcing: ${alias_file}" && source "$alias_file"
  fi

  if [[ -n $source_functions ]]; then
    local functions_file="${XDG_CONFIG_HOME:-$HOME/.config}/${topic}/functions.sh"
    [[ -f $functions_file ]] && _zsh_debug "sourcing: ${functions_file}" && source "$functions_file"
  fi

  return 0
}
