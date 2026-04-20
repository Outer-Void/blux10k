#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_src="${repo_root}/dotfiles"

mkdir -p "$HOME"
cp -a "${dotfiles_src}/." "$HOME/"
echo "Copied dotfiles from ${dotfiles_src} to $HOME."

read -r -p 'Copy scripts/ dir to $HOME/tools/scripts? [y/N]: ' copy_scripts
if [[ "$copy_scripts" == "y" || "$copy_scripts" == "Y" ]]; then
  mkdir -p "$HOME/tools/scripts"
  cp -a "${repo_root}/scripts/." "$HOME/tools/scripts/"
  echo "Copied scripts from ${repo_root}/scripts to $HOME/tools/scripts."
else
  echo "Skipped copying scripts."
fi
