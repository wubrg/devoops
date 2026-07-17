# Common, non-work-specific shell functions.

e() {
  if [[ -n "${1:-}" ]]; then
    command code "$1"
  else
    command code .
  fi
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}
