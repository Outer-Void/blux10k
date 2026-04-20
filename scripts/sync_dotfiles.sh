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

synced=0
while IFS= read -r rel_path; do
  home_path="${HOME}/${rel_path}"
  repo_path="${dotfiles_dir}/${rel_path}"

  if [[ -e "$home_path" || -L "$home_path" ]]; then
    rm -rf "$repo_path"
    mkdir -p "$(dirname "$repo_path")"
    cp -a "$home_path" "$repo_path"
    echo "Synced: ${home_path} -> ${repo_path}"
    synced=1
  fi
done < <("$managed_entries_script")

if [[ $synced -eq 0 ]]; then
  echo "No managed dotfiles found in ${HOME}; nothing to sync."
  exit 0
fi

echo "Sync complete."
