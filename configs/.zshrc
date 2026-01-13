#!/usr/bin/env zsh
############################################################################
# ~/.zshrc – BLUX10K.zsh Enhanced Professional Configuration
# Version: 4.0.0 | Secure | Optimized | Debuggable | Modular
############################################################################

############################################################################
# BLUX10K.zsh ENHANCED HEADER WITH DIAGNOSTICS
############################################################################
# Only show header on first login of the day
if [[ ! -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/last_login" ]] || \
   [[ $(date +%Y%m%d) -gt $(cat "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/last_login") ]]; then
    echo ""
    echo "            ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█            "
    echo "            ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█            "
    echo "            ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀            "
    echo ""
    echo "  █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█"
    echo "  █                                                                                      █"
    echo "  █  >> BLUX AI DISTRIBUTED SYSTEM v4.0.0 [SECURE MODE]                                  █"
    echo "  █  >> TERMINAL INTERFACE ACTIVE [$(date +"%H:%M:%S %Z")]                               █"
    echo "  █  >> UPTIME: $(uptime -p | sed 's/up //')                                             █"
    echo "  █  >> MEMORY: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')                             █"
    echo "  █                                                                                      █"
    echo "  █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█"
    echo "                BLUX Ecosystem: https://github.com/Outer-Void                         "
    echo "                Developer: https://github.com/Justadudeinspace                        "
    echo ""
    date +%Y%m%d > "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/last_login"
fi

############################################################################
# CONFIGURATION CONSTANTS & DEBUG SETTINGS
############################################################################
export ZSH_DEBUG=${ZSH_DEBUG:-0}
export ZSH_PROFILE=${ZSH_PROFILE:-0}
export ZSH_SECURE=${ZSH_SECURE:-1}

# Performance & Security
typeset -g ZSH_DISABLE_COMPFIX=true
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Start profiling if enabled
if [[ $ZSH_PROFILE -eq 1 ]]; then
    zmodload zsh/zprof
    PS4='+%D{%H:%M:%S.%.} %N:%i> '
    exec 3>&2 2>/tmp/zshstart.$$.log
    setopt xtrace prompt_subst
fi

############################################################################
# PERFORMANCE OPTIMIZATION: Instant Prompt
############################################################################
# Enable Powerlevel10k instant prompt - MUST BE AT THE VERY TOP
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    _p10k_start_time=$((EPOCHREALTIME*1000))
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    _p10k_end_time=$((EPOCHREALTIME*1000))
    (( _p10k_duration = _p10k_end_time - _p10k_start_time ))
    [[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] Powerlevel10k instant prompt: ${_p10k_duration}ms" >&2
fi

############################################################################
# SECURITY HARDENING
############################################################################
if [[ $ZSH_SECURE -eq 1 ]]; then
    # Restrict permissions
    umask 077
    
    # Secure history file
    chmod 600 "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history" 2>/dev/null
    
    # Disable core dumps
    ulimit -c 0
    
    # Secure temp files
    export TMPDIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmp"
    mkdir -p "$TMPDIR" && chmod 700 "$TMPDIR"
    
    # Secure directory navigation
    setopt CHASE_LINKS
    setopt NO_CLOBBER
fi

############################################################################
# PLUGIN MANAGER: SINGLE MANAGER APPROACH
############################################################################
_plugins_start_time=$((EPOCHREALTIME*1000))

# Use zinit as primary (faster than zplug)
if [[ ! -d ~/.local/share/zinit ]]; then
    git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/bin
fi
source ~/.local/share/zinit/bin/zinit.zsh

# Alternative: Antidote (simpler, faster)
# if [[ ! -d ~/.antidote ]]; then
#     git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
# fi
# source ~/.antidote/antidote.zsh
# antidote load

_plugins_end_time=$((EPOCHREALTIME*1000))
(( _plugins_duration = _plugins_end_time - _plugins_start_time ))
[[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] Plugin manager init: ${_plugins_duration}ms" >&2

############################################################################
# ESSENTIAL PLUGINS WITH LAZY LOADING
############################################################################
_plugin_load_start=$((EPOCHREALTIME*1000))

# Syntax highlighting (fast-syntax-highlighting is faster)
zinit ice wait"0" lucid atload"_zsh_highlight"
zinit light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions with async
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Enhanced completions
zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# History search
zinit ice wait"0" lucid
zinit light zsh-users/zsh-history-substring-search

# Directory jumping (zoxide replacement)
zinit ice wait"0" lucid
zinit light agkozak/zsh-z

# Auto-pair brackets
zinit ice wait"0" lucid
zinit light hlissner/zsh-autopair

# FZF integration
zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab

# Git enhancements
zinit ice wait"0" lucid
zinit light wfxr/forgit

# Python virtualenv auto-switching
zinit ice wait"0" lucid
zinit light MichaelAquilina/zsh-autoswitch-virtualenv

# Theme: Powerlevel10k (must be last)
zinit ice depth"1"
zinit light romkatv/powerlevel10k

_plugin_load_end=$((EPOCHREALTIME*1000))
(( _plugin_load_duration = _plugin_load_end - _plugin_load_start ))
[[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] Plugin loading: ${_plugin_load_duration}ms" >&2

############################################################################
# ENVIRONMENT & PATH CONFIGURATION
############################################################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Create required directories
mkdir -p \
    "$XDG_CACHE_HOME/zsh" \
    "$XDG_STATE_HOME/zsh" \
    "$XDG_DATA_HOME/zsh" \
    "$XDG_CONFIG_HOME/zsh" \
    2>/dev/null

# History Configuration (Secure)
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:ll:la:cd:cd -:pwd:exit:date:* --help"

setopt append_history           # Append to history file
setopt extended_history         # Save timestamp and duration
setopt hist_expire_dups_first   # Expire duplicates first
setopt hist_find_no_dups        # Don't show duplicates in find
setopt hist_ignore_all_dups     # Ignore all duplicates
setopt hist_ignore_space        # Ignore commands starting with space
setopt hist_reduce_blanks       # Remove superfluous blanks
setopt hist_save_no_dups        # Don't save duplicates
setopt hist_verify              # Show before executing
setopt inc_append_history_time  # Append immediately with timestamp
setopt share_history            # Share history between sessions

# Shell Behavior
setopt auto_cd                  # Change directories without cd
setopt auto_pushd               # Make cd push old dir onto dir stack
setopt pushd_ignore_dups        # Don't push duplicates
setopt pushd_minus              # Invert + and - operators
setopt extended_glob            # Extended globbing patterns
setopt interactive_comments     # Allow comments in interactive shell
setopt notify                   # Report background job status immediately
setopt no_beep                  # No beep on error
setopt no_flow_control          # Disable flow control (^S/^Q)
setopt correct                  # Correct spelling of commands
setopt correct_all              # Correct all arguments
setopt prompt_subst             # Enable prompt substitution

# Keybindings
bindkey -e                      # Emacs keybindings
bindkey '^[[3~' delete-char     # Delete key
bindkey '^[[1;5C' forward-word  # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left

############################################################################
# SECURE & DEDUPLICATED PATH CONSTRUCTION
############################################################################
_path_start=$((EPOCHREALTIME*1000))

# Define path segments in order of priority
path_segments=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.volta/bin"
    "$HOME/.local/share/gem/ruby/$(ruby -e 'puts RUBY_VERSION[/^\d+\.\d+/]' 2>/dev/null || echo "3.0")/bin"
    "$HOME/Scripts"
    "$HOME/dev/tools/flutter/bin"
    "$HOME/.turso"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "/sbin"
    "/bin"
)

# Platform-specific additions
case "$(uname -s)" in
    Linux*)
        [[ -f /proc/version ]] && grep -qi microsoft /proc/version && \
            path_segments+=(/mingw64/bin "/c/Program Files/Docker/Docker/resources/bin")
        
        # Snap support
        [[ -d /snap/bin ]] && path_segments+=(/snap/bin)
        
        # Flatpak support
        [[ -d /var/lib/flatpak/exports/bin ]] && path_segments+=(/var/lib/flatpak/exports/bin)
        [[ -d "$HOME/.local/share/flatpak/exports/bin" ]] && path_segments+=("$HOME/.local/share/flatpak/exports/bin")
        ;;
    Darwin*)
        # Homebrew on Apple Silicon
        [[ -d /opt/homebrew/bin ]] && path_segments=(/opt/homebrew/bin $path_segments)
        [[ -d /opt/homebrew/sbin ]] && path_segments=(/opt/homebrew/sbin $path_segments)
        
        # Homebrew on Intel
        [[ -d /usr/local/opt ]] && path_segments=(/usr/local/opt $path_segments)
        ;;
esac

# Build and deduplicate PATH
typeset -U path
for segment in $path_segments; do
    [[ -d "$segment" ]] && path+=("$segment")
done

# Clean PATH of non-existent directories
clean_path=()
for dir in $path; do
    if [[ -d "$dir" ]]; then
        clean_path+=("$dir")
    else
        [[ $ZSH_DEBUG -eq 1 ]] && echo "[DEBUG] Removing non-existent PATH entry: $dir" >&2
    fi
done
path=($clean_path)

export PATH

_path_end=$((EPOCHREALTIME*1000))
(( _path_duration = _path_end - _path_start ))
[[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] PATH construction: ${_path_duration}ms" >&2

############################################################################
# PLUGIN CONFIGURATIONS
############################################################################
# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=true

# fast-syntax-highlighting
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=red'
FAST_HIGHLIGHT_STYLES[command]='fg=green'
FAST_HIGHLIGHT_STYLES[builtin]='fg=yellow'
FAST_HIGHLIGHT_STYLES[path]='underline'

# zsh-z
ZSHZ_CMD='j'
ZSHZ_CASE='smart'
ZSHZ_UNCOMMON=1

# zsh-autoswitch-virtualenv
AUTOSWITCH_VIRTUAL_ENV_DIR='venv'
AUTOSWITCH_VIRTUAL_ENV_DIR_EXTRA='.venv'
AUTOSWITCH_SILENT=1
AUTOSWITCH_MESSAGE_FORMAT='Switched to virtualenv: %venv_name'

# forgit (git enhancements)
FORGIT_LOG_FZF_OPTS='
    --height=40%
    --layout=reverse
    --preview="echo {} | grep -o \"[a-f0-9]\{7,\}\" | head -1 | xargs git show --color=always"
'

############################################################################
# FZF CONFIGURATION WITH PERFORMANCE OPTIMIZATION
############################################################################
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --preview-window='right:60%'
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
"

# Use fd (fdfind) or find
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

############################################################################
# ENHANCED ALIASES WITH VALIDATION
############################################################################
# Safety first
alias rm='rm -I --preserve-root'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Modern ls replacement
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -lh --group-directories-first --icons --git'
    alias la='eza -lha --group-directories-first --icons --git'
    alias tree='eza --tree --level=2 --group-directories-first'
    alias l='eza -1 --group-directories-first'
else
    alias ls='ls --color=auto -F'
    alias ll='ls -lh --color=auto'
    alias la='ls -lha --color=auto'
    alias l='ls -1'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# System monitoring
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i'
alias top='htop'
alias iotop='sudo iotop'
alias iftop='sudo iftop'

# Network
alias ports='netstat -tulpn 2>/dev/null || ss -tulpn'
alias myip='curl -s https://api.ipify.org'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Git (enhanced)
alias g='git'
alias gst='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -v -am'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch -v'
alias gba='git branch -av'
alias gr='git remote -v'
alias gcl='git clone --recursive'

# Python
alias python='python3'
alias pip='pip3'
alias pyclean='find . -type f -name "*.py[co]" -delete -o -type d -name "__pycache__" -delete'
alias venv='python3 -m venv'
alias serve='python3 -m http.server 8080'

# Editors
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
else
    export EDITOR='vim'
    export VISUAL='vim'
fi

# Modern tools
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
fi

if command -v procs >/dev/null 2>&1; then
    alias ps='procs'
fi

# Docker/Podman
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
elif command -v podman >/dev/null 2>&1; then
    alias d='podman'
fi

# Platform-specific aliases
case "$(uname -s)" in
    Linux*)
        if command -v apt >/dev/null 2>&1; then
            alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
            alias install='sudo apt install'
            alias remove='sudo apt remove'
            alias search='apt search'
        elif command -v dnf >/dev/null 2>&1; then
            alias update='sudo dnf upgrade -y'
        elif command -v pacman >/dev/null 2>&1; then
            alias update='sudo pacman -Syu'
        fi
        ;;
    Darwin*)
        if command -v brew >/dev/null 2>&1; then
            alias update='brew update && brew upgrade && brew cleanup'
        fi
        ;;
esac

############################################################################
# ENHANCED UTILITY FUNCTIONS
############################################################################
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1" || return 1
}

# Backup file with timestamp
backup() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Usage: backup <file>"
        return 1
    fi
    cp -f "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)" && \
    echo "Backup created: ${file}.backup.$(date +%Y%m%d_%H%M%S)"
}

# Find files recursively
ff() {
    local pattern="$1"
    if [[ -z "$pattern" ]]; then
        echo "Usage: ff <pattern>"
        return 1
    fi
    find . -type f -iname "*${pattern}*" 2>/dev/null
}

# Search in history with regex
hist() {
    if [[ -z "$1" ]]; then
        history 1 | fzf +s --tac
    else
        history 1 | grep -i "$1"
    fi
}

# Extract various archive formats
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "File not found: $1"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2|*.tbz2)   tar xjf "$1" ;;
        *.tar.gz|*.tgz)     tar xzf "$1" ;;
        *.tar.xz)           tar xJf "$1" ;;
        *.bz2)              bunzip2 "$1" ;;
        *.rar)              unrar x "$1" ;;
        *.gz)               gunzip "$1" ;;
        *.tar)              tar xf "$1" ;;
        *.tbz)              tar xjf "$1" ;;
        *.tgz)              tar xzf "$1" ;;
        *.zip)              unzip "$1" ;;
        *.Z)                uncompress "$1" ;;
        *.7z)               7z x "$1" ;;
        *.xz)               unxz "$1" ;;
        *.exe)              cabextract "$1" ;;
        *)                  echo "Cannot extract '$1': Unknown format" ;;
    esac
}

# Kill process on specific port
killport() {
    local port="$1"
    if [[ -z "$port" ]]; then
        echo "Usage: killport <port>"
        return 1
    fi
    
    local pid
    if command -v lsof >/dev/null 2>&1; then
        pid=$(lsof -ti:"$port")
    else
        pid=$(netstat -tulpn 2>/dev/null | grep ":$port" | awk '{print $7}' | cut -d/ -f1)
    fi
    
    if [[ -n "$pid" ]]; then
        echo "Killing process $pid on port $port"
        kill -9 "$pid"
    else
        echo "No process found on port $port"
    fi
}

# Create a simple HTTP server with directory listing
httpserv() {
    local port="${1:-8080}"
    echo "Serving HTTP on port $port"
    python3 -m http.server "$port"
}

# Git commit all with message
gcom() {
    git add -A
    git commit -m "$*"
}

# Git commit and push
lazyg() {
    git add -A
    git commit -m "$*"
    git push
}

# Quick calculator
calc() {
    echo "$*" | bc -l
}

# Weather
weather() {
    local city="${*:-}"
    curl -s "wttr.in/${city}"
}

############################################################################
# DEBUGGING & DIAGNOSTICS FUNCTIONS
############################################################################
# ZSH Health Check
zsh-health() {
    echo "=== ZSH DIAGNOSTICS ==="
    echo ""
    
    echo "1. VERSION:"
    echo "   ZSH: $(zsh --version)"
    echo "   Shell: $SHELL"
    echo ""
    
    echo "2. PERFORMANCE:"
    echo "   Startup time: ${_total_startup_time:-"N/A"}ms"
    echo "   Plugin count: $(zinit list 2>/dev/null | wc -l)"
    echo "   PATH entries: ${#path[@]}"
    echo ""
    
    echo "3. PLUGINS:"
    zinit list 2>/dev/null | while read -r line; do
        echo "   ✓ $(echo "$line" | awk '{print $1}')"
    done
    echo ""
    
    echo "4. ENVIRONMENT:"
    echo "   XDG_CACHE_HOME: $XDG_CACHE_HOME"
    echo "   XDG_CONFIG_HOME: $XDG_CONFIG_HOME"
    echo "   HISTFILE: $HISTFILE"
    echo "   HISTSIZE: $HISTSIZE"
    echo ""
    
    echo "5. TOOLS:"
    local tools=("git" "nvim" "node" "python3" "docker" "fzf")
    for tool in $tools; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "   ✓ $tool: $(which $tool)"
        else
            echo "   ✗ $tool: Not found"
        fi
    done
    echo ""
    
    echo "6. KEYBINDINGS:"
    echo "   ^R: Reverse history search"
    echo "   ^S: Forward history search"
    echo "   ^A: Beginning of line"
    echo "   ^E: End of line"
    echo "   ^U: Kill to beginning"
    echo "   ^K: Kill to end"
    echo ""
    
    echo "=== END DIAGNOSTICS ==="
}

# Debug ZSH startup
debug-zsh() {
    ZSH_DEBUG=1 ZSH_PROFILE=1 exec zsh -i -c 'zprof | head -20'
}

# Profile ZSH startup
profile-zsh() {
    time (zsh -i -c exit)
}

# List large directories
duc() {
    local depth=${1:-1}
    du -h --max-depth="$depth" . | sort -rh | head -20
}

############################################################################
# ENHANCED UPDATE FUNCTION v4.0
############################################################################
update() {
    local version="4.0.0"
    local start_time=$(date +%s)
    local update_count=0
    local error_count=0
    local updated_packages=()
    local failed_packages=()
    
    # Colors
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local MAGENTA='\033[0;35m'
    local CYAN='\033[0;36m'
    local NC='\033[0m'
    local BOLD='\033[1m'
    
    # Helper functions
    _log() {
        local level="$1"
        local color="$2"
        local message="$3"
        echo -e "${color}[${level}]${NC} ${message}"
    }
    
    _run_cmd() {
        local cmd="$1"
        local name="$2"
        
        if eval "$cmd"; then
            _log "✓" "$GREEN" "$name"
            updated_packages+=("$name")
            ((update_count++))
            return 0
        else
            _log "✗" "$RED" "$name (Failed)"
            failed_packages+=("$name")
            ((error_count++))
            return 1
        fi
    }
    
    _section() {
        echo ""
        echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║                      $1                       ║${NC}"
        echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    }
    
    # Parse arguments
    local dry_run=0
    local verbose=0
    local skip_system=0
    local skip_lang=0
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--dry-run) dry_run=1 ;;
            -v|--verbose) verbose=1 ;;
            --skip-system) skip_system=1 ;;
            --skip-lang) skip_lang=1 ;;
            -h|--help)
                cat <<EOF
BLUX10K Universal Updater v${version}

Usage: update [OPTIONS]

Options:
  -n, --dry-run     Simulate updates without making changes
  -v, --verbose     Show detailed output
  --skip-system     Skip system package managers
  --skip-lang       Skip language package managers
  -h, --help        Show this help message

Examples:
  update            # Normal update
  update -n         # Dry run
  update -v         # Verbose output
EOF
                return 0
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
        shift
    done
    
    # Header
    clear
    echo -e "${MAGENTA}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           BLUX10K UNIVERSAL UPDATER v${version}                 ║"
    echo "║               System Maintenance Toolkit                       ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [[ $dry_run -eq 1 ]]; then
        _log "!" "$YELLOW" "DRY RUN MODE - No changes will be made"
    fi
    
    ############################################################################
    # SYSTEM PACKAGE MANAGERS
    ############################################################################
    if [[ $skip_system -eq 0 ]]; then
        _section "SYSTEM PACKAGES"
        
        # Detect package manager
        if command -v apt >/dev/null 2>&1; then
            _run_cmd "sudo apt update" "APT: Update package lists"
            _run_cmd "sudo apt full-upgrade -y" "APT: Upgrade packages"
            _run_cmd "sudo apt autoremove -y" "APT: Remove unused packages"
            _run_cmd "sudo apt autoclean" "APT: Clean cache"
            
        elif command -v dnf >/dev/null 2>&1; then
            _run_cmd "sudo dnf upgrade -y" "DNF: Upgrade packages"
            _run_cmd "sudo dnf autoremove -y" "DNF: Remove unused packages"
            
        elif command -v pacman >/dev/null 2>&1; then
            _run_cmd "sudo pacman -Syu --noconfirm" "Pacman: System update"
            _run_cmd "sudo pacman -Sc --noconfirm" "Pacman: Clean cache"
            
        elif command -v brew >/dev/null 2>&1; then
            _run_cmd "brew update" "Homebrew: Update"
            _run_cmd "brew upgrade" "Homebrew: Upgrade packages"
            _run_cmd "brew cleanup" "Homebrew: Cleanup"
        fi
        
        # Universal package managers
        if command -v flatpak >/dev/null 2>&1; then
            _run_cmd "flatpak update -y" "Flatpak: Update"
        fi
        
        if command -v snap >/dev/null 2>&1; then
            _run_cmd "sudo snap refresh" "Snap: Refresh"
        fi
    fi
    
    ############################################################################
    # LANGUAGE PACKAGES
    ############################################################################
    if [[ $skip_lang -eq 0 ]]; then
        _section "LANGUAGE PACKAGES"
        
        # Python
        if command -v pip3 >/dev/null 2>&1; then
            _run_cmd "pip3 install --upgrade pip setuptools wheel" "Python: Upgrade pip"
            if [[ $verbose -eq 1 ]]; then
                _run_cmd "pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U" "Python: Upgrade all packages"
            else
                _run_cmd "pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U -q" "Python: Upgrade all packages"
            fi
        fi
        
        if command -v pipx >/dev/null 2>&1; then
            _run_cmd "pipx upgrade-all" "Python: Upgrade pipx apps"
        fi
        
        # Node.js
        if command -v npm >/dev/null 2>&1; then
            _run_cmd "npm install -g npm@latest" "Node.js: Update npm"
            _run_cmd "npm update -g" "Node.js: Update global packages"
        fi
        
        if command -v pnpm >/dev/null 2>&1; then
            _run_cmd "pnpm update -g" "Node.js: Update pnpm packages"
        fi
        
        # Rust
        if command -v rustup >/dev/null 2>&1; then
            _run_cmd "rustup update" "Rust: Update toolchain"
        fi
        
        if command -v cargo >/dev/null 2>&1; then
            if command -v cargo-install-update >/dev/null 2>&1; then
                _run_cmd "cargo install-update -a" "Rust: Update cargo binaries"
            fi
        fi
        
        # Ruby
        if command -v gem >/dev/null 2>&1; then
            _run_cmd "gem update --system" "Ruby: Update RubyGems"
            _run_cmd "gem update" "Ruby: Update gems"
        fi
        
        # Go
        if command -v go >/dev/null 2>&1; then
            _run_cmd "go install golang.org/x/tools/cmd/...@latest" "Go: Update tools"
        fi
    fi
    
    ############################################################################
    # SHELL & TOOLS
    ############################################################################
    _section "SHELL & TOOLS"
    
    # Zinit (if using)
    if command -v zinit >/dev/null 2>&1; then
        _run_cmd "zinit self-update" "Zinit: Self update"
        _run_cmd "zinit update --all" "Zinit: Update all plugins"
    fi
    
    # Oh My Zsh
    if [[ -d "$ZSH" ]]; then
        _run_cmd "omz update" "Oh My Zsh: Update"
    fi
    
    # NeoVim
    if command -v nvim >/dev/null 2>&1; then
        _run_cmd "nvim --headless '+Lazy! sync' +qa" "NeoVim: Update plugins"
    fi
    
    # tldr
    if command -v tldr >/dev/null 2>&1; then
        _run_cmd "tldr --update" "tldr: Update cache"
    fi
    
    ############################################################################
    # SYSTEM MAINTENANCE
    ############################################################################
    _section "SYSTEM MAINTENANCE"
    
    # Update databases
    if command -v updatedb >/dev/null 2>&1; then
        _run_cmd "sudo updatedb" "System: Update file database"
    fi
    
    if command -v mandb >/dev/null 2>&1; then
        _run_cmd "sudo mandb" "System: Update man database"
    fi
    
    if command -v fc-cache >/dev/null 2>&1; then
        _run_cmd "fc-cache -fv" "System: Refresh font cache"
    fi
    
    # Docker cleanup
    if command -v docker >/dev/null 2>&1; then
        _run_cmd "docker system prune -f" "Docker: Cleanup"
    fi
    
    ############################################################################
    # SUMMARY
    ############################################################################
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    _section "UPDATE SUMMARY"
    
    echo -e "${GREEN}✓ Successful updates: ${update_count}${NC}"
    
    if [[ ${#updated_packages[@]} -gt 0 ]]; then
        echo -e "${CYAN}Updated:${NC}"
        for pkg in $updated_packages; do
            echo "  • $pkg"
        done
    fi
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        echo -e "${RED}✗ Failed updates: ${error_count}${NC}"
        for pkg in $failed_packages; do
            echo "  • $pkg"
        done
    fi
    
    echo -e "${BLUE}⏱ Duration: ${duration} seconds${NC}"
    
    if [[ -f /var/run/reboot-required ]]; then
        echo ""
        echo -e "${YELLOW}⚠ System reboot required!${NC}"
        echo "  Run: sudo reboot"
    fi
    
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}           Update process complete!                           ${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════════${NC}"
    
    return $error_count
}

# Completion for update
_update_completion() {
    local -a opts
    opts=(
        '(-n --dry-run)'{-n,--dry-run}'[Simulate without changes]'
        '(-v --verbose)'{-v,--verbose}'[Show detailed output]'
        '--skip-system[Skip system package managers]'
        '--skip-lang[Skip language package managers]'
        '(-h --help)'{-h,--help}'[Show help]'
    )
    _arguments $opts
}
compdef _update_completion update

# Aliases
alias up='update'
alias upgrade='update'
alias system-update='update'
alias update-dry='update -n'

############################################################################
# KEYBINDINGS ENHANCEMENT
############################################################################
# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# FZF keybindings
bindkey '^R' fzf-history-widget
bindkey '^T' fzf-file-widget
bindkey '^G' fzf-cd-widget

# Zoxide interactive
bindkey '^Z' zoxide_i

# Fix Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Delete keys
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char

############################################################################
# COMPLETION SYSTEM ENHANCEMENT
############################################################################
# Enable completion system
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-$ZSH_VERSION"

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"

############################################################################
# SSH AGENT & GPG SETUP
############################################################################
# SSH Agent
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    if [[ -n "$XDG_RUNTIME_DIR" ]] && [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    elif command -v ssh-agent >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
fi

# Add SSH keys
if [[ -n "$SSH_AUTH_SOCK" ]]; then
    ssh-add -l >/dev/null 2>&1 || {
        for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/id_ecdsa; do
            [[ -f "$key" ]] && ssh-add "$key" 2>/dev/null
        done
    }
fi

# GPG
export GPG_TTY=$(tty)
if command -v gpg-connect-agent >/dev/null 2>&1; then
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
fi

############################################################################
# TOOL INITIALIZATIONS
############################################################################
# nvm (lazy load)
nvm() {
    unset -f nvm
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# rbenv
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

# pyenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    if command -v pyenv-virtualenv-init >/dev/null 2>&1; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# starship (alternative to p10k)
# eval "$(starship init zsh)"

############################################################################
# BLUX10K HELP SYSTEM ENHANCED
############################################################################
b10k() {
    case "$1" in
        -h|--help|help)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                BLUX10K v4.0 COMMAND REFERENCE                 ║"
            echo "║                 Professional Terminal System                  ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ SYSTEM COMMANDS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  update, up, upgrade     - Universal system update"
            echo "  update -n               - Dry run (simulate)"
            echo "  update -v               - Verbose output"
            echo "  rz                      - Reload ZSH configuration"
            echo "  zsh-health              - ZSH diagnostics"
            echo "  debug-zsh               - Debug ZSH startup"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ NAVIGATION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  j <dir>                 - Smart directory jump (zsh-z)"
            echo "  zoxide_i (^Z)           - Interactive directory search"
            echo "  .., ..., ....           - Quick directory up"
            echo "  -                       - Previous directory"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ FILE OPERATIONS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  ls, ll, la, tree        - Enhanced listing"
            echo "  mkcd <dir>              - Make and cd into directory"
            echo "  backup <file>           - Backup with timestamp"
            echo "  extract <archive>       - Extract any archive format"
            echo "  ff <pattern>            - Find files by name"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ NETWORK & PROCESSES ▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  ports                   - List open ports"
            echo "  myip                    - Show public IP"
            echo "  killport <port>         - Kill process on port"
            echo "  weather [city]          - Weather forecast"
            echo "  speedtest               - Internet speed test"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ DEVELOPMENT ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  serve [port]            - Python HTTP server"
            echo "  gcom <msg>              - Git add all and commit"
            echo "  lazyg <msg>             - Git add, commit, push"
            echo "  pyclean                 - Clean Python cache"
            echo "  calc <expr>             - Quick calculator"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ KEYBINDINGS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  ^R                      - Reverse history search (FZF)"
            echo "  ^T                      - File search (FZF)"
            echo "  ^G                      - Directory search (FZF)"
            echo "  ^Z                      - Interactive zoxide"
            echo "  ^[[A / ^P               - History search up"
            echo "  ^[[B / ^N               - History search down"
            echo ""
            
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ DIAGNOSTICS ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  duc [depth]             - Disk usage by directory"
            echo "  hist [pattern]          - Search history"
            echo "  profile-zsh             - Profile ZSH startup time"
            echo ""
            
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║        For more details: b10k --help                          ║"
            echo "║        Report issues: https://github.com/Outer-Void           ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            ;;
        --version|-v)
            echo "BLUX10K Terminal System v4.0.0"
            echo "Build: $(date +%Y%m%d)"
            echo "ZSH: $(zsh --version)"
            ;;
        *)
            echo "BLUX10K Terminal System v4.0.0"
            echo "Usage: b10k [option]"
            echo "Options:"
            echo "  -h, --help, help    Show comprehensive command reference"
            echo "  -v, --version       Show version information"
            echo ""
            echo "Quick reference:"
            echo "  update              Update system"
            echo "  zsh-health          Diagnostics"
            echo "  j <dir>             Smart jump"
            echo "  gcom <msg>          Git commit all"
            ;;
    esac
}

############################################################################
# FINAL SETUP & LOCAL OVERRIDES
############################################################################
# Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Local overrides (load last)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.config/private/env.zsh ]] && source ~/.config/private/env.zsh

# Compile for performance
if [[ ! -f ~/.zshrc.zwc ]] || [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile -R ~/.zshrc.zwc ~/.zshrc 2>/dev/null && \
        [[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] Compiled .zshrc for faster loading" >&2
fi

# System info display (optional)
if [[ -o interactive ]]; then
    # Only show if terminal is large enough
    if (( LINES > 30 && COLUMNS > 80 )); then
        if command -v fastfetch >/dev/null 2>&1; then
            fastfetch --load-config neofetch
        elif command -v neofetch >/dev/null 2>&1; then
            neofetch
        fi
    fi
    
    # Show system status
    echo -e "${GREEN}✓ BLUX10K v4.0.0 loaded${NC}"
    echo -e "${BLUE}▶ $(date '+%A, %B %d, %Y - %H:%M:%S')${NC}"
    echo -e "${CYAN}▶ Uptime: $(uptime -p | sed 's/up //')${NC}"
fi

# End profiling if enabled
if [[ $ZSH_PROFILE -eq 1 ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    echo "Profiling data saved to /tmp/zshstart.$$.log"
fi

# Final PATH export
export PATH
_total_end_time=$((EPOCHREALTIME*1000))
(( _total_startup_time = _total_end_time - _p10k_start_time ))
[[ $ZSH_DEBUG -eq 1 ]] && echo "[PERF] Total startup time: ${_total_startup_time}ms" >&2
