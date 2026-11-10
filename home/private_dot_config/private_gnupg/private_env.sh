#!/usr/bin/env sh

GPG_TTY="$(tty)"

export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GPG_TTY
