#!/usr/bin/env sh

if [ -t 0 ]; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
