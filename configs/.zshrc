#!/usr/bin/env zsh
############################################################################
# ~/.zshrc – BLUX10K v3.0 - Complete, Debugged & Hardened Configuration
# BLUX10K.zsh Distributed System - Terminal Interface
############################################################################

############################################################################
# 0) INSTANT PROMPT - MUST BE FIRST
############################################################################
# Enable Powerlevel10k instant prompt before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

############################################################################
# 1) BLUX10K HEADER (After instant prompt to avoid conflicts)
############################################################################
# Only show header in interactive shells and if not already shown
if [[ -o interactive ]] && [[ -z "$BLUX10K_HEADER_SHOWN" ]]; then
    echo ""
    echo "            ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█            "
    echo "            ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█            "
    echo "            ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀            "
    echo ""
    echo "  ╔════════════════════════════════════════════════════════════════════════╗"
    echo "  ║  >> BLUX ARTIFICIAL INTELLIGENCE DISTRIBUTED SYSTEM ONLINE            ║"
    echo "  ║  >> TERMINAL INTERFACE ACTIVE [$(date +"%H:%M:%S %Z")]                        ║"
    echo "  ║  >> READY FOR USER COMMANDS                                           ║"
    echo "  ╚════════════════════════════════════════════════════════════════════════╝"
    echo "                BLUX: https://github.com/Outer-Void                         "
    echo "                Dev: https://github.com/Justadudeinspace                    "
    echo ""
    export BLUX10K_HEADER_SHOWN=1
fi

############################################################################
# 2) PERFORMANCE & COMPATIBILITY
############################################################################
typeset -g ZSH_DISABLE_COMPFIX=true

# XDG base directories - set early
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Create directories
mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh" "$XDG_CONFIG_HOME" 2>/dev/null

############################################################################
# 3) PLUGIN MANAGER SETUP - ZPLUG ONLY (Simplified)
############################################################################

# Zplug - Primary and ONLY plugin manager
export ZPLUG_HOME="${ZPLUG_HOME:-$HOME/.zplug}"

if [[ ! -d "$ZPLUG_HOME" ]]; then
    echo "Installing zplug..."
    git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
fi

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
    source "$ZPLUG_HOME/init.zsh"
else
    echo "Warning: zplug not found at $ZPLUG_HOME"
fi

############################################################################
# 4) ZPLUG PLUGINS - OPTIMIZED & STREAMLINED
############################################################################

# Core ZSH enhancements
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-completions"

# Directory jumping
zplug "agkozak/zsh-z"

# Oh My Zsh plugins (lightweight ones only)
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

# Theme - Powerlevel10k
zplug "romkatv/powerlevel10k", as:theme, depth:1

# Utility plugins
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
zplug "hlissner/zsh-autopair", defer:2
zplug "Aloxaf/fzf-tab"

# Install plugins if needed
if ! zplug check --verbose; then
    printf "Install missing zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load all plugins
zplug load

############################################################################
# 5) ADDITIONAL PLUGINS - MANUAL LOADING
############################################################################

# zsh-safe-rm for safer file deletion
if [[ ! -d "${ZDOTDIR:-~}/.zplugins/zsh-safe-rm" ]]; then
    git clone --recursive --depth 1 \
        https://github.com/mattmc3/zsh-safe-rm \
        "${ZDOTDIR:-~}/.zplugins/zsh-safe-rm" 2>/dev/null
fi

[[ -f "${ZDOTDIR:-~}/.zplugins/zsh-safe-rm/zsh-safe-rm.plugin.zsh" ]] && \
    source "${ZDOTDIR:-~}/.zplugins/zsh-safe-rm/zsh-safe-rm.plugin.zsh"

############################################################################
# 6) ENVIRONMENT VARIABLES
############################################################################

# Ruby gems config
[[ ! -f ~/.gemrc ]] && echo "gem: --no-document" > ~/.gemrc

# History configuration
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Shell options for history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY

# General shell behavior
setopt PROMPT_SUBST
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt NOTIFY
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# TTY-only options
if [[ -t 0 ]]; then
    setopt CORRECT
    setopt CORRECT_ALL
    bindkey -e  # Emacs keybindings
fi

SPROMPT='zsh: correct '\''%R'\'' to '\''%r'\''? [Yes, No, Abort, Edit] '

############################################################################
# 7) PATH CONFIGURATION
############################################################################

# Ensure unique paths
typeset -U path fpath

# Package manager homes
export PNPM_HOME="$HOME/.local/share/pnpm"
export VOLTA_HOME="$HOME/.volta"
export NVM_DIR="$HOME/.nvm"
export CARGO_HOME="$HOME/.cargo"
export GOPATH="$HOME/go"

# Build PATH array
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$CARGO_HOME/bin"
    "$HOME/.npm-global/bin"
    "$PNPM_HOME"
    "$VOLTA_HOME/bin"
    "$GOPATH/bin"
    "$HOME/.local/share/gem/ruby/3.0.0/bin"
    "$HOME/Scripts"
    "$HOME/dev/tools/flutter/bin"
    "$HOME/.turso"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
    "$path[@]"
)

# Platform-specific additions
[[ -d /mingw64/bin ]] && path+=(/mingw64/bin)
[[ -d "/c/Program Files/Docker/Docker/resources/bin" ]] && \
    path+=("/c/Program Files/Docker/Docker/resources/bin")

# Export PATH
export PATH

############################################################################
# 8) PLATFORM DETECTION
############################################################################

# WSL detection
export WSL=0
if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
    export WSL=1
fi

# Termux detection
export TERMUX=0
[[ -d "/data/data/com.termux" ]] && export TERMUX=1

# macOS detection
export MACOS=0
[[ "$(uname)" == "Darwin" ]] && export MACOS=1

# True-color auto-detection
if [[ "$COLORTERM" == "truecolor" ]] || [[ "$TERM" == *256* ]]; then
    export TERM=xterm-256color
    export BAT_THEME=TwoDark
fi

############################################################################
# 9) PLUGIN CONFIGURATIONS
############################################################################

# Powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# zsh-syntax-highlighting
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=bold
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold

# zsh-autoswitch-virtualenv
export AUTOSWITCH_VIRTUAL_ENV_DIR="venv"
export AUTOSWITCH_VIRTUAL_ENV_DIR_EXTRA=".venv"
export AUTOSWITCH_SILENT=1

# zsh-z
export ZSHZ_CMD="z"
export ZSHZ_CASE="smart"
export ZSHZ_UNCOMMON=1

# NVM (lazy loading for speed)
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Lazy load NVM
nvm() {
    unset -f nvm
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# zoxide - faster directory jumping
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

############################################################################
# 10) FZF + FD CONFIGURATION
############################################################################

export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --inline-info
    --preview-window=:hidden
    --bind=ctrl-/:toggle-preview
'

# True color support for FZF
if [[ "$COLORTERM" == "truecolor" ]] || [[ "$TERM" == *256* ]]; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=16,bg+:238,preview-bg:235"
fi

# Use fd if available
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
fi

# Load FZF keybindings if available
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh

############################################################################
# 11) ALIASES
############################################################################

# Listing commands - use eza if available, fallback to ls
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -lh --group-directories-first --icons'
    alias la='eza -lha --group-directories-first --icons'
    alias lt='eza --tree --level=2 --icons'
    alias tree='eza --tree --icons'
else
    alias ls='ls --color=auto -F'
    alias ll='ls -lhF --color=auto'
    alias la='ls -lhaF --color=auto'
fi

alias l='ls'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Safety aliases with better flags
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'
alias mkdir='mkdir -pv'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Utility aliases
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias wget='wget -c'
alias curl='curl -L'
alias ping='ping -c 5'
alias ports='ss -tulpn 2>/dev/null || netstat -tulpn'
alias myip='curl -s ifconfig.me'

# Python aliases
alias py='python3'
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server 8080'
alias json='python3 -m json.tool'
alias pyhttp='python3 -m http.server'
alias venv='python3 -m venv'

# Editor aliases
alias vi='nvim'
alias vim='nvim'
alias svi='sudo nvim'
alias edit='$EDITOR'

# Directory aliases
alias bd='cd "$OLDPWD"'
alias home='cd ~'
alias cd..='cd ..'
alias ..l='cd .. && ll'

# System aliases
if command -v apt >/dev/null 2>&1; then
    alias apt-update='sudo apt update'
    alias apt-upgrade='sudo apt update && sudo apt full-upgrade -y'
    alias apt-install='sudo apt install'
    alias apt-remove='sudo apt remove'
    alias apt-search='apt search'
    alias apt-clean='sudo apt autoremove -y && sudo apt autoclean'
    alias fix-install='sudo apt --fix-broken install'
fi

# Modern tool replacements
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
    alias less='bat'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
    alias less='batcat'
fi

if command -v rg >/dev/null 2>&1; then
    alias rgf='rg --files | rg'
fi

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git status -sb'
alias gsta='git stash'
alias gstp='git stash pop'

# Docker aliases
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlog='docker logs -f'
    alias dclean='docker system prune -af'
fi

############################################################################
# 12) FUNCTIONS
############################################################################

# Create directory and cd into it
mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1" || return 1
}

# Backup file with timestamp
bk() {
    [[ -z "$1" ]] && { echo "Usage: bk <file>"; return 1; }
    [[ ! -f "$1" ]] && { echo "File not found: $1"; return 1; }
    cp -f "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# Find files by name
ff() {
    [[ -z "$1" ]] && { echo "Usage: ff <pattern>"; return 1; }
    find . -type f -iname "*$1*" 2>/dev/null
}

# Search history
hist() {
    if (( $# )); then
        history | grep -i -- "$*"
    else
        history
    fi
}

# Extract various archive formats
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <archive-file>"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2|*.tbz|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz) tar xzf "$1" ;;
        *.tar.xz|*.txz) tar xJf "$1" ;;
        *.tar.zst) tar -I zstd -xf "$1" ;;
        *.tar) tar xf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.gz) gunzip "$1" ;;
        *.xz) unxz "$1" ;;
        *.zip|*.jar|*.war) unzip "$1" ;;
        *.rar) unrar x "$1" ;;
        *.7z) 7z x "$1" ;;
        *.Z) uncompress "$1" ;;
        *.zst) unzstd "$1" ;;
        *) echo "Error: Unsupported archive format '$1'"; return 1 ;;
    esac
}

# Kill process on specific port
killport() {
    local port="$1"
    [[ -z "$port" ]] && { echo "Usage: killport <port>"; return 1; }
    
    local pid
    if command -v lsof >/dev/null 2>&1; then
        pid=$(lsof -ti:"$port" 2>/dev/null)
    elif command -v ss >/dev/null 2>&1; then
        pid=$(ss -lptn "sport = :$port" 2>/dev/null | awk 'NR>1 {split($6, a, ","); split(a[2], b, "="); print b[2]}')
    fi
    
    if [[ -n "$pid" ]]; then
        echo "Killing process $pid on port $port"
        kill -9 "$pid" 2>/dev/null && echo "Process killed successfully"
    else
        echo "No process found on port $port"
        return 1
    fi
}

# Git convenience functions
gcom() {
    [[ -z "$1" ]] && { echo "Usage: gcom <message>"; return 1; }
    git add . && git commit -m "$1"
}

lazyg() {
    [[ -z "$1" ]] && { echo "Usage: lazyg <message>"; return 1; }
    git add . && git commit -m "$1" && git push
}

# Quick note taking
note() {
    local note_file="${NOTE_FILE:-$HOME/notes.txt}"
    if [[ $# -eq 0 ]]; then
        ${EDITOR:-vim} "$note_file"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$note_file"
    fi
}

# Weather function
weather() {
    local location="${1:-}"
    curl -s "wttr.in/${location}?format=3"
}

############################################################################
# 13) KEYBINDINGS
############################################################################

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Better word navigation
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left

# Better menuselect
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Edit command line in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# zoxide interactive (Ctrl+F)
if command -v zoxide >/dev/null 2>&1; then
    zoxide_i() {
        local result
        result="$(zoxide query -i 2>/dev/null)"
        if [[ -n "$result" ]]; then
            cd "$result" || return 1
            zle reset-prompt
        fi
    }
    zle -N zoxide_i
    bindkey '^f' zoxide_i
fi

############################################################################
# 14) SYSTEM CONFIGURATION
############################################################################

# SSH-Agent auto-start (smart)
if [[ -z "$SSH_AUTH_SOCK" ]] && command -v ssh-agent >/dev/null 2>&1; then
    # Check for existing agent
    if [[ -f ~/.ssh/agent.env ]]; then
        source ~/.ssh/agent.env >/dev/null
        if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
            rm -f ~/.ssh/agent.env
            eval "$(ssh-agent -s)" >/dev/null
            echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh/agent.env
            echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.ssh/agent.env
        fi
    else
        eval "$(ssh-agent -s)" >/dev/null
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh/agent.env
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.ssh/agent.env
    fi
    
    # Auto-add SSH keys
    for key in ~/.ssh/id_{ed25519,rsa,ecdsa}; do
        [[ -f "$key" ]] && ssh-add "$key" 2>/dev/null
    done
fi

# GPG TTY
export GPG_TTY=$(tty)

# Docker / Podman environment
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain
export COMPOSE_DOCKER_CLI_BUILD=1
export PODMAN_USERNS=keep-id

# Editor configuration
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export PAGER="${PAGER:-less}"

# Less configuration
export LESS='-R -i -g -s -w -X -F'
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

############################################################################
# 15) COMPLETION SYSTEM
############################################################################

# Initialize completion system
autoload -Uz compinit

# Use cache for faster loading
if [[ -n "${ZDOTDIR:-~}/.zcompdump"(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

############################################################################
# 16) BLUX10K HELP SYSTEM
############################################################################

b10k() {
    case "$1" in
        -h|--help|help)
            cat <<'EOF'

╔════════════════════════════════════════════════════════════════╗
║                   BLUX10K COMMAND REFERENCE                    ║
║                    Terminal Power System v3.0                  ║
╚════════════════════════════════════════════════════════════════╝

▬▬▬▬▬▬▬ SYSTEM COMMANDS ▬▬▬▬▬▬▬
  update              Universal system update (v3.0)
  update -n           Dry-run mode (preview)
  update -y           Non-interactive mode
  update --help       Show update help
  rz, reload-zsh      Reload ZSH configuration
  zsh-health          Show ZSH health status

▬▬▬▬▬▬▬ NAVIGATION ▬▬▬▬▬▬▬
  .., ..., ....       Quick directory navigation
  - (dash)            Go to previous directory
  z <dir>             Smart directory jump (zoxide)
  ^F                  Interactive directory search

▬▬▬▬▬▬▬ FILE OPERATIONS ▬▬▬▬▬▬▬
  ls, ll, la, lt      Enhanced listing (eza/ls)
  mkcd <dir>          Create and enter directory
  bk <file>           Backup file with timestamp
  ff <pattern>        Find files by pattern
  extract <archive>   Extract any archive format

▬▬▬▬▬▬▬ GIT COMMANDS ▬▬▬▬▬▬▬
  g                   Git shortcut
  gst                 Status (short)
  gl, gll             Log (one-line / detailed)
  gcom <msg>          Add all & commit
  lazyg <msg>         Add, commit & push

▬▬▬▬▬▬▬ UTILITIES ▬▬▬▬▬▬▬
  killport <port>     Kill process on port
  myip                Show external IP
  weather [city]      Get weather info
  note [text]         Quick note taking

▬▬▬▬▬▬▬ KEYBINDINGS ▬▬▬▬▬▬▬
  ^P / ^N             History search up/down
  ^F                  Interactive directory search
  ^X^E                Edit command in $EDITOR
  Ctrl+→ / Ctrl+←     Word navigation

╔════════════════════════════════════════════════════════════════╗
║           Use 'b10k --help' to show this reference             ║
║         BLUX10K: Professional Terminal Environment             ║
╚════════════════════════════════════════════════════════════════╝

EOF
            ;;
        *)
            echo "BLUX10K Terminal System v3.0"
            echo "Usage: b10k [option]"
            echo ""
            echo "Options:"
            echo "  -h, --help    Show comprehensive command reference"
            echo ""
            echo "For full reference: b10k --help"
            ;;
    esac
}

############################################################################
# 17) UPDATE FUNCTION v3.0
############################################################################

update() {
    local version="3.0.0"
    local dry_run=0 yes=0 verbose=0
    local skip_system=0 skip_lang=0 skip_shell=0
    local update_count=0 error_count=0
    local start_time=$(date +%s)
