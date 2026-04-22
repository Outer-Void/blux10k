#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_src="${repo_root}/dotfiles"
scripts_dir="${repo_root}/scripts"

NONINTERACTIVE=0

usage() {
  cat <<'EOF'
Usage: ./cp_dotfiles.sh [--noninteractive] [--help]

Options:
  --noninteractive   Run with safe defaults and no prompts.
  --help             Show this help text.

Noninteractive defaults:
  backup=yes, bootstrap=no, set-shell=no, ensure-dirs=yes,
  copy-scripts=yes, doctor=no, list=no, diff=no, update-plugins=no
EOF
}

while (($#)); do
  case "$1" in
    --noninteractive)
      NONINTERACTIVE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

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

ask_yes_no() {
  local prompt="$1"
  local default_choice="$2"
  local answer

  if [[ "$NONINTERACTIVE" -eq 1 ]]; then
    echo "${prompt} [${default_choice}] -> ${default_choice} (noninteractive default)"
    [[ "$default_choice" == "y" ]]
    return
  fi

  if [[ "$default_choice" == "y" ]]; then
    read -r -p "${prompt} [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]]
  else
    read -r -p "${prompt} [y/N]: " answer
    [[ "$answer" =~ ^[Yy]$ ]]
  fi
}

if ask_yes_no 'Back up existing managed dotfiles before copy?' 'y'; then
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

if ask_yes_no 'Run ./scripts/bootstrap-debian.sh?' 'n'; then
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

if ask_yes_no 'Set zsh as main shell?' 'n'; then
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

if ask_yes_no 'Run ./scripts/ensure_dirs.sh?' 'y'; then
  run_repo_script "scripts/ensure_dirs.sh"
else
  echo "Skipped running ./scripts/ensure_dirs.sh."
fi

if ask_yes_no 'Copy scripts/ dir to $HOME/tools/scripts?' 'y'; then
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

if ask_yes_no 'Run ./scripts/doctor.sh?' 'n'; then
  run_repo_script "scripts/doctor.sh"
else
  echo "Skipped running ./scripts/doctor.sh."
fi

if ask_yes_no 'Run ./scripts/list_dotfiles.sh?' 'n'; then
  run_repo_script "scripts/list_dotfiles.sh"
else
  echo "Skipped running ./scripts/list_dotfiles.sh."
fi

if ask_yes_no 'Run ./scripts/diff_dotfiles.sh?' 'n'; then
  run_repo_script "scripts/diff_dotfiles.sh"
else
  echo "Skipped running ./scripts/diff_dotfiles.sh."
fi

if ask_yes_no 'Run ./scripts/update_plugins.sh?' 'n'; then
  run_repo_script "scripts/update_plugins.sh"
else
  echo "Skipped running ./scripts/update_plugins.sh."
fi

echo
echo "Setup complete."
echo "To apply shell changes, start a new terminal session."
echo "If you use zsh, you can also run: zsh"
echo
echo "Run this manually from an interactive zsh session:"
echo "  p10k configure"
echo
