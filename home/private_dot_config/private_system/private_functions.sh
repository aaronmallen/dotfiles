mkfile() {
  if [[ $# -ne 1 || -z $1 ]]; then
    printf 'Usage: mkfile <path>\n' >&2
    return 1
  fi

  mkdir -p -- "$(dirname -- "$1")" && touch -- "$1"
}
