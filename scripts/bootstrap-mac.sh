#!/usr/bin/env bash

set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
FORMULAE_FILE="$ROOT/config/homebrew/formulae.txt"
CASKS_FILE="$ROOT/config/homebrew/casks.optional.txt"

apply=false
dry_run=true
include_casks=false
install_homebrew=false
list_only=false
link_dotfiles=false
dotfiles_only=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-mac.sh [options]

Options:
  --list                         Print the reviewed inventory and exit.
  --dry-run                      Print planned actions without changing the device.
  --apply                        Permit package or template-link changes.
  --install-homebrew             With --apply, install Homebrew if missing.
  --include-casks                Include optional GUI applications.
  --link-dotfiles                Manage templates under ~/.config/devoops.
  --dotfiles-only                Skip Homebrew package actions.
  -h, --help                     Show this help.

The default is a dry run. The script never uninstalls packages, manages secrets,
or replaces an existing non-symlink configuration target.
EOF
}

read_items() {
  local file="$1"
  sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$file"
}

print_items() {
  local title="$1"
  local file="$2"
  echo "$title"
  read_items "$file" | sed 's/^/  /'
}

run_or_print() {
  if "$apply"; then
    "$@"
  else
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  fi
}

link_template() {
  local source="$1"
  local target="$2"
  if "$apply"; then
    mkdir -p "$(dirname "$target")"
  fi
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Refusing to replace existing non-symlink: $target" >&2
    exit 2
  fi
  run_or_print ln -sfn "$source" "$target"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list) list_only=true ;;
    --dry-run) dry_run=true ;;
    --apply) apply=true; dry_run=false ;;
    --install-homebrew) install_homebrew=true ;;
    --include-casks) include_casks=true ;;
    --link-dotfiles) link_dotfiles=true ;;
    --dotfiles-only) dotfiles_only=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if "$list_only"; then
  print_items 'Homebrew formulae:' "$FORMULAE_FILE"
  print_items 'Optional casks:' "$CASKS_FILE"
  exit 0
fi

if "$link_dotfiles"; then
  link_template "$ROOT/dotfiles/shell/zshrc" "$HOME/.config/devoops/shell/zshrc"
  link_template "$ROOT/dotfiles/shell/path.zsh" "$HOME/.config/devoops/shell/path.zsh"
  link_template "$ROOT/dotfiles/shell/aliases.common.zsh" "$HOME/.config/devoops/shell/aliases.common.zsh"
  link_template "$ROOT/dotfiles/shell/functions.common.zsh" "$HOME/.config/devoops/shell/functions.common.zsh"
  link_template "$ROOT/dotfiles/kitty/kitty.conf" "$HOME/.config/devoops/kitty/kitty.conf"
  if [[ ! -e "$HOME/.config/devoops/shell/local.zsh" ]]; then
    run_or_print cp "$ROOT/dotfiles/shell/local.example.zsh" "$HOME/.config/devoops/shell/local.zsh"
  fi
  if [[ ! -e "$HOME/.config/devoops/kitty/local.conf" ]]; then
    run_or_print cp "$ROOT/dotfiles/kitty/local.example.conf" "$HOME/.config/devoops/kitty/local.conf"
  fi
fi

if "$dotfiles_only"; then
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  if "$apply" && "$install_homebrew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif "$dry_run"; then
    echo '[dry-run] Homebrew is not inspected.'
    exit 0
  else
    echo 'Homebrew is missing. Use --apply --install-homebrew or install it separately.' >&2
    exit 2
  fi
fi

while IFS= read -r formula; do
  if "$apply" && brew list --formula --versions "$formula" >/dev/null 2>&1; then
    echo "formula already installed: $formula"
  else
    run_or_print brew install "$formula"
  fi
done < <(read_items "$FORMULAE_FILE")

if "$include_casks"; then
  while IFS= read -r cask; do
    if "$apply" && brew list --cask --versions "$cask" >/dev/null 2>&1; then
      echo "cask already installed: $cask"
    else
      run_or_print brew install --cask --adopt "$cask"
    fi
  done < <(read_items "$CASKS_FILE")
fi
