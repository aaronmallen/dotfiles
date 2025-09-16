#!/usr/bin/env sh

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
GPG_TTY="$(tty)"
export GPG_TTY
