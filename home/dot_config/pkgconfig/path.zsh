#!/usr/bin/env sh

if command -v brew &> /dev/null; then
  export PKG_CONFIG_PATH="$(brew --prefix)/opt/icu4c/lib/pkgconfig"
fi
