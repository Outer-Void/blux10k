#!/usr/bin/env bash
set -euo pipefail

backup_base="${HOME}/.blux10k_backup"

if [[ ! -d "$backup_base" ]]; then
  echo "No backup directory found at ${backup_base}; nothing to restore."
  exit 0
fi

latest_backup="$(find "$backup_base" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"
if [[ -z "$latest_backup" ]]; then
  echo "No backups found under ${backup_base}; nothing to restore."
  exit 0
fi

restored=0
# Restore iterates the backup directory directly (not managed_entries.sh).
# This is intentional: a full restore brings back everything that was backed up,
# including entries that may have since been removed from managed scope.
while IFS= read -r rel_path; do
  src_path="${latest_backup}/${rel_path}"
  dst_path="${HOME}/${rel_path}"
  mkdir -p "$(dirname "$dst_path")"
  cp -a "$src_path" "$dst_path"
  echo "Restored: ${src_path} -> ${dst_path}"
  restored=1
done < <(cd "$latest_backup" && find . -mindepth 1 -maxdepth 1 -print | sed 's#^./##' | sort)

if [[ $restored -eq 0 ]]; then
  echo "Latest backup ${latest_backup} is empty; nothing to restore."
  exit 0
fi

echo "Restore complete from ${latest_backup}"
