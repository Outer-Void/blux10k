#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dotfiles_dir="${repo_root}/dotfiles"
backup_base="${HOME}/.blux10k_backup"
timestamp="$(date +%Y%m%d_%H%M%S)"
backup_dir="${backup_base}/${timestamp}"

if [[ ! -d "$dotfiles_dir" ]]; then
  echo "dotfiles directory not found at ${dotfiles_dir}."
  exit 1
fi

backed_up=0
while IFS= read -r rel_path; do
  home_path="${HOME}/${rel_path}"
  if [[ -e "$home_path" || -L "$home_path" ]]; then
    if [[ $backed_up -eq 0 ]]; then
      mkdir -p "$backup_dir"
    fi
    mkdir -p "${backup_dir}/$(dirname "$rel_path")"
    cp -a "$home_path" "${backup_dir}/${rel_path}"
    echo "Backed up: ${home_path} -> ${backup_dir}/${rel_path}"
    backed_up=1
  fi
done < <(cd "$dotfiles_dir" && find . -mindepth 1 -print | sed 's#^\./##' | sort)

if [[ $backed_up -eq 0 ]]; then
  echo "No existing managed dotfiles found in ${HOME}; nothing to back up."
  exit 0
fi

echo "Backup complete: ${backup_dir}"
