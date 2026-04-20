#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
managed_entries_script="${repo_root}/scripts/managed_entries.sh"

if [[ ! -f "$managed_entries_script" ]]; then
  echo "managed entries script not found at ${managed_entries_script}."
  exit 1
fi

echo "Managed dotfiles entries:"
"$managed_entries_script"
