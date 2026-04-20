# ~/.bashrc: executed by bash(1) for non-login interactive shells.

# If not running interactively, do nothing.
case $- in
  *i*) ;;
  *) return ;;
esac

# History behavior.
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Update terminal dimensions automatically.
shopt -s checkwinsize

# Debian chroot marker for prompt.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Prompt color handling.
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes ;;
esac

if [ -n "${force_color_prompt:-}" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >/dev/null 2>&1; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "${color_prompt:-}" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Set terminal title for xterm-like terminals.
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# Basic aliases.
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# Optional user aliases.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Optional bash completion.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Optional user-level toolchains.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Local machine-specific overrides (untracked).
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
