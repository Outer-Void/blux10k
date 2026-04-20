#!/usr/bin/env bash
set -euo pipefail

dirs=(
  "$HOME/tools"
  "$HOME/tools/scripts"
  "$HOME/.config"
)

for dir_path in "${dirs[@]}"; do
  if [[ -d "$dir_path" ]]; then
    echo "Already present: ${dir_path}"
  else
    mkdir -p "$dir_path"
    echo "Created: ${dir_path}"
  fi
done
