#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "[reload-shell] ERROR: this helper must be sourced; it cannot reload a parent shell." >&2
  echo "[reload-shell] Usage: source ./scripts/reload_shell.sh" >&2
  exit 1
fi

if [[ -n "${ZSH_VERSION:-}" ]]; then
  rc_file="$HOME/.zshrc"
elif [[ -n "${BASH_VERSION:-}" ]]; then
  rc_file="$HOME/.bashrc"
else
  echo "[reload-shell] ERROR: unsupported shell; expected bash or zsh." >&2
  return 1
fi

if [[ ! -f "$rc_file" ]]; then
  echo "[reload-shell] INFO: ${rc_file} does not exist; nothing to reload."
  return 0
fi

echo "[reload-shell] Reloading ${rc_file} ..."
# shellcheck source=/dev/null
. "$rc_file"
echo "[reload-shell] Reload complete."
