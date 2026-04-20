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

check_path 'home/.zplug' "$HOME/.zplug"
check_path 'home/powerlevel10k' "$HOME/powerlevel10k"
check_path 'home/.zshrc' "$HOME/.zshrc"
check_path 'home/.p10k.zsh' "$HOME/.p10k.zsh"

# Check LOCAL_TOOL_SCRIPTS path
tool_scripts_path="${LOCAL_TOOL_SCRIPTS:-$HOME/tools/scripts}"
check_path 'tools/scripts' "$tool_scripts_path"

# Check each helper script is installed
for helper_script in \
  py_venv.sh activate_venv.sh backup_dotfiles.sh bootstrap-debian.sh \
  diff_dotfiles.sh doctor.sh ensure_dirs.sh link.sh list_dotfiles.sh \
  managed_entries.sh reload_shell.sh restore_dotfiles_backup.sh \
  safe_zip.sh sync_dotfiles.sh unlink.sh update_plugins.sh; do
  check_path "$helper_script" "$tool_scripts_path/$helper_script"
done

# Check p10k command
check_cmd p10k

# Check actual Debian binary names
check_cmd batcat
check_cmd fdfind
check_cmd fastfetch
