#!/usr/bin/env zsh

if [ -f "$HOME/.config/mise/config.zsh" ]; then
  . "$HOME/.config/mise/config.zsh"
fi

eval "$(atuin init zsh)"
