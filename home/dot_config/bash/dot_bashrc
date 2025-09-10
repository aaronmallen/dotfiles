#!/bin/bash

if [[ "$BASH_BENCHMARK" == "true" ]]; then
  if [[ -z "$BASH_START_TIME" ]]; then
    BASH_START_TIME=$(date +%s.%N)
  fi
fi

bash_debug() {
  [[ "$BASH_DEBUG" == "true" ]] && printf "loading %s from %s\n" "$1" "$2"
}

[ -f "$HOME/.config/xdg/env.zsh" ] && source "$HOME/.config/xdg/env.zsh"

# set BASH directories
export BASH_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/bash

# collect all .zsh files (we'll still use .zsh extension to share configs)
typeset -a config_files
mapfile -t config_files < <(find "${XDG_CONFIG_HOME:-$HOME/.config}" -name "*.zsh" -type f 2>/dev/null)

# load the env files first
for file in "${config_files[@]}"; do
  if [[ "$file" == */env.zsh ]]; then
    bash_debug "env" "$file"
    source "$file"
  fi
done

# load the path files
for file in "${config_files[@]}"; do
  if [[ "$file" == */path.zsh ]]; then
    bash_debug "path" "$file"
    source "$file"
  fi
done

# load everything but the env, path and completion files
for file in "${config_files[@]}"; do
  if [[ "$file" != */env.zsh && "$file" != */path.zsh && "$file" != */completion.zsh ]]; then
    bash_debug "${file##*/}" "$file"
    source "$file"
  fi
done

# if secrets files exist, load them
for secrets in bash/secrets bash/secrets.local; do
  file="${XDG_CONFIG_HOME:-$HOME/.config}/$secrets"
  if [[ -f "$file" ]]; then
    bash_debug "secrets" "$file"
    source "$file"
  fi
done

# initialize bash completion
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  elif [[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
  fi
fi

# load completion files after bash completion is initialized
for file in "${config_files[@]}"; do
  if [[ "$file" == */completion.zsh ]]; then
    bash_debug "completion" "$file"
    source "$file"
  fi
done

unset config_files

if [[ "$BASH_BENCHMARK" == "true" ]]; then
  BASH_END_TIME=$(date +%s.%N)
  BASH_LOAD_TIME=$(printf "%.2f" "$(echo "$BASH_END_TIME - $BASH_START_TIME" | bc)")
  echo "bash loaded in ${BASH_LOAD_TIME} seconds"

  unset BASH_START_TIME BASH_END_TIME BASH_LOAD_TIME BASH_BENCHMARK BASH_DEBUG
fi
