#!/usr/bin/env zsh

if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f $XDG_CONFIG_HOME/shell/zsh/p10k.zsh ]] && source $XDG_CONFIG_HOME/shell/zsh/p10k.zsh
