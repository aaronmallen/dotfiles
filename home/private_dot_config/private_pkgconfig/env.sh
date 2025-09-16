#!/usr/bin/env sh

if command -v brew > /dev/null 2>&1; then
  PKG_CONFIG_PATH="$(brew --prefix)/opt/icu4c/lib/pkgconfig"
  export PKG_CONFIG_PATH
fi
