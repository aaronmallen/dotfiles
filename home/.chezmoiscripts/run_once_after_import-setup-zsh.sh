#!/usr/bin/env sh

set -e

sudo mkdir -p /etc/zsh

if ! sudo grep -q 'export ZDOTDIR=' /etc/zsh/zshenv 2>/dev/null; then
    echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a /etc/zsh/zshenv > /dev/null
fi

sudo chsh -s "$(which zsh)"
