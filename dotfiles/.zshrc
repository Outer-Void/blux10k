# Enable Powerlevel10k instant prompt. Keep near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If aliases/functions exist, remove them so helper names parse consistently.
unalias \
  pv av backup_dotfiles bootstrap_debian diff_dotfiles doctor ensure_dirs \
  link_dotfiles list_dotfiles reload_shell restore_dotfiles_backup safe_zip \
  sync_dotfiles unlink_dotfiles update_plugins b10k 2>/dev/null
unset -f \
  pv av backup_dotfiles bootstrap_debian diff_dotfiles doctor ensure_dirs \
  link_dotfiles list_dotfiles reload_shell restore_dotfiles_backup safe_zip \
  sync_dotfiles unlink_dotfiles update_plugins b10k 2>/dev/null

# Installed local utility scripts path.
LOCAL_TOOL_SCRIPTS="${LOCAL_TOOL_SCRIPTS:-$HOME/tools/scripts}"
case ":$PATH:" in
  *":$LOCAL_TOOL_SCRIPTS:"*) ;;
  *) export PATH="$LOCAL_TOOL_SCRIPTS:$PATH" ;;
esac

_run_tool_script() {
  local script_name="$1"
  shift
  local script_path="$LOCAL_TOOL_SCRIPTS/$script_name"

  if [[ ! -f "$script_path" ]]; then
    echo "blux10k helper error: missing script $script_path"
    return 1
  fi

  "$script_path" "$@"
}

_source_tool_script() {
  local script_name="$1"
  shift
  local script_path="$LOCAL_TOOL_SCRIPTS/$script_name"

  if [[ ! -f "$script_path" ]]; then
    echo "blux10k helper error: missing script $script_path"
    return 1
  fi

  source "$script_path" "$@"
}

pv() { _source_tool_script "py_venv.sh" "$@"; }
av() { _source_tool_script "activate_venv.sh" "$@"; }
backup_dotfiles() { _run_tool_script "backup_dotfiles.sh" "$@"; }
bootstrap_debian() { _run_tool_script "bootstrap-debian.sh" "$@"; }
diff_dotfiles() { _run_tool_script "diff_dotfiles.sh" "$@"; }
doctor() { _run_tool_script "doctor.sh" "$@"; }
ensure_dirs() { _run_tool_script "ensure_dirs.sh" "$@"; }
link_dotfiles() { _run_tool_script "link.sh" "$@"; }
list_dotfiles() { _run_tool_script "list_dotfiles.sh" "$@"; }
reload_shell() { _source_tool_script "reload_shell.sh" "$@"; }
restore_dotfiles_backup() { _run_tool_script "restore_dotfiles_backup.sh" "$@"; }
safe_zip() { _run_tool_script "safe_zip.sh" "$@"; }
sync_dotfiles() { _run_tool_script "sync_dotfiles.sh" "$@"; }
unlink_dotfiles() { _run_tool_script "unlink.sh" "$@"; }
update_plugins() { _run_tool_script "update_plugins.sh" "$@"; }

b10k() {
  case "${1:-}" in
    ""|-h|--help)
      cat <<'EOF_HELP'
blux10k helper menu

Usage:
  b10k --help

Helpers (scripts are expected in $HOME/tools/scripts):
  pv                      -> py_venv.sh                 Create/activate .venv in current dir (source)
  av                      -> activate_venv.sh           Activate .venv or venv in current dir (source)
  backup_dotfiles         -> backup_dotfiles.sh         Back up managed entries from $HOME
  bootstrap_debian        -> bootstrap-debian.sh        Bootstrap Debian/Ubuntu shell tooling
  diff_dotfiles           -> diff_dotfiles.sh           Compare managed entries with $HOME
  doctor                  -> doctor.sh                  Show tool/path health report
  ensure_dirs             -> ensure_dirs.sh             Create expected directories
  link_dotfiles           -> link.sh                    Symlink managed dotfiles into $HOME
  list_dotfiles           -> list_dotfiles.sh           List managed entries under dotfiles/
  reload_shell            -> reload_shell.sh            Reload current shell rc file (source)
  restore_dotfiles_backup -> restore_dotfiles_backup.sh Restore latest backup into $HOME
  safe_zip                -> safe_zip.sh                Create a safe timestamped zip archive
  sync_dotfiles           -> sync_dotfiles.sh           Sync managed entries from $HOME to repo
  unlink_dotfiles         -> unlink.sh                  Remove blux10k-managed symlinks
  update_plugins          -> update_plugins.sh          Update zplug and powerlevel10k
EOF_HELP
      ;;
    *)
      echo "Usage: b10k --help"
      return 1
      ;;
  esac
}

# History / options.
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
bindkey -e

# zplug initialization and plugins.
export ZPLUG_HOME="${ZPLUG_HOME:-$HOME/.zplug}"
if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source "$ZPLUG_HOME/init.zsh"

  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting"
  zplug "zsh-users/zsh-completions"
  zplug "Aloxaf/fzf-tab"

  if ! zplug check --verbose; then
    zplug install
  fi
  zplug load
fi

# Completion.
autoload -Uz compinit
compinit

# Powerlevel10k theme and prompt config.
if [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Local overrides (untracked).
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
