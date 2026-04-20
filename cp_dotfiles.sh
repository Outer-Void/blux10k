#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_src="${repo_root}/dotfiles"

read -r -p 'Back up existing managed dotfiles before copy? [y/N]: ' run_backup
if [[ "$run_backup" == "y" || "$run_backup" == "Y" ]]; then
  backup_script="${repo_root}/scripts/backup_dotfiles.sh"
  if [[ -f "$backup_script" ]]; then
    echo "Running ./scripts/backup_dotfiles.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/backup_dotfiles.sh)
    echo "Finished running ./scripts/backup_dotfiles.sh."
  else
    echo "backup_dotfiles.sh not found at ${backup_script}; skipping backup."
  fi
else
  echo "Skipped backup before copy."
fi

mkdir -p "$HOME"
cp -a "${dotfiles_src}/." "$HOME/"
echo "Copied dotfiles from ${dotfiles_src} to $HOME."

read -r -p 'Run ./scripts/bootstrap-debian.sh? [y/N]: ' run_bootstrap
if [[ "$run_bootstrap" == "y" || "$run_bootstrap" == "Y" ]]; then
  bootstrap_script="${repo_root}/scripts/bootstrap-debian.sh"
  if [[ -f "$bootstrap_script" ]]; then
    echo "Running ./scripts/bootstrap-debian.sh from ${repo_root}."
    (cd "$repo_root" && BLUX10K_SKIP_P10K_CONFIG_PROMPT=1 ./scripts/bootstrap-debian.sh)
    echo "Finished running ./scripts/bootstrap-debian.sh."
  else
    echo "bootstrap-debian.sh not found at ${bootstrap_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/bootstrap-debian.sh."
fi


read -r -p 'Run p10k configure now? [y/N]: ' run_p10k_configure
if [[ "$run_p10k_configure" == "y" || "$run_p10k_configure" == "Y" ]]; then
  if command -v p10k >/dev/null 2>&1; then
    echo "Running p10k configure."
    p10k configure || echo "p10k configure did not complete successfully; continuing."
  elif command -v zsh >/dev/null 2>&1 && [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    echo "Running p10k configure via zsh."
    zsh -i -c 'source ~/powerlevel10k/powerlevel10k.zsh-theme && p10k configure' \
      || echo "p10k configure via zsh did not complete successfully; continuing."
  else
    echo "Powerlevel10k is not available yet; skipping p10k configure."
  fi
else
  echo "Skipped p10k configure."
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

read -r -p 'Run ./scripts/ensure_dirs.sh? [y/N]: ' run_ensure_dirs
if [[ "$run_ensure_dirs" == "y" || "$run_ensure_dirs" == "Y" ]]; then
  ensure_dirs_script="${repo_root}/scripts/ensure_dirs.sh"
  if [[ -f "$ensure_dirs_script" ]]; then
    echo "Running ./scripts/ensure_dirs.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/ensure_dirs.sh)
    echo "Finished running ./scripts/ensure_dirs.sh."
  else
    echo "ensure_dirs.sh not found at ${ensure_dirs_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/ensure_dirs.sh."
fi

read -r -p 'Copy scripts/ dir to $HOME/tools/scripts? [y/N]: ' copy_scripts
if [[ "$copy_scripts" == "y" || "$copy_scripts" == "Y" ]]; then
  mkdir -p "$HOME/tools/scripts"
  cp -a "${repo_root}/scripts/." "$HOME/tools/scripts/"
  echo "Copied scripts from ${repo_root}/scripts to $HOME/tools/scripts."
else
  echo "Skipped copying scripts."
fi

read -r -p 'Run ./scripts/doctor.sh? [y/N]: ' run_doctor
if [[ "$run_doctor" == "y" || "$run_doctor" == "Y" ]]; then
  doctor_script="${repo_root}/scripts/doctor.sh"
  if [[ -f "$doctor_script" ]]; then
    echo "Running ./scripts/doctor.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/doctor.sh)
    echo "Finished running ./scripts/doctor.sh."
  else
    echo "doctor.sh not found at ${doctor_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/doctor.sh."
fi

read -r -p 'Run ./scripts/list_dotfiles.sh? [y/N]: ' run_list
if [[ "$run_list" == "y" || "$run_list" == "Y" ]]; then
  list_script="${repo_root}/scripts/list_dotfiles.sh"
  if [[ -f "$list_script" ]]; then
    echo "Running ./scripts/list_dotfiles.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/list_dotfiles.sh)
    echo "Finished running ./scripts/list_dotfiles.sh."
  else
    echo "list_dotfiles.sh not found at ${list_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/list_dotfiles.sh."
fi

read -r -p 'Run ./scripts/diff_dotfiles.sh? [y/N]: ' run_diff
if [[ "$run_diff" == "y" || "$run_diff" == "Y" ]]; then
  diff_script="${repo_root}/scripts/diff_dotfiles.sh"
  if [[ -f "$diff_script" ]]; then
    echo "Running ./scripts/diff_dotfiles.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/diff_dotfiles.sh)
    echo "Finished running ./scripts/diff_dotfiles.sh."
  else
    echo "diff_dotfiles.sh not found at ${diff_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/diff_dotfiles.sh."
fi

read -r -p 'Run ./scripts/update_plugins.sh? [y/N]: ' run_update_plugins
if [[ "$run_update_plugins" == "y" || "$run_update_plugins" == "Y" ]]; then
  update_plugins_script="${repo_root}/scripts/update_plugins.sh"
  if [[ -f "$update_plugins_script" ]]; then
    echo "Running ./scripts/update_plugins.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/update_plugins.sh)
    echo "Finished running ./scripts/update_plugins.sh."
  else
    echo "update_plugins.sh not found at ${update_plugins_script}; skipping."
  fi
else
  echo "Skipped running ./scripts/update_plugins.sh."
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
