#!/usr/bin/env bash

set -euo pipefail

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

case "$(uname -s)" in
Darwin)
  packages=()
  if [[ ! -d /Applications/1Password.app && ! -d "$HOME/Applications/1Password.app" ]]; then
    packages+=(1password)
  fi
  command -v op >/dev/null || packages+=(1password-cli)
  ((${#packages[@]})) || exit 0
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
  brew install --cask "${packages[@]}"
  ;;
Linux)
  packages=()
  command -v 1password >/dev/null || packages+=(1password)
  command -v op >/dev/null || packages+=(1password-cli)
  ((${#packages[@]})) || exit 0
  if command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    curl -fsSL https://downloads.1password.com/linux/keys/1password.asc -o "$work/1password.asc"
    gpg --batch --yes --dearmor --output "$work/1password.gpg" "$work/1password.asc"
    sudo install -m 644 "$work/1password.gpg" /usr/share/keyrings/1password-archive-keyring.gpg
    printf 'deb [arch=%s signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/%s stable main\n' \
      "$(dpkg --print-architecture)" "$(dpkg --print-architecture)" >"$work/1password.list"
    sudo install -m 644 "$work/1password.list" /etc/apt/sources.list.d/1password.list
    curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol -o "$work/1password.pol"
    sudo install -d /etc/debsig/policies/AC2D62742012EA22 /usr/share/debsig/keyrings/AC2D62742012EA22
    sudo install -m 644 "$work/1password.pol" /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo install -m 644 "$work/1password.gpg" /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
  elif command -v pacman >/dev/null; then
    if command -v paru >/dev/null; then
      aur=paru
    elif command -v yay >/dev/null; then
      aur=yay
    else
      sudo pacman -Syu --needed --noconfirm base-devel git
      git clone https://aur.archlinux.org/yay.git "$work/yay"
      (cd "$work/yay" && makepkg -si --noconfirm)
      aur=yay
    fi
    "$aur" -S --needed "${packages[@]}"
  else
    echo 'Installing 1Password CLI requires APT or pacman on Linux.' >&2
    exit 1
  fi
  ;;
*)
  echo 'Installing 1Password CLI supports macOS, Debian/Ubuntu, and Arch/CachyOS.' >&2
  exit 1
  ;;
esac
