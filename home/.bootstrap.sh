#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo 'Run chezmoi as your normal user, not with sudo.' >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export PATH="$HOME/.local/bin:$PATH"

case "$(uname -s)" in
Darwin)
  if ! command -v brew >/dev/null; then
    for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [[ -x "$brew" ]]; then
        eval "$("$brew" shellenv bash)"
        break
      fi
    done
  fi
  if ! command -v brew >/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$work/homebrew"
    bash "$work/homebrew"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv bash)"
    else
      eval "$(/usr/local/bin/brew shellenv bash)"
    fi
  fi
  if ! command -v git >/dev/null || ! command -v gpg >/dev/null || ! command -v zsh >/dev/null; then
    brew install git gnupg zsh
  fi
  ;;
Linux)
  if command -v apt-get >/dev/null; then
    if ! command -v curl >/dev/null || ! command -v git >/dev/null || ! command -v gpg >/dev/null ||
      ! command -v zsh >/dev/null || ! command -v unzip >/dev/null || ! command -v cc >/dev/null ||
      ! command -v make >/dev/null; then
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl git gnupg zsh unzip build-essential
    fi
  elif command -v pacman >/dev/null; then
    if ! command -v curl >/dev/null || ! command -v git >/dev/null || ! command -v gpg >/dev/null ||
      ! command -v zsh >/dev/null || ! command -v unzip >/dev/null || ! command -v cc >/dev/null ||
      ! command -v make >/dev/null; then
      sudo pacman -Syu --needed --noconfirm base-devel ca-certificates curl git gnupg zsh unzip
    fi
    if ! command -v paru >/dev/null && ! command -v yay >/dev/null; then
      git clone https://aur.archlinux.org/yay.git "$work/yay"
      (cd "$work/yay" && makepkg -si --noconfirm)
    fi
  else
    echo 'Supported Linux distributions use APT or pacman.' >&2
    exit 1
  fi
  ;;
*)
  echo 'Bootstrap supports macOS, Debian/Ubuntu, and Arch/CachyOS.' >&2
  exit 1
  ;;
esac

if ! command -v mise >/dev/null; then
  curl -fsSL https://mise.run -o "$work/mise"
  sh "$work/mise"
fi

if ! command -v jq >/dev/null; then
  mise install jq@latest
fi

bash "$(dirname "${BASH_SOURCE[0]}")/.install-password-manager.sh"
