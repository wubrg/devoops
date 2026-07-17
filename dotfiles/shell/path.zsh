# Portable path defaults. Keep machine-specific additions in local.zsh.

path=(
  /opt/homebrew/sbin
  /opt/homebrew/bin
  /usr/local/bin
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)
export PATH
