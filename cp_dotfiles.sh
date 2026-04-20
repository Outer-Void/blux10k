#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_src="${repo_root}/dotfiles"

mkdir -p "$HOME"
cp -a "${dotfiles_src}/." "$HOME/"
echo "Copied dotfiles from ${dotfiles_src} to $HOME."

read -r -p 'Run ./scripts/bootstrap-debian.sh? [y/N]: ' run_bootstrap
if [[ "$run_bootstrap" == "y" || "$run_bootstrap" == "Y" ]]; then
  bootstrap_script="${repo_root}/scripts/bootstrap-debian.sh"
  if [[ -f "$bootstrap_script" ]]; then
    echo "Running ./scripts/bootstrap-debian.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/bootstrap-debian.sh)
    echo "Finished running ./scripts/bootstrap-debian.sh."
  else
    echo "bootstrap-debian.sh not found at ${bootstrap_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/bootstrap-debian.sh."
fi

read -r -p 'Set zsh as main shell? [y/N]: ' set_main_shell
if [[ "$set_main_shell" == "y" || "$set_main_shell" == "Y" ]]; then
  if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh is not installed; cannot set it as main shell."
  elif ! command -v chsh >/dev/null 2>&1; then
    echo "chsh command is not available; cannot set zsh as main shell."
  else
    zsh_path="$(command -v zsh)"
    current_shell="${SHELL:-}"
    if [[ "$current_shell" == "$zsh_path" ]]; then
      echo "zsh is already your main shell (${zsh_path})."
    else
      user_name="${USER:-$(id -un)}"
      if chsh -s "$zsh_path" "$user_name"; then
        echo "Successfully set zsh as main shell (${zsh_path})."
      else
        echo "Failed to set zsh as main shell; continuing."
      fi
    fi
  fi
else
  echo "Skipped setting zsh as main shell."
fi

read -r -p 'Copy scripts/ dir to $HOME/tools/scripts? [y/N]: ' copy_scripts
if [[ "$copy_scripts" == "y" || "$copy_scripts" == "Y" ]]; then
  mkdir -p "$HOME/tools/scripts"
  cp -a "${repo_root}/scripts/." "$HOME/tools/scripts/"
  echo "Copied scripts from ${repo_root}/scripts to $HOME/tools/scripts."
else
  echo "Skipped copying scripts."
fi

read -r -p 'Source ~/.zshrc now? [y/N]: ' source_zshrc
if [[ "$source_zshrc" == "y" || "$source_zshrc" == "Y" ]]; then
  zshrc_path="$HOME/.zshrc"
  if [[ -f "$zshrc_path" ]]; then
    echo "Sourcing ${zshrc_path}."
    # shellcheck source=/dev/null
    if . "$zshrc_path"; then
      echo "Sourced ${zshrc_path}."
    else
      echo "Failed to source ${zshrc_path}; continuing."
    fi
  else
    echo "${zshrc_path} does not exist; skipping source."
  fi
else
  echo "Skipped sourcing ~/.zshrc."
fi
