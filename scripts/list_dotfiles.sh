#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotfiles_dir="${repo_root}/dotfiles"

if [[ ! -d "$dotfiles_dir" ]]; then
  echo "dotfiles directory not found at ${dotfiles_dir}."
  exit 1
fi

echo "Managed dotfiles entries:"
(cd "$dotfiles_dir" && find . -mindepth 1 -print | sed 's#^\./##' | sort)
