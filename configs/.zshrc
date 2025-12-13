#!/usr/bin/env zsh
############################################################################
# ~/.zshrc – Consolidated but Complete Configuration
# BLUX10K.zsh Distributed System - Terminal Interface
############################################################################

############################################################################
# BLUX10K.zsh HEADER
############################################################################
echo "                                                                                "
echo "            ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█            "
echo "            ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█            "
echo "            ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀            "
echo "                                                                                "
echo "  █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█"
echo "  █                                                                          █"
echo "  █  >> BLUX ARTIFICIAL INTELLIGENCE DISTRIBUTED SYSTEM ONLINE              █"
echo "  █  >> TERMINAL INTERFACE ACTIVE [$(date +"%H:%M:%S UTC")]                         █"
echo "  █  >> READY FOR USER COMMANDS                                            █"
echo "  █                                                                          █"
echo "  █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█"
echo "                BLUX Ecosystem: https://github.com/Outer-Void                "
echo "                Developer: https://github.com/Justadudeinspace               "
echo "                                                                                "

############################################################################
# 1) PERFORMANCE & COMPATIBILITY
############################################################################
typeset -g ZSH_DISABLE_COMPFIX=true

# Enable Powerlevel10k instant prompt - MUST BE AT THE VERY TOP
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

############################################################################
# 2) PLUGIN MANAGERS SETUP - SIMPLIFIED TO AVOID CONFLICTS
############################################################################

# A) Zplug - Primary plugin manager (RECOMMENDED - use only one)
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

# B) Zinit - Optional secondary (COMMENT OUT IF USING ZPLUG)
# source ~/.zinit/bin/zinit.zsh 2>/dev/null || {
#   git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
#   source ~/.zinit/bin/zinit.zsh
# }

# C) Zgenom - Comment out to avoid conflicts
# source "${HOME}/.zgenom/zgenom.zsh" 2>/dev/null || {
#   git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
#   source "${HOME}/.zgenom/zgenom.zsh"
# }

# D) Znap - For prompt and async loading
[[ -r ~/Repos/znap/znap.zsh ]] || 
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh

############################################################################
# 3) ZPLUG PLUGINS - STREAMLINED
############################################################################

# Core essential plugins only
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "agkozak/zsh-z"

# Oh My Zsh plugins
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

# Theme - Powerlevel10k (recommended)
zplug "romkatv/powerlevel10k", as:theme, depth:1

# Utility plugins
zplug "MichaelAquilina/zsh-autoswitch-virtualenv"
zplug "hlissner/zsh-autopair", defer:2
zplug "Aloxaf/fzf-tab"

# Install plugins if needed
if ! zplug check --verbose; then
    printf "Install missing plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then load them
zplug load

############################################################################
# 4) MANUALLY SOURCED PLUGINS - FIXED PATHS
############################################################################

# Load autosuggestions if not loaded by zplug
if ! typeset -f _zsh_autosuggest_start >/dev/null; then
    [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Safe RM plugin with better error handling
[[ -d ${ZDOTDIR:-~}/.zplugins/zsh-safe-rm ]] || \
  git clone --recursive --depth 1 https://github.com/mattmc3/zsh-safe-rm ${ZDOTDIR:-~}/.zplugins/zsh-safe-rm
[[ -f ${ZDOTDIR:-~}/.zplugins/zsh-safe-rm/zsh-safe-rm.plugin.zsh ]] && \
    source ${ZDOTDIR:-~}/.zplugins/zsh-safe-rm/zsh-safe-rm.plugin.zsh

############################################################################
# 5) ZINIT PLUGINS - OPTIONAL (COMMENT OUT IF USING ZPLUG)
############################################################################
# Note: Using multiple plugin managers can cause conflicts
# Uncomment below only if you want to use zinit instead of zplug

# # Fast syntax highlighting
# zinit light zdharma-continuum/fast-syntax-highlighting
# 
# # Pure theme
# zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light sindresorhus/pure
# 
# # Autosuggestions
# zinit light zsh-users/zsh-autosuggestions
# 
# # History search
# zinit light zdharma-continuum/history-search-multi-word

############################################################################
# 6) ZGENOM SETUP - COMMENTED OUT TO AVOID CONFLICTS
############################################################################
# Using multiple plugin managers causes conflicts. Stick with zplug.

############################################################################
# 7) ZNAP SETUP - FOR ASYNC LOADING
############################################################################

# Use znap for specific async functionality
znap source marlonrichert/zsh-autocomplete
znap function _pyenv pyenv "znap eval pyenv 'pyenv init - --no-rehash'"
compctl -K _pyenv pyenv

############################################################################
# 8) ENVIRONMENT & PATH SETUP
############################################################################

# XDG base dirs
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_CACHE_HOME:=$HOME/.cache}
: ${XDG_STATE_HOME:=$HOME/.local/state}
mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh" 2>/dev/null

# Ruby gems config
[[ ! -f ~/.gemrc ]] && echo "gem: --no-document" > ~/.gemrc

# History configuration
export HISTFILE="${XDG_STATE_HOME}/zsh/history-$(date +%Y-%m)"
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY

# Shell behaviour
setopt PROMPT_SUBST
setopt INTERACTIVE_COMMENTS
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt NOTIFY

# TTY-only options
if [[ -t 0 ]]; then
  setopt CORRECT
  setopt CORRECT_ALL
  bindkey -e  # Emacs keybindings
fi

SPROMPT='zsh: correct '\''%R'\'' to '\''%r'\''? [Yes, No, Abort, Edit] '

# PATH dedup + Windows extras
typeset -U path
export PNPM_HOME="$HOME/.local/share/pnpm"
export VOLTA_HOME="$HOME/.volta"

path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
    "$PNPM_HOME"
    "$VOLTA_HOME/bin"
    "$HOME/.local/share/gem/ruby/3.0.0/bin"  # Fixed version number
    "$HOME/Scripts"
    "$HOME/dev/tools/flutter/bin"
    "$HOME/.turso"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
    $path
)

# Windows additions
[[ -d /mingw64/bin ]] && path+=( /mingw64/bin )
[[ -d "/c/Program Files/Docker/Docker/resources/bin" ]] && path+=( "/c/Program Files/Docker/Docker/resources/bin" )

export PATH

# Platform detection
WSL=0
[[ -f /proc/version ]] && grep -qi microsoft /proc/version && WSL=1
export WSL

# Termux detection
TERMUX=0
[[ -d "/data/data/com.termux" ]] && TERMUX=1
export TERMUX

# macOS detection
MACOS=0
[[ "$(uname)" == "Darwin" ]] && MACOS=1
export MACOS

# True-color auto-detection
if [[ "$COLORTERM" == "truecolor" || "$TERM" == *256* ]]; then
    export TERM=xterm-256color
    export BAT_THEME=TwoDark
fi

############################################################################
# 9) PLUGIN CONFIGURATIONS
############################################################################

# Powerlevel10k - must be at the end for prompt systems
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[path]=bold
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold

# zsh-autoswitch-virtualenv
AUTOSWITCH_VIRTUAL_ENV_DIR="venv"
AUTOSWITCH_VIRTUAL_ENV_DIR_EXTRA=".venv"
AUTOSWITCH_SILENT=1

# zsh-z
ZSHZ_CMD="z"
ZSHZ_CASE="smart"
ZSHZ_UNCOMMON=1

# nvm setup
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# zoxide
eval "$(zoxide init zsh)"

############################################################################
# 10) FZF + FD CONFIGURATION
############################################################################
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if [[ "$COLORTERM" == "truecolor" || "$TERM" == *256* ]]; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=16,bg+:238,preview-bg:235"
fi

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

############################################################################
# 11) ALIASES
############################################################################

# Listing commands
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -lh --group-directories-first --icons'
    alias la='eza -lha --group-directories-first --icons'
    alias tree='eza --tree'
else
    alias ls='ls --color=auto -F'
    alias ll='ls -lh --color=auto'
    alias la='ls -lha --color=auto'
fi

alias l='ls'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Safety aliases
alias cp='cp -iv --reflink=auto'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

# Utility aliases
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias wget='wget -c'
alias ports='ss -tulpn 2>/dev/null || netstat -tulpn'

# Python aliases
alias serve='python3 -m http.server 8080'
alias json='python3 -m json.tool'
alias pyhttp='python3 -m http.server'

# Editor aliases
alias vi='nvim'
alias vim='nvim'
alias svi='sudo nvim'

# Directory aliases
alias bd='cd "$OLDPWD"'
alias home='cd ~'
alias cd..='cd ..'

# System aliases (Debian/Ubuntu specific)
if command -v apt >/dev/null 2>&1; then
    alias fix-install='sudo apt --fix-broken install'
    alias autoremove='sudo apt autoremove -y'
    alias system-upgrade="sudo apt update && sudo apt full-upgrade -y"
    alias dist-upgrade="sudo apt update && sudo apt dist-upgrade -y"
fi

# Modern tool aliases
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
fi

# Web search aliases (if web-search plugin is loaded)
alias google='web_search google' 2>/dev/null || true
alias ddg='web_search duckduckgo' 2>/dev/null || true
alias github='web_search github' 2>/dev/null || true
alias stackoverflow='web_search stackoverflow' 2>/dev/null || true

# Git aliases (extended)
alias gst='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gco='git checkout'

############################################################################
# 12) USEFUL FUNCTIONS
############################################################################

mkcd() { mkdir -p "$1" && cd "$1"; }
bk() { cp -f "$1" "$1.bak"; }
ff() { find . -type f -iname "*$1*" 2>/dev/null; }
hist() { (( $# )) && history | grep -- "$*" || history; }

extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <file>"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "File not found: $1"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz)         tar xJf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.zip)            unzip "$1" ;;
        *.Z)              uncompress "$1" ;;
        *.7z)             7z x "$1" ;;
        *.xz)             unxz "$1" ;;
        *.lzma)           unlzma "$1" ;;
        *)                echo "Cannot extract '$1': unknown format" && return 1 ;;
    esac
}

killport() {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: killport <port>"
        return 1
    fi
    
    local pid
    if command -v lsof >/dev/null 2>&1; then
        pid=$(lsof -ti:"$port")
    elif command -v netstat >/dev/null 2>&1; then
        # This might need adjustment for different systems
        pid=$(netstat -tulpn 2>/dev/null | awk -v port=":$port" '$4 ~ port {split($7, a, "/"); print a[1]}' | head -1)
    else
        echo "Neither lsof nor netstat found"
        return 1
    fi
    
    if [[ -n "$pid" ]]; then
        kill -9 "$pid"
        echo "Killed process $pid on port $port"
    else
        echo "No process found on port $port"
    fi
}

# GitHub functions
gcom() { git add . && git commit -m "$1"; }
lazyg() { git add . && git commit -m "$1" && git push; }

############################################################################
# 13) KEYBINDINGS
############################################################################

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Better menuselect
bindkey -M menuselect '^M' .accept-line

# Reduce beeping
setopt NO_LIST_BEEP

# zoxide interactive
zoxide_i() {
    local result
    result="$(zoxide query -i)"
    if [[ -n "$result" ]]; then
        cd "$result"
        local precmd
        for precmd in $precmd_functions; do
            $precmd
        done
        zle reset-prompt
    fi
}
zle -N zoxide_i
bindkey '^f' zoxide_i

############################################################################
# 14) SYSTEM CONFIGURATION
############################################################################

# SSH-Agent auto-start
if [[ -z "$SSH_AUTH_SOCK" ]] && command -v ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)" >/dev/null
    # Add common SSH keys
    for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/id_ecdsa; do
        [[ -f "$key" ]] && ssh-add "$key" 2>/dev/null
    done
fi

# GPG TTY
export GPG_TTY=$TTY

# Docker / Podman env
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain
export PODMAN_USERNS=keep-id

############################################################################
# 15) BLUX10K HELP SYSTEM - b10k --help
############################################################################

b10k() {
    case "$1" in
        -h|--help|help)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                   BLUX10K COMMAND REFERENCE                    ║"
            echo "║                    Terminal Power System                       ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            
            # System Commands
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ SYSTEM COMMANDS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  update, up, update_system  - Universal system update"
            echo "  rz                         - Reload ZSH configuration"
            echo "  zsh-health                 - Show ZSH health status"
            echo ""
            
            # Navigation Aliases
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ NAVIGATION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  .., ..., ...., .....       - Quick directory navigation"
            echo "  home                       - Go to home directory"
            echo "  bd                         - Go back to previous directory"
            echo "  cd..                       - Fix common cd typo"
            echo ""
            
            # File Operations
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ FILE OPERATIONS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  ls, ll, la, l, tree        - Enhanced listing (eza)"
            echo "  cp, mv, rm                 - Safe file operations"
            echo "  mkdir                      - Create directories with parents"
            echo "  grep                       - Colored grep"
            echo "  df, du                     - Human-readable disk usage"
            echo ""
            
            # Custom Functions
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ CUSTOM FUNCTIONS ▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  mkcd <dir>                 - Create and enter directory"
            echo "  bk <file>                  - Backup file with .bak extension"
            echo "  ff <pattern>               - Find files by name pattern"
            echo "  hist <pattern>             - Search command history"
            echo "  extract <archive>          - Extract various archive formats"
            echo "  killport <port>            - Kill process using specified port"
            echo ""
            
            # Development Tools
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ DEVELOPMENT ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  serve                      - Start Python HTTP server on 8080"
            echo "  json                       - Pretty-print JSON"
            echo "  pyhttp                     - Python HTTP server"
            echo "  vi, vim, svi               - NeoVim editor shortcuts"
            echo "  ports                      - Show listening ports"
            echo ""
            
            # Git Functions
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ GIT COMMANDS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  gst                        - Git status"
            echo "  gd                         - Git diff"
            echo "  gl                         - Git log with graph"
            echo "  ga                         - Git add"
            echo "  gc                         - Git commit"
            echo "  gp                         - Git push"
            echo "  gco                        - Git checkout"
            echo "  gcom <msg>                 - Git add all and commit"
            echo "  lazyg <msg>                - Git add, commit, and push"
            echo ""
            
            # System Management (Debian/Ubuntu)
            if command -v apt >/dev/null 2>&1; then
                echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ APT MANAGEMENT ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
                echo "  fix-install              - Fix broken packages"
                echo "  autoremove               - Remove unused packages"
                echo "  system-upgrade           - Full system upgrade"
                echo "  dist-upgrade             - Distribution upgrade"
                echo ""
            fi
            
            # Modern Tools
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ MODERN TOOLS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  cat                        - Bat-powered cat (if available)"
            echo "  fd                         - Modern find replacement"
            echo "  z <dir>                    - Smart directory jumping (zoxide)"
            echo "  ^f                         - Interactive directory search"
            echo ""
            
            # Web Search (if available)
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ WEB SEARCH ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  google <query>             - Search Google"
            echo "  ddg <query>                - Search DuckDuckGo"
            echo "  github <query>             - Search GitHub"
            echo "  stackoverflow <query>      - Search Stack Overflow"
            echo ""
            
            # Keybindings
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ KEYBINDINGS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  ^[[A / ^P                  - History search up"
            echo "  ^[[B / ^N                  - History search down"
            echo "  ^f                         - Interactive zoxide search"
            echo "  ^M (menuselect)            - Accept completion"
            echo ""
            
            # Plugin Information
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ PLUGINS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  zsh-syntax-highlighting    - Command syntax highlighting"
            echo "  zsh-autosuggestions        - Command suggestions from history"
            echo "  zsh-history-substring-search - Better history search"
            echo "  zsh-z / zoxide             - Smart directory jumping"
            echo "  zsh-autoswitch-virtualenv  - Auto Python virtualenv activation"
            echo "  fzf-tab                    - Enhanced tab completion"
            echo ""
            
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║           Use 'b10k --help' to show this reference            ║"
            echo "║         BLUX10K: Professional Terminal Environment            ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        *)
            echo "BLUX10K Terminal System"
            echo "Usage: b10k [option]"
            echo "Options:"
            echo "  -h, --help, help    Show this comprehensive command reference"
            echo "  (no args)           Show this brief usage info"
            echo ""
            echo "For full command reference: b10k --help"
            ;;
    esac
}

############################################################################
# 16) UPDATE FUNCTION v2.1 (SIMPLIFIED)
############################################################################

update() {
    echo "BLUX10K System Update v2.1.0"
    echo "=============================="
    
    local dry_run=0
    local yes=0
    
    # Parse simple arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--dry-run) dry_run=1 ;;
            -y|--yes) yes=1 ;;
            -h|--help)
                echo "Usage: update [options]"
                echo "  -n --dry-run    Simulate without making changes"
                echo "  -y --yes        Non-interactive mode"
                echo "  -h --help       Show this help"
                return 0
                ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
        shift
    done
    
    # System package managers
    if command -v apt >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating APT packages..."
        sudo apt update && sudo apt full-upgrade -y
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update APT packages"
    fi

    if command -v brew >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating Homebrew..."
        brew update && brew upgrade
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update Homebrew"
    fi

    if command -v flatpak >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating Flatpaks..."
        flatpak update -y
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update Flatpaks"
    fi

    # Language package managers
    if command -v pip3 >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating Python packages..."
        pip3 install --upgrade pip
        pip3 list --outdated --format=freeze | cut -d= -f1 | xargs -n1 pip3 install -U
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update Python packages"
    fi

    if command -v pipx >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating pipx packages..."
        pipx upgrade-all
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update pipx packages"
    fi

    if command -v npm >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating global npm packages..."
        npm update -g
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update npm packages"
    fi

    if command -v cargo >/dev/null && [[ $dry_run -eq 0 ]]; then
        echo "Updating Rust toolchain..."
        rustup update
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update Rust"
    fi

    # Shell frameworks
    if [[ -d "${ZSH:-$HOME/.oh-my-zsh}" ]] && [[ $dry_run -eq 0 ]]; then
        echo "Updating Oh My Zsh..."
        "$ZSH/tools/upgrade.sh"
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update Oh My Zsh"
    fi

    if [[ -d "$ZPLUG_HOME" ]] && [[ $dry_run -eq 0 ]]; then
        echo "Updating zplug plugins..."
        zplug update
    elif [[ $dry_run -eq 1 ]]; then
        echo "[DRY-RUN] Would update zplug"
    fi

    echo "System update complete!"
}

############################################################################
# 17) COMPLETION FOR UPDATE
############################################################################
_update_completion() {
    local -a opts
    opts=(
        '(-n --dry-run)'{-n,--dry-run}'[Simulate without changes]'
        '(-y --yes)'{-y,--yes}'[Non-interactive mode]'
        '(-h --help)'{-h,--help}'[Show help]'
    )
    _arguments $opts
}
compdef _update_completion update

alias update_system='update'
alias up='update'

############################################################################
# 18) UTILITY FUNCTIONS
############################################################################
reload-zsh() { exec zsh }
alias rz='reload-zsh'

zsh-health() {
    echo "ZSH Health Check:"
    echo "• ZSH Version: $(zsh --version)"
    echo "• Oh My Zsh: $([ -d "$ZSH" ] && echo "Installed" || echo "Not found")"
    echo "• zplug: $([ -d "$ZPLUG_HOME" ] && echo "Installed" || echo "Not found")"
    echo "• Plugins loaded: $(zplug list --installed 2>/dev/null | wc -l)"
    echo "• PATH directories: ${#path}"
    echo "• History entries: $(fc -l 1 | wc -l)"
}

############################################################################
# 19) FINAL LOADING AND OPTIONAL MOTD
############################################################################

# Local overrides (last)
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Private environment (API keys, etc.)
[[ -f ~/.config/private/env.zsh ]] && source ~/.config/private/env.zsh

# Compile for speed
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile -R ~/.zshrc.zwc ~/.zshrc 2>/dev/null
fi

# Optional: Fastfetch/Neofetch - COMMENTED OUT BY DEFAULT
# Uncomment the preferred option:

# Option 1: Fastfetch (fast)
# if command -v fastfetch >/dev/null 2>&1 && [[ -o interactive ]]; then
#     fastfetch
# fi

# Option 2: Neofetch (more detailed)
if command -v neofetch >/dev/null 2>&1 && [[ -o interactive ]]; then
    neofetch
fi

# Option 3: Conditional based on terminal size
# if [[ -o interactive ]] && (( LINES > 30 )); then
#     if command -v fastfetch >/dev/null 2>&1; then
#         fastfetch
#     elif command -v neofetch >/dev/null 2>&1; then
#         neofetch
#     fi
# fi

# Final PATH export
export PATH

# Success message
echo "BLUX10K configuration loaded successfully!"