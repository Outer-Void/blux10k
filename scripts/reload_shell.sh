#!/usr/bin/env bash
set -euo pipefail

echo "Note: to affect your current shell session, run this script with:"
echo "  source ./scripts/reload_shell.sh"

shell_name=""
rc_file=""

if [[ -n "${ZSH_VERSION:-}" ]]; then
  shell_name="zsh"
  rc_file="${HOME}/.zshrc"
elif [[ -n "${BASH_VERSION:-}" ]]; then
  shell_name="bash"
  rc_file="${HOME}/.bashrc"
elif [[ -n "${SHELL:-}" ]]; then
  case "$(basename "$SHELL")" in
    zsh)
      shell_name="zsh"
      rc_file="${HOME}/.zshrc"
      ;;
    bash)
      shell_name="bash"
      rc_file="${HOME}/.bashrc"
      ;;
  esac
fi

if [[ -z "$shell_name" || -z "$rc_file" ]]; then
  echo "Could not reliably determine whether to reload bash or zsh config."
  exit 0
fi

if [[ ! -f "$rc_file" ]]; then
  echo "${rc_file} does not exist; nothing to reload."
  exit 0
fi

echo "Detected shell context: ${shell_name}"
echo "Sourcing ${rc_file}"
# shellcheck source=/dev/null
. "$rc_file"
echo "Reload complete."
