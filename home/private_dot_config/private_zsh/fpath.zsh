#!/usr/bin/env zsh

fpath+="$HOME/.local/share/zsh-completions/src"

# add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($HOME/.config/*) if [ -d $topic_folder ]; then
  fpath+=$topic_folder
fi
