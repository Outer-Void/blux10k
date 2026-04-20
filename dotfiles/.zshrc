# Enable Powerlevel10k instant prompt. Keep near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =====================================================
# GLOBAL TOOLCHAINS
# =====================================================

# If an alias exists, remove it so the function name parses correctly
unalias ac pv av lda 2>/dev/null
unset -f ac pv av lda 2>/dev/null

# ----- LOCAL TOOL SCRIPTS -----
LOCAL_TOOL_SCRIPTS="${LOCAL_TOOL_SCRIPTS:-$HOME/tools/scripts}"
case ":$PATH:" in
  *":$LOCAL_TOOL_SCRIPTS:"*) ;;
  *) export PATH="$LOCAL_TOOL_SCRIPTS:$PATH" ;;
esac

pv() {
  source "$LOCAL_TOOL_SCRIPTS/py_venv.sh"
}

av() {
  source "$LOCAL_TOOL_SCRIPTS/activate_venv.sh"
}

backup_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/backup_dotfiles.sh" "$@"
}

bootstrap_debian() {
  "$LOCAL_TOOL_SCRIPTS/bootstrap-debian.sh" "$@"
}

diff_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/diff_dotfiles.sh" "$@"
}

doctor() {
  "$LOCAL_TOOL_SCRIPTS/doctor.sh" "$@"
}

ensure_dirs() {
  "$LOCAL_TOOL_SCRIPTS/ensure_dirs.sh" "$@"
}

link_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/link.sh" "$@"
}

list_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/list_dotfiles.sh" "$@"
}

reload_shell() {
  source "$LOCAL_TOOL_SCRIPTS/reload_shell.sh" "$@"
}

restore_dotfiles_backup() {
  "$LOCAL_TOOL_SCRIPTS/restore_dotfiles_backup.sh" "$@"
}

safe_zip() {
  "$LOCAL_TOOL_SCRIPTS/safe_zip.sh" "$@"
}

sync_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/sync_dotfiles.sh" "$@"
}

unlink_dotfiles() {
  "$LOCAL_TOOL_SCRIPTS/unlink.sh" "$@"
}

update_plugins() {
  "$LOCAL_TOOL_SCRIPTS/update_plugins.sh" "$@"
}

b10k() {
  case "$1" in
    -h|--help|"")
      cat <<'EOF'
blux10k helper functions

Usage:
  b10k --help

Helpers (from $HOME/tools/scripts):
  pv                     -> py_venv.sh                 Create/activate local .venv (source)
  av                     -> activate_venv.sh           Activate .venv or venv in current directory (source)
  backup_dotfiles        -> backup_dotfiles.sh         Back up tracked dotfiles from $HOME
  bootstrap_debian       -> bootstrap-debian.sh        Install Debian/Ubuntu shell tooling and prompt deps
  diff_dotfiles          -> diff_dotfiles.sh           Compare tracked dotfiles with $HOME copies
  doctor                 -> doctor.sh                  Report tool/path presence for this environment
  ensure_dirs            -> ensure_dirs.sh             Ensure expected directories exist
  link_dotfiles          -> link.sh                    Symlink managed dotfiles into $HOME
  list_dotfiles          -> list_dotfiles.sh           List tracked entries under dotfiles/
  reload_shell           -> reload_shell.sh            Reload shell rc file for detected shell context (source)
  restore_dotfiles_backup -> restore_dotfiles_backup.sh Restore latest dotfiles backup into $HOME
  safe_zip               -> safe_zip.sh                Create timestamped zip excluding common cache/secrets
  sync_dotfiles          -> sync_dotfiles.sh           Sync tracked dotfiles from $HOME back into repo
  unlink_dotfiles        -> unlink.sh                  Remove blux10k-managed symlinks from $HOME
  update_plugins         -> update_plugins.sh          Update zplug and powerlevel10k if present
EOF
      ;;
    *)
      echo "Usage: b10k --help"
      return 1
      ;;
  esac
}

lda() {
  lsd -a "$@"
}

# ----- AXIOM -----
AXIOM_LOCKER="$HOME/axiom/locker"
case ":$PATH:" in
  *":$AXIOM_LOCKER:"*) ;;
  *) export PATH="$AXIOM_LOCKER:$PATH" ;;
esac

ac() {
  artifact_compress.sh "$@"
}

# History / options
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
bindkey -e

# zplug initialization and plugins
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

# Completion (run once)
autoload -Uz compinit
compinit

# Powerlevel10k theme (run once)
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Local overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
