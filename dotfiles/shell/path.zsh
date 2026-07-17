# Portable path defaults. Keep machine-specific additions in local.zsh.

typeset -U path

brew_command="$(command -v brew 2>/dev/null || true)"
if [[ -z "$brew_command" ]]; then
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      brew_command="$candidate"
      break
    fi
  done
fi

if [[ -n "$brew_command" ]]; then
  brew_prefix="$("$brew_command" --prefix)"
  path=(
    "$brew_prefix/sbin"
    "$brew_prefix/bin"
    $path
  )
  unset brew_command
  unset brew_prefix
fi

path=(
  /usr/local/bin
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)
export PATH
