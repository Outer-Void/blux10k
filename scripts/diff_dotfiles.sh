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
  repo_path="${dotfiles_dir}/${rel_path}"
  home_path="${HOME}/${rel_path}"

  if [[ ! -e "$home_path" && ! -L "$home_path" ]]; then
    echo "[missing in HOME] ${rel_path}"
    continue
  fi

  if [[ -d "$repo_path" && ! -L "$repo_path" ]]; then
    if diff -qr "$repo_path" "$home_path" >/dev/null 2>&1; then
      echo "[identical] ${rel_path}"
    else
      echo "[different] ${rel_path}"
    fi
  else
    if cmp -s "$repo_path" "$home_path"; then
      echo "[identical] ${rel_path}"
    else
      echo "[different] ${rel_path}"
    fi
  fi
done < <("$managed_entries_script")
