#!/usr/bin/env bash
set -euo pipefail

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "This helper must be sourced to affect your current shell session."
  echo "Usage: source ./scripts/reload_shell.sh"
  exit 1
fi

if [[ -n "${ZSH_VERSION:-}" ]]; then
  rc_file="$HOME/.zshrc"
elif [[ -n "${BASH_VERSION:-}" ]]; then
  rc_file="$HOME/.bashrc"
else
  echo "Could not determine current shell; no rc file reloaded."
  return 1
fi

if [[ ! -f "$rc_file" ]]; then
  echo "${rc_file} does not exist; nothing to reload."
  return 0
fi

echo "Reloading ${rc_file} ..."
# shellcheck source=/dev/null
. "$rc_file"
echo "Reload complete."
