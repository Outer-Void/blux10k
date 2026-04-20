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

remove_managed_link() {
  local target="$1"
  local source="$2"

  if [[ -L "$target" ]]; then
    local resolved_target resolved_source
    resolved_target="$(readlink -f "$target")"
    resolved_source="$(readlink -f "$source")"
    if [[ "$resolved_target" == "$resolved_source" ]]; then
      rm "$target"
      echo "Unlinked: ${target}"
      return 0
    fi
  fi
  return 1
}

unlinked=0
while IFS= read -r rel_path; do
  if remove_managed_link "$HOME/${rel_path}" "$dotfiles_dir/${rel_path}"; then
    unlinked=1
  fi
done < <("$managed_entries_script")

if [[ $unlinked -eq 0 ]]; then
  echo "No matching blux10k-managed symlinks found to remove."
fi
