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

# ----- JADIS -----
JADIS_SCRIPTS="$HOME/jadis/tools/scripts"
case ":$PATH:" in
  *":$JADIS_SCRIPTS:"*) ;;
  *) export PATH="$JADIS_SCRIPTS:$PATH" ;;
esac

pv() {
  source "$JADIS_SCRIPTS/py_venv.sh"
}

av() {
  source "$JADIS_SCRIPTS/activate_venv.sh"
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
