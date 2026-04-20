#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotfiles_dir="${repo_root}/dotfiles"

remove_managed_link() {
  local target="$1"
  local source="$2"

  if [[ -L "$target" ]]; then
    local resolved
    resolved="$(readlink -f "$target")"
    if [[ "$resolved" == "$(readlink -f "$source")" ]]; then
      rm "$target"
      echo "Unlinked: ${target}"
      return 0
    fi
  fi
  return 1
}

unlinked=0

if remove_managed_link "$HOME/.bashrc" "$dotfiles_dir/.bashrc"; then unlinked=1; fi
if remove_managed_link "$HOME/.profile" "$dotfiles_dir/.profile"; then unlinked=1; fi
if remove_managed_link "$HOME/.zshrc" "$dotfiles_dir/.zshrc"; then unlinked=1; fi
if remove_managed_link "$HOME/.p10k.zsh" "$dotfiles_dir/.p10k.zsh"; then unlinked=1; fi
if remove_managed_link "$HOME/.gitconfig" "$dotfiles_dir/.gitconfig"; then unlinked=1; fi
if remove_managed_link "$HOME/.config/nvim" "$dotfiles_dir/.config/nvim"; then unlinked=1; fi
if remove_managed_link "$HOME/.config/fastfetch" "$dotfiles_dir/.config/fastfetch"; then unlinked=1; fi
if remove_managed_link "$HOME/.config/ranger" "$dotfiles_dir/.config/ranger"; then unlinked=1; fi

if [[ $unlinked -eq 0 ]]; then
  echo "No matching blux10k-managed symlinks found to remove."
fi
