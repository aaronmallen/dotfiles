#!/usr/bin/env sh

# shellcheck source=/dev/null
[ -f "$XDG_CONFIG_HOME/rust/env.sh" ] && . "$XDG_CONFIG_HOME/rust/env.sh"

export MISE_CARGO_HOME="$CARGO_HOME"
export MISE_NODE_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/javascript/default_npm_packages"
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/python/default_packages"
export MISE_RUBY_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/ruby/default_gems"
export MISE_RUSTUP_HOME="$RUSTUP_HOME"
