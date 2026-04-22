#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_src="${repo_root}/dotfiles"
scripts_dir="${repo_root}/scripts"

if [[ ! -d "$dotfiles_src" ]]; then
  echo "Error: dotfiles directory not found at ${dotfiles_src}."
  exit 1
fi

run_repo_script() {
  local rel_script="$1"
  local abs_script="${repo_root}/${rel_script}"

  if [[ ! -f "$abs_script" ]]; then
    echo "Missing ${rel_script} at ${abs_script}; skipping."
    return 0
  fi

  echo "Running ${rel_script} from ${repo_root}."
  (cd "$repo_root" && "$abs_script")
  echo "Finished ${rel_script}."
}

read -r -p 'Back up existing managed dotfiles before copy? [y/N]: ' run_backup
if [[ "$run_backup" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/backup_dotfiles.sh"
else
  echo "Skipped backup before copy."
fi

mkdir -p "$HOME"

# Rescue git identity before the copy overwrites ~/.gitconfig.
# The tracked .gitconfig is a neutral baseline; personal identity belongs in
# ~/.gitconfig.local (already included by the tracked config).
_rescue_git_identity() {
  local src="$HOME/.gitconfig"
  local local_cfg="$HOME/.gitconfig.local"

  [[ -f "$src" ]] || return 0

  local git_name git_email git_sigkey
  git_name="$(git config --file "$src" user.name 2>/dev/null || true)"
  git_email="$(git config --file "$src" user.email 2>/dev/null || true)"
  git_sigkey="$(git config --file "$src" user.signingkey 2>/dev/null || true)"

  [[ -n "$git_name" || -n "$git_email" ]] || return 0

  local existing_name existing_email
  existing_name="$(git config --file "$local_cfg" user.name 2>/dev/null || true)"
  existing_email="$(git config --file "$local_cfg" user.email 2>/dev/null || true)"

  if [[ -n "$existing_name" || -n "$existing_email" ]]; then
    echo "Git identity already in ~/.gitconfig.local; skipping migration."
    return 0
  fi

  echo "Migrating git identity to ~/.gitconfig.local..."
  touch "$local_cfg"
  [[ -n "$git_name" ]]   && git config --file "$local_cfg" user.name       "$git_name"   && echo "  user.name  = $git_name"
  [[ -n "$git_email" ]]  && git config --file "$local_cfg" user.email      "$git_email"  && echo "  user.email = $git_email"
  [[ -n "$git_sigkey" ]] && git config --file "$local_cfg" user.signingkey "$git_sigkey" && echo "  user.signingkey = $git_sigkey"
  echo "Git identity saved to ~/.gitconfig.local."
}

_rescue_git_identity

cp -a "${dotfiles_src}/." "$HOME/"
echo "Copied dotfiles from ${dotfiles_src} to $HOME."

read -r -p 'Run ./scripts/bootstrap-debian.sh? [y/N]: ' run_bootstrap
if [[ "$run_bootstrap" =~ ^[Yy]$ ]]; then
  if [[ -f "${scripts_dir}/bootstrap-debian.sh" ]]; then
    echo "Running ./scripts/bootstrap-debian.sh from ${repo_root}."
    (cd "$repo_root" && ./scripts/bootstrap-debian.sh)
    echo "Finished ./scripts/bootstrap-debian.sh."
  else
    echo "Missing scripts/bootstrap-debian.sh; skipping."
  fi
else
  echo "Skipped running ./scripts/bootstrap-debian.sh."
fi

read -r -p 'Set zsh as main shell? [y/N]: ' set_main_shell
if [[ "$set_main_shell" =~ ^[Yy]$ ]]; then
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
if [[ "$run_ensure_dirs" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/ensure_dirs.sh"
else
  echo "Skipped running ./scripts/ensure_dirs.sh."
fi

read -r -p 'Copy scripts/ dir to $HOME/tools/scripts? [y/N]: ' copy_scripts
if [[ "$copy_scripts" =~ ^[Yy]$ ]]; then
  if [[ ! -d "$scripts_dir" ]]; then
    echo "Missing scripts directory at ${scripts_dir}; skipping copy."
  else
    mkdir -p "$HOME/tools/scripts"
    cp -a "${scripts_dir}/." "$HOME/tools/scripts/"
    echo "Copied scripts from ${scripts_dir} to $HOME/tools/scripts."
  fi
else
  echo "Skipped copying scripts."
fi

read -r -p 'Run ./scripts/doctor.sh? [y/N]: ' run_doctor
if [[ "$run_doctor" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/doctor.sh"
else
  echo "Skipped running ./scripts/doctor.sh."
fi

read -r -p 'Run ./scripts/list_dotfiles.sh? [y/N]: ' run_list
if [[ "$run_list" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/list_dotfiles.sh"
else
  echo "Skipped running ./scripts/list_dotfiles.sh."
fi

read -r -p 'Run ./scripts/diff_dotfiles.sh? [y/N]: ' run_diff
if [[ "$run_diff" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/diff_dotfiles.sh"
else
  echo "Skipped running ./scripts/diff_dotfiles.sh."
fi

read -r -p 'Run ./scripts/update_plugins.sh? [y/N]: ' run_update_plugins
if [[ "$run_update_plugins" =~ ^[Yy]$ ]]; then
  run_repo_script "scripts/update_plugins.sh"
else
  echo "Skipped running ./scripts/update_plugins.sh."
fi

echo
echo "Setup complete."
echo "To apply shell changes, start a new terminal session."
echo "If you use zsh, you can also run: zsh"
echo
echo "Powerlevel10k was not configured automatically from this script."
echo "To finish prompt setup, run:"
echo "  p10k configure"
echo
