#!/usr/bin/env bash
set -euo pipefail

check_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    printf '[present] %-14s %s\n' "$name" "$(command -v "$name")"
  else
    printf '[missing] %-14s -\n' "$name"
  fi
}

check_path() {
  local label="$1"
  local path="$2"
  if [[ -e "$path" ]]; then
    printf '[present] %-14s %s\n' "$label" "$path"
  else
    printf '[missing] %-14s %s\n' "$label" "$path"
  fi
}

echo 'blux10k doctor report'
echo '====================='

check_cmd bash
check_cmd zsh
check_cmd git
check_cmd tmux
check_cmd nvim
check_cmd rg
check_cmd fzf
check_cmd python3

if command -v pip >/dev/null 2>&1; then
  printf '[present] %-14s %s\n' 'pip' "$(command -v pip)"
elif command -v pip3 >/dev/null 2>&1; then
  printf '[present] %-14s %s\n' 'pip3' "$(command -v pip3)"
else
  printf '[missing] %-14s -\n' 'pip/pip3'
fi

check_path '~/.zplug' "$HOME/.zplug"
check_path '~/powerlevel10k' "$HOME/powerlevel10k"
check_path '~/.zshrc' "$HOME/.zshrc"
check_path '~/.p10k.zsh' "$HOME/.p10k.zsh"
