if [[ "$ZSH_BENCHMARK" == "true" && -z "$ZSH_START_TIME" ]]; then
  export ZSH_START_TIME=$(date +%s.%N)
fi

[ -f "$HOME/.config/xdg/env.zsh" ] && source "$HOME/.config/xdg/env.zsh"
