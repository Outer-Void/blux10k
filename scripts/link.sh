#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotfiles_dir="${repo_root}/dotfiles"
managed_entries_script="${repo_root}/scripts/managed_entries.sh"

if [[ ! -d "$dotfiles_dir" ]]; then
  echo "dotfiles directory not found at ${dotfiles_dir}."
  exit 1
fi
if [[ ! -f "$managed_entries_script" ]]; then
  echo "managed entries script not found at ${managed_entries_script}."
  exit 1
fi

while IFS= read -r rel_path; do
  src="${dotfiles_dir}/${rel_path}"
  dst="${HOME}/${rel_path}"
  mkdir -p "$(dirname "$dst")"

  if [[ -d "$src" && ! -L "$src" ]]; then
    ln -sfn "$src" "$dst"
  else
    ln -sf "$src" "$dst"
  fi
  echo "Linked: ${dst} -> ${src}"
done < <("$managed_entries_script")

echo "Dotfiles linked."
