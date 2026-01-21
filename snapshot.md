# Repository Snapshot

## 1) Metadata
- Repository name: blux10k
- Organization / owner: unknown
- Default branch: unknown
- HEAD commit hash: 4403b688d98a63b0e707109d4267994eece4e540
- Snapshot timestamp (UTC): 2026-01-21T07:59:49Z
- Total file count (excluding directories): 36
- Description: Curated Zsh setup with installer, bundled fonts, and ready-to-use configuration files for Starship and Neofetch.

## 2) Repository Tree
├── .bqrc [text]
├── .config/
│   └── starship/
│       └── b10k-helper.zsh [text]
├── .editorconfig [text]
├── .gitignore [text]
├── CHANGELOG.md [text]
├── CODE_OF_CONDUCT.md [text]
├── CONTRIBUTING.md [text]
├── LICENSE [text]
├── README.md [text]
├── ROADMAP.md [text]
├── SECURITY.md [text]
├── blux10k-manifest.json [text]
├── configs/
│   ├── .p10k.zsh [text]
│   ├── .zshrc [text]
│   ├── b10k.neofetch.conf [text]
│   ├── env.zsh.example [text]
│   └── starship.toml [text]
├── docs/
│   ├── CONFIGURATION.md [text]
│   ├── CUSTOMIZATION.md [text]
│   ├── INSTALLATION.md [text]
│   ├── PLATFORMS.md [text]
│   ├── TROUBLESHOOTING.md [text]
│   └── assets/
│       └── blux10k.png [binary]
├── fonts/
│   ├── alternatives/
│   │   ├── ProFontIIxNerdFont-Regular.ttf [binary]
│   │   ├── ProFontIIxNerdFontMono-Regular.ttf [binary]
│   │   ├── ProFontIIxNerdFontPropo-Regular.ttf [binary]
│   │   ├── ProFontWindowsNerdFont-Regular.ttf [binary]
│   │   ├── ProFontWindowsNerdFontMono-Regular.ttf [binary]
│   │   └── ProFontWindowsNerdFontPropo-Regular.ttf [binary]
│   ├── install-fonts.sh [text]
│   └── meslolgs-nf/
│       ├── MesloLGS NF Bold Italic.ttf [binary]
│       ├── MesloLGS NF Bold.ttf [binary]
│       ├── MesloLGS NF Italic.ttf [binary]
│       └── MesloLGS NF Regular.ttf [binary]
├── install.sh [text]
└── snapshot.md [text]

## 3) FULL FILE CONTENTS (MANDATORY)

FILE: .bqrc
Kind: text
Size: 30887
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env bq
############################################################################
# ~/.bqrc – BLUX Quantum Shell Configuration
# BLUX10K Distributed System - Terminal Interface
# This file replaces ~/.zshrc and creates bq shell environment
############################################################################

############################################################################
# BLUX QUANTUM SHELL HEADER
############################################################################
print_blux_header() {
    echo ""
    echo "            ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█            "
    echo "            ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█            "
    echo "            ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀            "
    echo ""
    echo "  █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█"
    echo "  █                                                                          █"
    echo "  █  >> BLUX QUANTUM SHELL ONLINE                                          █"
    echo "  █  >> INTERFACE: bq v2.0.0                                              █"
    echo "  █  >> SYSTEM TIME: $(date +"%H:%M:%S UTC")                                 █"
    echo "  █  >> READY FOR QUANTUM COMMANDS                                        █"
    echo "  █                                                                          █"
    echo "  █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█"
    echo "                BLUX Ecosystem: https://github.com/Outer-Void                "
    echo "                Developer: https://github.com/Justadudeinspace               "
    echo "                                                                                "
}

############################################################################
# BQ SHELL DETECTION AND FALLBACK
############################################################################
# If not running in bq shell, fall back to zsh but source this config
if [[ "$(basename "$SHELL")" != "bq" ]]; then
    # We're in zsh but want bq environment - source this file and continue
    if [[ -n "$ZSH_VERSION" ]]; then
        # Set flag to indicate we're running bq environment in zsh
        export BQ_MODE="zsh_compat"
    fi
fi

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

# A) Zplug - Primary plugin manager
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

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
# 4) ZNAP SETUP - FOR ASYNC LOADING
############################################################################

# Use znap for specific async functionality
znap source marlonrichert/zsh-autocomplete
znap function _pyenv pyenv "znap eval pyenv 'pyenv init - --no-rehash'"
compctl -K _pyenv pyenv

############################################################################
# 5) ENVIRONMENT & PATH SETUP
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
# 6) PLUGIN CONFIGURATIONS
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
# 7) FZF + FD CONFIGURATION
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
# 8) ALIASES
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
    alias fix-all='sudo apt --fix-broken install'
    alias arem='sudo apt autoremove -y'
    alias sys-up="sudo apt update && sudo apt full-upgrade -y"
    alias dist-up="sudo apt update && sudo apt dist-upgrade -y"
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
# 9) USEFUL FUNCTIONS
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
bq_gc() { git add . && git commit -m "$1"; }
bq_lg() { git add . && git commit -m "$1" && git push; }

############################################################################
# 10) KEYBINDINGS
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
# 11) SYSTEM CONFIGURATION
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
# 12) BLUX QUANTUM CORE SYSTEM
############################################################################

_bq_err() { print -P "%F{red}[bq]%f $*"; return 1 }
_bq_ok()  { print -P "%F{green}[bq]%f $*"; }

# bq CLI: subcommands = dat / df / dscan / dsn-lrc / dsn-rpt / mscan
bq() {
  local cmd="$1"; shift 2>/dev/null || true

  case "$cmd" in
    # Pass-through to dat (keeps filename 'dat' intact)
    dat)
      if ! command -v dat >/dev/null 2>&1; then _bq_err "dat not found"; return 127; fi
      dat "$@"
      ;;

    # Format/export helper → `dat -f <folder> -o <outfile>`
    df)
      if ! command -v dat >/dev/null 2>&1; then _bq_err "dat not found"; return 127; fi

      local folder="."
      local repo_name="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"
      local default_out="outputs/dat_${repo_name}.md"
      local out="$default_out"
      local opt
      
      while [[ $# -gt 0 ]]; do
        case "$1" in
          -f|--folder) folder="$2"; shift 2 ;;
          -o|--out|--output) out="$2"; shift 2 ;;
          *) opt="$1"; shift ;;
        esac
      done

      mkdir -p "outputs" 2>/dev/null || true

      # support comma-separated outputs: a.md,a.txt,a.pdf
      if [[ "$out" == *,* ]]; then
        local item
        local IFS=,
        for item in $out; do
          item="${item//[[:space:]]/}"
          [[ -z "$item" ]] && continue
          _bq_ok "dat -f \"$folder\" -o \"$item\""
          dat -f "$folder" -o "$item" || return $?
        done
      else
        _bq_ok "dat -f \"$folder\" -o \"$out\""
        dat -f "$folder" -o "$out" || return $?
      fi
      ;;

    # Triage with default dat rules
    dscan)
      if ! command -v dat-scan >/dev/null 2>&1; then _bq_err "dat-scan not found"; return 127; fi
      local rules="${DATSCAN_HOME:-$HOME/dev/dat-scan}/rules/dat.json"
      dat-scan ./outputs/dat_latest.jsonl --rules "$rules"
      ;;

    # LRC-focused rules
    dsn-lrc)
      if ! command -v dat-scan >/dev/null 2>&1; then _bq_err "dat-scan not found"; return 127; fi
      local rules="${DATSCAN_HOME:-$HOME/dev/dat-scan}/rules/lrc.json"
      dat-scan ./outputs/dat_latest.jsonl --rules "$rules"
      ;;

    # HTML report
    dsn-rpt)
      if ! command -v dat-scan-report >/dev/null 2>&1; then _bq_err "dat-scan-report not found"; return 127; fi
      mkdir -p ./reports 2>/dev/null || true
      dat-scan-report ./outputs/dat_latest.jsonl ./reports/report.html \
        && _bq_ok "Report → ./reports/report.html"
      ;;

    # Monster scan battery then triage (keeps 'monster-scan' filename)
    mscan)
      if ! command -v monster-scan >/dev/null 2>&1; then _bq_err "monster-scan not found"; return 127; fi
      local root="${1:-$PWD}"
      local out="$root/outputs/dat_latest.jsonl"
      local rules="${DATSCAN_HOME:-$HOME/dev/dat-scan}/rules/dat.json"
      mkdir -p "$root/outputs" 2>/dev/null || true
      monster-scan "$root" "$out" && dat-scan "$out" --rules "$rules"
      ;;

    # Enhanced monster scan with repo-aware output naming
    mscan-repo)
      if ! command -v monster-scan >/dev/null 2>&1; then _bq_err "monster-scan not found"; return 127; fi
      local root="${1:-$PWD}"
      local repo_name="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "$root")")"
      local timestamp="$(date +%Y%m%d_%H%M%S)"
      local out="$root/outputs/dat_${repo_name}_${timestamp}.jsonl"
      local rules="${DATSCAN_HOME:-$HOME/dev/dat-scan}/rules/dat.json"
      mkdir -p "$root/outputs" 2>/dev/null || true
      _bq_ok "Monster scanning $repo_name → $out"
      monster-scan "$root" "$out" && dat-scan "$out" --rules "$rules"
      ;;

    # Quick scan current git repo
    scan-repo)
      local repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
      if [[ -z "$repo_root" ]]; then
        _bq_err "Not in a git repository"
        return 1
      fi
      bq mscan-repo "$repo_root"
      ;;

    # Stubs you can wire later without renaming the real tools
    lrc)
      _bq_err "lrc not wired yet. (Keep filename 'lrc' when you add it.)"
      ;;

    guard)
      _bq_err "BLUX Guard not wired yet. (Keep filename structure when ready.)"
      ;;

    ca)
      _bq_err "BLUX Conscious Agent not wired yet."
      ;;

    quantum)
      _bq_err "BLUX Quantum core not wired yet."
      ;;

    dat*)
      # convenience: let 'bq dat-anything' pass straight through to dat
      if ! command -v dat >/dev/null 2>&1; then _bq_err "dat not found"; return 127; fi
      dat "$cmd" "$@"
      ;;

    shell)
      # bq shell - Switch to bq shell environment
      _setup_bq_shell
      ;;

    ""|help|-h|--help)
      echo ""
      echo "╔════════════════════════════════════════════════════════════════╗"
      echo "║                   BLUX QUANTUM COMMAND SYSTEM                  ║"
      echo "║                     bq - Unified Tool Interface                ║"
      echo "╚════════════════════════════════════════════════════════════════╝"
      echo ""
      
      echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ DATA ACQUISITION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
      echo "  bq dat [args...]              # Pass-through to dat tool"
      echo "  bq df [-f DIR] [-o OUT]       # Export to dat_\$REPO_NAME.md"
      echo "  bq mscan [PATH]               # Full monster scan + triage"
      echo "  bq mscan-repo [PATH]          # Repo-aware scan with timestamp"
      echo "  bq scan-repo                  # Quick scan current git repo"
      echo ""
      
      echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ ANALYSIS & TRIAGE ▬▬▬▬▬▬▬▬▬▬▬▬▬"
      echo "  bq dscan                      # Triage with dat rules"
      echo "  bq dsn-lrc                    # Triage with LRC rules"
      echo "  bq dsn-rpt                    # Generate HTML report"
      echo ""
      
      echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ BLUX ECOSYSTEM ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
      echo "  bq lrc                        # Local Repo Compiler (stub)"
      echo "  bq guard                      # BLUX Guard (stub)"
      echo "  bq ca                         # BLUX Conscious Agent (stub)"
      echo "  bq quantum                    # BLUX Quantum core (stub)"
      echo "  bq shell                      # Switch to bq shell environment"
      echo ""
      
      echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ EXAMPLES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
      echo "  bq mscan                      # Scan current directory"
      echo "  bq scan-repo                  # Scan current git repo"
      echo "  bq df                         # Export to dat_\$REPO_NAME.md"
      echo "  bq df -o report.md,report.txt # Multiple export formats"
      echo "  bq dscan                      # Analyze latest scan"
      echo "  bq dsn-rpt                    # Generate HTML report"
      echo ""
      
      echo "╔════════════════════════════════════════════════════════════════╗"
      echo "║           Output: ./outputs/dat_\$REPO_NAME.md                 ║"
      echo "║           Reports: ./reports/report.html                       ║"
      echo "╚════════════════════════════════════════════════════════════════╝"
      ;;

    *)
      _bq_err "unknown subcommand '$cmd' (try: bq help)"
      return 2
      ;;
  esac
}

# BLUX Quantum aliases for quick access
alias bq-help='bq help'
alias bq-scan='bq mscan'
alias bq-analyze='bq dscan'
alias bq-report='bq dsn-rpt'
alias bq-export='bq df'

############################################################################
# 13) UPDATE FUNCTION v2.1
############################################################################

update() {
    echo "BLUX Quantum System Update v2.1.0"
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

    echo "BLUX Quantum system update complete!"
}

############################################################################
# 14) COMPLETION FOR UPDATE
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
# 15) UTILITY FUNCTIONS
############################################################################
reload-bq() { 
    if [[ "$(basename "$SHELL")" == "bq" ]]; then
        exec bq
    else
        source ~/.bqrc
        echo "BLUX Quantum environment reloaded"
    fi
}
alias rb='reload-bq'
alias rz='reload-bq'

bq-health() {
    echo "BLUX Quantum Health Check:"
    echo "• Shell: $(basename "$SHELL")"
    echo "• BQ Mode: ${BQ_MODE:-native}"
    echo "• ZSH Version: $(zsh --version 2>/dev/null | head -1 || echo "Not available")"
    echo "• Oh My Zsh: $([ -d "$ZSH" ] && echo "Installed" || echo "Not found")"
    echo "• zplug: $([ -d "$ZPLUG_HOME" ] && echo "Installed" || echo "Not found")"
    echo "• Plugins loaded: $(zplug list --installed 2>/dev/null | wc -l)"
    echo "• PATH directories: ${#path}"
    echo "• BLUX Tools:"
    echo "  - dat: $(command -v dat >/dev/null && echo "✓" || echo "✗")"
    echo "  - dat-scan: $(command -v dat-scan >/dev/null && echo "✓" || echo "✗")"
    echo "  - monster-scan: $(command -v monster-scan >/dev/null && echo "✓" || echo "✗")"
    echo "• DATSCAN_HOME: ${DATSCAN_HOME:-Not set}"
}

############################################################################
# 16) BQ SHELL SETUP FUNCTION
############################################################################
_setup_bq_shell() {
    local bq_shell_path="$HOME/.local/bin/bq"
    
    # Create bq shell launcher
    cat > "$bq_shell_path" << 'EOF'
#!/usr/bin/env zsh
# BLUX Quantum Shell Launcher
# This file enables chsh -s bq functionality

# Source the main bq configuration
source ~/.bqrc

# Start interactive shell
if [[ -o interactive ]]; then
    print_blux_header
fi

# Start zsh
exec -a bq zsh "$@"
EOF

    chmod +x "$bq_shell_path"
    
    # Add to shells if not already present
    if ! grep -q "$bq_shell_path" /etc/shells 2>/dev/null; then
        echo "$bq_shell_path" | sudo tee -a /etc/shells
    fi
    
    echo "BLUX Quantum shell installed at: $bq_shell_path"
    echo "You can now set as default shell with: chsh -s $bq_shell_path"
}

############################################################################
# 17) BLUX QUANTUM ENVIRONMENT SETUP
############################################################################
setup_blux_quantum() {
    # Ensure DATSCAN_HOME is set
    if [[ -z "${DATSCAN_HOME:-}" ]]; then
        export DATSCAN_HOME="$HOME/dev/dat-scan"
    fi
    
    # Check for required tools
    local missing_tools=()
    for tool in dat dat-scan monster-scan; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print -P "%F{yellow}BLUX Quantum: Missing tools: ${missing_tools[*]}%f"
        print -P "%F{blue}Install from: https://github.com/Justadudeinspace%f"
    else
        print -P "%F{green}BLUX Quantum system ready - use 'bq help' for commands%f"
    fi
}

############################################################################
# 18) FINAL LOADING AND INITIALIZATION
############################################################################

# Local overrides (last)
[[ -r ~/.bqrc.local ]] && source ~/.bqrc.local
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Private environment (API keys, etc.)
[[ -f ~/.config/private/env.zsh ]] && source ~/.config/private/env.zsh

# Compile for speed
if [[ ! -f ~/.bqrc.zwc || ~/.bqrc -nt ~/.bqrc.zwc ]]; then
    zcompile -R ~/.bqrc.zwc ~/.bqrc 2>/dev/null
fi

# Optional: Fastfetch/Neofetch
if command -v neofetch >/dev/null 2>&1 && [[ -o interactive ]]; then
    neofetch
fi

# Final PATH export
export PATH

# Initialize BLUX Quantum
setup_blux_quantum

# Show header in interactive shells
if [[ -o interactive ]]; then
    print_blux_header
fi

# Success message
print -P "%F{green}BLUX Quantum configuration loaded successfully!%f"
print -P "%F{blue}Use 'bq help' for BLUX Quantum commands%f"
FILE: .config/starship/b10k-helper.zsh
Kind: text
Size: 4917
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env zsh
# BLUX10K Starship Helper Functions

# Resolve Starship config paths with XDG support and legacy fallback.
function _starship_config_base() {
    echo "${XDG_CONFIG_HOME:-$HOME/.config}"
}

function _starship_config_default() {
    local base="$(_starship_config_base)"

    if [[ -f "$base/starship.toml" ]]; then
        echo "$base/starship.toml"
    else
        echo "$base/starship/starship.toml"
    fi
}

# Function to toggle Starship modules
function starship-toggle() {
    local base="$(_starship_config_base)"
    case "$1" in
        minimal)
            export STARSHIP_CONFIG="$base/starship/minimal.toml"
            echo "Starship: Minimal mode activated"
            ;;
        blux10k)
            export STARSHIP_CONFIG="$(_starship_config_default)"
            echo "Starship: BLUX10K mode activated"
            ;;
        detailed)
            export STARSHIP_CONFIG="$base/starship/detailed.toml"
            echo "Starship: Detailed mode activated"
            ;;
        help|--help|-h)
            echo "Starship Mode Switcher:"
            echo "  starship-toggle minimal   - Minimal prompt"
            echo "  starship-toggle blux10k   - BLUX10K style (default)"
            echo "  starship-toggle detailed  - Detailed prompt"
            echo "  starship-toggle help      - Show this help"
            ;;
        *)
            echo "Current Starship config: $STARSHIP_CONFIG"
            ;;
    esac
}

# Function to reload Starship configuration
function starship-reload() {
    export STARSHIP_CONFIG="$(_starship_config_default)"
    echo "Starship configuration reloaded"
}

# Function to show current Starship configuration
function starship-config() {
    if [[ -n "$STARSHIP_CONFIG" ]]; then
        echo "Current config: $STARSHIP_CONFIG"
        cat "$STARSHIP_CONFIG" | head -20
    else
        echo "Using default Starship configuration"
    fi
}

# Function to edit Starship configuration
function starship-edit() {
    ${EDITOR:-nvim} "$(_starship_config_default)"
}

# Add Starship help to b10k system
function b10k() {
    case "$1" in
        starship)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                     STARSHIP COMMANDS                          ║"
            echo "║                    BLUX10K Integration                         ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ CONFIGURATION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  starship-toggle <mode>     - Switch prompt modes"
            echo "  starship-reload            - Reload configuration"
            echo "  starship-config            - Show current config"
            echo "  starship-edit              - Edit configuration"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ MODES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  minimal                    - Clean, minimal prompt"
            echo "  blux10k                    - BLUX10K professional style"
            echo "  detailed                   - Feature-rich detailed prompt"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▤ FEATURES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  • Git integration with detailed status"
            echo "  • Programming language versions"
            echo "  • Kubernetes and Docker context"
            echo "  • System information"
            echo "  • Custom BLUX10K modules"
            echo "  • Performance optimized"
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║        Run 'starship toggle blux10k' for BLUX10K style        ║"
            echo "║        Run 'b10k --help' for full BLUX10K reference           ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        # ... rest of your existing b10k function
    esac
}

# Initialize Starship if available
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    export STARSHIP_CONFIG="$(_starship_config_default)"
fi
FILE: .editorconfig
Kind: text
Size: 13535
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# BLUX10K EditorConfig
# Professional code style configuration for BLUX10K development
# Repository: https://github.com/Justadudeinspace/blux10k

# Top-level configuration (applies to all files)
root = true

# =============================================================================
# Universal Configuration
# =============================================================================

[*]
# Character set
charset = utf-8

# Line endings (Unix-style)
end_of_line = lf

# File trailing newline
insert_final_newline = true

# Trim trailing whitespace
trim_trailing_whitespace = true

# =============================================================================
# Shell Scripts (ZSH/Bash)
# =============================================================================

[*.{zsh,sh,bash}]
# Indentation
indent_style = space
indent_size = 2
tab_width = 2

# Max line length (for readability)
max_line_length = 100

# Shell-specific settings
insert_final_newline = true
trim_trailing_whitespace = true

# =============================================================================
# Configuration Files
# =============================================================================

[*.{conf,config,cfg}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# TOML Files (Starship, Cargo, etc.)
# =============================================================================

[*.toml]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# JSON Files
# =============================================================================

[*.json]
indent_style = space
indent_size = 2
tab_width = 2
insert_final_newline = true

# JSON Manifest files can have longer lines for URLs
[blux10k-manifest.json]
max_line_length = 120

# =============================================================================
# Markdown Documentation
# =============================================================================

[*.md]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80
trim_trailing_whitespace = true

# Allow longer lines for code blocks and URLs
[README.md]
max_line_length = 120

[**/docs/*.md]
max_line_length = 100

# =============================================================================
# YAML Files (GitHub Actions, etc.)
# =============================================================================

[*.{yml,yaml}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Git Files
# =============================================================================

[.gitignore]
indent_style = space
indent_size = 2
tab_width = 2

[.gitattributes]
indent_style = space
indent_size = 2
tab_width = 2

# =============================================================================
# License File
# =============================================================================

[LICENSE]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Editor Configuration Files
# =============================================================================

[.editorconfig]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Makefiles
# =============================================================================

[Makefile]
indent_style = tab
tab_width = 4

[**/Makefile]
indent_style = tab
tab_width = 4

# =============================================================================
# Docker Files
# =============================================================================

[Dockerfile]
indent_style = space
indent_size = 4
tab_width = 4
max_line_length = 80

[*.dockerfile]
indent_style = space
indent_size = 4
tab_width = 4
max_line_length = 80

# =============================================================================
# Python Scripts
# =============================================================================

[*.py]
indent_style = space
indent_size = 4
tab_width = 4
max_line_length = 88  # Black formatter compatibility

# =============================================================================
# Rust Files
# =============================================================================

[*.rs]
indent_style = space
indent_size = 4
tab_width = 4
max_line_length = 100

# =============================================================================
# JavaScript/TypeScript
# =============================================================================

[*.{js,ts,jsx,tsx}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# CSS/SCSS
# =============================================================================

[*.{css,scss,sass}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# HTML Files
# =============================================================================

[*.{html,htm}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 120

# =============================================================================
# XML Files
# =============================================================================

[*.{xml,xsd}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Configuration Templates
# =============================================================================

[*.example]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

[*.template]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Test Files
# =============================================================================

[**/tests/*]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

[**/test_*.{zsh,sh}]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# =============================================================================
# Script Files
# =============================================================================

[**/scripts/*.sh]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# =============================================================================
# Configuration Directories
# =============================================================================

[**/configs/*]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Documentation Files
# =============================================================================

[**/docs/*.md]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# =============================================================================
# Private Configuration (Security Sensitive)
# =============================================================================

[**/private/*]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# CI/CD Configuration
# =============================================================================

[**/.github/**/*.yml]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

[**/.github/**/*.yaml]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Binary and Generated Files (No formatting)
# =============================================================================

[*.{bin,exe,dll,so,dylib}]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

[*.{jpg,jpeg,png,gif,ico,svg,pdf}]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

[*.{zip,rar,7z,tar,gz,whl}]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

# =============================================================================
# Font Files
# =============================================================================

[*.{ttf,otf,woff,woff2,eot}]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

# =============================================================================
# Compiled ZSH Files
# =============================================================================

[*.zwc]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

# =============================================================================
# Log Files
# =============================================================================

[*.log]
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

# =============================================================================
# Temporary/Cache Files
# =============================================================================

[*.{tmp,swp,swo}]
charset = binary
indent_style = unspecified
indent_size = unspecified
tab_width = unspecified
max_line_length = unspecified
trim_trailing_whitespace = false
insert_final_newline = false

# =============================================================================
# BLUX10K Specific File Types
# =============================================================================

# Powerlevel10k configuration
[.p10k.zsh]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# Starship configuration
[starship.toml]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# Neofetch configuration
[b10k.neofetch.conf]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# Environment templates
[env.zsh.example]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 80

# =============================================================================
# Project Manifest
# =============================================================================

[blux10k-manifest.json]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 120

# =============================================================================
# Module Files
# =============================================================================

[**/modules/**/*.zsh]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# =============================================================================
# Plugin Files
# =============================================================================

[**/plugins/**/*.zsh]
indent_style = space
indent_size = 2
tab_width = 2
max_line_length = 100

# =============================================================================
# Exceptions for specific files that need different formatting
# =============================================================================

# Package.json might need longer lines for dependencies
[package.json]
max_line_length = 120

# Composer.json for PHP dependencies
[composer.json]
max_line_length = 120

# Cargo.toml for Rust dependencies
[Cargo.toml]
max_line_length = 100

# =============================================================================
# File-specific overrides
# =============================================================================

# Main zshrc can have longer comments
[.zshrc]
max_line_length = 120

# Installation scripts might have longer commands
[install.sh]
max_line_length = 120

[scripts/install-*.sh]
max_line_length = 120

# =============================================================================
# BLUX10K Code Style Summary
# =============================================================================
#
# Universal Rules:
# - UTF-8 encoding
# - Unix line endings (LF)
# - Trim trailing whitespace
# - Final newline required
#
# Indentation:
# - Shell scripts: 2 spaces
# - Python: 4 spaces
# - Makefiles: Tabs
# - Most configs: 2 spaces
#
# Line Length:
# - Code: 80-100 characters
# - Documentation: 80-120 characters
# - Configuration: 80 characters
# - URLs and long strings: exceptions allowed
#
# File Type Support:
# - Shell (ZSH/Bash)
# - Configuration (TOML, JSON, YAML)
# - Documentation (Markdown)
# - Code (Python, Rust, JavaScript)
# - Project-specific (p10k, starship, neofetch)
#
# This configuration ensures consistent code style across the BLUX10K project
# and makes collaboration easier by enforcing uniform formatting standards.
FILE: .gitignore
Kind: text
Size: 14
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# placeholder
FILE: CHANGELOG.md
Kind: text
Size: 348
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

- Refresh documentation to match the current repo structure and installer behavior.
- Harden the standalone font installer with platform-safe defaults and Termux guidance.
- Clarify configuration usage for Starship, Neofetch, and private env files.
FILE: CODE_OF_CONDUCT.md
Kind: text
Size: 453
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Code of Conduct

This project is committed to providing a friendly, safe, and welcoming environment for everyone.
By participating, you agree to:

- Be respectful and constructive in discussions.
- Assume good intent and provide helpful feedback.
- Avoid harassment, discrimination, or abusive behavior.

If you witness unacceptable behavior, please open an issue describing what happened. Maintainers
will review reports and take appropriate action.
FILE: CONTRIBUTING.md
Kind: text
Size: 684
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Contributing

Thanks for helping improve BLUX10K. This repo is intentionally small and documentation-driven, so
changes should stay focused and easy to review.

## What to work on

- Documentation accuracy and clarity.
- Safe updates to configuration templates.
- Improvements to the standalone font installer (`fonts/install-fonts.sh`).

## Workflow

1. Fork the repo and create a feature branch.
2. Keep changes minimal and scoped.
3. Update docs when behavior changes.
4. Open a pull request describing what changed and why.

## Notes

- Avoid adding new dependencies.
- Do not modify binary assets (fonts).
- Keep user data safe: never commit real secrets or personal dotfiles.
FILE: LICENSE
Kind: text
Size: 1067
Last modified: 2026-01-21T07:57:55Z

CONTENT:
MIT License

Copyright (c) 2026 Outer Void

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
FILE: README.md
Kind: text
Size: 2584
Last modified: 2026-01-21T07:57:55Z

CONTENT:
<p align="center">
  <img src="docs/assets/blux10k.png" alt="BLUX10K" width="600">
</p>

# BLUX10K v4.0.0 (Stable)

BLUX10K is a curated Zsh setup with an installer, bundled fonts, and ready-to-use configuration
files for Starship and Neofetch. It is **not** a full dotfiles framework or a plugin manager; it
provides a focused, documented baseline that you can customize.

## Quickstart

```bash
git clone https://github.com/Outer-Void/blux10k.git
cd blux10k
chmod +x ./install.sh
./install.sh
```

The installer copies this repo into `~/.config/blux10k`, adds a managed block to `~/.zshrc`, and
creates `~/.config/private/env.zsh` if it doesn’t exist.

During installation you will choose a prompt engine (Powerlevel10k or Starship). To change it
later, re-run the installer with `--prompt=p10k` or `--prompt=starship`.

## Fonts

Install bundled fonts with:

```bash
./fonts/install-fonts.sh
```

- Linux/proot: installs into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k/`.
- macOS: installs into `~/Library/Fonts/BLUX10K/`.
- Termux: run `./fonts/install-fonts.sh --termux-apply` to set `~/.termux/font.ttf`.

Set your terminal font to “MesloLGS NF” afterward.

## Configuration locations

- Private environment: `~/.config/private/env.zsh` (template in `configs/env.zsh.example`)
- Starship config: `~/.config/starship.toml` (from `configs/starship.toml`)
- Neofetch config: `~/.config/neofetch/config.conf` (from `configs/b10k.neofetch.conf`)

See the docs for details:

- [Installation](docs/INSTALLATION.md)
- [Configuration](docs/CONFIGURATION.md)
- [Customization](docs/CUSTOMIZATION.md)
- [Platforms](docs/PLATFORMS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Platform notes

BLUX10K supports Linux, macOS, and Termux. Termux requires manual font application and may not be
able to change the default shell. See [Platforms](docs/PLATFORMS.md).

On Debian/Ubuntu, the installer uses `eza` (replacement for `exa`) and installs `bottom` as the
`btm` package.

## Tests

1. Run `./install.sh --profile` and verify the platform detection output.
2. Run the installer and confirm it completes without errors.
3. Verify `~/.config/starship.toml` is deployed from `configs/starship.toml`.
4. Confirm `~/.zshrc` contains the BLUX10K prompt block.
5. Verify config deploy:
   - After a dry run is not enough, but minimally ensure logic exists and paths are correct.
6. Ensure the zshrc activation block is guarded and idempotent:
   - Running installer twice must not duplicate the BLUX10K NEOFETCH block.

## License

MIT License — see [LICENSE](./LICENSE).
FILE: ROADMAP.md
Kind: text
Size: 514
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Roadmap

This roadmap reflects the current, minimal scope of the repo.

## Short-term

- Improve configuration docs and examples as the installer evolves.
- Expand troubleshooting guidance based on common install logs.
- Add optional tips for terminal font setup on more platforms.

## Medium-term

- Provide optional theme variants for Starship and Neofetch.
- Add a lightweight validation script for configuration paths.

## Long-term

- Document additional shell integrations when they are added to the repo.
FILE: SECURITY.md
Kind: text
Size: 922
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Security

## Reporting vulnerabilities

If you discover a security issue, please open an issue with a clear description of the impact and
steps to reproduce. If a private report is needed, include “SECURITY” in the issue title so it can
be handled discreetly.

## Safe usage guidance

- **Private environment file**: Store secrets in `~/.config/private/env.zsh` and keep the file
  permissions restricted (`chmod 600 ~/.config/private/env.zsh`).
- **Least privilege**: Avoid running the installer as root unless absolutely necessary. The
  installer is designed for per-user setup.
- **Backups**: The installer attempts to back up existing BLUX10K directories. Still, keep your
  own backups of personal dotfiles before running any setup scripts.
- **Review before running**: `scripts/install.sh` and `fonts/install-fonts.sh` are shell scripts.
  Review them before execution, especially in production environments.
FILE: blux10k-manifest.json
Kind: text
Size: 1392
Last modified: 2026-01-21T07:57:55Z

CONTENT:
{
  "blux10k": {
    "metadata": {
      "name": "BLUX10K",
      "version": "4.0.0",
      "description": "Curated Zsh setup with installer, fonts, and optional Starship/Neofetch configs",
      "repository": "https://github.com/Outer-Void/blux10k",
      "license": "MIT",
      "status": "active"
    },
    "structure": {
      "scripts": [
        "scripts/install.sh",
        "fonts/install-fonts.sh"
      ],
      "configs": [
        "configs/env.zsh.example",
        "configs/starship.toml",
        "configs/b10k.neofetch.conf"
      ],
      "docs": [
        "docs/INSTALLATION.md",
        "docs/CONFIGURATION.md",
        "docs/CUSTOMIZATION.md",
        "docs/PLATFORMS.md",
        "docs/TROUBLESHOOTING.md"
      ],
      "fonts": [
        "fonts/meslolgs-nf/*.ttf",
        "fonts/alternatives/*.ttf"
      ]
    },
    "runtime_paths": {
      "config_dir": "~/.config/blux10k",
      "private_env": "~/.config/private/env.zsh",
      "font_dir_linux": "${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k",
      "font_dir_macos": "~/Library/Fonts/BLUX10K",
      "termux_font": "~/.termux/font.ttf"
    },
    "platforms": {
      "supported": ["Linux", "macOS", "Termux"],
      "notes": [
        "Termux requires manual font application via fonts/install-fonts.sh --termux-apply",
        "Default shell changes may be restricted in containers"
      ]
    }
  }
}
FILE: configs/.p10k.zsh
Kind: text
Size: 32907
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Generated by Powerlevel10k configuration wizard on 2024-01-01 at 00:00:00 UTC.
# Enhanced for BLUX10K v4.0.0 - Professional Terminal Configuration
# Based on romkatv/powerlevel10k/config/p10k-lean.zsh.
#
# Repository: https://github.com/romkatv/powerlevel10k
# BLUX10K: https://github.com/Justadudeinspace/blux10k
#
# Version: 4.0.0
# Features:
#   - Performance optimized segments
#   - Context-aware styling
#   - Enhanced debugging support
#   - Integrated with BLUX10K ecosystem
#   - Dynamic element loading

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # ===========================================================================
  # DYNAMIC PROMPT ELEMENTS - LOADED BASED ON CONTEXT
  # ===========================================================================
  
  # Core elements always shown
  local core_left_elements=(
    # =========================[ Line #1 ]=========================
    context                   # user@hostname
    dir                       # current directory
    vcs                       # git status
    virtualenv                # python virtual environment
    command_execution_time    # previous command duration
    # =========================[ Line #2 ]=========================
    newline                   # \n
    prompt_char               # prompt symbol
  )

  local core_right_elements=(
    status                    # exit code of the last command
    background_jobs           # presence of background jobs
    time                      # current time
    battery                   # battery level
    os_icon                   # operating system icon
  )

  # Context-aware elements (added dynamically)
  local context_elements=()

  # Add Docker context if in Docker project
  if [[ -f "Dockerfile" || -f "docker-compose.yml" || -f ".dockerignore" ]]; then
    context_elements+=(blux_docker_context)
  fi

  # Add Kubernetes context if in k8s project
  if [[ -d "k8s" || -f "kustomization.yaml" || -n $(print -l *.yaml(N)) ]]; then
    context_elements+=(blux_k8s_context)
  fi

  # Add Node.js version if package.json exists
  if [[ -f "package.json" ]]; then
    context_elements+=(blux_node_version)
  fi

  # Add Python version if requirements.txt exists
  if [[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" ]]; then
    context_elements+=(blux_python_version)
  fi

  # Add Rust version if Cargo.toml exists
  if [[ -f "Cargo.toml" ]]; then
    context_elements+=(blux_rust_version)
  fi

  # Add Go version if go.mod exists
  if [[ -f "go.mod" ]]; then
    context_elements+=(blux_go_version)
  fi

  # Add BLUX10K status if in development mode
  if [[ -n "$BLUX10K_DEBUG" || -n "$ZSH_DEBUG" ]]; then
    context_elements=(blux10k_status $context_elements)
  fi

  # Final element arrays
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=($core_left_elements)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=($core_right_elements $context_elements)

  # ===========================================================================
  # PERFORMANCE OPTIMIZATIONS
  # ===========================================================================
  typeset -g POWERLEVEL9K_DISABLE_GITSTATUS=false
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  
  # Async loading
  typeset -g POWERLEVEL9K_VCS_ASYNC=true
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_ASYNC=true
  
  # Disable slow features when terminal is small
  if (( COLUMNS < 80 )); then
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/background_jobs})
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/battery})
  fi

  # ===========================================================================
  # VISUAL STYLING - BLUX10K THEME
  # ===========================================================================
  
  # Basic style options.
  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

  # Color scheme and design for BLUX10K.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  
  # Enable hyperlinks in directory segment
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=true

  # ===========================================================================
  # SEGMENT CONFIGURATIONS
  # ===========================================================================

  # Context segment configuration.
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=7
  typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=0
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND=3
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_TEMPLATE='%n@%m'
  
  # Show SSH icon when connected via SSH
  if [[ -n "$SSH_CONNECTION" ]]; then
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m 🔐'
  fi

  # Directory segment configuration.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=4
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=0
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=4
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=6
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_DIR_SHORTEN_DELIMITER=''
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=true
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_DIR_HYPERLINK_COLOR=4
  
  # Directory coloring based on depth
  typeset -g POWERLEVEL9K_DIR_DIRNAME_LEVELS_FOREGROUND=(
    4  # level 1
    12 # level 2
    6  # level 3
    13 # level 4
    5  # level 5+
  )

  # VCS (Git) segment configuration.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=0
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=0
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=2
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=0
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=9
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=0
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=8
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=0
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
  typeset -g POWERLEVEL9K_VCS_TAG_ICON='\uF412'
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='\uF417'
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON='\uF408'
  typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON='\uF296'
  typeset -g POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON='\uF171'
  typeset -g POWERLEVEL9K_VCS_GIT_ICON='\uF1D3'
  
  # Enable VCS stash indicator
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='\uF01C'

  # Virtualenv segment configuration.
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=6
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=0
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER='('
  typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=')'
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🐍'

  # Command execution time segment configuration.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  
  # Show execution time in different colors based on duration
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND_EXECUTION_TIME=(
    2  # < 1 min: green
    3  # 1-5 min: yellow
    1  # > 5 min: red
  )

  # Status segment configuration.
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=9
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=9
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

  # Background jobs segment configuration.
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=5
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⚙'

  # Time segment configuration.
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=7
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=0
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

  # Battery segment configuration.
  typeset -g POWERLEVEL9K_BATTERY_FOREGROUND=7
  typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=0
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=9
  typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=2
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3
  typeset -g POWERLEVEL9K_BATTERY_STAGES='\uf58d\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'

  # OS icon segment configuration.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=7
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=0
  
  # Platform-specific icons
  case "$(uname)" in
    Darwin)
      typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
      ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''  # WSL
      else
        typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''  # Linux
      fi
      ;;
    *)
      typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
      ;;
  esac

  # Prompt character configuration.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=4
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=9
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_LEFT_WHITESPACE=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_RIGHT_WHITESPACE=''
  
  # Context-aware prompt character
  if [[ -n "$BLUX10K_DEBUG" ]]; then
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=3  # Yellow for debug
    typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='🔧'
  elif [[ -n "$VIRTUAL_ENV" ]]; then
    typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='🐍'
  elif git rev-parse --git-dir > /dev/null 2>&1; then
    typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='🅑'
  else
    typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='➜'
  fi

  # ===========================================================================
  # ADVANCED CONFIGURATION
  # ===========================================================================
  
  # Transient prompt configuration.
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  
  # Instant prompt customization
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_INSTANT_PROMPT_FORCE_FIRST_COMMAND_EXECUTION=false

  # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false
  
  # Gitstatus configuration
  typeset -g POWERLEVEL9K_GITSTATUS_DIR="$HOME/.cache/gitstatus"
  
  # Icon overrides for better visibility
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='${P9K_VCS_VISUAL_IDENTIFIER// }'
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON=''
  typeset -g POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=''

  # ===========================================================================
  # BLUX10K CUSTOM SEGMENTS
  # ===========================================================================
  
  # Custom segment: BLUX10K Status
  typeset -g POWERLEVEL9K_BLUX10K_STATUS_FOREGROUND=4
  typeset -g POWERLEVEL9K_BLUX10K_STATUS_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX10K_STATUS_CONTENT_EXPANSION='🅑 BLUX10K'

  # Custom segment: Docker Context
  typeset -g POWERLEVEL9K_BLUX_DOCKER_CONTEXT_FOREGROUND=6
  typeset -g POWERLEVEL9K_BLUX_DOCKER_CONTEXT_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_DOCKER_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='🐳'

  # Custom segment: Kubernetes Context
  typeset -g POWERLEVEL9K_BLUX_K8S_CONTEXT_FOREGROUND=5
  typeset -g POWERLEVEL9K_BLUX_K8S_CONTEXT_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_K8S_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='⎈'

  # Custom segment: Node.js Version
  typeset -g POWERLEVEL9K_BLUX_NODE_VERSION_FOREGROUND=2
  typeset -g POWERLEVEL9K_BLUX_NODE_VERSION_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='⬢'

  # Custom segment: Python Version
  typeset -g POWERLEVEL9K_BLUX_PYTHON_VERSION_FOREGROUND=3
  typeset -g POWERLEVEL9K_BLUX_PYTHON_VERSION_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_PYTHON_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐍'

  # Custom segment: Rust Version
  typeset -g POWERLEVEL9K_BLUX_RUST_VERSION_FOREGROUND=1
  typeset -g POWERLEVEL9K_BLUX_RUST_VERSION_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='🦀'

  # Custom segment: Go Version
  typeset -g POWERLEVEL9K_BLUX_GO_VERSION_FOREGROUND=6
  typeset -g POWERLEVEL9K_BLUX_GO_VERSION_BACKGROUND=0
  typeset -g POWERLEVEL9K_BLUX_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='🐹'

  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}

# ===========================================================================
# CUSTOM FUNCTIONS FOR BLUX10K SEGMENTS
# ===========================================================================

# Custom segment to show BLUX10K status
function prompt_blux10k_status() {
    local content='🅑 BLUX10K'
    
    if [[ -n "$BLUX10K_DEBUG" ]]; then
        content='🅑 DEBUG'
        p10k segment -b 1 -f 3 -t "$content"
    elif [[ -n "$ZSH_DEBUG" ]]; then
        content='🅑 PROFILE'
        p10k segment -b 1 -f 3 -t "$content"
    else
        p10k segment -b 0 -f 4 -t "$content"
    fi
}

# Custom segment for showing current Docker context
function prompt_blux_docker_context() {
    if command -v docker >/dev/null 2>&1; then
        local context=$(docker context show 2>/dev/null)
        if [[ -n "$context" && "$context" != "default" ]]; then
            local icon='🐳'
            local color=6  # Cyan
            
            # Color coding based on context
            case "$context" in
                *prod*|*production*)
                    color=1  # Red for production
                    ;;
                *stag*|*staging*)
                    color=3  # Yellow for staging
                    ;;
                *dev*|*development*)
                    color=2  # Green for development
                    ;;
                *test*)
                    color=5  # Magenta for test
                    ;;
            esac
            
            p10k segment -b 0 -f $color -i "$icon" -t "$context"
        fi
    fi
}

# Custom segment for showing current Kubernetes context
function prompt_blux_k8s_context() {
    if command -v kubectl >/dev/null 2>&1; then
        local context=$(kubectl config current-context 2>/dev/null)
        if [[ -n "$context" ]]; then
            local icon='⎈'
            local color=5  # Magenta
            
            # Color coding based on context
            case "$context" in
                *prod*|*production*)
                    color=1  # Red for production
                    ;;
                *stag*|*staging*)
                    color=3  # Yellow for staging
                    ;;
                *dev*|*development*)
                    color=2  # Green for development
                    ;;
                *minikube*|*docker-desktop*)
                    color=6  # Cyan for local
                    ;;
            esac
            
            p10k segment -b 0 -f $color -i "$icon" -t "$context"
        fi
    fi
}

# Custom segment for Node.js version (context-aware)
function prompt_blux_node_version() {
    if [[ -f "package.json" ]] || [[ -n "$NVM_BIN" ]] || command -v node >/dev/null 2>&1; then
        local node_version
        if command -v node >/dev/null 2>&1; then
            node_version=$(node --version 2>/dev/null | sed 's/v//')
        fi
        
        if [[ -n "$node_version" ]]; then
            p10k segment -b 0 -f 2 -i '⬢' -t "$node_version"
        fi
    fi
}

# Custom segment for Python version (alternative to virtualenv)
function prompt_blux_python_version() {
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]] || command -v python3 >/dev/null 2>&1; then
        local python_version
        if command -v python3 >/dev/null 2>&1; then
            python_version=$(python3 --version 2>/dev/null | cut -d' ' -f2)
        fi
        
        if [[ -n "$python_version" && -z "$VIRTUAL_ENV" ]]; then
            p10k segment -b 0 -f 3 -i '🐍' -t "$python_version"
        fi
    fi
}

# Custom segment for Rust version
function prompt_blux_rust_version() {
    if [[ -f "Cargo.toml" ]] || command -v rustc >/dev/null 2>&1; then
        local rust_version
        if command -v rustc >/dev/null 2>&1; then
            rust_version=$(rustc --version 2>/dev/null | cut -d' ' -f2)
        fi
        
        if [[ -n "$rust_version" ]]; then
            p10k segment -b 0 -f 1 -i '🦀' -t "$rust_version"
        fi
    fi
}

# Custom segment for Go version
function prompt_blux_go_version() {
    if [[ -f "go.mod" ]] || command -v go >/dev/null 2>&1; then
        local go_version
        if command -v go >/dev/null 2>&1; then
            go_version=$(go version 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i ~ /^go[0-9]/) {sub(/^go/, "", $i); print $i; exit}}')
        fi
        
        if [[ -n "$go_version" ]]; then
            p10k segment -b 0 -f 6 -i '🐹' -t "$go_version"
        fi
    fi
}

# Enhanced VCS status with stash indicator
function +vi-git-stash() {
    if [[ -s ${hook_com[git_root]}/.git/refs/stash ]] ; then
        hook_com[stash]='↩'
    fi
}

# ===========================================================================
# UTILITY FUNCTIONS FOR PROMPT MANAGEMENT
# ===========================================================================

# Function to toggle prompt elements (useful for debugging)
function p10k-toggle-elements() {
    if [[ ${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[(I)time]} -eq 0 ]]; then
        # Add time to right prompt
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(time)
        echo "Time display enabled"
    else
        # Remove time from right prompt
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/time})
        echo "Time display disabled"
    fi
    
    # Toggle battery on laptops
    if [[ "$(uname)" == "Darwin" ]] || grep -qi "battery" /sys/class/power_supply/*/type 2>/dev/null; then
        if [[ ${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[(I)battery]} -eq 0 ]]; then
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=(battery)
            echo "Battery display enabled"
        else
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/battery})
            echo "Battery display disabled"
        fi
    fi
    
    p10k reload
    echo "Prompt elements updated"
}

# Function to switch between prompt styles
function p10k-switch-style() {
    local style=${1:-blux10k}
    
    case $style in
        lean|minimal)
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
            POWERLEVEL9K_DIR_MAX_LENGTH=40
            echo "Switched to minimal style"
            ;;
            
        standard|default)
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv newline prompt_char)
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time battery)
            POWERLEVEL9K_DIR_MAX_LENGTH=60
            echo "Switched to standard style"
            ;;
            
        detailed|full)
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv command_execution_time newline prompt_char)
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time battery os_icon)
            POWERLEVEL9K_DIR_MAX_LENGTH=80
            echo "Switched to detailed style"
            ;;
            
        blux10k|blux)
            # BLUX10K custom style
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs virtualenv command_execution_time newline prompt_char)
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time battery os_icon)
            POWERLEVEL9K_DIR_MAX_LENGTH=80
            
            # Custom colors for BLUX10K
            POWERLEVEL9K_DIR_BACKGROUND=4
            POWERLEVEL9K_DIR_FOREGROUND=0
            POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
            POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
            POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=4
            echo "Switched to BLUX10K style"
            ;;
            
        debug)
            POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(blux10k_status context dir vcs virtualenv command_execution_time newline prompt_char)
            POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs time battery os_icon)
            POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=3
            echo "Switched to debug style"
            ;;
            
        *)
            echo "Available styles: lean, standard, detailed, blux10k, debug"
            echo "Current style:"
            p10k-show-config
            return 1
            ;;
    esac
    
    p10k reload
}

# Aliases for quick prompt style switching
alias p10k-lean='p10k-switch-style lean'
alias p10k-standard='p10k-switch-style standard'
alias p10k-detailed='p10k-switch-style detailed'
alias p10k-blux='p10k-switch-style blux10k'
alias p10k-debug='p10k-switch-style debug'

# Function to show current Powerlevel10k configuration
function p10k-show-config() {
    echo "=== POWERLEVEL10K CONFIGURATION ==="
    echo ""
    echo "Left Prompt Elements:"
    for element in $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS; do
        echo "  • $element"
    done
    echo ""
    echo "Right Prompt Elements:"
    for element in $POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS; do
        echo "  • $element"
    done
    echo ""
    echo "Performance Settings:"
    echo "  • VCS Async: $POWERLEVEL9K_VCS_ASYNC"
    echo "  • Command Time Async: $POWERLEVEL9K_COMMAND_EXECUTION_TIME_ASYNC"
    echo "  • Dir Max Length: $POWERLEVEL9K_DIR_MAX_LENGTH"
    echo ""
    echo "Use 'p10k-switch-style <style>' to change styles"
    echo "Use 'p10k-toggle-elements' to toggle elements"
}

# Enhanced prompt character with custom symbols based on context
function blux10k_prompt_char() {
    local symbol='➜'
    local color=4  # Blue
    
    if [[ -n "$BLUX10K_DEBUG" ]]; then
        symbol='🔧'
        color=3  # Yellow
    elif [[ -n "$ZSH_DEBUG" ]]; then
        symbol='📊'
        color=3  # Yellow
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        symbol='🐍'
        color=6  # Cyan
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        symbol='🅑'
        color=2  # Green
    elif [[ -f "Dockerfile" || -f "docker-compose.yml" ]]; then
        symbol='🐳'
        color=6  # Cyan
    elif [[ -f "package.json" ]]; then
        symbol='⬢'
        color=2  # Green
    fi
    
    p10k segment -f $color -t "$symbol"
}

# Optional: Uncomment to use custom prompt character
# typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERRIDE=true
# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[-1]='blux10k_prompt_char'

# ===========================================================================
# BLUX10K INTEGRATION WITH HELP SYSTEM
# ===========================================================================

# BLUX10K Powerlevel10k Integration with b10k help system
function p10k-help() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                   POWERLEVEL10K v4.0.0                         ║"
    echo "║                    BLUX10K Enhanced Integration                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ PROMPT STYLES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
    echo "  p10k-lean                    - Minimal prompt (dir, vcs)"
    echo "  p10k-standard                - Standard prompt with context"
    echo "  p10k-detailed                - Detailed prompt with all elements"
    echo "  p10k-blux                    - BLUX10K custom style"
    echo "  p10k-debug                   - Debug style with BLUX10K status"
    echo ""
    echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ CONFIGURATION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
    echo "  p10k configure               - Run configuration wizard"
    echo "  p10k reload                  - Reload prompt configuration"
    echo "  p10k-show-config             - Show current configuration"
    echo "  p10k-toggle-elements         - Toggle time/battery display"
    echo "  p10k-switch-style <style>    - Switch between prompt styles"
    echo ""
    echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ PROMPT ELEMENTS ▬▬▬▬▬▬▬▬▬▬▬▬▬"
    echo "  context                      - user@hostname (SSH indicator)"
    echo "  dir                          - current directory (hyperlinked)"
    echo "  vcs                          - git status with stash indicator"
    echo "  virtualenv                   - python virtual environment"
    echo "  command_execution_time       - colored by duration"
    echo "  status                       - exit code with icon"
    echo "  background_jobs              - background jobs indicator"
    echo "  time                         - current time"
    echo "  battery                      - battery level with stages"
    echo "  os_icon                      - OS-specific icon"
    echo ""
    echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ CUSTOM SEGMENTS ▬▬▬▬▬▬▬▬▬▬▬▬▬"
    echo "  blux10k_status               - BLUX10K system status"
    echo "  blux_docker_context          - Docker context (colored)"
    echo "  blux_k8s_context             - K8s context (colored)"
    echo "  blux_node_version            - Node.js version"
    echo "  blux_python_version          - Python version"
    echo "  blux_rust_version            - Rust version"
    echo "  blux_go_version              - Go version"
    echo ""
    echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ PERFORMANCE ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
    echo "  • Async VCS loading"
    echo "  • Dynamic element loading"
    echo "  • Context-aware segments"
    echo "  • Terminal size optimization"
    echo ""
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║        Use 'p10k configure' to customize interactively        ║"
    echo "║        Run 'b10k --help' for full BLUX10K reference           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Add p10k-help to b10k system
function b10k() {
    case "$1" in
        p10k|powerlevel10k|prompt)
            shift
            p10k-help
            ;;
        # ... rest of your existing b10k function
    esac
}

# Function to profile prompt rendering
function p10k-profile() {
    local iterations=${1:-100}
    echo "Profiling prompt rendering ($iterations iterations)..."
    
    local start_time=$((EPOCHREALTIME*1000))
    for ((i=1; i<=iterations; i++)); do
        print -P "$PROMPT" >/dev/null
    done
    local end_time=$((EPOCHREALTIME*1000))
    
    local total_time=$((end_time - start_time))
    local avg_time=$((total_time / iterations))
    
    echo "Total time: ${total_time}ms"
    echo "Average per prompt: ${avg_time}ms"
    echo "Performance: $((1000 / avg_time)) prompts/second"
}

# ===========================================================================
# FINAL INITIALIZATION
# ===========================================================================

# Tell Powerlevel10k to reload configuration when user configuration changes.
(( ! $+functions[p10k] )) || p10k reload

# Final configuration validation and optimization
if (( $+functions[p10k] )); then
    # Enable instant prompt if available
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    
    # Finalize p10k configuration
    p10k finalize
    
    # Performance optimization for slow systems
    if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname -m)" == "arm"* ]]; then
        # Disable some animations on ARM/Mac for better performance
        typeset -g POWERLEVEL9K_VCS_ASYNC=false
        typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=60
    fi
    
    # Debug mode optimizations
    if [[ -n "$BLUX10K_DEBUG" ]]; then
        echo "[P10K] Configuration loaded in debug mode"
        echo "[P10K] Left elements: ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"
        echo "[P10K] Right elements: ${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"
    fi
    
else
    echo "Powerlevel10k not loaded. BLUX10K will use fallback prompt."
    echo "Install with: zinit ice depth=1; zinit light romkatv/powerlevel10k"
    
    # Fallback simple prompt
    PROMPT='%F{4}%n@%m%f:%F{2}%~%f %# '
    RPROMPT='%F{3}%*%f'
fi

# ===========================================================================
# ENVIRONMENT-SPECIFIC OVERRIDES
# ===========================================================================

# Override settings in specific environments
case "$(uname)" in
    Darwin)
        # macOS specific optimizations
        typeset -g POWERLEVEL9K_BATTERY_STAGES='\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'
        ;;
    Linux)
        # Linux/WSL optimizations
        if grep -qi microsoft /proc/version 2>/dev/null; then
            # WSL specific
            typeset -g POWERLEVEL9K_DIR_HYPERLINK=false  # Hyperlinks don't work well in WSL
        fi
        ;;
esac

# SSH session optimizations
if [[ -n "$SSH_CONNECTION" ]]; then
    # Simplify prompt over SSH for better performance
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/battery})
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/os_icon})
    POWERLEVEL9K_DIR_MAX_LENGTH=40
fi

# Small terminal optimizations
if (( COLUMNS < 80 )); then
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
fi

# Export configuration version
export BLUX10K_P10K_VERSION="4.0.0"
FILE: configs/.zshrc
Kind: text
Size: 101327
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env bash
# BLUX10K Enhanced Installer v4.0.0
# Universal Cross-Platform Professional Terminal Setup
# Enterprise-Grade | Performance Optimized | Security Hardened

if [[ -n "${ZSH_VERSION:-}" ]]; then
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
__BLUX_PROMPT_BLOCK__
    if [[ -f "${XDG_CONFIG_HOME}/blux10k/blux10k.zsh" ]]; then
        source "${XDG_CONFIG_HOME}/blux10k/blux10k.zsh"
    fi
    return 0 2>/dev/null || exit 0
fi

set -euo pipefail
IFS=$'\n\t'

# ===========================================================================
# CONSTANTS & GLOBAL CONFIGURATION
# ===========================================================================

set_readonly_default() {
    local name="$1"
    local value="$2"

    if [[ -z "${!name-}" ]]; then
        readonly "${name}=${value}"
    fi
}

# Version and metadata
set_readonly_default "BLUX10K_VERSION" "4.0.0"
set_readonly_default "BLUX10K_REPO" "https://github.com/Justadudeinspace/blux10k"
set_readonly_default "BLUX10K_DOCS" "https://blux10k.github.io/docs"
set_readonly_default "B10K_DIR" "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
set_readonly_default "BLUX10K_CONFIG_DIR" "${B10K_DIR}"
set_readonly_default "BLUX10K_CACHE_DIR" "${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"
set_readonly_default "BLUX10K_LOG_DIR" "${BLUX10K_CACHE_DIR}/logs"
set_readonly_default "BLUX10K_INSTALL_LOG" "${BLUX10K_LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"
set_readonly_default "B10K_DATA_DIR" "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k"
set_readonly_default "P10K_DIR" "${B10K_DATA_DIR}/p10k/powerlevel10k"

# Color codes for output (ANSI 256-color support)
set_readonly_default "RED" '\033[0;31m'
set_readonly_default "GREEN" '\033[0;32m'
set_readonly_default "YELLOW" '\033[1;33m'
set_readonly_default "BLUE" '\033[0;34m'
set_readonly_default "MAGENTA" '\033[0;35m'
set_readonly_default "CYAN" '\033[0;36m'
set_readonly_default "WHITE" '\033[1;37m'
set_readonly_default "GRAY" '\033[0;90m'
set_readonly_default "ORANGE" '\033[38;5;208m'
set_readonly_default "PURPLE" '\033[38;5;93m'
set_readonly_default "NC" '\033[0m' # No Color

# Emojis for better UX
set_readonly_default "EMOJI_INFO" "🔵"
set_readonly_default "EMOJI_SUCCESS" "✅"
set_readonly_default "EMOJI_WARN" "⚠️"
set_readonly_default "EMOJI_ERROR" "❌"
set_readonly_default "EMOJI_DEBUG" "🐛"
set_readonly_default "EMOJI_STEP" "➡️"
set_readonly_default "EMOJI_SPARKLES" "✨"
set_readonly_default "EMOJI_ROCKET" "🚀"
set_readonly_default "EMOJI_SHIELD" "🛡️"
set_readonly_default "EMOJI_GEAR" "⚙️"
set_readonly_default "EMOJI_CLOCK" "⏱️"
set_readonly_default "EMOJI_CHOICE" "🔘"
set_readonly_default "EMOJI_PLUGIN" "🔌"
set_readonly_default "EMOJI_PROMPT" "💻"

# ===========================================================================
# INTERACTIVE MENU SYSTEM
# ===========================================================================

show_interactive_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              BLUX10K Interactive Setup Menu v4.0.0            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Prompt selection
    echo -e "${CYAN}${EMOJI_CHOICE} ${EMOJI_PROMPT} Select your preferred prompt system:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Powerlevel10k${NC} - Highly customizable, fast ZSH theme"
    echo -e "     • Rich, configurable prompts"
    echo -e "     • Instant prompt for fast startup"
    echo -e "     • Extensive segment library"
    echo ""
    echo -e "  2) ${GREEN}Starship${NC} - Minimal, fast, and customizable prompt"
    echo -e "     • Cross-shell (ZSH, Bash, Fish, etc.)"
    echo -e "     • Written in Rust for speed"
    echo -e "     • Language-aware prompts"
    echo ""
    echo -e "  3) ${YELLOW}Skip prompt selection${NC}"
    echo ""
    
    local choice=""
    while true; do
        read -rp "Enter your choice (1-3): " choice
        case $choice in
            1)
                SELECTED_PROMPT="powerlevel10k"
                echo -e "${GREEN}✓ Selected Powerlevel10k${NC}"
                break
                ;;
            2)
                SELECTED_PROMPT="starship"
                echo -e "${GREEN}✓ Selected Starship${NC}"
                break
                ;;
            3)
                SELECTED_PROMPT="none"
                echo -e "${YELLOW}✓ Skipping prompt selection${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1, 2, or 3.${NC}"
                ;;
        esac
    done
    
    echo ""
    
    # Plugin selection
    echo -e "${CYAN}${EMOJI_CHOICE} ${EMOJI_PLUGIN} Select plugin installation mode:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Complete${NC} - Install all popular ZSH plugins"
    echo -e "  2) ${YELLOW}Essential${NC} - Install essential plugins only"
    echo -e "  3) ${GRAY}Minimal${NC} - Install minimal plugins"
    echo -e "  4) ${BLUE}Custom${NC} - Select plugins individually"
    echo ""
    
    local plugin_choice=""
    while true; do
        read -rp "Enter your choice (1-4): " plugin_choice
        case $plugin_choice in
            1)
                PLUGIN_MODE="complete"
                echo -e "${GREEN}✓ Complete plugin installation${NC}"
                break
                ;;
            2)
                PLUGIN_MODE="essential"
                echo -e "${YELLOW}✓ Essential plugins only${NC}"
                break
                ;;
            3)
                PLUGIN_MODE="minimal"
                echo -e "${GRAY}✓ Minimal plugins${NC}"
                break
                ;;
            4)
                PLUGIN_MODE="custom"
                echo -e "${BLUE}✓ Custom plugin selection${NC}"
                select_custom_plugins
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-4.${NC}"
                ;;
        esac
    done
    
    echo ""
    
    # Update options
    echo -e "${CYAN}${EMOJI_CHOICE} 🔄 Update options:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Full Update${NC} - Update all packages and plugins"
    echo -e "  2) ${YELLOW}Plugin Update Only${NC} - Update Zinit plugins only"
    echo -e "  3) ${GRAY}Skip Updates${NC} - Don't update anything"
    echo ""
    
    local update_choice=""
    while true; do
        read -rp "Enter your choice (1-3): " update_choice
        case $update_choice in
            1)
                UPDATE_MODE="full"
                echo -e "${GREEN}✓ Full update selected${NC}"
                break
                ;;
            2)
                UPDATE_MODE="plugins"
                echo -e "${YELLOW}✓ Plugin update only${NC}"
                break
                ;;
            3)
                UPDATE_MODE="none"
                echo -e "${GRAY}✓ Skipping updates${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-3.${NC}"
                ;;
        esac
    done
    
    # Confirmation
    echo ""
    echo -e "${CYAN}${EMOJI_CHOICE} 📊 Installation Summary:${NC}"
    echo -e "  Prompt: ${GREEN}${SELECTED_PROMPT}${NC}"
    echo -e "  Plugins: ${GREEN}${PLUGIN_MODE}${NC}"
    echo -e "  Updates: ${GREEN}${UPDATE_MODE}${NC}"
    echo ""
    
    read -rp "Proceed with installation? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    fi
    
    echo ""
}

select_custom_plugins() {
    echo -e "${CYAN}${EMOJI_CHOICE} Select plugins to install (space to toggle, enter when done):${NC}"
    echo ""
    
    SELECTED_CUSTOM_PLUGINS=()
    
    # Essential plugins (pre-selected)
    local essential_plugins=(
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zdharma-continuum/fast-syntax-highlighting"
    )
    
    # Popular plugins
    local popular_plugins=(
        "zsh-users/zsh-history-substring-search"
        "hlissner/zsh-autopair"
        "agkozak/zsh-z"
        "Aloxaf/fzf-tab"
        "wfxr/forgit"
        "MichaelAquilina/zsh-autoswitch-virtualenv"
        "zsh-users/zsh-history-substring-search"
    )
    
    # Advanced plugins
    local advanced_plugins=(
        "jeffreytse/zsh-vi-mode"
        "marlonrichert/zsh-autocomplete"
        "z-shell/F-Sy-H"
        "z-shell/H-S-MW"
        "zdharma-continuum/zinit-annex-bin-gem-node"
        "OMZ::plugins/git"
        "OMZ::plugins/docker"
        "OMZ::plugins/kubectl"
    )
    
    echo -e "${YELLOW}Essential plugins (selected by default):${NC}"
    for plugin in "${essential_plugins[@]}"; do
        SELECTED_CUSTOM_PLUGINS+=("$plugin")
        echo "  ✓ $plugin"
    done
    
    echo ""
    echo -e "${CYAN}Popular plugins:${NC}"
    for plugin in "${popular_plugins[@]}"; do
        echo "  [ ] $plugin"
    done
    
    echo ""
    echo -e "${BLUE}Advanced plugins:${NC}"
    for plugin in "${advanced_plugins[@]}"; do
        echo "  [ ] $plugin"
    done
    
    echo ""
    echo -e "${YELLOW}Note: Custom selection requires manual editing. For now, using essential plugins.${NC}"
    echo -e "${GREEN}You can customize plugins later in ~/.zshrc${NC}"
}

# ===========================================================================
# LOGGING SYSTEM WITH MULTI-OUTPUT SUPPORT
# ===========================================================================

init_logging() {
    mkdir -p "${BLUX10K_LOG_DIR}"
    exec 3>&1 4>&2
    if [[ "${BLUX10K_VERBOSE:-0}" -eq 1 ]]; then
        exec 1> >(tee -a "${BLUX10K_INSTALL_LOG}" >&3) 2> >(tee -a "${BLUX10K_INSTALL_LOG}" >&4)
    else
        exec 1> >(tee -a "${BLUX10K_INSTALL_LOG}" >&3) 2>&1
    fi
    
    echo "=== BLUX10K Installer v${BLUX10K_VERSION} Log ===" >> "${BLUX10K_INSTALL_LOG}"
    echo "Timestamp: $(date -Iseconds)" >> "${BLUX10K_INSTALL_LOG}"
    echo "User: $(whoami)" >> "${BLUX10K_INSTALL_LOG}"
    echo "Selected Prompt: ${SELECTED_PROMPT:-not_set}" >> "${BLUX10K_INSTALL_LOG}"
    echo "Plugin Mode: ${PLUGIN_MODE:-not_set}" >> "${BLUX10K_INSTALL_LOG}"
}

# Enhanced logging functions
log_header() {
    local title="$1"
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}                      $(printf "%-48s" "${title}")${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
}

log_section() {
    local title="$1"
    echo -e "\n${CYAN}▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ ${WHITE}${title}${CYAN} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬${NC}"
}

log_info() {
    echo -e "${BLUE}${EMOJI_INFO}  ${NC}$1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_success() {
    echo -e "${GREEN}${EMOJI_SUCCESS}  ${NC}$1"
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_warn() {
    echo -e "${YELLOW}${EMOJI_WARN}  ${NC}$1"
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_error() {
    echo -e "${RED}${EMOJI_ERROR}  ${NC}$1" >&2
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_debug() {
    if [[ "${BLUX10K_DEBUG:-0}" -eq 1 ]]; then
        echo -e "${GRAY}${EMOJI_DEBUG}  ${NC}$1"
        echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
    fi
}

log_step() {
    local step_number="${1}"
    local step_title="${2}"
    echo -e "${MAGENTA}${EMOJI_STEP} Step ${step_number}: ${WHITE}${step_title}${NC}"
}

log_perf() {
    local message="$1"
    local duration="$2"
    echo -e "${CYAN}${EMOJI_CLOCK}  ${message}: ${WHITE}${duration}ms${NC}"
}

log_security() {
    echo -e "${PURPLE}${EMOJI_SHIELD}  ${NC}$1"
}

# ===========================================================================
# BANNER & WELCOME MESSAGE
# ===========================================================================

print_banner() {
    clear
    cat << 'EOF'
    
    ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
    ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
    ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀
    
╔════════════════════════════════════════════════════════════════╗
║                 BLUX10K ENHANCED INSTALLER v4.0.0             ║
║           Enterprise-Grade Universal Terminal Setup           ║
║        Performance Optimized | Security Hardened | AI Ready   ║
╚════════════════════════════════════════════════════════════════╝

EOF
    
    log_success "Starting BLUX10K v${BLUX10K_VERSION} Installation"
    echo -e "${GRAY}Repository: ${BLUE}${BLUX10K_REPO}${NC}"
    echo -e "${GRAY}Documentation: ${BLUE}${BLUX10K_DOCS}${NC}"
    echo -e "${GRAY}Installation Log: ${BLUE}${BLUX10K_INSTALL_LOG}${NC}"
    echo ""
}

# ===========================================================================
# PLATFORM DETECTION & VALIDATION
# ===========================================================================

detect_platform() {
    local start_time
    start_time=$(date +%s%N)
    
    log_header "Platform Detection"
    
    # Reset environment variables
    unset OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER PLATFORM ENVIRONMENT \
          IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
          IS_TERMUX IS_PROOT ARCH CPU_CORES RAM_GB
    
    # Basic system info
    ARCH=$(uname -m)
    CPU_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
    RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || sysctl -n hw.memsize 2>/dev/null || echo 0)
    RAM_GB=$((RAM_KB / 1048576))
    
    log_debug "Architecture: ${ARCH}"
    log_debug "CPU Cores: ${CPU_CORES}"
    log_debug "RAM: ${RAM_GB}GB"
    
    local platform_forced="false"
    local apt_locked="false"
    local termux_prefix="false"
    local termux_version="false"
    local termux_android="false"
    local android_kernel="false"

    if [[ "$(uname -o 2>/dev/null)" == "Android" ]] || [[ -f "/system/build.prop" ]]; then
        android_kernel="true"
    fi

    # Detect operating system
    case "$(uname -s)" in
        Linux*)
            if [[ -f "/etc/os-release" ]]; then
                source /etc/os-release
                OS_NAME="${NAME:-Unknown}"
                OS_VERSION="${VERSION_ID:-Unknown}"
                
                case "${ID:-}" in
                    debian|ubuntu|linuxmint|pop|zorin|elementary|kali)
                        OS_TYPE="debian"
                        PACKAGE_MANAGER="apt"
                        ;;
                    arch|manjaro|endeavouros|garuda)
                        OS_TYPE="arch"
                        PACKAGE_MANAGER="pacman"
                        ;;
                    fedora|rhel|centos|almalinux|rocky)
                        OS_TYPE="fedora"
                        PACKAGE_MANAGER="dnf"
                        ;;
                    alpine)
                        OS_TYPE="alpine"
                        PACKAGE_MANAGER="apk"
                        ;;
                    void)
                        OS_TYPE="void"
                        PACKAGE_MANAGER="xbps"
                        ;;
                    gentoo)
                        OS_TYPE="gentoo"
                        PACKAGE_MANAGER="emerge"
                        ;;
                    chromeos)
                        OS_TYPE="chromeos"
                        PACKAGE_MANAGER="apt"
                        ;;
                    *)
                        OS_TYPE="linux"
                        PACKAGE_MANAGER="apt"
                        ;;
                esac
                log_info "Detected: ${PRETTY_NAME:-$OS_NAME} (${OS_TYPE})"
            else
                OS_TYPE="linux"
                OS_NAME="Linux"
                PACKAGE_MANAGER="apt"
                log_warn "Could not detect Linux distribution, using generic setup"
            fi
            ;;
        Darwin*)
            OS_TYPE="macos"
            OS_NAME="macOS"
            OS_VERSION=$(sw_vers -productVersion)
            PACKAGE_MANAGER="brew"
            log_info "Detected: macOS ${OS_VERSION}"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS_TYPE="windows"
            OS_NAME="Windows"
            if command -v winget >/dev/null 2>&1; then
                PACKAGE_MANAGER="winget"
            elif command -v choco >/dev/null 2>&1; then
                PACKAGE_MANAGER="chocolatey"
            else
                PACKAGE_MANAGER="winget"
            fi
            log_info "Detected: Windows (${PACKAGE_MANAGER})"
            ;;
        FreeBSD*)
            OS_TYPE="freebsd"
            OS_NAME="FreeBSD"
            PACKAGE_MANAGER="pkg"
            log_info "Detected: FreeBSD"
            ;;
        OpenBSD*)
            OS_TYPE="openbsd"
            OS_NAME="OpenBSD"
            PACKAGE_MANAGER="pkg_add"
            log_info "Detected: OpenBSD"
            ;;
        *)
            OS_TYPE="unknown"
            OS_NAME="Unknown"
            PACKAGE_MANAGER="unknown"
            log_warn "Unknown operating system: $(uname -s)"
            ;;
    esac

    # Apply platform override
    case "${BLUX10K_FORCE_PLATFORM:-}" in
        termux)
            OS_TYPE="termux"
            PACKAGE_MANAGER="pkg"
            IS_TERMUX="true"
            platform_forced="true"
            log_info "Platform override: termux"
            ;;
        debian|apt)
            OS_TYPE="debian"
            PACKAGE_MANAGER="apt"
            platform_forced="true"
            log_info "Platform override: debian"
            ;;
    esac
    
    # Detect WSL
    if [[ "$OS_TYPE" == "linux" ]] && (grep -qi microsoft /proc/version 2>/dev/null || [[ -d "/mnt/c/Windows" ]]); then
        IS_WSL="true"
        if grep -qi "WSL2" /proc/version 2>/dev/null; then
            WSL_VERSION="2"
        else
            WSL_VERSION="1"
        fi
        log_info "Running in WSL ${WSL_VERSION}"
    fi
    
    if [[ "${platform_forced}" != "true" ]] \
        && [[ -f "/etc/os-release" ]] \
        && [[ "${ID:-}" != "android" ]] \
        && command -v apt-get >/dev/null 2>&1; then
        if [[ "${OS_TYPE}" == "linux" ]]; then
            OS_TYPE="debian"
        fi
        PACKAGE_MANAGER="apt"
        apt_locked="true"
        log_info "Locked package manager to apt based on /etc/os-release"
    fi

    # Detect proot environments
    local proot_signal="false"
    if grep -qi "proot" /proc/self/status 2>/dev/null \
        || grep -aq "proot" /proc/self/maps 2>/dev/null \
        || grep -aq "proot" /proc/1/cmdline 2>/dev/null \
        || env | grep -q '^PROOT_' \
        || { command -v proot >/dev/null 2>&1 && [[ -n "${PROOT_TMP_DIR:-}" || -n "${PROOT_ROOTFS:-}" ]]; }; then
        proot_signal="true"
    fi

    if [[ "${proot_signal}" == "true" ]]; then
        IS_PROOT="true"
        log_info "Detected proot environment"
    fi

    if [[ "${android_kernel}" == "true" ]] \
        && [[ -f "/etc/os-release" ]] \
        && [[ "${ID:-}" != "android" ]] \
        && command -v apt-get >/dev/null 2>&1; then
        if [[ -z "${IS_PROOT:-}" ]] \
            && [[ -d "/data/data/com.termux" ]] \
            && [[ "${ID:-}" == "debian" ]]; then
            IS_PROOT="true"
            log_info "Detected proot environment (Termux host with Debian userland)"
        fi
    fi

    if [[ "${PREFIX:-}" == *"/data/data/com.termux/files/usr"* ]]; then
        termux_prefix="true"
    fi

    if [[ -n "${TERMUX_VERSION:-}" ]]; then
        termux_version="true"
    fi

    if [[ "${android_kernel}" == "true" ]]; then
        termux_android="true"
    fi

    # Detect Termux (Android)
    if [[ "${platform_forced}" != "true" ]] \
        && [[ "${apt_locked}" != "true" ]] \
        && [[ "${IS_PROOT:-}" != "true" ]] \
        && [[ "${termux_prefix}" == "true" || "${termux_version}" == "true" ]] \
        && command -v pkg >/dev/null 2>&1 \
        && { [[ "${termux_android}" == "true" ]] || [[ ! -f "/etc/os-release" ]] || [[ "${ID:-}" == "android" ]] || [[ "${ID_LIKE:-}" == *"android"* ]]; }; then
        IS_TERMUX="true"
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
        log_info "Detected Termux (Android)"
    fi

    # Prefer apt in proot if available
    if [[ -n "${IS_PROOT:-}" ]] && command -v apt-get >/dev/null 2>&1 && [[ "${platform_forced}" != "true" ]]; then
        PACKAGE_MANAGER="apt"
    fi

    # Ensure package manager is available; fallback between apt and pkg
    if [[ "${PACKAGE_MANAGER}" == "pkg" ]] && ! command -v pkg >/dev/null 2>&1; then
        if [[ "${platform_forced}" == "true" ]]; then
            log_error "pkg not found but BLUX10K_FORCE_PLATFORM is set"
            return 1
        elif command -v apt-get >/dev/null 2>&1; then
            log_warn "pkg not found, falling back to apt"
            PACKAGE_MANAGER="apt"
        else
            log_error "pkg not found and apt-get unavailable. Please install a supported package manager."
            return 1
        fi
    fi

    if [[ "${PACKAGE_MANAGER}" == "apt" ]] && ! command -v apt-get >/dev/null 2>&1; then
        if [[ "${platform_forced}" == "true" ]]; then
            log_error "apt-get not found but BLUX10K_FORCE_PLATFORM is set"
            return 1
        elif command -v pkg >/dev/null 2>&1; then
            log_warn "apt-get not found, falling back to pkg"
            PACKAGE_MANAGER="pkg"
        else
            log_error "apt-get not found and pkg unavailable. Please install a supported package manager."
            return 1
        fi
    fi

    log_debug "Platform summary: OS_TYPE=${OS_TYPE} PACKAGE_MANAGER=${PACKAGE_MANAGER} IS_PROOT=${IS_PROOT:-false} TERMUX_PREFIX=${termux_prefix} TERMUX_VERSION=${termux_version}"
    # Detect container environments
    if [[ -f "/.dockerenv" ]] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        IS_CONTAINER="docker"
        log_info "Running in Docker container"
    elif [[ -f "/run/.containerenv" ]]; then
        IS_CONTAINER="podman"
        log_info "Running in Podman container"
    fi
    
    # Detect cloud environments
    if [[ -n "${CLOUD_SHELL:-}" ]] || [[ -d "/google" ]]; then
        IS_CLOUD="google-cloud-shell"
        log_info "Detected Google Cloud Shell"
    elif [[ -n "${CODESPACES:-}" ]]; then
        IS_CLOUD="github-codespaces"
        log_info "Detected GitHub Codespaces"
    elif [[ -n "${GITPOD_WORKSPACE_ID:-}" ]]; then
        IS_CLOUD="gitpod"
        log_info "Detected Gitpod"
    elif [[ -n "${AWS_CLOUDSHELL:-}" ]]; then
        IS_CLOUD="aws-cloudshell"
        log_info "Detected AWS CloudShell"
    fi
    
    # Detect virtual machines
    if command -v systemd-detect-virt >/dev/null 2>&1; then
        local virt_env
        virt_env=$(systemd-detect-virt 2>/dev/null)
        if [[ "$virt_env" != "none" ]]; then
            log_info "Virtualization: ${virt_env}"
        fi
    fi
    
    # Performance metrics
    local end_time
    end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    log_perf "Platform detection completed" "${duration}"
    PLATFORM="${OS_TYPE}"
    if [[ -n "${IS_PROOT:-}" ]]; then
        ENVIRONMENT="proot"
    elif [[ -n "${IS_TERMUX:-}" ]]; then
        ENVIRONMENT="termux"
    else
        ENVIRONMENT="native"
    fi

    log_success "Platform: ${OS_NAME} ${OS_VERSION:-} (${OS_TYPE})"
    log_success "Package Manager: ${PACKAGE_MANAGER}"
    
    [[ -n "${IS_WSL:-}" ]] && log_info "WSL: Version ${WSL_VERSION}"
    [[ -n "${IS_CONTAINER:-}" ]] && log_info "Container: ${IS_CONTAINER}"
    [[ -n "${IS_CLOUD:-}" ]] && log_info "Cloud: ${IS_CLOUD}"
    [[ -n "${IS_TERMUX:-}" ]] && log_info "Environment: Termux"
    
    export OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER PLATFORM ENVIRONMENT \
           IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
           IS_TERMUX IS_PROOT ARCH CPU_CORES RAM_GB
}

# ===========================================================================
# SECURITY & PERMISSION CHECKS
# ===========================================================================

check_permissions() {
    log_section "Security & Permission Checks"
    
    # Check if running as root (not recommended)
    if [[ "$EUID" -eq 0 ]]; then
        log_warn "Running as root is not recommended"
        if [[ "${BLUX10K_FORCE_ROOT:-0}" -ne 1 ]]; then
            log_error "Please run as a regular user. Use --force-root to override"
            return 1
        fi
    fi
    
    # Check sudo access if needed
    if [[ "$OS_TYPE" != "windows" ]] && [[ "$OS_TYPE" != "termux" ]]; then
        if ! sudo -n true 2>/dev/null; then
            log_warn "Sudo access may be required for some operations"
        fi
    fi
    
    # Check for existing BLUX10K installation
    if [[ -d "$BLUX10K_CONFIG_DIR" ]]; then
        local backup_dir="${BLUX10K_CONFIG_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
        log_warn "Existing BLUX10K configuration found"
        log_info "Creating backup at: ${backup_dir}"
        cp -r "$BLUX10K_CONFIG_DIR" "$backup_dir" 2>/dev/null || true
    fi
    
    log_security "Permission checks passed"
    return 0
}

# ===========================================================================
# UNIVERSAL PACKAGE MANAGEMENT
# ===========================================================================

install_packages() {
    local packages=("$@")
    local silent="${BLUX10K_SILENT_INSTALL:-0}"
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        log_debug "No packages specified for installation"
        return 0
    fi
    
    log_info "Installing ${#packages[@]} package(s): ${packages[*]}"
    
    case $PACKAGE_MANAGER in
        apt)
            local apt_update_args=()
            local apt_install_args=()
            if [[ "$silent" -eq 1 ]]; then
                apt_update_args=(-qq)
                apt_install_args=(-yq)
            else
                apt_update_args=()
                apt_install_args=(-y)
            fi

            sudo DEBIAN_FRONTEND=noninteractive apt-get update "${apt_update_args[@]}"

            local install_list=()
            local docker_optional_packages=("docker-ce" "docker-ce-cli" "containerd.io" "docker-compose-plugin" "docker" "docker-compose")
            for pkg in "${packages[@]}"; do
                local candidate
                local is_docker_optional=0
                for docker_pkg in "${docker_optional_packages[@]}"; do
                    if [[ "$pkg" == "$docker_pkg" ]]; then
                        is_docker_optional=1
                        break
                    fi
                done
                candidate=$(apt-cache policy "$pkg" 2>/dev/null | awk -F': ' '/Candidate:/{print $2; exit}')
                if ! apt-cache show "$pkg" >/dev/null 2>&1 || [[ -z "$candidate" || "$candidate" == "(none)" ]]; then
                    if [[ $is_docker_optional -eq 1 ]]; then
                        log_warn "Docker package ${pkg} has no installation candidate; skipping. Enable the Docker apt repository if you need Docker."
                        continue
                    fi
                    if [[ "$pkg" == "unrar" ]]; then
                        local fallback_candidate
                        fallback_candidate=$(apt-cache policy "unrar-free" 2>/dev/null | awk -F': ' '/Candidate:/{print $2; exit}')
                        if apt-cache show "unrar-free" >/dev/null 2>&1 && [[ -n "$fallback_candidate" && "$fallback_candidate" != "(none)" ]]; then
                            log_warn "Package unrar unavailable, using unrar-free instead"
                            install_list+=("unrar-free")
                        else
                            log_warn "Package unrar unavailable and unrar-free not found, skipping"
                        fi
                        continue
                    fi
                    log_error "Package ${pkg} has no installation candidate"
                    return 1
                fi
                install_list+=("$pkg")
            done

            if [[ ${#install_list[@]} -gt 0 ]]; then
                sudo DEBIAN_FRONTEND=noninteractive apt-get install "${apt_install_args[@]}" "${install_list[@]}"
            else
                log_warn "No packages available to install via apt-get"
            fi
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
        pacman)
            sudo pacman -Syu --noconfirm "${packages[@]}"
            ;;
        dnf|yum)
            sudo dnf upgrade -y
            sudo dnf install -y "${packages[@]}"
            ;;
        pkg)  # Termux/FreeBSD
            pkg update
            pkg install -y "${packages[@]}"
            ;;
        winget)
            for pkg in "${packages[@]}"; do
                winget install --id "$pkg" --silent --accept-package-agreements --accept-source-agreements
            done
            ;;
        chocolatey)
            for pkg in "${packages[@]}"; do
                choco install "$pkg" -y --no-progress
            done
            ;;
        apk)  # Alpine
            sudo apk update
            sudo apk add "${packages[@]}"
            ;;
        pkg_add)  # OpenBSD
            doas pkg_add "${packages[@]}"
            ;;
        xbps)  # Void Linux
            sudo xbps-install -Syu "${packages[@]}"
            ;;
        emerge)  # Gentoo
            sudo emerge --quiet-build=y "${packages[@]}"
            ;;
        *)
            log_error "Unsupported package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
    
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        log_success "Package installation completed"
    else
        log_warn "Some packages may have failed to install (exit code: $exit_code)"
    fi
    
    return $exit_code
}

install_package_manager() {
    log_info "Ensuring package manager is available..."
    
    case $PACKAGE_MANAGER in
        brew)
            if ! command -v brew >/dev/null 2>&1; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                
                # Add Homebrew to PATH for macOS
                if [[ "$OS_TYPE" == "macos" ]]; then
                    if [[ "$ARCH" == "arm64" ]]; then
                        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                        eval "$(/opt/homebrew/bin/brew shellenv)"
                    else
                        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
                        eval "$(/usr/local/bin/brew shellenv)"
                    fi
                fi
                log_success "Homebrew installed"
            fi
            ;;
        winget)
            if ! command -v winget >/dev/null 2>&1; then
                log_warn "Winget not found. Please install from Microsoft Store"
                log_info "Alternatively, install Chocolatey: https://chocolatey.org"
                return 1
            fi
            ;;
        chocolatey)
            if ! command -v choco >/dev/null 2>&1; then
                log_info "Installing Chocolatey..."
                if [[ "$(uname -s)" == "MINGW"* ]] || [[ "$(uname -s)" == "CYGWIN"* ]]; then
                    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
                    log_success "Chocolatey installed"
                else
                    log_error "Chocolatey requires Windows"
                    return 1
                fi
            fi
            ;;
    esac
    
    return 0
}

# ===========================================================================
# DEPENDENCY MANAGEMENT
# ===========================================================================

check_dependencies() {
    log_section "Dependency Checks"
    
    local critical_deps=("curl" "git")
    local missing_deps=()
    local optional_deps=("zsh" "nvim" "tmux" "python3" "node" "docker")
    local missing_optional=()
    
    # Check critical dependencies
    for dep in "${critical_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    # Check optional dependencies
    for dep in "${optional_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_optional+=("$dep")
        fi
    done
    
    # Install missing critical dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_warn "Missing critical dependencies: ${missing_deps[*]}"
        log_info "Installing missing dependencies..."
        
        case $PACKAGE_MANAGER in
            apt) install_packages "curl" "git" ;;
            brew) install_packages "curl" "git" ;;
            pacman) install_packages "curl" "git" ;;
            dnf) install_packages "curl" "git" ;;
            pkg) install_packages "curl" "git" ;;
            winget) install_packages "cURL.cURL" "Git.Git" ;;
            chocolatey) install_packages "curl" "git" ;;
            *) log_error "Cannot auto-install dependencies on $PACKAGE_MANAGER" ;;
        esac
        
        # Verify installation
        for dep in "${missing_deps[@]}"; do
            if command -v "$dep" &>/dev/null; then
                log_success "Installed: $dep"
            else
                log_error "Failed to install: $dep"
                return 1
            fi
        done
    else
        log_success "All critical dependencies satisfied"
    fi
    
    # Report optional dependencies
    if [[ ${#missing_optional[@]} -gt 0 ]]; then
        log_info "Optional dependencies not found: ${missing_optional[*]}"
        log_info "These will be installed during setup if needed"
    fi
    
    return 0
}

# ===========================================================================
# CORE COMPONENTS INSTALLATION
# ===========================================================================

install_core_packages() {
    log_section "Core System Packages"
    
    local packages=()
    
    case $OS_TYPE in
        debian|ubuntu|wsl)
            packages=(
                "zsh" "git" "gnupg2" "openssh-client" "curl" "wget" "ca-certificates"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz-utils" "p7zip-full" "unrar"
                "lsof" "iproute2" "net-tools" "file" "procps" "htop" "nmap" "tcpdump"
                "python3" "python3-pip" "python3-venv" "python3-numpy" "pipx" "jq" "yq"
                "neovim" "tmux" "screen" "rsync" "sshfs"
            )
            ;;
        arch)
            packages=(
                "zsh" "git" "gnupg" "openssh" "curl" "wget" "ca-certificates"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar"
                "lsof" "iproute2" "net-tools" "file" "procps-ng" "htop" "nmap" "tcpdump"
                "python" "python-pip" "python-virtualenv" "pipx" "jq" "yq"
                "neovim" "tmux" "screen" "rsync" "sshfs"
            )
            ;;
        fedora)
            packages=(
                "zsh" "git" "gnupg2" "openssh-clients" "curl" "wget" "ca-certificates"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "p7zip-plugins" "unrar"
                "lsof" "iproute" "net-tools" "file" "procps-ng" "htop" "nmap" "tcpdump"
                "python3" "python3-pip" "python3-virtualenv" "pipx" "jq" "yq"
                "neovim" "tmux" "screen" "rsync" "sshfs"
            )
            ;;
        macos)
            packages=(
                "zsh" "git" "gnupg" "openssh" "curl" "wget" "coreutils" "findutils"
                "unzip" "p7zip" "unrar" "gnu-tar" "gnu-sed" "lsof" "iproute2mac"
                "python" "python@3.11" "pipx" "jq" "yq"
                "neovim" "tmux" "screen" "rsync" "sshfs"
            )
            ;;
        windows)
            packages=(
                "Git.Git" "Microsoft.PowerShell" "Neovim.Neovim" "OpenSSH.Client"
                "Python.Python.3.11" "7zip.7zip" "CURL.cURL" "Wget.Wget"
            )
            ;;
        termux)
            packages=(
                "zsh" "git" "gnupg" "openssh" "curl" "wget" "coreutils" "findutils"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" "procps"
                "python" "python-numpy" "jq" "yq"
                "neovim" "tmux" "screen" "rsync"
            )
            ;;
        freebsd)
            packages=(
                "zsh" "git" "gnupg" "openssh" "curl" "wget" "ca_root_nss"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof"
                "python3" "py3*-pip" "jq" "yq"
                "neovim" "tmux" "screen" "rsync"
            )
            ;;
        alpine)
            packages=(
                "zsh" "git" "gnupg" "openssh-client" "curl" "wget" "ca-certificates"
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof"
                "python3" "py3-pip" "jq" "yq"
                "neovim" "tmux" "screen" "rsync"
            )
            ;;
        *)
            log_warn "Unknown OS type, installing minimal packages"
            packages=("zsh" "git" "curl" "wget" "neovim")
            ;;
    esac
    
    install_packages "${packages[@]}"
}

install_modern_tools() {
    log_section "Modern Development Tools"
    
    # Tools to install via package manager
    local pm_tools=()
    # Tools to install via cargo
    local cargo_tools=("bat" "fd-find" "ripgrep" "eza" "zoxide" "starship" "du-dust" "procs")
    # Tools to install via pip
    local pip_tools=("httpie" "pygments" "rich-cli" "cookiecutter" "poetry")
    
    case $OS_TYPE in
        debian|ubuntu|wsl)
            pm_tools=("fzf" "gh" "docker-ce" "docker-ce-cli" "containerd.io" "docker-compose-plugin")
            ;;
        arch)
            pm_tools=("fzf" "github-cli" "docker" "docker-compose" "kubectl" "helm")
            ;;
        fedora)
            pm_tools=("fzf" "gh" "docker" "docker-compose" "kubectl" "helm")
            ;;
        macos)
            pm_tools=("fzf" "gh" "docker" "docker-compose" "kubectl" "helm")
            ;;
        windows)
            pm_tools=("fzf" "GitHub.cli" "Docker.DockerDesktop" "Kubernetes.kubectl" "Helm.Helm")
            ;;
        *)
            pm_tools=("fzf")
            ;;
    esac

    if [[ -n "${IS_PROOT:-}" ]]; then
        local filtered_tools=()
        local skipped_docker=0
        local docker_optional_packages=("docker-ce" "docker-ce-cli" "containerd.io" "docker-compose-plugin" "docker" "docker-compose")
        for tool in "${pm_tools[@]}"; do
            local skip_tool=0
            for docker_pkg in "${docker_optional_packages[@]}"; do
                if [[ "$tool" == "$docker_pkg" ]]; then
                    skip_tool=1
                    skipped_docker=1
                    break
                fi
            done
            if [[ $skip_tool -eq 0 ]]; then
                filtered_tools+=("$tool")
            fi
        done
        if [[ $skipped_docker -eq 1 ]]; then
            log_warn "Skipping Docker install: proot environment detected (Docker not supported here)."
        fi
        pm_tools=("${filtered_tools[@]}")
    fi
    
    # Install via package manager
    if [[ ${#pm_tools[@]} -gt 0 ]]; then
        install_packages "${pm_tools[@]}"
    fi
    
    # Install Rust/cargo if needed
    if ! command -v cargo >/dev/null 2>&1; then
        log_info "Installing Rust toolchain..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        log_success "Rust toolchain installed"
    fi
    
    # Install tools via cargo
    for tool in "${cargo_tools[@]}"; do
        if ! command -v "${tool//-/_}" &>/dev/null && ! command -v "$tool" &>/dev/null; then
            log_info "Installing $tool via cargo..."
            cargo install "$tool" --locked
        fi
    done
    
    # Install tools via pip
    for tool in "${pip_tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            log_info "Installing $tool via pip..."
            pip3 install --user "$tool"
        fi
    done
    
    # Create symlinks for Debian/Ubuntu
    if [[ "$OS_TYPE" == "debian" ]] || [[ "$OS_TYPE" == "ubuntu" ]]; then
        mkdir -p ~/.local/bin
        [[ -f "/usr/bin/batcat" ]] && ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
        [[ -f "/usr/bin/fdfind" ]] && ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true
    fi
    
    log_success "Modern tools installation completed"
}

# ===========================================================================
# ZINIT INSTALLATION & PLUGIN MANAGEMENT
# ===========================================================================

install_zinit() {
    log_section "Zinit Installation"
    
    local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    
    if [[ -d "$zinit_home" ]]; then
        log_info "Zinit already installed, updating..."
        git -C "$zinit_home" pull origin main
        log_success "Zinit updated"
    else
        log_info "Installing Zinit..."
        mkdir -p "$(dirname "$zinit_home")"
        git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
        log_success "Zinit installed"
    fi
    
    # Create zinit configuration directory
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zinit"
    
    log_success "Zinit ready"
}

install_zsh_plugins_via_zinit() {
    log_section "Installing ZSH Plugins via Zinit"
    
    # Define plugin sets based on selected mode
    local essential_plugins=(
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zdharma-continuum/fast-syntax-highlighting"
        "hlissner/zsh-autopair"
    )
    
    local popular_plugins=(
        "zsh-users/zsh-history-substring-search"
        "agkozak/zsh-z"
        "Aloxaf/fzf-tab"
        "wfxr/forgit"
        "MichaelAquilina/zsh-autoswitch-virtualenv"
    )
    
    local complete_plugins=(
        "jeffreytse/zsh-vi-mode"
        "marlonrichert/zsh-autocomplete"
        "zdharma-continuum/zinit-annex-bin-gem-node"
        "zdharma-continuum/zinit-annex-readurl"
        "zdharma-continuum/zinit-annex-patch-dl"
        "z-shell/F-Sy-H"
        "z-shell/H-S-MW"
        "z-shell/zsh-navigation-tools"
        "OMZ::plugins/git"
        "OMZ::plugins/docker"
        "OMZ::plugins/kubectl"
    )
    
    local plugins_to_install=()
    
    case "$PLUGIN_MODE" in
        minimal)
            plugins_to_install=("${essential_plugins[@]:0:3}")
            ;;
        essential)
            plugins_to_install=("${essential_plugins[@]}")
            ;;
        complete)
            plugins_to_install=("${essential_plugins[@]}" "${popular_plugins[@]}" "${complete_plugins[@]}")
            ;;
        custom)
            plugins_to_install=("${essential_plugins[@]}")
            if [[ ${#SELECTED_CUSTOM_PLUGINS[@]} -gt 0 ]]; then
                plugins_to_install+=("${SELECTED_CUSTOM_PLUGINS[@]}")
            fi
            ;;
        *)
            plugins_to_install=("${essential_plugins[@]}")
            ;;
    esac
    
    # Create plugins.zsh file
    local plugins_file="${B10K_DIR}/modules/zsh/plugins.zsh"
    mkdir -p "$(dirname "$plugins_file")"
    
    cat > "$plugins_file" << EOF
#!/usr/bin/env zsh
# BLUX10K ZSH Plugins Configuration
# Generated: $(date)

# Source zinit
source "\${XDG_DATA_HOME:-\$HOME/.local/share}/zinit/zinit.git/zinit.zsh"

# Load plugins
EOF
    
    for plugin in "${plugins_to_install[@]}"; do
        echo "zinit light \"$plugin\"" >> "$plugins_file"
        log_info "Added plugin: $plugin"
    done
    
    # Add completion and compilation
    cat >> "$plugins_file" << 'EOF'

# Load completions
autoload -Uz compinit
compinit

# Compile zinit plugins
zinit compile --all

# Plugin configurations
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# fzf-tab configuration
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' continuous-trigger 'tab'
zstyle ':fzf-tab:*' switch-group ',' '.'

# zsh-z configuration
ZSHZ_CMD='j'
ZSHZ_CASE='smart'
ZSHZ_UNCOMMON=1
EOF
    
    log_success "ZSH plugins configuration created"
    
    # Actually install plugins
    log_info "Installing plugins via Zinit..."
    
    # Source zinit temporarily to install plugins
    local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    if [[ -f "$zinit_home/zinit.zsh" ]]; then
        source "$zinit_home/zinit.zsh"
        
        # Install plugins
        for plugin in "${plugins_to_install[@]}"; do
            zinit light "$plugin"
        done
        
        # Update plugins
        zinit update --all --quiet
        log_success "Zinit plugins installed"
    else
        log_error "Zinit not found, plugins not installed"
        return 1
    fi
}

# ===========================================================================
# PROMPT SELECTION & INSTALLATION
# ===========================================================================

install_prompt_system() {
    log_section "Prompt System Installation"
    
    case "$SELECTED_PROMPT" in
        powerlevel10k)
            install_powerlevel10k
            configure_powerlevel10k
            ;;
        starship)
            install_starship
            configure_starship
            ;;
        none)
            log_info "Skipping prompt system installation"
            return 0
            ;;
        *)
            log_warn "Unknown prompt system: $SELECTED_PROMPT, defaulting to powerlevel10k"
            SELECTED_PROMPT="powerlevel10k"
            install_powerlevel10k
            configure_powerlevel10k
            ;;
    esac
}

install_powerlevel10k() {
    log_info "Installing Powerlevel10k..."
    
    mkdir -p "$(dirname "$P10K_DIR")"
    
    if [[ -d "$P10K_DIR/.git" ]]; then
        log_info "Updating Powerlevel10k..."
        if git -C "$P10K_DIR" pull --ff-only; then
            log_success "Powerlevel10k updated"
        else
            log_warn "Powerlevel10k update failed; continuing"
        fi
    else
        log_info "Cloning Powerlevel10k..."
        if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"; then
            log_success "Powerlevel10k installed"
        else
            log_error "Powerlevel10k installation failed"
            return 1
        fi
    fi
}

configure_powerlevel10k() {
    log_info "Configuring Powerlevel10k..."
    
    # Create p10k configuration
    local p10k_config="$HOME/.p10k.zsh"
    
    if [[ ! -f "$p10k_config" ]]; then
        cat > "$p10k_config" << 'EOF'
# Generated by BLUX10K Installer
# Powerlevel10k Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k
source "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
        log_success "Powerlevel10k configuration created"
    else
        log_info "Powerlevel10k configuration already exists"
    fi
    
    # Add to blux10k entrypoint
    echo "# Powerlevel10k configuration" >> "${B10K_DIR}/blux10k.zsh"
    echo "export P10K_DIR=\"${P10K_DIR}\"" >> "${B10K_DIR}/blux10k.zsh"
    echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> "${B10K_DIR}/blux10k.zsh"
    echo "source \"${P10K_DIR}/powerlevel10k.zsh-theme\"" >> "${B10K_DIR}/blux10k.zsh"
}

install_starship() {
    log_info "Installing Starship..."
    
    # Install Starship
    case "$OS_TYPE" in
        linux|debian|ubuntu|arch|fedora|wsl)
            if ! command -v starship >/dev/null 2>&1; then
                log_info "Downloading and installing Starship..."
                curl -sS https://starship.rs/install.sh | sh -s -- -y
                log_success "Starship installed"
            else
                log_info "Starship already installed"
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install starship
            else
                curl -sS https://starship.rs/install.sh | sh -s -- -y
            fi
            ;;
        windows)
            if command -v winget >/dev/null 2>&1; then
                winget install --id Starship.Starship --silent
            elif command -v choco >/dev/null 2>&1; then
                choco install starship -y
            else
                log_warn "Package manager not found for Starship installation on Windows"
            fi
            ;;
        *)
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            ;;
    esac
    
    # Verify installation
    if command -v starship >/dev/null 2>&1; then
        log_success "Starship installed: $(starship --version)"
    else
        log_error "Starship installation failed"
        return 1
    fi
}

configure_starship() {
    log_info "Configuring Starship..."
    
    # Create starship configuration
    local starship_config="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    
    if [[ ! -f "$starship_config" ]]; then
        cat > "$starship_config" << 'EOF'
# BLUX10K Starship Configuration

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$docker_context\
$package\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$golang\
$helm\
$java\
$julia\
$kotlin\
$lua\
$nim\
$nodejs\
$ocaml\
$perl\
$php\
$pulumi\
$purescript\
$python\
$rlang\
$red\
$ruby\
$rust\
$scala\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$nix_shell\
$conda\
$memory_usage\
$aws\
$gcloud\
$openstack\
$env_var\
$crystal\
$custom\
$sudo\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$shell\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = false
style = "bold blue"

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold red"

[time]
disabled = false
format = "[🕒 %T]"
time_range = "10:00..20:00"

[battery]
full_symbol = "🔋"
charging_symbol = "⚡"
discharging_symbol = "💀"
disabled = false

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
vicmd_symbol = "[V](bold green)"

[python]
symbol = "🐍 "

[nodejs]
symbol = "⬢ "

[docker_context]
symbol = " "
style = "bold blue"

[kubernetes]
symbol = "☸ "
style = "bold blue"

[aws]
symbol = "🅰 "
style = "bold yellow"

[memory_usage]
disabled = false
threshold = 75
symbol = " "
style = "bold dimmed white"
EOF
        log_success "Starship configuration created"
    else
        log_info "Starship configuration already exists"
    fi
    
    # Add to blux10k entrypoint
    echo "# Starship configuration" >> "${B10K_DIR}/blux10k.zsh"
    echo 'eval "$(starship init zsh)"' >> "${B10K_DIR}/blux10k.zsh"
}

# ===========================================================================
# UPDATE MANAGEMENT
# ===========================================================================

run_updates() {
    log_section "System Updates"
    
    case "$UPDATE_MODE" in
        full)
            update_system_packages
            update_zinit_plugins
            update_custom_tools
            ;;
        plugins)
            update_zinit_plugins
            ;;
        none)
            log_info "Skipping updates as requested"
            ;;
        *)
            log_warn "Unknown update mode: $UPDATE_MODE"
            ;;
    esac
}

update_system_packages() {
    log_info "Updating system packages..."
    
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update && sudo apt upgrade -y
            ;;
        brew)
            brew update && brew upgrade
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
        dnf)
            sudo dnf upgrade -y
            ;;
        pkg)
            pkg update && pkg upgrade -y
            ;;
        winget)
            winget upgrade --all --silent
            ;;
        chocolatey)
            choco upgrade all -y
            ;;
        *)
            log_warn "Package manager $PACKAGE_MANAGER not supported for updates"
            ;;
    esac
    
    log_success "System packages updated"
}

update_zinit_plugins() {
    log_info "Updating Zinit plugins..."
    
    local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    
    if [[ -f "$zinit_home/zinit.zsh" ]]; then
        source "$zinit_home/zinit.zsh"
        zinit self-update
        zinit update --all
        log_success "Zinit plugins updated"
    else
        log_warn "Zinit not found, skipping plugin update"
    fi
}

update_custom_tools() {
    log_info "Updating custom tools..."
    
    # Update Rust toolchain
    if command -v rustup >/dev/null 2>&1; then
        rustup update
        log_success "Rust toolchain updated"
    fi
    
    # Update pip packages
    if command -v pip3 >/dev/null 2>&1; then
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
        log_success "Python packages updated"
    fi
    
    # Update npm packages
    if command -v npm >/dev/null 2>&1; then
        npm update -g
        log_success "NPM packages updated"
    fi
}

# ===========================================================================
# CONFIGURATION DEPLOYMENT
# ===========================================================================

backup_file() {
    local target="$1"
    if [[ -f "$target" || -L "$target" ]]; then
        local backup="${target}.bak.$(date +%Y%m%d-%H%M%S)"
        cp -p "$target" "$backup"
        log_info "Backup created: $backup"
    fi
}

ensure_blux10k_block() {
    local target="$1"
    local block_start="# >>> BLUX10K START"
    local block_content
    block_content=$(cat << 'EOF'
# >>> BLUX10K START
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/blux10k.zsh"
# <<< BLUX10K END
EOF
)

    local existing_count=0
    if [[ -f "$target" ]]; then
        existing_count=$(grep -c "^${block_start}$" "$target" || true)
        if [[ "$existing_count" -eq 1 ]] && grep -Fq "$block_content" "$target"; then
            log_info "BLUX10K block already present in $(basename "$target")"
            return 0
        fi
        backup_file "$target"
        awk 'BEGIN{inblock=0}
            /^# >>> BLUX10K START$/ {inblock=1; next}
            /^# <<< BLUX10K END$/ {inblock=0; next}
            !inblock {print}' "$target" > "${target}.tmp"
        mv "${target}.tmp" "$target"
    fi

    printf "\n%s\n" "$block_content" >> "$target"
    log_success "Added BLUX10K block to $(basename "$target")"
}

sync_repo_dir() {
    local src_dir="$1"
    local dst_dir="$2"

    if [[ -d "$src_dir" ]]; then
        mkdir -p "$dst_dir"
        if command -v rsync >/dev/null 2>&1; then
            rsync -a --delete "$src_dir"/ "$dst_dir"/
        else
            cp -a "$src_dir"/. "$dst_dir"/
        fi
        log_success "Synced $(basename "$src_dir") -> $dst_dir"
    else
        log_warn "Source directory not found: $src_dir"
    fi
}

create_blux10k_entrypoint() {
    local entrypoint="$B10K_DIR/blux10k.zsh"

    cat > "$entrypoint" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Entrypoint (generated by install.sh)

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export B10K_DIR="${XDG_CONFIG_HOME}/blux10k"
export BLUX10K_CONFIG_DIR="${B10K_DIR}"

# Source modules
b10k_source() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
    else
        echo "⚠️  BLUX10K: missing ${file}" >&2
    fi
}

# Load modules
b10k_source "${B10K_DIR}/modules/zsh/plugins.zsh"
b10k_source "${B10K_DIR}/modules/zsh/aliases.zsh"
b10k_source "${B10K_DIR}/modules/zsh/functions.zsh"
b10k_source "${B10K_DIR}/modules/zsh/keybindings.zsh"

# Platform detection
platform="generic"
case "$(uname -s)" in
    Linux*)
        if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
            platform="wsl"
        else
            platform="linux"
        fi
        ;;
    Darwin*)
        platform="macos"
        ;;
esac

# Load platform-specific configuration
for platform_file in "${B10K_DIR}/modules/zsh/platform/${platform}.zsh" "${B10K_DIR}/modules/zsh/platform/${platform}-"*.zsh(N); do
    [[ -f "${platform_file}" ]] && b10k_source "${platform_file}"
done
EOF

    chmod 644 "$entrypoint"
    log_success "Created BLUX10K entrypoint at $entrypoint"
}

deploy_configurations() {
    log_section "Configuration Deployment"
    
    # Create directory structure
    local dirs=(
        "$B10K_DIR"
        "$B10K_DIR/modules"
        "$B10K_DIR/scripts"
        "$B10K_DIR/templates"
        "$B10K_DIR/configs"
        "$B10K_DIR/resources"
        "$B10K_DIR/tools"
        "$B10K_DIR/examples"
        "$HOME/.config/private"
        "$HOME/.config/neofetch"
        "$HOME/.local/bin"
        "$HOME/.local/share"
        "$HOME/.local/state"
        "$HOME/.cache"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
    done
    
    # Sync repository directories into BLUX10K config home
    sync_repo_dir "configs" "$B10K_DIR/configs"
    sync_repo_dir "modules" "$B10K_DIR/modules"
    sync_repo_dir "resources" "$B10K_DIR/resources"
    sync_repo_dir "tools" "$B10K_DIR/tools"
    sync_repo_dir "templates" "$B10K_DIR/templates"
    sync_repo_dir "examples" "$B10K_DIR/examples"
    
    # Create essential configuration files if they don't exist
    create_essential_configs
    
    # Create BLUX10K entrypoint and ensure zshrc block
    create_blux10k_entrypoint
    
    # Deploy .zshrc
    deploy_zshrc
    
    # Deploy private environment template
    if [[ ! -f "$HOME/.config/private/env.zsh" ]]; then
        create_private_env_template
    fi
    
    # Set secure permissions
    chmod 700 "$HOME/.config/private"
    chmod 600 "$HOME/.config/private/env.zsh" 2>/dev/null || true
    
    log_success "Configuration deployment completed"
}

create_essential_configs() {
    # Create aliases.zsh
    if [[ ! -f "$B10K_DIR/modules/zsh/aliases.zsh" ]]; then
        cat > "$B10K_DIR/modules/zsh/aliases.zsh" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Aliases

# Safety first
alias rm='rm -I --preserve-root'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Git
alias g='git'
alias gst='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gc='git commit -v'
alias gco='git checkout'
alias gp='git push'
alias gpf='git push --force-with-lease'

# Editors
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
fi

# Modern tools
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
fi

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='netstat -tulpn 2>/dev/null || ss -tulpn'
EOF
        log_success "Created aliases.zsh"
    fi
    
    # Create functions.zsh
    if [[ ! -f "$B10K_DIR/modules/zsh/functions.zsh" ]]; then
        cat > "$B10K_DIR/modules/zsh/functions.zsh" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Functions

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
        *.zip)              unzip "$1" ;;
        *.7z)               7z x "$1" ;;
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
EOF
        log_success "Created functions.zsh"
    fi
}

deploy_zshrc() {
    log_info "Deploying .zshrc configuration..."
    
    local zshrc_file="$HOME/.zshrc"
    local backup_zshrc="$zshrc_file.backup.$(date +%Y%m%d-%H%M%S)"
    
    # Backup existing .zshrc
    if [[ -f "$zshrc_file" ]]; then
        cp "$zshrc_file" "$backup_zshrc"
        log_info "Backed up existing .zshrc to $backup_zshrc"
    fi
    
    # Create new .zshrc with BLUX10K integration
    cat > "$zshrc_file" << 'EOF'
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
# BLUX10K CORE INTEGRATION
############################################################################
# >>> BLUX10K START
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
source "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/blux10k.zsh"
# <<< BLUX10K END

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
# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

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
    echo -e "\033[0;32m✓ BLUX10K v4.0.0 loaded\033[0m"
    echo -e "\033[0;34m▶ $(date '+%A, %B %d, %Y - %H:%M:%S')\033[0m"
    echo -e "\033[0;36m▶ Uptime: $(uptime -p | sed 's/up //')\033[0m"
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
EOF

    log_success "Created .zshrc with BLUX10K integration"
}

create_private_env_template() {
    cat > "$HOME/.config/private/env.zsh" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Private Environment v4.0.0
# ⚠️  SECURITY CRITICAL FILE ⚠️

# Security settings
export BLUX10K_SECURITY_MODE="strict"
export BLUX10K_ENCRYPTION_ENABLED=0
export BLUX10K_SECURITY_LAST_AUDIT=$(date +%Y-%m-%d)

echo "🔐 BLUX10K v4.0.0 Private Environment Loaded"

# ===========================================================================
# API KEYS & TOKENS (Replace with your actual keys)
# ===========================================================================

# AI/ML Services
# export OPENAI_API_KEY='sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
# export ANTHROPIC_API_KEY='sk-ant-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# GitHub
# export GITHUB_TOKEN='ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
# export GITHUB_USER='YourUsername'

# Cloud Providers
# export AWS_ACCESS_KEY_ID='AKIAxxxxxxxxxxxxxxxx'
# export AWS_SECRET_ACCESS_KEY='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# ===========================================================================
# DEVELOPMENT CONFIGURATION
# ===========================================================================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language environments
export PYTHONPATH='$HOME/projects:$PYTHONPATH'
export GOPATH='$HOME/go'
export CARGO_HOME='$HOME/.cargo'

# ===========================================================================
# BLUX10K SPECIFIC
# ===========================================================================

export BLUX10K_ENV='development'
export BLUX10K_DEBUG='0'
export BLUX10K_PERF_MODE='auto'

# Update system
export SYSUPDATE_LOG_KEEP=30
export SYSUPDATE_KERNELS_KEEP=3
export SYSUPDATE_MAX_RETRIES=5

# ===========================================================================
# SECURITY VALIDATION
# ===========================================================================

# Run security audit
if [[ "$BLUX10K_SECURITY_MODE" == "strict" ]]; then
    echo "🔍 Running security validation..."
    # Add validation checks here
fi

echo "✅ Private environment initialized"
EOF
    
    log_success "Private environment template created"
}

# ===========================================================================
# FONT INSTALLATION
# ===========================================================================

install_fonts() {
    log_section "Font Installation"
    
    # Skip if fonts already installed or skipped
    if [[ "${BLUX10K_SKIP_FONTS:-0}" -eq 1 ]]; then
        log_info "Skipping font installation (BLUX10K_SKIP_FONTS=1)"
        return 0
    fi
    
    local font_dir
    case $OS_TYPE in
        linux|debian|ubuntu|arch|fedora|wsl|alpine)
            font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k"
            ;;
        macos)
            font_dir="$HOME/Library/Fonts"
            ;;
        termux)
            log_info "Termux detected: run fonts/install-fonts.sh for manual setup"
            return 0
            ;;
        windows)
            font_dir="$HOME/AppData/Local/Microsoft/Windows/Fonts"
            log_info "Windows: Please manually install MesloLGS NF fonts"
            return 0
            ;;
        *)
            font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k"
            ;;
    esac

    mkdir -p "$font_dir"

    local font_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
    local fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )

    local downloaded=0
    for font in "${fonts[@]}"; do
        local font_file="${font//%20/ }"
        if curl -fSL "$font_url/$font" -o "$font_dir/$font_file" 2>/dev/null; then
            log_success "Downloaded: $font_file"
            ((downloaded++))
        else
            log_warn "Failed to download: $font_file"
        fi
    done

    # Update font cache
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$font_dir"
        log_success "Font cache updated"
    fi

    if [[ $downloaded -gt 0 ]]; then
        log_success "Installed fonts to $font_dir"
        log_info "Please set your terminal font to 'MesloLGS NF'"
    else
        log_error "No fonts were installed"
        return 1
    fi
}

# ===========================================================================
# POST-INSTALLATION SETUP
# ===========================================================================

post_install_setup() {
    log_section "Post-Installation Setup"
    
    # Create update script
    create_update_script
    
    # Create health check
    create_health_check
    
    # Create first run marker
    echo "$(date -Iseconds)" > "$BLUX10K_CACHE_DIR/first_run"
    
    log_success "Post-installation setup completed"
}

create_update_script() {
    cat > "$BLUX10K_CONFIG_DIR/scripts/update.sh" << 'EOF'
#!/usr/bin/env bash
# BLUX10K Update Script v4.0.0

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  BLUX10K System Update v4.0.0                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

# Detect package manager
if command -v apt >/dev/null; then
    sudo apt update && sudo apt upgrade -y
elif command -v pacman >/dev/null; then
    sudo pacman -Syu --noconfirm
elif command -v brew >/dev/null; then
    brew update && brew upgrade
elif command -v dnf >/dev/null; then
    sudo dnf upgrade -y
fi

# Update zinit plugins
if command -v zinit >/dev/null 2>&1; then
    zinit self-update
    zinit update --all
fi

# Update configuration
if [[ -d "$BLUX10K_CONFIG_DIR" ]]; then
    git -C "$BLUX10K_CONFIG_DIR" pull origin main 2>/dev/null || true
fi

echo -e "${GREEN}✅ BLUX10K update completed${NC}"
EOF
    
    chmod +x "$BLUX10K_CONFIG_DIR/scripts/update.sh"
}

create_health_check() {
    cat > "$BLUX10K_CONFIG_DIR/scripts/health-check.sh" << 'EOF'
#!/usr/bin/env bash
# BLUX10K Health Check v4.0.0

echo "🔍 BLUX10K System Health Check"
echo "════════════════════════════════════════════════════════════════"

# Check core components
components=("zsh" "git" "nvim" "curl" "tmux")
for comp in "${components[@]}"; do
    if command -v "$comp" >/dev/null 2>&1; then
        echo "✅ $comp: $(which $comp)"
    else
        echo "❌ $comp: Not found"
    fi
done

# Check configuration files
configs=("$HOME/.zshrc" "$HOME/.p10k.zsh" "$BLUX10K_CONFIG_DIR")
for config in "${configs[@]}"; do
    if [[ -e "$config" ]]; then
        echo "✅ Config: $(basename "$config") exists"
    else
        echo "❌ Config: $(basename "$config") missing"
    fi
done

# Performance check
echo "⚡ Performance:"
echo "  • CPU Cores: $(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null)"
echo "  • Shell Startup: Run 'zsh -i -c exit' to measure"

echo "════════════════════════════════════════════════════════════════"
echo "Health check completed. Run 'b10k --help' for more commands."
EOF
    
    chmod +x "$BLUX10K_CONFIG_DIR/scripts/health-check.sh"
}

# ===========================================================================
# FINALIZATION
# ===========================================================================

run_validation_report() {
    log_section "Installation Validation"

    if command -v zsh >/dev/null 2>&1; then
        log_success "zsh available: $(command -v zsh)"
    else
        log_warn "zsh not found"
    fi

    if [[ -f "$B10K_DIR/blux10k.zsh" ]]; then
        log_success "BLUX10K entrypoint present"
    else
        log_warn "BLUX10K entrypoint missing: $B10K_DIR/blux10k.zsh"
    fi

    if [[ -f "$HOME/.zshrc" ]]; then
        local start_count end_count
        start_count=$(grep -c "^# >>> BLUX10K START$" "$HOME/.zshrc" || true)
        end_count=$(grep -c "^# <<< BLUX10K END$" "$HOME/.zshrc" || true)
        if [[ "$start_count" -eq 1 ]] && [[ "$end_count" -eq 1 ]]; then
            log_success "BLUX10K block present once in ~/.zshrc"
        else
            log_warn "BLUX10K block count mismatch in ~/.zshrc (start=$start_count, end=$end_count)"
        fi
    else
        log_warn "~/.zshrc missing"
    fi

    if [[ "$SELECTED_PROMPT" == "powerlevel10k" ]] && [[ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]]; then
        log_success "Powerlevel10k theme present"
    elif [[ "$SELECTED_PROMPT" == "starship" ]] && command -v starship >/dev/null 2>&1; then
        log_success "Starship installed"
    fi

    log_success "Validation completed"
}

finalize_installation() {
    log_section "Finalizing Installation"
    
    # Record installation completion
    echo "BLUX10K v${BLUX10K_VERSION} installed $(date -Iseconds)" > "$BLUX10K_CACHE_DIR/installed"
    
    # Set up default shell (skip Windows)
    if [[ "$OS_TYPE" != "windows" ]] && [[ "$SHELL" != "$(command -v zsh)" ]]; then
        log_info "Setting zsh as default shell..."
        if chsh -s "$(command -v zsh)"; then
            log_success "Default shell set to zsh"
        else
            log_warn "Could not change default shell. Run manually: chsh -s $(command -v zsh)"
        fi
    fi
    
    # Print completion message
    print_completion_message
    run_validation_report
}

print_completion_message() {
    local total_time=$(( $(date +%s) - START_TIME ))
    
    cat << EOF

${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}
${BLUE}║              BLUX10K INSTALLATION COMPLETE v4.0.0             ║${NC}
${BLUE}║                ${EMOJI_SPARKLES} Professional Terminal Environment Ready ${EMOJI_SPARKLES}            ║${NC}
${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}

${GREEN}✅ Installation successfully completed in ${total_time} seconds${NC}
${CYAN}📊 System Profile:${NC}
  • Platform: ${OS_NAME} ${OS_VERSION:-} (${ARCH})
  • Resources: ${CPU_CORES} cores, ${RAM_GB}GB RAM
  • Prompt: ${SELECTED_PROMPT}
  • Plugins: ${PLUGIN_MODE}
  • Updates: ${UPDATE_MODE}

${CYAN}🚀 Next Steps:${NC}
  1. ${WHITE}Restart your terminal or run: ${GREEN}exec zsh${NC}
  2. ${WHITE}Configure your prompt: ${GREEN}$([[ "$SELECTED_PROMPT" == "powerlevel10k" ]] && echo "p10k configure" || echo "edit ~/.config/starship.toml")${NC}
  3. ${WHITE}Set your terminal font to 'MesloLGS NF'${NC}
  4. ${WHITE}Edit private configuration: ${GREEN}nvim ~/.config/private/env.zsh${NC}
  5. ${WHITE}Run health check: ${GREEN}${BLUX10K_CONFIG_DIR}/scripts/health-check.sh${NC}

${CYAN}🛠️  Available Commands:${NC}
  • ${GREEN}b10k --help${NC}           - Show BLUX10K command reference
  • ${GREEN}zsh-health${NC}            - ZSH diagnostics and performance
  • ${GREEN}update${NC}                - System update utility
  • ${GREEN}blux10k_validate_env${NC}  - Security audit

${CYAN}🔗 Useful Links:${NC}
  • Repository: ${BLUE}${BLUX10K_REPO}${NC}
  • Documentation: ${BLUE}${BLUX10K_DOCS}${NC}
  • Issues: ${BLUE}${BLUX10K_REPO}/issues${NC}

${YELLOW}⚠️  Important Security Notes:${NC}
  • Private configuration at ~/.config/private/env.zsh
  • Set permissions: ${GREEN}chmod 600 ~/.config/private/env.zsh${NC}
  • Never commit private configuration to version control
  • Regular updates: ${GREEN}${BLUX10K_CONFIG_DIR}/scripts/update.sh${NC}

${GREEN}${EMOJI_ROCKET} BLUX10K v4.0.0 is ready for professional development!${NC}
${GRAY}Installation log: ${BLUX10K_INSTALL_LOG}${NC}

EOF
}

# ===========================================================================
# MAIN INSTALLATION FLOW
# ===========================================================================

main() {
    START_TIME=$(date +%s)
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Show interactive menu if not in silent mode
    if [[ "${BLUX10K_SILENT_INSTALL:-0}" -ne 1 ]]; then
        show_interactive_menu
    else
        # Set defaults for silent mode
        SELECTED_PROMPT="${BLUX10K_PROMPT:-powerlevel10k}"
        PLUGIN_MODE="${BLUX10K_PLUGIN_MODE:-complete}"
        UPDATE_MODE="${BLUX10K_UPDATE_MODE:-full}"
    fi
    
    # Initialize
    init_logging
    print_banner
    
    # Installation steps
    detect_platform
    check_permissions || exit 1
    install_package_manager
    check_dependencies || exit 1
    install_core_packages
    install_modern_tools
    install_zinit
    install_zsh_plugins_via_zinit
    install_prompt_system
    install_fonts
    deploy_configurations
    post_install_setup
    finalize_installation
    
    exit 0
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --verbose|-v)
                BLUX10K_VERBOSE=1
                ;;
            --debug|-d)
                BLUX10K_DEBUG=1
                ;;
            --silent|-s)
                BLUX10K_SILENT_INSTALL=1
                ;;
            --minimal|-m)
                BLUX10K_MINIMAL=1
                ;;
            --skip-fonts)
                BLUX10K_SKIP_FONTS=1
                ;;
            --force-root)
                BLUX10K_FORCE_ROOT=1
                ;;
            --profile-only)
                detect_platform
                show_platform_profile
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

show_help() {
    cat << 'EOF'
BLUX10K Enhanced Installer v4.0.0

Usage: ./install.sh [OPTIONS]

Options:
  -h, --help          Show this help message
  -v, --verbose       Enable verbose output
  -d, --debug         Enable debug mode
  -s, --silent        Silent installation (minimal output)
  -m, --minimal       Minimal installation (core components only)
  --skip-fonts        Skip font installation
  --force-root        Allow installation as root (not recommended)
  --profile-only      Show platform profile and exit

Environment Variables:
  BLUX10K_VERBOSE=1        Enable verbose output
  BLUX10K_DEBUG=1          Enable debug mode
  BLUX10K_SILENT_INSTALL=1 Silent installation
  BLUX10K_MINIMAL=1        Minimal installation
  BLUX10K_SKIP_FONTS=1     Skip font installation
  BLUX10K_PROMPT=          Set prompt (powerlevel10k/starship)
  BLUX10K_PLUGIN_MODE=     Set plugin mode (complete/essential/minimal/custom)
  BLUX10K_UPDATE_MODE=     Set update mode (full/plugins/none)

Examples:
  ./install.sh                    # Interactive installation
  ./install.sh --verbose          # Verbose installation
  ./install.sh --minimal          # Minimal installation
  BLUX10K_DEBUG=1 ./install.sh    # Debug mode installation

Supported Platforms:
  • Linux (Debian, Ubuntu, Arch, Fedora, Alpine, etc.)
  • macOS (Intel & Apple Silicon)
  • Windows (Native & WSL)
  • BSD (FreeBSD, OpenBSD)
  • Termux (Android)
  • Cloud Shells (GCP, GitHub Codespaces, Gitpod, AWS)

EOF
}

show_platform_profile() {
    detect_platform
    cat << EOF
BLUX10K Platform Profile
════════════════════════════════════════════════════════════════
Operating System: ${OS_NAME} ${OS_VERSION:-}
Platform Type:    ${OS_TYPE}
Architecture:     ${ARCH}
Package Manager:  ${PACKAGE_MANAGER}
CPU Cores:        ${CPU_CORES}
RAM:              ${RAM_GB}GB

Environment:
  WSL:            ${IS_WSL:-false} ${WSL_VERSION:-}
  Container:      ${IS_CONTAINER:-false}
  Cloud:          ${IS_CLOUD:-false}
  Termux:         ${IS_TERMUX:-false}

════════════════════════════════════════════════════════════════
EOF
}

# Error handling
trap 'log_error "Installation failed at line $LINENO"; exit 1' ERR

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
FILE: configs/b10k.neofetch.conf
Kind: text
Size: 24909
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env bash
# BLUX10K Neofetch Configuration v4.0.0
# Repository: https://github.com/Justadudeinspace/blux10k
#
# Usage:
#   - Run: neofetch --config /path/to/blux10k/configs/b10k.neofetch.conf
#   - Or copy to: ~/.config/neofetch/config.conf

# ============================================================================
# BLUX10K CONFIGURATION - PERFORMANCE OPTIMIZED
# ============================================================================

##--------- BLUX10K Color Scheme (Enhanced)
# Colors: 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white, 8=grey
colors=(4 6 2 3 1 5 7)

##--------- Display Configuration
# Hide/Show Fully qualified domain name.
title_fqdn="off"

# Display mode
display_mode="ascii"

# Image backend (ascii for performance, kitty/wezterm for graphics)
image_backend="ascii"

# Gap between image and text
gap=3

##--------- Performance Settings
# Enable/disable slow features
blux10k_performance_mode="auto"  # auto, on, off
blux10k_async_loading="on"
blux10k_cache_enabled="on"
blux10k_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k/neofetch"

##--------- BLUX10K Custom Functions (Enhanced)

# BLUX10K Version Information
blux10k_version_info() {
    echo "v4.0.0"
}

# Plugin Manager Detection
detect_plugin_manager() {
    if command -v zinit >/dev/null 2>&1 && [[ -d ~/.local/share/zinit ]]; then
        echo "Zinit ($(zinit list 2>/dev/null | wc -l) plugins)"
    elif command -v zplug >/dev/null 2>&1 && [[ -d ~/.zplug ]]; then
        echo "Zplug ($(zplug list --installed 2>/dev/null | wc -l) plugins)"
    elif [[ -d ~/.zgenom ]]; then
        echo "Zgenom"
    elif [[ -d ~/.zplugin ]]; then
        echo "Zplugin"
    else
        echo "None"
    fi
}

# ZSH Performance Metrics
zsh_performance_metrics() {
    local metrics=()
    
    # Startup time if available
    if [[ -n "$_total_startup_time" ]]; then
        metrics+=("${_total_startup_time}ms startup")
    fi
    
    # History size
    if command -v fc >/dev/null 2>&1; then
        local hist_size=$(fc -l 1 | wc -l 2>/dev/null || echo "0")
        metrics+=("$hist_size history")
    fi
    
    # PATH optimization
    if [[ -n "$path" ]]; then
        metrics+=("${#path[@]} PATH dirs")
    fi
    
    echo "${metrics[*]}"
}

# Development Tools Status (Enhanced)
dev_tools_status() {
    local tools_status=()
    
    # Python
    if command -v python3 >/dev/null 2>&1; then
        local py_version=$(python3 --version 2>/dev/null | cut -d' ' -f2)
        tools_status+=("🐍 $py_version")
    fi
    
    # Node.js
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version 2>/dev/null | sed 's/v//')
        tools_status+=("⬢ $node_version")
    fi
    
    # Rust
    if command -v rustc >/dev/null 2>&1; then
        local rust_version=$(rustc --version 2>/dev/null | cut -d' ' -f2)
        tools_status+=("🦀 $rust_version")
    fi
    
    # Go
    if command -v go >/dev/null 2>&1; then
        local go_version=$(go version 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i ~ /^go[0-9]/) {sub(/^go/, "", $i); print $i; exit}}')
        tools_status+=("🐹 $go_version")
    fi
    
    # Docker
    if command -v docker >/dev/null 2>&1; then
        tools_status+=("🐳")
    fi
    
    # Kubernetes
    if command -v kubectl >/dev/null 2>&1; then
        tools_status+=("⎈")
    fi
    
    echo "${tools_status[*]}"
}

# Terminal Enhancements Status
terminal_enhancements_status() {
    local enhancements=()
    
    # FZF
    command -v fzf >/dev/null 2>&1 && enhancements+=("FZF")
    
    # Zoxide
    command -v zoxide >/dev/null 2>&1 && enhancements+=("Zoxide")
    
    # Bat
    command -v bat >/dev/null 2>&1 && enhancements+=("Bat")
    
    # Eza
    command -v eza >/dev/null 2>&1 && enhancements+=("Eza")
    
    # Modern tools
    command -v rg >/dev/null 2>&1 && enhancements+=("Ripgrep")
    command -v fd >/dev/null 2>&1 && enhancements+=("FD")
    
    if [[ ${#enhancements[@]} -gt 0 ]]; then
        echo "${enhancements[*]}"
    else
        echo "Basic"
    fi
}

# System Readiness Check (Enhanced)
blux10k_ready_check() {
    local issues=0
    local warnings=0
    local messages=()
    
    # Critical checks
    if ! command -v zsh >/dev/null 2>&1; then
        messages+=("❌ ZSH not installed")
        ((issues++))
    fi
    
    if ! command -v git >/dev/null 2>&1; then
        messages+=("❌ Git not installed")
        ((issues++))
    fi
    
    # Warning checks
    if ! command -v nvim >/dev/null 2>&1; then
        messages+=("⚠️  NeoVim not found")
        ((warnings++))
    fi
    
    if [[ ! -d "$HOME/.local/share/zinit" ]] && [[ ! -d "$HOME/.zplug" ]]; then
        messages+=("⚠️  Plugin manager not installed")
        ((warnings++))
    fi
    
    if [[ ! -f "$HOME/.p10k.zsh" ]]; then
        messages+=("⚠️  Powerlevel10k not configured")
        ((warnings++))
    fi
    
    # Performance checks
    if [[ ${#path[@]} -gt 50 ]]; then
        messages+=("⚠️  Large PATH (${#path[@]} entries)")
        ((warnings++))
    fi
    
    if [[ $issues -eq 0 && $warnings -eq 0 ]]; then
        echo "✅ System Ready"
    elif [[ $issues -eq 0 && $warnings -gt 0 ]]; then
        echo "⚠️  $warnings warning(s)"
    else
        echo "❌ $issues issue(s), $warnings warning(s)"
    fi
}

# Package Manager Detection
package_manager_info() {
    local pkg_count="N/A"
    
    if command -v apt >/dev/null 2>&1; then
        pkg_count=$(dpkg-query -f '${binary:Package}\n' -W 2>/dev/null | wc -l)
        echo "APT ($pkg_count)"
    elif command -v pacman >/dev/null 2>&1; then
        pkg_count=$(pacman -Qq 2>/dev/null | wc -l)
        echo "Pacman ($pkg_count)"
    elif command -v dnf >/dev/null 2>&1; then
        pkg_count=$(rpm -qa 2>/dev/null | wc -l)
        echo "DNF ($pkg_count)"
    elif command -v brew >/dev/null 2>&1; then
        pkg_count=$(brew list 2>/dev/null | wc -l)
        echo "Homebrew ($pkg_count)"
    else
        echo "Unknown"
    fi
}

# Shell Information (Enhanced)
shell_info() {
    local shell_name="${SHELL##*/}"
    local shell_version
    
    case "$shell_name" in
        zsh)
            shell_version=$(zsh --version | cut -d' ' -f2)
            ;;
        bash)
            shell_version=$(bash --version | head -n1 | cut -d' ' -f4)
            ;;
        fish)
            shell_version=$(fish --version | cut -d' ' -f3)
            ;;
        *)
            shell_version="Unknown"
            ;;
    esac
    
    echo "$shell_name $shell_version"
}

# ============================================================================
# CUSTOM PRINT INFO FUNCTION (Enhanced for BLUX10K v4.0.0)
# ============================================================================

print_info() {
    # Performance optimization: Cache expensive operations
    local cache_file="${blux10k_cache_dir}/system_info.cache"
    local cache_age=300  # 5 minutes
    
    if [[ "$blux10k_cache_enabled" == "on" ]] && \
       [[ -f "$cache_file" ]] && \
       [[ $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0))) -lt $cache_age ]]; then
        # Use cached version for fast display
        cat "$cache_file"
        return 0
    fi
    
    # Create cache directory
    mkdir -p "$(dirname "$cache_file")"
    
    {
        # BLUX10K Header with version
        prin "$(color 4)╔════════════════════════════════════════════════════════════════╗"
        info "$(color 6)🅑  BLUX10K" "$(blux10k_version_info)"
        prin "$(color 4)╚════════════════════════════════════════════════════════════════╝"
        
        # BLUX10K Accent Line (Dynamic based on system status)
        local accent_colors=(4 6 2 3 1 5 7)
        local accent_line=""
        for color in "${accent_colors[@]}"; do
            accent_line+="$(color $color)▬"
        done
        prin "$accent_line"
        
        # ========================= SYSTEM INFORMATION =========================
        prin "$(color 4)┌─────────────────── $(color 6)SYSTEM INFORMATION$(color 4) ──────────────────┐"
        
        # Operating System
        info "$(color 4)🖥  OS" os
        info "$(color 4)│ ├$(color 6) " distro
        info "$(color 4)│ ├$(color 2) " kernel
        info "$(color 4)│ ├$(color 3) " "$(package_manager_info)"
        info "$(color 4)│ └$(color 1) " "$(shell_info)"
        
        prin "$(color 4)│"
        
        # Desktop Environment
        info "$(color 6)🖼  DE/WM" wm
        info "$(color 6)│ ├$(color 2) " theme
        info "$(color 6)│ ├$(color 3) " icons
        info "$(color 6)│ └$(color 1) " term
        
        prin "$(color 4)│"
        
        # Hardware Information
        info "$(color 2)💻 Hardware" model
        info "$(color 2)│ ├$(color 6) " cpu
        info "$(color 2)│ ├$(color 3) " gpu
        info "$(color 2)│ ├$(color 1) " memory
        info "$(color 2)│ ├$(color 4) " uptime
        info "$(color 2)│ └$(color 5) " resolution
        
        prin "$(color 4)└─────────────────── $(color 6)SYSTEM STATUS$(color 4) ──────────────────────┘"
        
        # ========================= BLUX10K ENVIRONMENT =========================
        prin "$(color 4)┌─────────────────── $(color 6)BLUX10K ENVIRONMENT$(color 4) ────────────────┐"
        
        # BLUX10K Core Information
        info "$(color 6)🅑  BLUX10K" "$(blux10k_ready_check)"
        info "$(color 6)│ ├$(color 2)📦 " "$(detect_plugin_manager)"
        info "$(color 6)│ ├$(color 3)⚡ " "$(zsh_performance_metrics)"
        info "$(color 6)│ ├$(color 1)📚 " "echo '$(fc -l 1 | wc -l 2>/dev/null || echo 0) history'"
        info "$(color 6)│ └$(color 4)🔧 " "echo '${#path[@]} PATH dirs'"
        
        prin "$(color 4)│"
        
        # Development Tools
        info "$(color 2)🛠  Development" "echo '$(dev_tools_status)'"
        info "$(color 2)│ ├$(color 6)🐙 " "command -v git >/dev/null && git --version 2>/dev/null | cut -d' ' -f3 || echo 'Not found'"
        info "$(color 2)│ ├$(color 3) " "command -v nvim >/dev/null && nvim --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'Not found'"
        info "$(color 2)│ ├$(color 1) " "command -v curl >/dev/null && curl --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'Not found'"
        info "$(color 2)│ └$(color 4) " "command -v wget >/dev/null && wget --version 2>/dev/null | head -n1 | cut -d' ' -f3 || echo 'Not found'"
        
        prin "$(color 4)│"
        
        # Terminal Enhancements
        info "$(color 3)🔧  Terminal" "echo '$(terminal_enhancements_status)'"
        info "$(color 3)│ ├$(color 6)🎨 " "echo '${TERM:-Unknown}'"
        info "$(color 3)│ ├$(color 2)📁 " "pwd | sed \"s|$HOME|~|\""
        info "$(color 3)│ ├$(color 1)🕒 " "date '+%H:%M:%S %Z'"
        info "$(color 3)│ └$(color 4)🌐 " "curl -s --connect-timeout 2 https://api.ipify.org || echo 'Offline'"
        
        prin "$(color 4)└─────────────────── $(color 6)PERFORMANCE$(color 4) ────────────────────────┘"
        
        # ========================= PERFORMANCE METRICS =========================
        prin "$(color 4)┌─────────────────── $(color 6)PERFORMANCE METRICS$(color 4) ────────────────┐"
        
        # System Load
        local load_avg=$(uptime | awk -F'load average:' '{print $2}')
        info "$(color 6)📊  Load Avg" "echo '$load_avg'"
        
        # Disk Usage
        if command -v df >/dev/null 2>&1; then
            local disk_info=$(df -h / | awk 'NR==2 {print $4 "/" $2 " (" $5 ")"}')
            info "$(color 2)💾  Disk (/) " "echo '$disk_info'"
        fi
        
        # Temperature (if available)
        if [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
            local temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
            info "$(color 3)🌡  CPU Temp" "echo '${temp}°C'"
        elif command -v sensors >/dev/null 2>&1; then
            local temp=$(sensors | awk '/Package id 0:/ {match($0, /[0-9.]+/); if (RSTART) {print substr($0, RSTART, RLENGTH); exit}}')
            info "$(color 3)🌡  CPU Temp" "echo '${temp}°C'"
        fi
        
        # Battery (if available)
        if [[ -d /sys/class/power_supply/BAT* ]] || [[ "$(uname)" == "Darwin" ]]; then
            if command -v acpi >/dev/null 2>&1; then
                local battery=$(acpi -b | grep -Eo '[0-9]+%' | head -1)
                info "$(color 1)🔋  Battery" "echo '$battery'"
            elif [[ "$(uname)" == "Darwin" ]]; then
                local battery=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1)
                info "$(color 1)🔋  Battery" "echo '$battery'"
            fi
        fi
        
        # Network Status
        if command -v ip >/dev/null 2>&1; then
            local network_ip=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
            info "$(color 4)🌐  Local IP" "echo '${network_ip:-Disconnected}'"
        fi
        
        prin "$(color 4)└─────────────────── $(color 6)SYSTEM READY$(color 4) ──────────────────────┘"
        
        # BLUX10K Footer
        echo
        prin "$accent_line"
        
        # BLUX10K Motto and Help
        prin "$(color 6)           BLUX10K v4.0.0: Enhanced Terminal Environment"
        prin "$(color 2)           Performance Optimized | Security Hardened | Developer Ready"
        prin "$(color 4)           Run 'b10k --help' for available commands | 'neofetch --help' for options"
        
        # Quick Stats Summary
        echo
        local stats=()
        [[ -n "$load_avg" ]] && stats+=("Load: $load_avg")
        [[ -n "$disk_info" ]] && stats+=("Disk: $(echo "$disk_info" | awk '{print $1}') free")
        [[ -n "$battery" ]] && stats+=("Battery: $battery")
        
        if [[ ${#stats[@]} -gt 0 ]]; then
            prin "$(color 3)📈 Quick Stats: $(IFS=' | '; echo "${stats[*]}")"
        fi
        
    } | tee "$cache_file" 2>/dev/null
    
    return 0
}

# ============================================================================
# PERFORMANCE OPTIMIZATION SETTINGS
# ============================================================================

##--------- Kernel Configuration
# Shorten the output of the kernel function.
kernel_shorthand="on"

##--------- Distro Configuration
# Shorten the output of the distro function
distro_shorthand="off"

# Show/Hide OS Architecture.
os_arch="on"

##--------- Uptime Configuration
# Shorten the output of the uptime function
uptime_shorthand="on"

##--------- Memory Configuration
# Show memory percentage in output.
memory_percent="off"

# Change memory output unit.
memory_unit="mib"

##--------- Packages Configuration
# Show/Hide Package Manager names.
package_managers="on"

##--------- Shell Configuration
# Show the path to $SHELL
shell_path="off"

# Show $SHELL version
shell_version="on"

##--------- CPU Configuration
# CPU speed type
speed_type="bios_limit"

# CPU speed shorthand
speed_shorthand="on"

# Enable/Disable CPU brand in output.
cpu_brand="on"

# CPU Speed - Hide/Show CPU speed.
cpu_speed="on"

# CPU Cores - Display CPU cores in output
cpu_cores="logical"

# CPU Temperature - Hide/Show CPU temperature.
cpu_temp="auto"

##--------- GPU Configuration
# Enable/Disable GPU Brand
gpu_brand="on"

# Which GPU to display
gpu_type="all"

##--------- Resolution Configuration
# Display refresh rate next to each monitor
refresh_rate="off"

##--------- Gtk Theme / Icons / Font Configuration
# Shorten output of GTK Theme / Icons / Font
gtk_shorthand="on"

# Enable/Disable gtk2 Theme / Icons / Font
gtk2="on"

# Enable/Disable gtk3 Theme / Icons / Font
gtk3="on"

##--------- IP Address Configuration
# Website to ping for the public IP
public_ip_host="http://ident.me"

# Public IP timeout.
public_ip_timeout=2

# Desktop Environment version
de_version="on"

##--------- Disk Configuration
# Which disks to display.
disk_show=('/')

# Disk subtitle.
disk_subtitle="mount"

# Disk percent.
disk_percent="on"

##--------- Text Options
# Toggle bold text
bold="on"

# Enable/Disable Underline
underline_enabled="on"

# Underline character
underline_char="─"

# Info Separator
separator="→"

##--------- Color Blocks
# Color block range
block_range=(0 15)

# Toggle color blocks
color_blocks="off"  # Disabled for cleaner look

# Color block width in spaces
block_width=3

# Color block height in lines
block_height=1

# Color Alignment
col_offset="auto"

##--------- Progress Bars
# Bar characters
bar_char_elapsed="─"
bar_char_total="═"

# Toggle Bar border
bar_border="on"

# Progress bar length in spaces
bar_length=15

# Progress bar colors
bar_color_elapsed="4"  # Blue
bar_color_total="6"    # Cyan

# Info display
cpu_display="off"
memory_display="off"
battery_display="off"
disk_display="off"

##--------- Ascii Options
# Ascii distro
ascii_distro="auto"

# Ascii Colors - BLUX10K color scheme
ascii_colors=(4 6 2 3 1 5 7)

# Bold ascii logo
ascii_bold="on"

# Custom BLUX10K ASCII art
ascii_art_blux10k() {
    cat << 'EOF'
    
    ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
    ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
    ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀
    
EOF
}

# Use BLUX10K ASCII art when ascii_distro is set to blux10k
if [[ "$ascii_distro" == "blux10k" ]]; then
    ascii_art="ascii_art_blux10k"
fi

##--------- Image Options
# Image loop
image_loop="off"

# Thumbnail directory
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"

# Crop mode
crop_mode="normal"

# Crop offset
crop_offset="center"

# Image size
image_size="auto"

# Image offsets
yoffset=0
xoffset=0

# Image background color
background_color=""

##--------- Misc Options
# Stdout mode
stdout="off"

# Suppress function output
suppress_small="on"

# ============================================================================
# BLUX10K SPECIFIC SETTINGS
# ============================================================================

# Enable BLUX10K custom modules
blux10k_custom_info="on"

# Show development tools status
blux10k_show_dev_tools="on"

# Show terminal enhancements status
blux10k_show_terminal_enhancements="on"

# BLUX10K performance mode (reduces output for faster display)
blux10k_performance_mode="auto"

# BLUX10K Help Integration
blux10k_show_help_hint="on"

# ============================================================================
# HELPER FUNCTIONS FOR BLUX10K INTEGRATION
# ============================================================================

# Function to display BLUX10K neofetch help
blux10k_neofetch_help() {
    echo ""
    echo "$(color 4)╔════════════════════════════════════════════════════════════════╗"
    echo "$(color 4)║                   BLUX10K NEOFETCH v4.0.0                      ║"
    echo "$(color 4)║               Enhanced System Information                      ║"
    echo "$(color 4)╚════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "$(color 6)Usage:"
    echo "  neofetch                          - Display system info with BLUX10K style"
    echo "  neofetch --config ~/.config/neofetch/b10k.neofetch.conf"
    echo "  neofetch --help                   - Show neofetch options"
    echo "  neofetch --blux10k-help           - Show BLUX10K specific help"
    echo ""
    echo "$(color 2)Features:"
    echo "  • Performance optimized display"
    echo "  • Context-aware information"
    echo "  • Development tools status"
    echo "  • Terminal environment details"
    echo "  • Custom BLUX10K color scheme"
    echo "  • System readiness check"
    echo "  • Caching for faster display"
    echo ""
    echo "$(color 3)Performance Options:"
    echo "  --perf-mode [auto|on|off]         - Control performance optimizations"
    echo "  --no-cache                        - Disable caching"
    echo "  --simple                          - Minimal output"
    echo ""
    echo "$(color 1)Display Options:"
    echo "  --ascii                           - Force ASCII art display"
    echo "  --blux10k-ascii                   - Show BLUX10K ASCII art"
    echo "  --compact                         - Compact layout"
    echo ""
    echo "$(color 5)Information Sections:"
    echo "  --show-all                        - Show all information"
    echo "  --hide-dev-tools                  - Hide development tools"
    echo "  --hide-term-enhance               - Hide terminal enhancements"
    echo "  --show-performance                - Show performance metrics"
    echo ""
    echo "$(color 4)Related Commands:"
    echo "  b10k --help                       - Show all BLUX10K commands"
    echo "  fastfetch                         - Faster alternative"
    echo "  p10k-show-config                  - Show Powerlevel10k config"
    echo "  zsh-health                        - ZSH diagnostics"
    echo ""
}

# Function to handle BLUX10K specific arguments
handle_blux10k_args() {
    case "$1" in
        --blux10k-help)
            blux10k_neofetch_help
            exit 0
            ;;
        --perf-mode)
            blux10k_performance_mode="$2"
            shift
            ;;
        --no-cache)
            blux10k_cache_enabled="off"
            ;;
        --simple)
            blux10k_performance_mode="on"
            color_blocks="off"
            ;;
        --blux10k-ascii)
            ascii_distro="blux10k"
            ;;
        --compact)
            gap=1
            blux10k_performance_mode="on"
            ;;
        --show-all)
            blux10k_performance_mode="off"
            ;;
        --hide-dev-tools)
            blux10k_show_dev_tools="off"
            ;;
        --hide-term-enhance)
            blux10k_show_terminal_enhancements="off"
            ;;
        --show-performance)
            # Already shown by default
            ;;
    esac
}

# Apply performance mode settings
apply_performance_mode() {
    case "$blux10k_performance_mode" in
        on)
            # Minimal output
            blux10k_show_dev_tools="off"
            blux10k_show_terminal_enhancements="off"
            color_blocks="off"
            gap=1
            ;;
        off)
            # Full output
            blux10k_show_dev_tools="on"
            blux10k_show_terminal_enhancements="on"
            color_blocks="on"
            gap=3
            ;;
        auto)
            # Auto-detect based on terminal size
            if [[ -t 1 ]] && (( COLUMNS < 100 )); then
                blux10k_performance_mode="on"
                apply_performance_mode
            fi
            ;;
    esac
}

# ============================================================================
# INITIALIZATION
# ============================================================================

# Create cache directory
mkdir -p "${blux10k_cache_dir}"

# Apply performance mode
apply_performance_mode

# Check for BLUX10K integration
if [[ -n "$BLUX10K_VERSION" ]] || [[ -f "$HOME/.config/blux10k/version" ]]; then
    # BLUX10K environment detected
    :
else
    echo "Note: BLUX10K environment not fully detected. Some features may be limited."
fi

# Load custom configurations
if [[ -f "$HOME/.config/neofetch/b10k.local.conf" ]]; then
    source "$HOME/.config/neofetch/b10k.local.conf"
fi

# Final message (only in verbose mode)
if [[ "$blux10k_performance_mode" != "on" ]]; then
    echo "BLUX10K Neofetch v4.0.0 loaded" >&2
fi
FILE: configs/env.zsh.example
Kind: text
Size: 901
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env zsh
# BLUX10K private environment template
#
# Usage:
#   1) Copy this file to: ~/.config/private/env.zsh
#   2) Set permissions: chmod 600 ~/.config/private/env.zsh
#   3) Edit values for your environment
#
# This file is sourced by the BLUX10K entrypoint if it exists.
# Do NOT commit your real secrets to version control.

# ---- BLUX10K behavior ----
export BLUX10K_ENV="development"   # development | staging | production
export BLUX10K_DEBUG="0"            # 1 to enable extra logging (installer uses BLUX10K_DEBUG)
export BLUX10K_PERF_MODE="auto"     # auto | on | off (documented, optional)
export BLUX10K_SECURITY_MODE="strict"

# ---- Example service tokens (keep commented until needed) ----
# export GITHUB_TOKEN="ghp_xxx"
# export GITHUB_USER="your-username"
# export GITHUB_EMAIL="you@example.com"

# export OPENAI_API_KEY="sk-xxx"
# export ANTHROPIC_API_KEY="sk-ant-xxx"
FILE: configs/starship.toml
Kind: text
Size: 23544
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# BLUX10K Starship Configuration v4.0.0
# Repository: https://github.com/Justadudeinspace/blux10k
#
# Usage:
#   - Copy or symlink this file to: ~/.config/starship.toml
#   - Enable Starship in your shell (e.g., `eval "$(starship init zsh)"`)
#   - Re-run the installer with --prompt=starship to make BLUX10K load Starship.

# ===========================================================================
# PERFORMANCE & SECURITY SETTINGS
# ===========================================================================

# Performance optimization
scan_timeout = 30  # Reduced from default 30s
command_timeout = 500  # ms
min_time = 2_000  # Show duration for commands >2s

# Security settings
show_traceback = false  # Don't show tracebacks in production
allow_unsafe_commands = false  # Only allow safe commands

# Debug mode (BLUX10K integration)
[env_var]
BLUX10K_DEBUG = false  # Set to true for debugging

# ===========================================================================
# GLOBAL FORMAT CONFIGURATION - BLUX10K ENHANCED
# ===========================================================================

# Main prompt format with BLUX10K styling
format = """
[░▒▓](#3B4252)\
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$git_state\
$git_metrics\
$nix_shell\
$conda\
$python\
$nodejs\
$rust\
$golang\
$php\
$java\
$lua\
$docker_context\
$kubernetes\
$aws\
$gcloud\
$azure\
$openstack\
$terraform\
$pulumi\
$cmake\
$package\
$memory_usage\
$sudo\
$env_var\
$cmd_duration\
$line_break\
$custom.blux10k\
$custom.k8s_context\
$custom.docker_status\
$custom.system_info\
$custom.terminal_info\
$custom.uptime\
$custom.git_enhanced\
$custom.path_info\
$custom.cpu_load\
$custom.disk_usage\
$custom.network_status\
$jobs\
$battery\
$time\
[░▒▓](#3B4252)\
$character"""

# Right prompt format (experimental - performance optimized)
right_format = """
$custom.performance\
$custom.security\
$custom.resource_monitor\
$cmd_duration\
$jobs\
$battery\
$time"""

# Add blank space before prompt
add_newline = true

# ===========================================================================
# PERFORMANCE OPTIMIZED MODULES
# ===========================================================================

# Disable rarely used modules for performance
[package]
disabled = true

[buf]
disabled = true

[crystal]
disabled = true

[dart]
disabled = true

[deno]
disabled = true

[dotnet]
disabled = true

[elixir]
disabled = true

[elm]
disabled = true

[erlang]
disabled = true

[haskell]
disabled = true

[haxe]
disabled = true

[julia]
disabled = true

[kotlin]
disabled = true

[nim]
disabled = true

[ocaml]
disabled = true

[perl]
disabled = true

[purescript]
disabled = true

[rlang]
disabled = true

[red]
disabled = true

[scala]
disabled = true

[swift]
disabled = true

[vagrant]
disabled = true

[zig]
disabled = true

# ===========================================================================
# CORE MODULES - BLUX10K ENHANCED
# ===========================================================================

# Username module with security indicators
[username]
format = '[$user]($style)'
show_always = false
style_user = 'bold blue'
style_root = 'bold red'
disabled = false

# Hostname module with SSH detection
[hostname]
ssh_only = true
format = '[@$hostname]($style) '
trim_at = '.'
style = 'bold yellow'
disabled = false

# Directory module with smart truncation
[directory]
format = '[ $path ]($style)'
truncation_length = 4
truncation_symbol = '…/'
home_symbol = '~'
read_only_style = 'bold red'
read_only = ' '
style = 'bold cyan'

[directory.substitutions]
'Documents' = ' '
'Downloads' = ' '
'Music' = ' '
'Pictures' = ' '
'Videos' = ' '
'Projects' = ' '
'Work' = '💼 '
'Git' = ' '
'Src' = ' '
'Source' = ' '
'.config' = ' '
'.local' = ' '
'.cache' = ' '
'.ssh' = '🔐 '
'.gnupg' = '🔑 '
'.docker' = '🐳 '
'.kube' = '⎈ '
'node_modules' = '📦 '
'venv' = '🐍 '
'.venv' = '🐍 '
'.git' = ' '

# Git Branch module
[git_branch]
format = '[ $symbol$branch ]($style)'
symbol = ' '
truncation_length = 30
truncation_symbol = '…'
style = 'bold purple'

# Git Status module
[git_status]
format = '([$all_status$ahead_behind]($style))'
conflicted = '🏳'
ahead = '⇡${count}'
behind = '⇣${count}'
diverged = '⇕'
untracked = '?${count}'
stashed = '📦'
modified = '!${count}'
staged = '+${count}'
renamed = '»${count}'
deleted = '✘${count}'
style = 'bold green'

# Git State module
[git_state]
format = '([$state( $progress_current/$progress_total)]($style))'
cherry_pick = '[🍒 PICKING](bold red)'
rebase = '[↩ REBASING](bold yellow)'
merge = '[🔄 MERGING](bold magenta)'
revert = '[↩ REVERTING](bold cyan)'

# Git Metrics module
[git_metrics]
added_style = 'bold green'
deleted_style = 'bold red'
disabled = false
only_nonzero_diffs = true

# ===========================================================================
# LANGUAGE & FRAMEWORK MODULES
# ===========================================================================

# Python module with virtualenv support
[python]
format = '[🐍 $version $virtualenv]($style)'
python_binary = ['python', 'python3', 'py']
symbol = 'Py '
style = 'bold yellow'
disabled = false

# Node.js module
[nodejs]
format = '[⬢ $version]($style)'
symbol = 'Node '
style = 'bold green'
disabled = false

# Rust module
[rust]
format = '[🦀 $version]($style)'
symbol = 'Rs '
style = 'bold red'
disabled = false

# Go module
[golang]
format = '[🐹 $version]($style)'
symbol = 'Go '
style = 'bold cyan'
disabled = false

# Java module
[java]
format = '[☕ $version]($style)'
symbol = 'Java '
style = 'bold magenta'
disabled = false

# PHP module
[php]
format = '[🐘 $version]($style)'
symbol = 'PHP '
style = 'bold blue'
disabled = false

# ===========================================================================
# CLOUD & INFRASTRUCTURE MODULES
# ===========================================================================

# AWS module with profile and region
[aws]
format = '[$symbol($profile)(\($region\))]($style)'
symbol = '☁️  '
style = 'bold yellow'
disabled = false

[aws.region_aliases]
ap-southeast-2 = 'au'
us-east-1 = 'va'
us-west-2 = 'or'
eu-west-1 = 'ie'
ap-northeast-1 = 'jp'

# Azure module
[azure]
format = '[$symbol($subscription)]($style)'
symbol = 'ﴃ '
style = 'blue'
disabled = false

# Google Cloud module
[gcloud]
format = '[$symbol$account(@$domain)(\($region\))]($style)'
symbol = ' '
style = 'bold blue'
disabled = false

# Kubernetes module
[kubernetes]
format = '[☸ $context \($namespace\)]($style)'
symbol = '⎈ '
style = 'bold cyan'
disabled = false

# Docker Context module
[docker_context]
format = '[🐳 $context]($style)'
symbol = ''
style = 'blue'
disabled = false

# Terraform module
[terraform]
format = '[💠 $workspace]($style)'
symbol = 'TF '
style = 'bold magenta'
disabled = false

# ===========================================================================
# SYSTEM & PERFORMANCE MODULES
# ===========================================================================

# Battery module
[battery]
full_symbol = '🔋'
charging_symbol = '⚡️'
discharging_symbol = '💀'
disabled = false
format = '[$symbol$percentage]($style)'
style = 'bold yellow'

[memory_usage]
format = '[$symbol($usage | $swap)]($style)'
threshold = 85
symbol = '🐏 '
style = 'bold white'
disabled = false

# Command Duration module
[cmd_duration]
format = '[$duration]($style)'
min_time = 2_000
show_milliseconds = false
style = 'yellow'
disabled = false

# Jobs module
[jobs]
symbol = '✦'
threshold = 1
format = '[$symbol$number]($style)'
style = 'bold green'
disabled = false

# Time module
[time]
format = '[$time]($style)'
disabled = false
time_format = '%H:%M:%S'
utc_time_offset = 'local'
time_range = '-'
style = 'bold dimmed'

# Character module (prompt symbol)
[character]
error_symbol = '[✗](bold red)'
success_symbol = '[➜](bold green)'
vicmd_symbol = '[V](bold yellow)'
format = '$symbol '
disabled = false

# ===========================================================================
# BLUX10K CUSTOM MODULES - ENHANCED
# ===========================================================================

# BLUX10K System Indicator
[custom.blux10k]
command = 'echo "BLUX10K v4.0.0"'
when = 'true'
format = '[🅑 $output]($style)'
style = 'bold blue'
description = 'BLUX10K System Indicator'
shell = ['bash', 'zsh', 'fish']
interval = 3600  # Update every hour

# Kubernetes Context (Enhanced)
[custom.k8s_context]
command = '''
  if command -v kubectl >/dev/null 2>&1; then
    context=$(kubectl config current-context 2>/dev/null)
    if [ -n "$context" ]; then
      namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
      if [ -n "$namespace" ] && [ "$namespace" != "default" ]; then
        # Color coding based on context name
        if [[ "$context" == *prod* ]] || [[ "$context" == *production* ]]; then
          echo "⎈ $context ($namespace)"
        elif [[ "$context" == *stag* ]] || [[ "$context" == *staging* ]]; then
          echo "🟡 $context ($namespace)"
        elif [[ "$context" == *dev* ]] || [[ "$context" == *development* ]]; then
          echo "🟢 $context ($namespace)"
        elif [[ "$context" == *minikube* ]] || [[ "$context" == *docker-desktop* ]]; then
          echo "🟣 $context ($namespace)"
        else
          echo "⎈ $context ($namespace)"
        fi
      else
        echo "⎈ $context"
      fi
    fi
  fi
'''
when = 'command -v kubectl >/dev/null 2>&1'
format = '[$output]($style)'
style = 'bold cyan'
description = 'Kubernetes Context'
shell = ['bash', 'zsh']
interval = 10  # Update every 10 seconds

# Docker Status (Enhanced)
[custom.docker_status]
command = '''
  if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
      containers=$(docker ps -q | wc -l)
      if [ "$containers" -gt 0 ]; then
        echo "🐳 Running ($containers containers)"
      else
        echo "🐳 Ready"
      fi
    else
      echo "🐳 Stopped"
    fi
  fi
'''
when = 'command -v docker >/dev/null 2>&1'
format = '[$output]($style)'
style = 'bold blue'
description = 'Docker Status'
shell = ['bash', 'zsh']
interval = 10

# System Info (Enhanced)
[custom.system_info]
command = '''
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "🍎 $(sw_vers -productVersion)"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ -n "$PRETTY_NAME" ]]; then
      echo "🐧 $PRETTY_NAME"
    else
      echo "🐧 $NAME"
    fi
  elif [[ "$(uname)" == "Linux" ]]; then
    if command -v lsb_release >/dev/null 2>&1; then
      echo "🐧 $(lsb_release -ds)"
    else
      echo "🐧 $(uname -o)"
    fi
  else
    echo "💻 $(uname -s)"
  fi
'''
when = 'true'
format = '[$output]($style)'
style = 'bold yellow'
description = 'Operating System'
shell = ['bash', 'zsh']
interval = 3600

# Terminal Info
[custom.terminal_info]
command = '''
  if [[ -n "$ITERM_SESSION_ID" ]]; then
    echo "iTerm2"
  elif [[ "$TERM_PROGRAM" == "vscode" ]]; then
    echo "VSCode"
  elif [[ -n "$KITTY_WINDOW_ID" ]]; then
    echo "Kitty"
  elif [[ -n "$ALACRITTY_WINDOW_ID" ]]; then
    echo "Alacritty"
  elif [[ "$TERM" == "tmux"* ]]; then
    echo "tmux"
  elif [[ -n "$TMUX" ]]; then
    echo "tmux"
  else
    echo "${TERM:-unknown}"
  fi
'''
when = 'true'
format = '[🖥 $output]($style)'
style = 'bold magenta'
description = 'Terminal Type'
shell = ['bash', 'zsh']
interval = 30

# System Uptime (Performance Optimized)
[custom.uptime]
command = '''
  if [[ "$(uname)" == "Darwin" ]]; then
    uptime | awk -F'( |,|:)+' '{
      if ($6=="min") printf "%s min", $5;
      else if ($7=="min") printf "%s min", $6;
      else if ($6~/^day/) printf "%s days", $5;
      else if ($7~/^day/) printf "%s days", $6;
      else if ($8=="sec") printf "%s sec", $7;
      else printf "%s:%s hrs", $6, $7
    }'
  else
    uptime -p | sed "s/up //; s/ days\?/d/; s/ hours\?/h/; s/ minutes\?/m/; s/^ *//"
  fi
'''
when = 'true'
format = '[⏱ $output]($style)'
style = 'bold green'
description = 'System Uptime'
shell = ['bash', 'zsh']
interval = 60

# Enhanced Git Information
[custom.git_enhanced]
command = '''
  if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
    changes=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$changes" -gt 0 ]; then
      echo "$branch ✎"
    else
      echo "$branch ✓"
    fi
  fi
'''
when = 'git rev-parse --git-dir > /dev/null 2>&1'
format = '[$output]($style)'
style = 'bold cyan'
description = 'Enhanced Git Status'
shell = ['bash', 'zsh']
interval = 5

# Path Information
[custom.path_info]
command = '''
  pwd | sed "s|^$HOME|~|" | awk -F/ '{
    if (NF <= 3) print $0;
    else print ".../" $(NF-1) "/" $(NF)
  }'
'''
when = 'true'
format = '[📁 $output]($style)'
style = 'bold blue'
description = 'Smart Path Display'
shell = ['bash', 'zsh']
interval = 1

# CPU Load
[custom.cpu_load]
command = '''
  if [[ "$(uname)" == "Darwin" ]]; then
    sysctl -n vm.loadavg | awk '{printf "%.2f %.2f %.2f", $2, $3, $4}'
  else
    awk '{printf "%.2f %.2f %.2f", $1, $2, $3}' /proc/loadavg
  fi
'''
when = 'true'
format = '[⚡ $output]($style)'
style = 'bold yellow'
description = 'CPU Load Average'
shell = ['bash', 'zsh']
interval = 10

# Disk Usage
[custom.disk_usage]
command = '''
  df -h / | awk "NR==2 {print \$4 \" free\"}"
'''
when = 'true'
format = '[💾 $output]($style)'
style = 'bold magenta'
description = 'Disk Usage'
shell = ['bash', 'zsh']
interval = 30

# Network Status
[custom.network_status]
command = '''
  if ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
    echo "🌐 Online"
  else
    echo "🌐 Offline"
  fi
'''
when = 'true'
format = '[$output]($style)'
style = 'bold green'
description = 'Network Status'
shell = ['bash', 'zsh']
interval = 30

# ===========================================================================
# PERFORMANCE MONITORING MODULES
# ===========================================================================

[custom.performance]
command = '''
  if [[ -n "$BLUX10K_DEBUG" ]]; then
    echo "⚡ $(($(date +%s%N) - ${BLUX10K_START_TIME:-0} | awk "{printf \"%.1fms\", \$1/1000000}"))"
  fi
'''
when = '[[ -n "$BLUX10K_DEBUG" ]]'
format = '[$output]($style)'
style = 'bold cyan'
description = 'Shell Performance'
shell = ['zsh', 'bash']
interval = 1

[custom.resource_monitor]
command = '''
  mem=$(free -m | awk "NR==2 {printf \"%.1fG\", \$3/1024}")
  load=$(awk "{printf \"%.2f\", \$1}" /proc/loadavg 2>/dev/null || echo "N/A")
  echo "$mem RAM • $load Load"
'''
when = '[[ -f /proc/loadavg ]]'
format = '[$output]($style)'
style = 'bold white'
description = 'Resource Monitor'
shell = ['bash', 'zsh']
interval = 10

# Security Status Module
[custom.security]
command = '''
  if [[ -n "$SSH_CONNECTION" ]]; then
    echo "🔐 SSH"
  elif [[ -n "$BLUX10K_SECURITY_MODE" ]]; then
    echo "🛡️ $BLUX10K_SECURITY_MODE"
  else
    echo "🔓 Standard"
  fi
'''
when = 'true'
format = '[$output]($style)'
style = 'bold yellow'
description = 'Security Status'
shell = ['bash', 'zsh']
interval = 30

# ===========================================================================
# BLUX10K INTEGRATION MODULES
# ===========================================================================

# BLUX10K Update Status
[custom.blux10k_update_status]
command = '''
  last_update=$(stat -c %Y ~/.cache/blux10k/last_update 2>/dev/null || echo 0)
  now=$(date +%s)
  days_since=$(( (now - last_update) / 86400 ))
  if [ $days_since -gt 7 ]; then
    echo "🔄 $days_since days"
  fi
'''
when = '[[ -f ~/.cache/blux10k/last_update ]]'
format = '[$output]($style)'
style = 'bold yellow'
description = 'BLUX10K Update Status'
shell = ['bash', 'zsh']
interval = 3600

# Plugin Manager Status
[custom.plugin_manager]
command = '''
  if [[ -d ~/.local/share/zinit ]]; then
    count=$(find ~/.local/share/zinit/plugins -maxdepth 2 -type d 2>/dev/null | wc -l)
    echo "Zinit ($((count/2)))"
  elif [[ -d ~/.zplug ]]; then
    count=$(zplug list --installed 2>/dev/null | wc -l)
    echo "Zplug ($count)"
  elif [[ -d ~/.zgenom ]]; then
    echo "Zgenom"
  else
    echo "No PM"
  fi
'''
when = 'true'
format = '[$output]($style)'
style = 'bold magenta'
description = 'Plugin Manager'
shell = ['zsh']
interval = 3600

# Shell Performance
[custom.shell_performance]
command = '''
  if [[ -n "$_total_startup_time" ]]; then
    echo "🚀 ${_total_startup_time}ms"
  fi
'''
when = '[[ -n "$_total_startup_time" ]]'
format = '[$output]($style)'
style = 'bold green'
description = 'Shell Startup Time'
shell = ['zsh']
interval = 3600

# ===========================================================================
# PALETTE & THEME - BLUX10K v4.0.0
# ===========================================================================

[palette]
# BLUX10K Nord-inspired color scheme
primary = "3B4252"    # Polar Night (dark blue-gray)
secondary = "434C5E"   # Polar Night (medium blue-gray)
accent = "4C566A"     # Polar Night (light blue-gray)
background = "2E3440"  # Polar Night (darkest)
foreground = "D8DEE9"  # Snow Storm (light gray)

# Status colors
success = "A3BE8C"    # Aurora (green)
warning = "EBCB8B"    # Aurora (yellow)
error = "BF616A"      # Aurora (red)
info = "81A1C1"       # Frost (blue)
highlight = "88C0D0"   # Frost (cyan)
muted = "616E88"      # Polar Night (muted gray)

# Language-specific colors
python = "FFD43B"     # Python yellow
nodejs = "339933"     # Node.js green
rust = "DEA584"       # Rust orange
golang = "00ADD8"     # Go cyan
java = "007396"       # Java blue
php = "777BB4"        # PHP purple

# Cloud colors
aws = "FF9900"        # AWS orange
azure = "0078D4"      # Azure blue
gcloud = "4285F4"     # Google blue
kubernetes = "326CE5" # Kubernetes blue

# ===========================================================================
# STYLES & FORMATTING
# ===========================================================================

# Global style configuration
[style]
# Default styles for modules
success = "bold green"
warning = "bold yellow"
error = "bold red"
info = "bold blue"
muted = "dimmed"

# Module-specific style overrides
[git_branch.style]
default = "bold purple"
detached = "bold red"

[git_status.style]
conflicted = "bold red"
ahead = "bold yellow"
behind = "bold yellow"
diverged = "bold red"
untracked = "bold green"
stashed = "bold cyan"
modified = "bold yellow"
staged = "bold green"
renamed = "bold magenta"
deleted = "bold red"

[directory.style]
default = "bold cyan"
read_only = "bold red"
home = "bold blue"

[username.style]
user = "bold blue"
root = "bold red"

[hostname.style]
default = "bold yellow"
ssh = "bold green"

# ===========================================================================
# ADVANCED CONFIGURATION
# ===========================================================================

# Conditional module loading
[conditional]
# Only show certain modules in specific directories
[conditional.docker_context]
condition = '[[ -f "Dockerfile" || -f "docker-compose.yml" || -d ".docker" ]]'
format = '[$symbol$context]($style)'

[conditional.kubernetes]
condition = '[[ -f "kustomization.yaml" || -f "*.yaml" =~ "apiVersion:" || -d "k8s" ]]'
format = '[$symbol$context \($namespace\)]($style)'

[conditional.python]
condition = '[[ -f "requirements.txt" || -f "pyproject.toml" || -f "setup.py" || -d "venv" || -d ".venv" ]]'
format = '[$symbol$version $virtualenv]($style)'

[conditional.nodejs]
condition = '[[ -f "package.json" || -f "yarn.lock" || -f "package-lock.json" ]]'
format = '[$symbol$version]($style)'

# Environment variable filters
[env_var.filters]
# Filter out sensitive environment variables
BLUX10K_SECRET = ".*"
API_KEY = ".*"
SECRET = ".*"
TOKEN = ".*"
PASSWORD = ".*"

# ===========================================================================
# BLUX10K PERFORMANCE PROFILES
# ===========================================================================

# Performance profile selection
[profiles]
# Minimal profile for slow systems
[profiles.minimal]
modules = [
  "username",
  "hostname",
  "directory",
  "git_branch",
  "git_status",
  "character"
]
disabled = [
  "memory_usage",
  "battery",
  "time",
  "custom"
]

# Standard profile (default)
[profiles.standard]
modules = [
  "username",
  "hostname",
  "directory",
  "git_branch",
  "git_status",
  "git_state",
  "python",
  "nodejs",
  "rust",
  "golang",
  "docker_context",
  "kubernetes",
  "cmd_duration",
  "jobs",
  "battery",
  "time",
  "custom.blux10k",
  "custom.k8s_context",
  "character"
]

# Full profile for debugging
[profiles.full]
modules = "*"  # All modules
scan_timeout = 60
command_timeout = 1000

# Apply profile based on system performance
if [[ $(nproc) -lt 4 ]] || [[ $(free -m | awk '/^Mem:/ {print $2}') -lt 4000 ]]; then
  profile = "minimal"
elif [[ -n "$BLUX10K_DEBUG" ]]; then
  profile = "full"
else
  profile = "standard"
fi

# ===========================================================================
# INTEGRATION WITH BLUX10K SYSTEM
# ===========================================================================

# BLUX10K environment integration
[integration.blux10k]
# Sync with BLUX10K configuration
config_path = "$HOME/.config/blux10k/starship.toml"
auto_sync = true
sync_interval = 300  # 5 minutes

# Shell integration
[integration.shell]
zsh = {
  precmd_hook = "true",
  preexec_hook = "true",
  prompt_char = "true"
}
bash = {
  precmd_hook = "true",
  preexec_hook = "true"
}
fish = {
  precmd_hook = "true",
  preexec_hook = "true"
}

# Terminal integration
[integration.terminal]
# Support for various terminals
hyper = true
iterm2 = true
alacritty = true
kitty = true
tmux = true

# ===========================================================================
# FINAL CONFIGURATION
# ===========================================================================

# Configuration validation
[validation]
check_command_timeout = true
check_unsafe_commands = true
validate_paths = true

# Error handling
[error]
log_file = "$HOME/.cache/starship/error.log"
max_log_size = "10MB"
log_level = "warn"

# Cache configuration
[cache]
enabled = true
directory = "$HOME/.cache/starship"
max_size = "100MB"
cleanup_interval = 3600

# ===========================================================================
# BLUX10K SPECIFIC COMMANDS
# ===========================================================================

# Command to switch profiles
[custom.profile_switch]
command = '''
  current_profile=$(starship explain --profile 2>/dev/null | grep "Profile:" | awk "{print \$2}" || echo "standard")
  if [[ "$current_profile" == "minimal" ]]; then
    echo "standard"
  elif [[ "$current_profile" == "standard" ]]; then
    echo "full"
  else
    echo "minimal"
  fi
'''
when = 'false'  # Disabled by default, enable with keybinding
format = '[$output]($style)'
style = 'bold cyan'
description = 'Switch Starship Profile'

# BLUX10K system health
[custom.blux10k_health]
command = 'echo "$(uptime -p | sed "s/up //") • $(free -h | awk "/^Mem:/ {print \$3}") used"'
when = '[[ -n "$BLUX10K_DEBUG" ]]'
format = '[🩺 $output]($style)'
style = 'bold green'
description = 'BLUX10K System Health'
shell = ['bash', 'zsh']
interval = 30

echo "🚀 BLUX10K Starship v4.0.0 Configuration Loaded"
echo "📊 Profile: $profile"
echo "⚡ Performance: $(nproc) cores, $(free -h | awk '/^Mem:/ {print $2}') RAM"
FILE: docs/CONFIGURATION.md
Kind: text
Size: 1136
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Configuration

BLUX10K keeps user-editable configuration in standard XDG locations. The installer writes its
runtime files to `~/.config/blux10k` and will source `~/.config/private/env.zsh` if it exists.

## Private environment (`configs/env.zsh.example`)

Use the template to store personal variables and API keys.

```bash
cp ./configs/env.zsh.example ~/.config/private/env.zsh
chmod 600 ~/.config/private/env.zsh
```

This file is intentionally excluded from version control. Keep secrets commented out until needed.

## Starship prompt (`configs/starship.toml`)

To use the bundled Starship configuration:

```bash
mkdir -p ~/.config
cp ./configs/starship.toml ~/.config/starship.toml
```

The installer manages prompt activation; re-run it with `--prompt=starship` to switch engines.

## Neofetch configuration (`configs/b10k.neofetch.conf`)

You can run Neofetch directly with the configuration file:

```bash
neofetch --config /path/to/blux10k/configs/b10k.neofetch.conf
```

Or copy it into Neofetch’s default location:

```bash
mkdir -p ~/.config/neofetch
cp ./configs/b10k.neofetch.conf ~/.config/neofetch/config.conf
```
FILE: docs/CUSTOMIZATION.md
Kind: text
Size: 898
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Customization

BLUX10K focuses on a clean Zsh setup, optional Starship configuration, and bundled fonts.

## Fonts

Install fonts from the repo with:

```bash
./fonts/install-fonts.sh
```

- Linux/proot: installs into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k/`.
- macOS: installs into `~/Library/Fonts/BLUX10K/`.
- Termux: run `./fonts/install-fonts.sh --termux-apply` to set `~/.termux/font.ttf`.

After installation, set your terminal font to “MesloLGS NF” (or a bundled alternative) and restart
your terminal.

## Prompt selection

Choose a prompt engine during installation (Powerlevel10k or Starship). To change it later,
re-run the installer with `--prompt=p10k` or `--prompt=starship`.

## Environment variables

Customize BLUX10K behavior in `~/.config/private/env.zsh`. The template at
`configs/env.zsh.example` includes safe defaults and optional entries for API tokens.
FILE: docs/INSTALLATION.md
Kind: text
Size: 2009
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Installation

BLUX10K is installed via the bundled script: `scripts/install.sh`. The installer copies this repo into
`~/.config/blux10k`, adds a managed block to `~/.zshrc`, and creates a private env file at
`~/.config/private/env.zsh` if one does not exist. Review the script output for any warnings.

## Quickstart (all platforms)

```bash
git clone https://github.com/Outer-Void/blux10k.git
cd blux10k
chmod +x ./scripts/install.sh
./scripts/install.sh
```

The installer logs to `~/.cache/blux10k/logs/` and prints next steps at the end.

## Platform-specific notes

### Debian/Ubuntu (normal host)

1. Ensure `git`, `zsh`, and `curl` are available.
2. Run the installer from the repo root.
3. If the installer cannot change your default shell automatically, run:
   ```bash
   chsh -s "$(command -v zsh)"
   ```
4. Restart your terminal.

### Debian/Ubuntu in proot (including Termux + proot)

1. Enter your proot container and install `git` + `zsh`.
2. Run the installer from inside the container.
3. Fonts are installed to:
   ```text
   ${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k
   ```
4. If `fc-cache` is not available, install `fontconfig` in the container or rebuild the cache later.

### Termux (host)

Termux does not support system-wide font installation. The main installer will skip fonts and
print guidance.

Optional font application for Termux only:

```bash
./fonts/install-fonts.sh --termux-apply
```

This copies the bundled MesloLGS font to `~/.termux/font.ttf`. Restart Termux afterward.

### macOS

1. Ensure `git` and `zsh` are available.
2. Run the installer from the repo root.
3. Fonts are installed into `~/Library/Fonts`. Set your terminal font to “MesloLGS NF”.
4. Restart your terminal session.

## Optional environment flags

The installer honors a few environment flags:

- `BLUX10K_SKIP_FONTS=1` — skip font installation.
- `BLUX10K_VERBOSE=1` / `BLUX10K_DEBUG=1` — increase output.

Use them like:

```bash
BLUX10K_SKIP_FONTS=1 ./scripts/install.sh
```
FILE: docs/PLATFORMS.md
Kind: text
Size: 870
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Platforms

BLUX10K targets Zsh environments on Linux, macOS, and Termux. The installer adapts behavior based
on the host platform.

## Support matrix

| Platform | Installer support | Fonts | Notes |
| --- | --- | --- | --- |
| Debian/Ubuntu (host) | ✅ | ✅ | Uses `~/.local/share/fonts/blux10k` and `fc-cache` when available. |
| Debian/Ubuntu (proot) | ✅ | ✅ | Same as Linux; ensure `fontconfig` for `fc-cache` if desired. |
| macOS | ✅ | ✅ | Fonts install into `~/Library/Fonts`. |
| Termux (host) | ✅ | ⚠️ | Fonts require manual apply to `~/.termux/font.ttf`. |

## Known limitations

- Termux does not allow system-wide font installation; use `fonts/install-fonts.sh --termux-apply`.
- Changing the default shell may fail in containerized environments; re-run `chsh` manually if needed.
- Fonts may require a terminal restart after installation.
FILE: docs/TROUBLESHOOTING.md
Kind: text
Size: 1515
Last modified: 2026-01-21T07:57:55Z

CONTENT:
# Troubleshooting

## Installer ran but the shell didn’t switch

The installer attempts to set Zsh as your default shell, but this can fail in some environments.
Run the following manually and restart your terminal:

```bash
chsh -s "$(command -v zsh)"
```

If `chsh` fails (common in containers or Termux), start Zsh manually: `zsh`.

## Prompt is not showing

1. Ensure the BLUX10K entrypoint exists:
   ```bash
   ls ~/.config/blux10k/blux10k.zsh
   ```
2. Confirm your `~/.zshrc` includes a BLUX10K block between:
   ```text
   # >>> BLUX10K START
   # <<< BLUX10K END
   ```
3. Re-run `./scripts/install.sh` from the repo root if either is missing.

## Starship isn’t loading

- Ensure Starship is installed (`starship --version`).
- Re-run the installer with `--prompt=starship`.
- Confirm `~/.zshrc` includes `eval "$(starship init zsh)"`, then restart your shell.

## Fonts installed but terminal doesn’t show them

1. Set your terminal font to “MesloLGS NF” (or another bundled font).
2. On Linux/proot, rebuild the font cache if needed:
   ```bash
   fc-cache -f
   ```
3. Restart the terminal application.

## Termux font application

Termux requires a manual font apply step:

```bash
./fonts/install-fonts.sh --termux-apply
```

Then restart Termux.

## PATH or permission issues

- Ensure the installer ran from the repo root.
- Check the installer log at `~/.cache/blux10k/logs/` for errors.
- Verify your private env file permissions:
  ```bash
  chmod 600 ~/.config/private/env.zsh
  ```
FILE: docs/assets/blux10k.png
Kind: binary
Size: 1228982
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 1228982
detected type: unknown
FILE: fonts/alternatives/ProFontIIxNerdFont-Regular.ttf
Kind: binary
Size: 2280276
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2280276
detected type: unknown
FILE: fonts/alternatives/ProFontIIxNerdFontMono-Regular.ttf
Kind: binary
Size: 2286984
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2286984
detected type: unknown
FILE: fonts/alternatives/ProFontIIxNerdFontPropo-Regular.ttf
Kind: binary
Size: 2280140
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2280140
detected type: unknown
FILE: fonts/alternatives/ProFontWindowsNerdFont-Regular.ttf
Kind: binary
Size: 2265160
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2265160
detected type: unknown
FILE: fonts/alternatives/ProFontWindowsNerdFontMono-Regular.ttf
Kind: binary
Size: 2265628
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2265628
detected type: unknown
FILE: fonts/alternatives/ProFontWindowsNerdFontPropo-Regular.ttf
Kind: binary
Size: 2286736
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2286736
detected type: unknown
FILE: fonts/install-fonts.sh
Kind: text
Size: 2726
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

meslo_dir="${repo_root}/fonts/meslolgs-nf"
alternatives_dir="${repo_root}/fonts/alternatives"

usage() {
  cat <<'USAGE'
BLUX10K font installer

Usage:
  ./fonts/install-fonts.sh [--termux-apply] [--help]

Options:
  --termux-apply  In Termux, copy MesloLGS NF Regular.ttf to ~/.termux/font.ttf
  --help          Show this help message

Notes:
  - Linux/proot Debian: installs fonts into $XDG_DATA_HOME/fonts/blux10k (or ~/.local/share/fonts/blux10k)
  - macOS: installs fonts into ~/Library/Fonts/BLUX10K
  - Termux: by default prints guidance and exits without changing system fonts
USAGE
}

is_termux() {
  [[ -n "${TERMUX_VERSION:-}" ]] || [[ "${PREFIX:-}" == "/data/data/com.termux/files/usr" ]]
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

termux_apply=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --termux-apply)
      termux_apply=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if is_termux; then
  if [[ "${termux_apply}" == "true" ]]; then
    termux_font_src="${meslo_dir}/MesloLGS NF Regular.ttf"
    termux_font_dst="${HOME}/.termux/font.ttf"

    if [[ ! -f "${termux_font_src}" ]]; then
      echo "Termux font source not found: ${termux_font_src}" >&2
      exit 1
    fi

    mkdir -p "${HOME}/.termux"
    cp -f "${termux_font_src}" "${termux_font_dst}"
    echo "Installed Termux font to ${termux_font_dst} (overwritten if it existed)."
    echo "Restart Termux for the font change to take effect."
    exit 0
  fi

  cat <<'TERMUX'
Termux detected. This installer does not change system fonts by default.

To apply the bundled MesloLGS font to Termux only:
  ./fonts/install-fonts.sh --termux-apply

This copies the font to ~/.termux/font.ttf and requires a Termux restart.
TERMUX
  exit 0
fi

install_dir=""
if is_macos; then
  install_dir="${HOME}/Library/Fonts/BLUX10K"
else
  install_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/blux10k"
fi

mkdir -p "${install_dir}"

copy_fonts() {
  local src_dir="$1"
  if compgen -G "${src_dir}/*.ttf" > /dev/null; then
    cp -f "${src_dir}"/*.ttf "${install_dir}/"
  else
    echo "Warning: no .ttf files found in ${src_dir}" >&2
  fi
}

copy_fonts "${meslo_dir}"
copy_fonts "${alternatives_dir}"

echo "Installed BLUX10K fonts to ${install_dir} (overwritten if they existed)."

if ! is_macos; then
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f
  else
    echo "Warning: fc-cache not available; refresh your font cache manually if needed." >&2
  fi
fi
FILE: fonts/meslolgs-nf/MesloLGS NF Bold Italic.ttf
Kind: binary
Size: 2561984
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2561984
detected type: unknown
FILE: fonts/meslolgs-nf/MesloLGS NF Bold.ttf
Kind: binary
Size: 2603868
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2603868
detected type: unknown
FILE: fonts/meslolgs-nf/MesloLGS NF Italic.ttf
Kind: binary
Size: 2553260
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2553260
detected type: unknown
FILE: fonts/meslolgs-nf/MesloLGS NF Regular.ttf
Kind: binary
Size: 2594368
Last modified: 2026-01-21T07:57:55Z

CONTENT:
BINARY FILE — NOT DISPLAYED
file size: 2594368
detected type: unknown
FILE: install.sh
Kind: text
Size: 110915
Last modified: 2026-01-21T07:57:55Z

CONTENT:
#!/usr/bin/env bash
# BLUX10K Enhanced Installer v4.0.0
# Universal Cross-Platform Professional Terminal Setup
# Enterprise-Grade | Performance Optimized | Security Hardened

BLUX10K_ORIG_SHELLOPTS="$(set +o)"
BLUX10K_ORIG_IFS="$IFS"
BLUX10K_ORIG_TRAP_ERR="$(trap -p ERR || true)"
BLUX10K_ORIG_TRAP_INT="$(trap -p INT || true)"
BLUX10K_ORIG_TRAP_TERM="$(trap -p TERM || true)"

set -euo pipefail
IFS=$'\n\t'

# ===========================================================================
# CONSTANTS & GLOBAL CONFIGURATION
# ===========================================================================

# Version and metadata
readonly BLUX10K_VERSION="4.0.0"
readonly BLUX10K_REPO="https://github.com/Justadudeinspace/blux10k"
readonly BLUX10K_DOCS="https://blux10k.github.io/docs"
readonly B10K_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
readonly BLUX10K_CONFIG_DIR="${B10K_DIR}"
readonly BLUX10K_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"
readonly BLUX10K_LOG_DIR="${BLUX10K_CACHE_DIR}/logs"
readonly BLUX10K_INSTALL_LOG="${BLUX10K_LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"
readonly B10K_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/blux10k"
readonly P10K_DIR="${B10K_DATA_DIR}/p10k/powerlevel10k"
readonly OMZ_DIR="${ZDOTDIR:-$HOME}/.oh-my-zsh"
readonly BLUX10K_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes for output (ANSI 256-color support)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;90m'
readonly ORANGE='\033[38;5;208m'
readonly PURPLE='\033[38;5;93m'
readonly NC='\033[0m' # No Color

# Emojis for better UX
readonly EMOJI_INFO="🔵"
readonly EMOJI_SUCCESS="✅"
readonly EMOJI_WARN="⚠️"
readonly EMOJI_ERROR="❌"
readonly EMOJI_DEBUG="🐛"
readonly EMOJI_STEP="➡️"
readonly EMOJI_SPARKLES="✨"
readonly EMOJI_ROCKET="🚀"
readonly EMOJI_SHIELD="🛡️"
readonly EMOJI_GEAR="⚙️"
readonly EMOJI_CLOCK="⏱️"
readonly EMOJI_CHOICE="🔘"

# ===================================================================
# SAFE EXIT HANDLING (AVOID EXITING SOURCED SHELLS)
# ===================================================================

is_sourced() {
    [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

restore_shell_state() {
    if [[ -n "${BLUX10K_ORIG_SHELLOPTS:-}" ]]; then
        eval "${BLUX10K_ORIG_SHELLOPTS}"
    fi
    if [[ -n "${BLUX10K_ORIG_IFS:-}" ]]; then
        IFS="${BLUX10K_ORIG_IFS}"
    fi
    if [[ -n "${BLUX10K_ORIG_TRAP_ERR:-}" ]]; then
        eval "${BLUX10K_ORIG_TRAP_ERR}"
    else
        trap - ERR
    fi
    if [[ -n "${BLUX10K_ORIG_TRAP_INT:-}" ]]; then
        eval "${BLUX10K_ORIG_TRAP_INT}"
    else
        trap - INT
    fi
    if [[ -n "${BLUX10K_ORIG_TRAP_TERM:-}" ]]; then
        eval "${BLUX10K_ORIG_TRAP_TERM}"
    else
        trap - TERM
    fi
}

safe_exit() {
    local status="${1:-0}"
    if is_sourced; then
        restore_shell_state
        return "${status}"
    fi
    exit "${status}"
}

if is_sourced; then
    trap 'restore_shell_state' RETURN
fi

# ===========================================================================
# INTERACTIVE MENU SYSTEM
# ===========================================================================

show_interactive_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              BLUX10K Interactive Setup Menu v4.0.0            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Prompt selection
    echo -e "${CYAN}${EMOJI_CHOICE} Select your preferred prompt system:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Powerlevel10k${NC} - Highly customizable, fast ZSH theme (recommended)"
    echo -e "     • Rich, configurable prompts"
    echo -e "     • Instant prompt for fast startup"
    echo -e "     • Extensive segment library"
    echo ""
    echo -e "  2) ${GREEN}Starship${NC} - Minimal, fast, and customizable prompt"
    echo -e "     • Cross-shell (ZSH, Bash, Fish, etc.)"
    echo -e "     • Written in Rust for speed"
    echo -e "     • Language-aware prompts"
    echo ""
    
    local choice=""
    while true; do
        read -rp "Enter your choice (1-2): " choice
        case $choice in
            1)
                SELECTED_PROMPT="p10k"
                echo -e "${GREEN}✓ Selected Powerlevel10k${NC}"
                break
                ;;
            2)
                SELECTED_PROMPT="starship"
                echo -e "${GREEN}✓ Selected Starship${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1 or 2.${NC}"
                ;;
        esac
    done
    
    echo ""
    
    # Plugin selection
    echo -e "${CYAN}${EMOJI_CHOICE} Select plugin installation mode:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Complete${NC} - Install all popular ZSH plugins"
    echo -e "  2) ${YELLOW}Essential${NC} - Install essential plugins only"
    echo -e "  3) ${GRAY}Minimal${NC} - Install minimal plugins"
    echo -e "  4) ${BLUE}Custom${NC} - Select plugins individually"
    echo ""
    
    local plugin_choice=""
    while true; do
        read -rp "Enter your choice (1-4): " plugin_choice
        case $plugin_choice in
            1)
                PLUGIN_MODE="complete"
                echo -e "${GREEN}✓ Complete plugin installation${NC}"
                break
                ;;
            2)
                PLUGIN_MODE="essential"
                echo -e "${YELLOW}✓ Essential plugins only${NC}"
                break
                ;;
            3)
                PLUGIN_MODE="minimal"
                echo -e "${GRAY}✓ Minimal plugins${NC}"
                break
                ;;
            4)
                PLUGIN_MODE="custom"
                echo -e "${BLUE}✓ Custom plugin selection${NC}"
                select_custom_plugins
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-4.${NC}"
                ;;
        esac
    done
    
    echo ""
    
    # Update options
    echo -e "${CYAN}${EMOJI_CHOICE} Update options:${NC}"
    echo ""
    echo -e "  1) ${GREEN}Full Update${NC} - Update all packages and plugins"
    echo -e "  2) ${YELLOW}Plugin Update Only${NC} - Update Zinit plugins only"
    echo -e "  3) ${GRAY}Skip Updates${NC} - Don't update anything"
    echo ""
    
    local update_choice=""
    while true; do
        read -rp "Enter your choice (1-3): " update_choice
        case $update_choice in
            1)
                UPDATE_MODE="full"
                echo -e "${GREEN}✓ Full update selected${NC}"
                break
                ;;
            2)
                UPDATE_MODE="plugins"
                echo -e "${YELLOW}✓ Plugin update only${NC}"
                break
                ;;
            3)
                UPDATE_MODE="none"
                echo -e "${GRAY}✓ Skipping updates${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1-3.${NC}"
                ;;
        esac
    done
    
    # Confirmation
    echo ""
    echo -e "${CYAN}${EMOJI_CHOICE} Installation Summary:${NC}"
    echo -e "  Prompt: ${GREEN}${SELECTED_PROMPT}${NC}"
    echo -e "  Plugins: ${GREEN}${PLUGIN_MODE}${NC}"
    echo -e "  Updates: ${GREEN}${UPDATE_MODE}${NC}"
    echo ""
    
    read -rp "Proceed with installation? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        return 1
    fi
    
    echo ""
}

normalize_prompt_choice() {
    local choice="${1:-}"
    case "${choice}" in
        p10k|powerlevel10k)
            echo "p10k"
            ;;
        starship)
            echo "starship"
            ;;
        *)
            echo "p10k"
            ;;
    esac
}

select_custom_plugins() {
    local plugins=(
        "syntax-highlighting" "fast-syntax-highlighting"
        "autosuggestions" "zsh-autosuggestions"
        "completions" "zsh-completions"
        "history-substring-search" "history-substring-search"
        "auto-notify" "auto-notify"
        "you-should-use" "you-should-use"
        "colored-man-pages" "colored-man-pages"
        "copypath" "copypath"
        "copyfile" "copyfile"
        "dirhistory" "dirhistory"
        "web-search" "web-search"
        "alias-tips" "alias-tips"
        "git" "git"
        "docker" "docker"
        "kubectl" "kubectl"
        "fzf-tab" "fzf-tab"
        "fzf" "fzf"
        "zoxide" "zoxide"
        "exa" "exa"
        "bat" "bat"
        "ripgrep" "ripgrep"
        "htop" "htop"
    )
    
    SELECTED_CUSTOM_PLUGINS=()
    
    echo ""
    echo -e "${CYAN}Select plugins (space to toggle, enter when done):${NC}"
    
    for ((i=0; i<${#plugins[@]}; i+=2)); do
        local plugin_name="${plugins[i]}"
        local plugin_package="${plugins[i+1]}"
        local selected=" "
        
        # Default selections
        if [[ "$plugin_name" == "syntax-highlighting" ]] || \
           [[ "$plugin_name" == "autosuggestions" ]] || \
           [[ "$plugin_name" == "completions" ]]; then
            selected="✓"
            SELECTED_CUSTOM_PLUGINS+=("$plugin_package")
        fi
        
        printf "  [%s] %s\n" "$selected" "$plugin_name"
    done
    
    echo ""
    echo -e "${YELLOW}Note: Using default essential plugins. Custom selection coming soon.${NC}"
}

# ===========================================================================
# LOGGING SYSTEM WITH MULTI-OUTPUT SUPPORT
# ===========================================================================

init_logging() {
    mkdir -p "${BLUX10K_LOG_DIR}"
    exec 3>&1 4>&2
    if [[ "${BLUX10K_VERBOSE:-0}" -eq 1 ]]; then
        exec 1> >(tee -a "${BLUX10K_INSTALL_LOG}" >&3) 2> >(tee -a "${BLUX10K_INSTALL_LOG}" >&4)
    else
        exec 1> >(tee -a "${BLUX10K_INSTALL_LOG}" >&3) 2>&1
    fi
    
    echo "=== BLUX10K Installer v${BLUX10K_VERSION} Log ===" >> "${BLUX10K_INSTALL_LOG}"
    echo "Timestamp: $(date -Iseconds)" >> "${BLUX10K_INSTALL_LOG}"
    echo "User: $(whoami)" >> "${BLUX10K_INSTALL_LOG}"
    echo "Selected Prompt: ${SELECTED_PROMPT:-not_set}" >> "${BLUX10K_INSTALL_LOG}"
    echo "Plugin Mode: ${PLUGIN_MODE:-not_set}" >> "${BLUX10K_INSTALL_LOG}"
}

# Enhanced logging functions
log_header() {
    local title="$1"
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}                      $(printf "%-48s" "${title}")${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
}

log_section() {
    local title="$1"
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "\n${CYAN}▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ ${WHITE}${title}${CYAN} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬${NC}"
}

log_info() {
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${BLUE}${EMOJI_INFO}  ${NC}$1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_success() {
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${GREEN}${EMOJI_SUCCESS}  ${NC}$1"
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_warn() {
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${YELLOW}${EMOJI_WARN}  ${NC}$1"
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_error() {
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${RED}${EMOJI_ERROR}  ${NC}$1" >&2
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
}

log_debug() {
    if [[ "${BLUX10K_DEBUG:-0}" -eq 1 ]]; then
        if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
            return 0
        fi
        echo -e "${GRAY}${EMOJI_DEBUG}  ${NC}$1"
        echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "${BLUX10K_INSTALL_LOG}"
    fi
}

log_step() {
    local step_number="${1}"
    local step_title="${2}"
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${MAGENTA}${EMOJI_STEP} Step ${step_number}: ${WHITE}${step_title}${NC}"
}

log_perf() {
    local message="$1"
    local duration="$2"
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${CYAN}${EMOJI_CLOCK}  ${message}: ${WHITE}${duration}ms${NC}"
}

log_security() {
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        return 0
    fi
    echo -e "${PURPLE}${EMOJI_SHIELD}  ${NC}$1"
}

# ===================================================================
# PACKAGE MANAGER HELPERS
# ===================================================================

get_sudo_prefix() {
    if command -v sudo >/dev/null 2>&1 && [[ "${EUID}" -ne 0 ]]; then
        echo "sudo"
    fi
}

apt_get_update() {
    local sudo_prefix
    sudo_prefix=$(get_sudo_prefix)
    if [[ -n "${sudo_prefix}" ]]; then
        ${sudo_prefix} apt-get update "$@"
    else
        apt-get update "$@"
    fi
}

apt_get_install() {
    local sudo_prefix
    sudo_prefix=$(get_sudo_prefix)
    if [[ -n "${sudo_prefix}" ]]; then
        ${sudo_prefix} apt-get install -y "$@"
    else
        apt-get install -y "$@"
    fi
}

apt_is_package_available() {
    local package_name="$1"
    apt-cache show "$package_name" >/dev/null 2>&1
}

apt_install_optional_candidates() {
    local tool="$1"
    shift
    local candidates=("$@")
    local candidate
    local installed=0

    for candidate in "${candidates[@]}"; do
        if [[ -z "$candidate" ]]; then
            continue
        fi
        if apt_is_package_available "$candidate"; then
            if apt_get_install "$candidate"; then
                log_success "Installed ${tool} (${candidate})"
                installed=1
                break
            else
                log_warn "SKIP: ${tool} (${candidate} install failed)"
            fi
        fi
    done

    if [[ "$installed" -eq 0 ]]; then
        log_warn "SKIP: ${tool} (not available in repo)"
    fi
}

apt_get_upgrade() {
    local sudo_prefix
    sudo_prefix=$(get_sudo_prefix)
    if [[ -n "${sudo_prefix}" ]]; then
        ${sudo_prefix} apt-get upgrade -y "$@"
    else
        apt-get upgrade -y "$@"
    fi
}

map_termux_package() {
    local package_name="$1"
    if [[ "${package_name}" == "python" ]]; then
        echo "python3"
        return
    fi
    echo "${package_name}"
}

# ===========================================================================
# BANNER & WELCOME MESSAGE
# ===========================================================================

print_banner() {
    clear
    cat << 'EOF'
    
    ░█▀▄░█░░░█░█░█░█ ░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
    ░█▀▄░█░░░█░█░▄▀▄ ░█▀▀░█░░░█░█░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
    ░▀▀░░▀▀▀░▀▀▀░▀░▀░ ▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀
    
╔════════════════════════════════════════════════════════════════╗
║                 BLUX10K ENHANCED INSTALLER v4.0.0             ║
║           Enterprise-Grade Universal Terminal Setup           ║
║        Performance Optimized | Security Hardened | AI Ready   ║
╚════════════════════════════════════════════════════════════════╝

EOF
    
    log_success "Starting BLUX10K v${BLUX10K_VERSION} Installation"
    echo -e "${GRAY}Repository: ${BLUE}${BLUX10K_REPO}${NC}"
    echo -e "${GRAY}Documentation: ${BLUE}${BLUX10K_DOCS}${NC}"
    echo -e "${GRAY}Installation Log: ${BLUE}${BLUX10K_INSTALL_LOG}${NC}"
    echo ""
}

# ===========================================================================
# PLATFORM DETECTION & VALIDATION
# ===========================================================================

detect_platform() {
    local start_time
    start_time=$(date +%s%N)
    
    log_header "Platform Detection"
    
    # Reset environment variables
    unset OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER PLATFORM ENVIRONMENT \
          IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
          IS_TERMUX IS_PROOT ARCH CPU_CORES RAM_GB
    
    # Basic system info
    ARCH=$(uname -m)
    CPU_CORES=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
    RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}' || sysctl -n hw.memsize 2>/dev/null || echo 0)
    RAM_GB=$((RAM_KB / 1048576))
    
    log_debug "Architecture: ${ARCH}"
    log_debug "CPU Cores: ${CPU_CORES}"
    log_debug "RAM: ${RAM_GB}GB"
    
    local platform_forced="false"
    local apt_locked="false"
    local termux_version="false"
    local termux_usr_dir="false"
    local termux_pkg_android="false"
    local termux_prefix="false"
    local termux_native="false"
    local termux_proot="false"
    local android_kernel="false"
    local os_release_present="false"
    local os_release_android="false"
    local os_release_debian_like="false"
    local proot_signal="false"
    local android_host_markers="false"
    local termux_reasons=()
    local proot_reasons=()

    if [[ "$(uname -o 2>/dev/null)" == "Android" ]] || [[ -f "/system/build.prop" ]]; then
        android_kernel="true"
    fi

    # Detect operating system
    case "$(uname -s)" in
        Linux*)
            if [[ -f "/etc/os-release" ]]; then
                source /etc/os-release
                os_release_present="true"
                OS_NAME="${NAME:-Unknown}"
                OS_VERSION="${VERSION_ID:-Unknown}"
                
                case "${ID:-}" in
                    debian)
                        OS_TYPE="debian"
                        PACKAGE_MANAGER="apt"
                        ;;
                    ubuntu)
                        OS_TYPE="ubuntu"
                        PACKAGE_MANAGER="apt"
                        ;;
                    linuxmint|pop|zorin|elementary|kali)
                        OS_TYPE="debian"
                        PACKAGE_MANAGER="apt"
                        ;;
                    arch|manjaro|endeavouros|garuda)
                        OS_TYPE="arch"
                        PACKAGE_MANAGER="pacman"
                        ;;
                    fedora|rhel|centos|almalinux|rocky)
                        OS_TYPE="fedora"
                        PACKAGE_MANAGER="dnf"
                        ;;
                    alpine)
                        OS_TYPE="alpine"
                        PACKAGE_MANAGER="apk"
                        ;;
                    void)
                        OS_TYPE="void"
                        PACKAGE_MANAGER="xbps"
                        ;;
                    gentoo)
                        OS_TYPE="gentoo"
                        PACKAGE_MANAGER="emerge"
                        ;;
                    chromeos)
                        OS_TYPE="chromeos"
                        PACKAGE_MANAGER="apt"
                        ;;
                    *)
                        OS_TYPE="linux"
                        PACKAGE_MANAGER="apt"
                        ;;
                esac
                log_info "Detected: ${PRETTY_NAME:-$OS_NAME} (${OS_TYPE})"
            else
                OS_TYPE="linux"
                OS_NAME="Linux"
                PACKAGE_MANAGER="apt"
                log_warn "Could not detect Linux distribution, using generic setup"
            fi
            ;;
        Darwin*)
            OS_TYPE="macos"
            OS_NAME="macOS"
            OS_VERSION=$(sw_vers -productVersion)
            PACKAGE_MANAGER="brew"
            log_info "Detected: macOS ${OS_VERSION}"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS_TYPE="windows"
            OS_NAME="Windows"
            if command -v winget >/dev/null 2>&1; then
                PACKAGE_MANAGER="winget"
            elif command -v choco >/dev/null 2>&1; then
                PACKAGE_MANAGER="chocolatey"
            else
                PACKAGE_MANAGER="winget"
            fi
            log_info "Detected: Windows (${PACKAGE_MANAGER})"
            ;;
        FreeBSD*)
            OS_TYPE="freebsd"
            OS_NAME="FreeBSD"
            PACKAGE_MANAGER="pkg"
            log_info "Detected: FreeBSD"
            ;;
        OpenBSD*)
            OS_TYPE="openbsd"
            OS_NAME="OpenBSD"
            PACKAGE_MANAGER="pkg_add"
            log_info "Detected: OpenBSD"
            ;;
        *)
            OS_TYPE="unknown"
            OS_NAME="Unknown"
            PACKAGE_MANAGER="unknown"
            log_warn "Unknown operating system: $(uname -s)"
            ;;
    esac

    if [[ "${os_release_present}" == "true" ]]; then
        if [[ "${ID:-}" == "android" ]] || [[ "${NAME:-}" == *Android* ]]; then
            os_release_android="true"
        fi
        if [[ "${ID:-}" == "debian" || "${ID:-}" == "ubuntu" ]] \
            || [[ "${ID_LIKE:-}" == *debian* || "${ID_LIKE:-}" == *ubuntu* ]]; then
            os_release_debian_like="true"
        fi
    fi

    if [[ -n "${TERMUX_VERSION:-}" ]]; then
        termux_version="true"
        termux_reasons+=("TERMUX_VERSION is set")
    fi

    if [[ -n "${PREFIX:-}" && "${PREFIX}" == /data/data/com.termux/files/usr* ]]; then
        termux_prefix="true"
        termux_reasons+=("PREFIX points to Termux userland")
    fi

    if [[ -d "/data/data/com.termux/files/usr" ]]; then
        termux_usr_dir="true"
        termux_reasons+=("found /data/data/com.termux/files/usr")
    fi

    if [[ "${android_kernel}" == "true" ]] \
        && command -v pkg >/dev/null 2>&1 \
        && { [[ "${os_release_present}" != "true" ]] || [[ "${os_release_android}" == "true" ]]; }; then
        termux_pkg_android="true"
        termux_reasons+=("Android kernel with pkg available and Android-like or missing /etc/os-release")
    fi

    if [[ "${android_kernel}" == "true" ]] \
        || [[ "${termux_version}" == "true" ]] \
        || [[ "${termux_prefix}" == "true" ]] \
        || [[ "${termux_usr_dir}" == "true" ]] \
        || [[ -d "/data/data/com.termux" ]]; then
        android_host_markers="true"
    fi

    # Apply platform override
    case "${BLUX10K_FORCE_PLATFORM:-}" in
        termux)
            OS_TYPE="termux"
            PACKAGE_MANAGER="pkg"
            IS_TERMUX="true"
            platform_forced="true"
            log_info "Platform override: termux"
            ;;
        debian|apt)
            OS_TYPE="debian"
            PACKAGE_MANAGER="apt"
            platform_forced="true"
            log_info "Platform override: debian"
            ;;
    esac
    
    # Detect WSL
    if [[ "$(uname -s)" == "Linux" ]] && (grep -qi microsoft /proc/version 2>/dev/null || [[ -d "/mnt/c/Windows" ]]); then
        IS_WSL="true"
        if grep -qi "WSL2" /proc/version 2>/dev/null; then
            WSL_VERSION="2"
        else
            WSL_VERSION="1"
        fi
        log_info "Running in WSL ${WSL_VERSION}"
    fi
    
    if [[ "${platform_forced}" != "true" ]]; then
        if [[ -f "/etc/os-release" ]] \
            && command -v apt-get >/dev/null 2>&1 \
            && [[ -d "/data/data/com.termux/files/usr" ]]; then
            termux_proot="true"
            proot_reasons+=("Termux proot detected with /etc/os-release and apt-get")
        fi

        if [[ "${termux_version}" == "true" ]] || [[ "${termux_prefix}" == "true" ]]; then
            termux_native="true"
        fi

        if grep -qi "proot" /proc/self/status 2>/dev/null \
            || grep -qa "proot" /proc/1/environ 2>/dev/null \
            || env | grep -q '^PROOT_' \
            || { command -v proot >/dev/null 2>&1 && [[ -n "${PROOT_TMP_DIR:-}" || -n "${PROOT_ROOTFS:-}" ]]; }; then
            proot_signal="true"
            proot_reasons+=("proot markers in /proc or environment variables")
        fi

        if [[ "${os_release_present}" == "true" ]] && [[ "${os_release_debian_like}" == "true" ]]; then
            if [[ "${proot_signal}" == "true" ]]; then
                IS_PROOT="true"
                proot_reasons+=("Debian/Ubuntu userland with proot signal")
            elif [[ "${android_host_markers}" == "true" ]]; then
                IS_PROOT="true"
                proot_reasons+=("Android host markers with Debian/Ubuntu userland")
            fi
        fi

        if [[ "${termux_proot}" == "true" ]]; then
            IS_PROOT="true"
            OS_TYPE="${ID:-debian}"
            PACKAGE_MANAGER="apt"
            log_info "Detected Termux proot because: ${proot_reasons[*]}"
        elif [[ -n "${IS_PROOT:-}" ]]; then
            OS_TYPE="${ID:-debian}"
            PACKAGE_MANAGER="apt"
            log_info "Detected proot Debian/Ubuntu because: ${proot_reasons[*]}"
        elif [[ "${termux_native}" == "true" ]] \
            || [[ "${termux_usr_dir}" == "true" ]] \
            || [[ "${termux_pkg_android}" == "true" ]]; then
            IS_TERMUX="true"
            OS_TYPE="termux"
            PACKAGE_MANAGER="pkg"
            log_info "Detected Termux legacy because: ${termux_reasons[*]}"
        fi
    fi

    if [[ "${platform_forced}" != "true" ]] \
        && [[ -f "/etc/os-release" ]] \
        && [[ "${ID:-}" != "android" ]] \
        && [[ -z "${IS_TERMUX:-}" ]] \
        && [[ -z "${IS_PROOT:-}" ]] \
        && command -v apt-get >/dev/null 2>&1; then
        if [[ "${OS_TYPE}" == "linux" ]]; then
            OS_TYPE="${ID:-debian}"
        fi
        PACKAGE_MANAGER="apt"
        apt_locked="true"
        log_info "Locked package manager to apt based on /etc/os-release"
    fi

    # Prefer apt in proot if available
    if [[ -n "${IS_PROOT:-}" ]] && command -v apt-get >/dev/null 2>&1 && [[ "${platform_forced}" != "true" ]]; then
        PACKAGE_MANAGER="apt"
        if [[ "${OS_TYPE}" == "linux" ]]; then
            OS_TYPE="${ID:-debian}"
        fi
    fi

    # Ensure package manager is available; fallback between apt and pkg
    if [[ "${PACKAGE_MANAGER}" == "pkg" ]] && ! command -v pkg >/dev/null 2>&1; then
        if [[ "${platform_forced}" == "true" ]]; then
            log_error "pkg not found but BLUX10K_FORCE_PLATFORM is set"
            return 1
        elif [[ -n "${IS_TERMUX:-}" ]]; then
            log_error "pkg not found in Termux environment. Please install Termux packages."
            return 1
        elif command -v apt-get >/dev/null 2>&1; then
            log_warn "pkg not found, falling back to apt"
            PACKAGE_MANAGER="apt"
        else
            log_error "pkg not found and apt-get unavailable. Please install a supported package manager."
            return 1
        fi
    fi

    if [[ "${PACKAGE_MANAGER}" == "apt" ]] && ! command -v apt-get >/dev/null 2>&1; then
        if [[ "${platform_forced}" == "true" ]]; then
            log_error "apt-get not found but BLUX10K_FORCE_PLATFORM is set"
            return 1
        elif [[ -n "${IS_PROOT:-}" ]]; then
            log_error "apt-get not found in proot environment. Please install apt."
            return 1
        elif command -v pkg >/dev/null 2>&1; then
            log_warn "apt-get not found, falling back to pkg"
            PACKAGE_MANAGER="pkg"
        else
            log_error "apt-get not found and pkg unavailable. Please install a supported package manager."
            return 1
        fi
    fi

    if [[ "${OS_TYPE}" == "linux" ]] && command -v pacman >/dev/null 2>&1; then
        OS_TYPE="arch"
        PACKAGE_MANAGER="pacman"
        log_info "Detected Arch-based system via pacman"
    fi

    if [[ "${OS_TYPE}" == "linux" ]] && command -v dnf >/dev/null 2>&1; then
        OS_TYPE="fedora"
        PACKAGE_MANAGER="dnf"
        log_info "Detected Fedora/RHEL system via dnf"
    fi

    log_debug "Platform summary: OS_TYPE=${OS_TYPE} PACKAGE_MANAGER=${PACKAGE_MANAGER} IS_PROOT=${IS_PROOT:-false} TERMUX_VERSION=${termux_version} TERMUX_PREFIX=${termux_prefix} TERMUX_USR_DIR=${termux_usr_dir} TERMUX_PKG_ANDROID=${termux_pkg_android} ANDROID_KERNEL=${android_kernel}"
    
    # Detect container environments
    if [[ -f "/.dockerenv" ]] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        IS_CONTAINER="docker"
        log_info "Running in Docker container"
    elif [[ -f "/run/.containerenv" ]]; then
        IS_CONTAINER="podman"
        log_info "Running in Podman container"
    fi
    
        # Detect cloud environments
    if [[ -n "${CLOUD_SHELL:-}" ]] || [[ -d "/google" ]]; then
        IS_CLOUD="google-cloud-shell"
        log_info "Detected Google Cloud Shell"
    elif [[ -n "${CODESPACES:-}" ]]; then
        IS_CLOUD="github-codespaces"
        log_info "Detected GitHub Codespaces"
    elif [[ -n "${GITPOD_WORKSPACE_ID:-}" ]]; then
        IS_CLOUD="gitpod"
        log_info "Detected Gitpod"
    elif [[ -n "${AWS_CLOUDSHELL:-}" ]]; then
        IS_CLOUD="aws-cloudshell"
        log_info "Detected AWS CloudShell"
    fi
    
    # Detect virtual machines
    if command -v systemd-detect-virt >/dev/null 2>&1; then
        local virt_env
        virt_env=$(systemd-detect-virt 2>/dev/null)
        if [[ "$virt_env" != "none" ]]; then
            log_info "Virtualization: ${virt_env}"
        fi
    fi
    
    # Performance metrics
    local end_time
    end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    log_perf "Platform detection completed" "${duration}"
    PLATFORM="${OS_TYPE}"
    if [[ -n "${IS_PROOT:-}" ]]; then
        ENVIRONMENT="proot"
    elif [[ -n "${IS_TERMUX:-}" ]]; then
        ENVIRONMENT="termux"
    else
        ENVIRONMENT="native"
    fi

    log_success "Platform: ${OS_NAME} ${OS_VERSION:-} (${OS_TYPE})"
    log_success "Package Manager: ${PACKAGE_MANAGER}"
    
    [[ -n "${IS_WSL:-}" ]] && log_info "WSL: Version ${WSL_VERSION}"
    [[ -n "${IS_CONTAINER:-}" ]] && log_info "Container: ${IS_CONTAINER}"
    [[ -n "${IS_CLOUD:-}" ]] && log_info "Cloud: ${IS_CLOUD}"
    [[ -n "${IS_TERMUX:-}" ]] && log_info "Environment: Termux"
    
    export OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER PLATFORM ENVIRONMENT \
           IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
           IS_TERMUX IS_PROOT ARCH CPU_CORES RAM_GB
}

# ===========================================================================
# ZINIT INSTALLATION & MANAGEMENT
# ===========================================================================

install_oh_my_zsh() {
    log_section "Oh My Zsh Installation"
    
    if [[ -d "${OMZ_DIR}/.git" ]]; then
        log_info "Oh My Zsh already installed, updating..."
        if git -C "${OMZ_DIR}" pull --ff-only; then
            log_success "Oh My Zsh updated"
        else
            log_warn "Oh My Zsh update failed; continuing"
        fi
        return 0
    fi
    
    if [[ -d "${OMZ_DIR}" ]]; then
        log_warn "Oh My Zsh directory exists without git metadata, skipping clone"
        return 0
    fi
    
    log_info "Cloning Oh My Zsh..."
    if git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "${OMZ_DIR}"; then
        log_success "Oh My Zsh installed"
    else
        log_error "Oh My Zsh installation failed"
        return 1
    fi
}

install_zinit() {
    log_section "Zinit Installation"
    
    local zinit_home="${ZDOTDIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zinit}/zinit.git"
    
    if [[ -d "$zinit_home" ]]; then
        log_info "Zinit already installed, updating..."
        git -C "$zinit_home" pull origin main
        log_success "Zinit updated"
    else
        log_info "Installing Zinit..."
        mkdir -p "$(dirname "$zinit_home")"
        git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
        log_success "Zinit installed"
    fi
    
    # Create zinit configuration directory
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zinit"
    
    if [[ -f "$zinit_home/zinit.zsh" ]]; then
        log_success "Zinit installed at ${zinit_home}"
    else
        log_error "Zinit installation failed"
        return 1
    fi
}

install_zsh_plugins_via_zinit() {
    log_section "Installing ZSH Plugins via Zinit"
    
    # Define plugin sets based on selected mode
    local essential_plugins=(
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zdharma-continuum/fast-syntax-highlighting"
        "hlissner/zsh-autopair"
    )
    
    local popular_plugins=(
        "zsh-users/zsh-history-substring-search"
        "MichaelAquilina/zsh-you-should-use"
        "changyuheng/fz"
        "rupa/z"
        "ael-code/zsh-colored-man-pages"
        "OMZ::plugins/git"
        "OMZ::plugins/docker"
        "OMZ::plugins/kubectl"
        "Aloxaf/fzf-tab"
        "wfxr/forgit"
        "zdharma-continuum/history-search-multi-word"
        "Tarrasch/zsh-autoenv"
    )
    
    local complete_plugins=(
        "agkozak/zsh-z"
        "jeffreytse/zsh-vi-mode"
        "marlonrichert/zsh-autocomplete"
        "zdharma-continuum/zinit-annex-bin-gem-node"
        "zdharma-continuum/zinit-annex-readurl"
        "zdharma-continuum/zinit-annex-patch-dl"
        "zdharma-continuum/zinit-annex-rust"
        "z-shell/F-Sy-H"
        "z-shell/H-S-MW"
        "z-shell/zsh-navigation-tools"
        "z-shell/zsh-diff-so-fancy"
    )
    
    local plugins_to_install=()
    
    case "$PLUGIN_MODE" in
        minimal)
            plugins_to_install=("${essential_plugins[@]:0:3}")
            ;;
        essential)
            plugins_to_install=("${essential_plugins[@]}")
            ;;
        complete)
            plugins_to_install=("${essential_plugins[@]}" "${popular_plugins[@]}" "${complete_plugins[@]}")
            ;;
        custom)
            plugins_to_install=("${essential_plugins[@]}")
            if [[ ${#SELECTED_CUSTOM_PLUGINS[@]} -gt 0 ]]; then
                plugins_to_install+=("${SELECTED_CUSTOM_PLUGINS[@]}")
            fi
            ;;
        *)
            plugins_to_install=("${essential_plugins[@]}")
            ;;
    esac
    
    # Create plugins.zsh file
    local plugins_file="${B10K_DIR}/modules/zsh/plugins.zsh"
    mkdir -p "$(dirname "$plugins_file")"

    local plugins_tmp
    plugins_tmp="$(mktemp)"

    cat > "$plugins_tmp" << EOF
#!/usr/bin/env zsh
# BLUX10K ZSH Plugins Configuration
# Generated: $(date)

# Source zinit if not already sourced
if [[ -z "\${ZINIT[START_DIR]}" ]]; then
    source "\${ZDOTDIR:-\${XDG_DATA_HOME:-\$HOME/.local/share}/zinit}/zinit.git/zinit.zsh"
fi

# Essential plugins
EOF
    
    for plugin in "${plugins_to_install[@]}"; do
        echo "zinit light \"$plugin\"" >> "$plugins_tmp"
        log_info "Added plugin: $plugin"
    done
    
    # Add completion and compilation
    cat >> "$plugins_tmp" << 'EOF'

# Load completions
autoload -Uz compinit
compinit

# Compile zinit plugins
zinit compile --all

# Plugin configurations
# Syntax highlighting
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# fzf-tab configuration
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' continuous-trigger 'tab'
zstyle ':fzf-tab:*' switch-group ',' '.'

# You-should-use configuration
YSU_MESSAGE_POSITION="after"
YSU_MODE=ALL
YSU_HARDCORE=0
EOF

    mv "$plugins_tmp" "$plugins_file"
    log_success "ZSH plugins configuration created"
    
    # Install plugins
    log_info "Installing plugins via Zinit..."
    
    # Source zinit and load plugins
    if [[ -f "$plugins_file" ]]; then
        if zsh -lc "source \"$plugins_file\"; zinit self-update; zinit update --all --quiet --no-pager"; then
            log_success "Zinit plugins installed/updated"
        else
            log_error "Zinit plugin installation failed"
            return 1
        fi
    else
        log_error "Plugins configuration file not found"
        return 1
    fi
}

update_zinit_plugins() {
    log_section "Updating Zinit Plugins"
    
    log_info "Updating all Zinit plugins..."
    if zsh -lc 'source ~/.zshrc; zinit self-update; zinit update --all --parallel'; then
        log_success "Zinit plugins updated"
    else
        log_warn "Zinit update skipped (zsh/zinit not available)"
    fi
}

# ===========================================================================
# PROMPT SELECTION & INSTALLATION
# ===========================================================================

install_prompt_system() {
    log_section "Prompt System Installation"

    SELECTED_PROMPT="$(normalize_prompt_choice "$SELECTED_PROMPT")"

    case "$SELECTED_PROMPT" in
        p10k|powerlevel10k)
            install_powerlevel10k
            configure_powerlevel10k
            ;;
        starship)
            install_starship
            configure_starship
            ;;
        *)
            log_warn "Unknown prompt system: $SELECTED_PROMPT, defaulting to Powerlevel10k"
            SELECTED_PROMPT="p10k"
            install_powerlevel10k
            configure_powerlevel10k
            ;;
    esac
}

install_powerlevel10k() {
    log_info "Installing Powerlevel10k..."
    
    mkdir -p "$(dirname "$P10K_DIR")"
    
    if [[ -d "$P10K_DIR/.git" ]]; then
        log_info "Updating Powerlevel10k..."
        if git -C "$P10K_DIR" pull --ff-only; then
            log_success "Powerlevel10k updated"
        else
            log_warn "Powerlevel10k update failed; continuing"
        fi
    else
        log_info "Cloning Powerlevel10k..."
        if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"; then
            log_success "Powerlevel10k installed"
        else
            log_error "Powerlevel10k installation failed"
            return 1
        fi
    fi
}

configure_powerlevel10k() {
    log_info "Configuring Powerlevel10k..."
    
    # Create p10k configuration
    local p10k_config="$HOME/.p10k.zsh"
    
    if [[ ! -f "$p10k_config" ]]; then
        local p10k_tmp
        p10k_tmp="$(mktemp)"
        cat > "$p10k_tmp" << 'EOF'
# Generated by BLUX10K Installer
# Powerlevel10k Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k
source "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k/powerlevel10k.zsh-theme"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
        mv "$p10k_tmp" "$p10k_config"
        log_success "Powerlevel10k configuration created"
    else
        log_info "Powerlevel10k configuration already exists"
    fi
}

install_starship() {
    log_info "Installing Starship..."
    
    if command -v starship >/dev/null 2>&1; then
        log_info "Starship already installed"
    else
        case "$PACKAGE_MANAGER" in
            apt)
                if apt_get_install starship; then
                    log_success "Starship installed via apt"
                else
                    log_warn "apt install failed, falling back to Starship install script"
                    curl -sS https://starship.rs/install.sh | sh -s -- -y
                fi
                ;;
            pkg)
                if pkg install -y starship; then
                    log_success "Starship installed via pkg"
                else
                    log_warn "pkg install failed, falling back to Starship install script"
                    curl -sS https://starship.rs/install.sh | sh -s -- -y
                fi
                ;;
            brew)
                brew install starship
                ;;
            winget)
                winget install --id Starship.Starship --silent
                ;;
            chocolatey)
                choco install starship -y
                ;;
            *)
                curl -sS https://starship.rs/install.sh | sh -s -- -y
                ;;
        esac
    fi
    
    # Verify installation
    if command -v starship >/dev/null 2>&1; then
        log_success "Starship installed: $(starship --version)"
    else
        log_error "Starship installation failed"
        return 1
    fi
}

configure_starship() {
    log_info "Configuring Starship..."
    
    # Create starship configuration
    local starship_config="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    
    if [[ ! -f "$starship_config" ]]; then
        local starship_tmp
        starship_tmp="$(mktemp)"
        cat > "$starship_tmp" << 'EOF'
# BLUX10K Starship Configuration
# https://starship.rs/config/

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$docker_context\
$package\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$golang\
$helm\
$java\
$julia\
$kotlin\
$lua\
$nim\
$nodejs\
$ocaml\
$perl\
$php\
$pulumi\
$purescript\
$python\
$rlang\
$red\
$ruby\
$rust\
$scala\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$nix_shell\
$conda\
$memory_usage\
$aws\
$gcloud\
$openstack\
$env_var\
$crystal\
$custom\
$sudo\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$shell\
$character"""

# Directory configuration
[directory]
truncation_length = 3
truncate_to_repo = false
style = "bold blue"

[directory.substitutions]
"Documents" = " "
"Downloads" = " "
"Music" = " "
"Pictures" = " "
"Videos" = " "
"src" = " "
"~" = " "

# Git configuration
[git_branch]
symbol = " "
style = "bold purple"

[git_status]
conflicted = "🏳"
ahead = "⇡\${count}"
behind = "⇣\${count}"
diverged = "⇕"
untracked = "\${count}?"
stashed = ""
modified = "\${count}! "
renamed = "➜"
deleted = "✘"
style = "bold red"

# Time configuration
[time]
disabled = false
format = "[🕒 %T]"
time_range = "10:00..20:00"

# Battery configuration
[battery]
full_symbol = "🔋"
charging_symbol = "⚡"
discharging_symbol = "💀"
disabled = false

# Prompt character
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
vicmd_symbol = "[V](bold green)"

# Python configuration
[python]
symbol = "🐍 "

# Node.js configuration
[nodejs]
symbol = "⬢ "

# Docker configuration
[docker_context]
symbol = " "
style = "bold blue"

# Kubernetes configuration
[kubernetes]
symbol = "☸ "
style = "bold blue"

# AWS configuration
[aws]
symbol = "🅰 "
style = "bold yellow"

# Memory usage
[memory_usage]
disabled = false
threshold = 75
symbol = " "
style = "bold dimmed white"
EOF
        mv "$starship_tmp" "$starship_config"
        log_success "Starship configuration created"
    else
        log_info "Starship configuration already exists"
    fi
}

verify_prompt_activation() {
    log_section "Prompt Activation Verification"

    local verify_cmd
    verify_cmd=$(cat << 'EOF'
echo "shell=$(ps -p $$ -o comm=)";
echo "engine=$BLUX_PROMPT_ENGINE";
if [ "$BLUX_PROMPT_ENGINE" = "p10k" ]; then
  grep -q "powerlevel10k" ~/.zshrc && echo "P10K configured OK" || exit 1;
  ! grep -q "starship init zsh" ~/.zshrc && echo "Starship not enabled OK" || exit 1;
fi
if [ "$BLUX_PROMPT_ENGINE" = "starship" ]; then
  grep -q "starship init zsh" ~/.zshrc && echo "Starship configured OK" || exit 1;
  ! grep -q "powerlevel10k" ~/.zshrc && echo "P10K not enabled OK" || exit 1;
fi
EOF
)

    if zsh -lc "$verify_cmd"; then
        log_success "Prompt activation verified"
    else
        log_error "Prompt activation verification failed"
        log_error "Hint: re-run the installer with --prompt=p10k or --prompt=starship"
        return 1
    fi
}

# ===========================================================================
# UPDATE MANAGEMENT
# ===========================================================================

run_updates() {
    log_section "System Updates"
    
    case "$UPDATE_MODE" in
        full)
            update_system_packages
            update_zinit_plugins
            update_custom_tools
            ;;
        plugins)
            update_zinit_plugins
            ;;
        none)
            log_info "Skipping updates as requested"
            ;;
        *)
            log_warn "Unknown update mode: $UPDATE_MODE"
            ;;
    esac
}

update_system_packages() {
    log_info "Updating system packages..."
    
    case "$PACKAGE_MANAGER" in
        apt)
            apt_get_update && apt_get_upgrade
            ;;
        brew)
            brew update && brew upgrade
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
        dnf)
            sudo dnf upgrade -y
            ;;
        pkg)
            pkg update && pkg upgrade -y
            ;;
        winget)
            winget upgrade --all --silent
            ;;
        chocolatey)
            choco upgrade all -y
            ;;
        *)
            log_warn "Package manager $PACKAGE_MANAGER not supported for updates"
            ;;
    esac
    
    log_success "System packages updated"
}

update_custom_tools() {
    log_info "Updating custom tools..."
    
    # Update Rust toolchain
    if command -v rustup >/dev/null 2>&1; then
        rustup update
        log_success "Rust toolchain updated"
    fi
    
    # Update pip packages
    if command -v pip3 >/dev/null 2>&1; then
        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
        log_success "Python packages updated"
    fi
    
    # Update npm packages
    if command -v npm >/dev/null 2>&1; then
        npm update -g
        log_success "NPM packages updated"
    fi
}

# ===========================================================================
# MAIN INSTALLATION FLOW
# ===========================================================================

for blux10k_arg in "$@"; do
    if [[ "${blux10k_arg}" == "--profile" ]]; then
        BLUX10K_PROFILE=1
        break
    fi
done

main() {
    START_TIME=$(date +%s)
    
    # Parse command line arguments
    parse_arguments "$@"
    
    if [[ "${BLUX10K_PROFILE:-0}" -eq 1 ]]; then
        detect_platform
        local neofetch_config
        neofetch_config="${XDG_CONFIG_HOME:-$HOME/.config}/neofetch/config.conf"
        echo "OS_TYPE=${OS_TYPE}"
        echo "ENVIRONMENT=${ENVIRONMENT}"
        echo "PACKAGE_MANAGER=${PACKAGE_MANAGER}"
        echo "PREFIX=${PREFIX:-}"
        echo "TERMUX_VERSION=${TERMUX_VERSION:-}"
        echo "NEOFETCH_INSTALLED=$(command -v neofetch >/dev/null 2>&1 && echo true || echo false)"
        echo "NEOFETCH_CONFIG_PRESENT=$(test -f "$neofetch_config" && echo true || echo false)"
        safe_exit 0
    fi
    
    # Show interactive menu if not in silent mode
    if [[ "${BLUX10K_SILENT_INSTALL:-0}" -ne 1 ]]; then
        if ! show_interactive_menu; then
            return 0
        fi
    else
        # Set defaults for silent mode
        SELECTED_PROMPT="$(normalize_prompt_choice "${BLUX10K_PROMPT:-p10k}")"
        PLUGIN_MODE="${BLUX10K_PLUGIN_MODE:-complete}"
        UPDATE_MODE="${BLUX10K_UPDATE_MODE:-full}"
    fi
    
    # Initialize
    init_logging
    print_banner
    
    # Installation steps
    log_step "1" "Detecting platform..."
    detect_platform
    
    log_step "2" "Checking permissions..."
    check_permissions || return 1
    
    log_step "3" "Installing package manager..."
    install_package_manager
    
    log_step "4" "Installing environment dependencies..."
    install_environment_dependencies
    
    log_step "5" "Checking dependencies..."
    check_dependencies || return 1
    
    log_step "6" "Installing core packages..."
    install_core_packages

    log_step "7" "Installing Neofetch..."
    install_neofetch
    
    log_step "8" "Installing modern tools..."
    install_modern_tools
    
    log_step "9" "Installing Oh My Zsh..."
    install_oh_my_zsh
    
    log_step "10" "Installing Zinit..."
    install_zinit
    
    log_step "11" "Installing ZSH plugins..."
    install_zsh_plugins_via_zinit
    
    log_step "12" "Installing prompt system..."
    install_prompt_system
    
    log_step "13" "Installing fonts..."
    install_fonts
    
    log_step "14" "Deploying configurations..."
    deploy_configurations

    log_step "15" "Verifying prompt activation..."
    verify_prompt_activation
    
    log_step "16" "Running updates..."
    run_updates
    
    log_step "17" "Post-installation setup..."
    post_install_setup
    
    log_step "18" "Finalizing installation..."
    finalize_installation
    
    return 0
}

# ===========================================================================
# REMAINING FUNCTIONS (from original script)
# ===========================================================================

# Function to check and escalate permissions if needed
check_permissions() {
    log_section "Permission Verification"
    
    local need_sudo="false"
    
    # Check if we have write access to required directories
    local dirs_to_check=(
        "$HOME"
        "${B10K_DIR}"
        "${BLUX10K_CACHE_DIR}"
        "${B10K_DATA_DIR}"
    )
    
    for dir in "${dirs_to_check[@]}"; do
        if [[ ! -w "$dir" ]] && [[ ! -w "$(dirname "$dir")" ]]; then
            log_debug "Need write access to: $dir"
            need_sudo="true"
        fi
    done
    
    # Check if we can install packages
    case "$PACKAGE_MANAGER" in
        apt|pacman|dnf|apk|xbps|emerge)
            if ! command -v sudo >/dev/null 2>&1; then
                log_warn "sudo not found but may be needed for package installation"
                need_sudo="true"
            fi
            ;;
        pkg|brew|winget|chocolatey)
            # These typically don't need sudo for user installations
            ;;
    esac
    
    # Handle sudo requirements
    if [[ "$need_sudo" == "true" ]] && [[ "$EUID" -ne 0 ]]; then
        log_info "Elevated permissions may be required for some operations"
        
        if command -v sudo >/dev/null 2>&1; then
            log_info "Testing sudo access..."
            if sudo -v; then
                log_success "sudo access confirmed"
            else
                log_warn "sudo access unavailable or requires password"
                log_info "Some operations may fail without sudo"
            fi
        else
            log_warn "sudo not available, some operations may fail"
        fi
    elif [[ "$EUID" -eq 0 ]]; then
        log_warn "Running as root. Consider running as regular user with sudo."
    fi
    
    return 0
}

# Function to ensure package manager is available
install_package_manager() {
    log_section "Package Manager Setup"
    
    case "$PACKAGE_MANAGER" in
        apt)
            if ! command -v apt-get >/dev/null 2>&1; then
                log_error "apt-get not found on Debian-based system"
                return 1
            fi
            log_info "Updating APT cache..."
            apt_get_update -qq
            ;;
            
        brew)
            if ! command -v brew >/dev/null 2>&1; then
                log_warn "Homebrew not available; skipping brew setup"
                return 0
            fi
            log_info "Updating Homebrew..."
            brew update
            ;;
            
        pacman)
            if ! command -v pacman >/dev/null 2>&1; then
                log_error "pacman not found on Arch-based system"
                return 1
            fi
            log_info "Updating pacman database..."
            sudo pacman -Syu --noconfirm
            ;;
            
        dnf)
            if ! command -v dnf >/dev/null 2>&1; then
                log_error "dnf not found on Fedora/RHEL system"
                return 1
            fi
            log_info "Updating DNF cache..."
            sudo dnf makecache -y
            ;;
            
        pkg)
            if ! command -v pkg >/dev/null 2>&1; then
                log_error "pkg not found (Termux)"
                return 1
            fi
            log_info "Updating Termux packages..."
            pkg update
            ;;
            
        winget)
            if ! command -v winget >/dev/null 2>&1; then
                log_error "winget not found on Windows"
                return 1
            fi
            ;;
            
        chocolatey)
            if ! command -v choco >/dev/null 2>&1; then
                log_info "Installing Chocolatey..."
                powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; \
                    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
                    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
            fi
            ;;
            
        *)
            log_warn "Package manager $PACKAGE_MANAGER may not be fully supported"
            ;;
    esac
    
    log_success "Package manager configured"
    return 0
}

# Function to check and install required dependencies
check_dependencies() {
    log_section "Dependency Check"
    
    local missing_deps=()
    local optional_deps=()
    
    # Essential dependencies
    if ! command -v git >/dev/null 2>&1; then
        missing_deps+=("git")
    fi
    
    if ! command -v curl >/dev/null 2>&1; then
        missing_deps+=("curl")
    fi
    
    if ! command -v zsh >/dev/null 2>&1; then
        missing_deps+=("zsh")
    fi
    
    # Optional but recommended
    if ! command -v wget >/dev/null 2>&1; then
        optional_deps+=("wget")
    fi
    
    if ! command -v unzip >/dev/null 2>&1; then
        optional_deps+=("unzip")
    fi
    
    if ! command -v tar >/dev/null 2>&1; then
        optional_deps+=("tar")
    fi
    
    if ! command -v gzip >/dev/null 2>&1; then
        optional_deps+=("gzip")
    fi
    
    # Platform-specific dependencies
    case "$OS_TYPE" in
        macos)
            if ! command -v xcode-select >/dev/null 2>&1; then
                optional_deps+=("xcode-select (Command Line Tools)")
            fi
            ;;
        windows)
            if ! command -v pwsh >/dev/null 2>&1; then
                optional_deps+=("PowerShell 7+")
            fi
            ;;
    esac
    
    # Report missing dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_warn "Missing essential dependencies: ${missing_deps[*]}"
        log_info "Attempting to install missing dependencies..."
        
        for dep in "${missing_deps[@]}"; do
            install_dependency "$dep"
        done
        
        # Verify installation
        local still_missing=()
        for dep in "${missing_deps[@]}"; do
            if ! command -v "$dep" >/dev/null 2>&1; then
                still_missing+=("$dep")
            fi
        done
        
        if [[ ${#still_missing[@]} -gt 0 ]]; then
            log_error "Failed to install: ${still_missing[*]}"
            log_error "Please install these dependencies manually and restart the installer"
            return 1
        fi
    fi
    
    # Install optional dependencies
    if [[ ${#optional_deps[@]} -gt 0 ]]; then
        log_info "Optional dependencies: ${optional_deps[*]}"
        read -rp "Install optional dependencies? (y/N): " opt_choice
        if [[ "$opt_choice" =~ ^[Yy]$ ]]; then
            for dep in "${optional_deps[@]}"; do
                install_dependency "$dep"
            done
        fi
    fi
    
    log_success "Dependencies verified"
    return 0
}

# Helper function to install a single dependency
install_dependency() {
    local dep="$1"
    
    case "$PACKAGE_MANAGER" in
        apt)
            apt_get_install "$dep"
            ;;
        brew)
            if command -v brew >/dev/null 2>&1; then
                brew install "$dep"
            else
                log_warn "Homebrew not available; cannot install $dep"
                return 1
            fi
            ;;
        pacman)
            sudo pacman -Syu --noconfirm "$dep"
            ;;
        dnf)
            sudo dnf install -y "$dep"
            ;;
        pkg)
            pkg install -y "$(map_termux_package "$dep")"
            ;;
        winget)
            winget install --id "$dep" --silent
            ;;
        chocolatey)
            choco install "$dep" -y
            ;;
        apk)
            sudo apk add "$dep"
            ;;
        xbps)
            sudo xbps-install -y "$dep"
            ;;
        emerge)
            sudo emerge --ask n "$dep"
            ;;
        *)
            log_warn "Cannot install $dep: unsupported package manager"
            return 1
            ;;
    esac
}

# Install environment-specific dependencies
install_environment_dependencies() {
    log_section "Environment Dependencies"

    case "${ENVIRONMENT}" in
        termux)
            log_info "Installing Termux dependencies via pkg..."
            pkg update
            pkg install -y zsh git curl wget python3 python-pip
            log_success "Termux dependencies installed"
            ;;
        proot)
            if [[ "${OS_TYPE}" == "debian" || "${OS_TYPE}" == "ubuntu" ]]; then
                log_info "Installing Debian/Ubuntu dependencies via apt..."
                apt_get_update
                apt_get_install zsh git curl wget fzf locales ca-certificates
                log_success "Debian/Ubuntu dependencies installed"
            else
                log_warn "Proot environment detected, but OS type is not Debian/Ubuntu; skipping dependency bundle"
            fi
            ;;
        *)
            log_debug "No environment-specific dependency bundle needed"
            ;;
    esac
}

# Function to install core system packages
install_core_packages() {
    log_section "Core Packages Installation"
    
    local packages=()
    
    # Define packages based on platform
    case "$OS_TYPE" in
        debian|ubuntu|linuxmint)
            packages=(
                "build-essential"
                "libssl-dev"
                "zlib1g-dev"
                "libbz2-dev"
                "libreadline-dev"
                "libsqlite3-dev"
                "libncursesw5-dev"
                "xz-utils"
                "tk-dev"
                "libffi-dev"
                "liblzma-dev"
                "python3-openssl"
                "neofetch"
            )
            ;;
            
        arch|manjaro)
            packages=(
                "base-devel"
                "openssl"
                "zlib"
                "bzip2"
                "readline"
                "sqlite"
                "ncurses"
                "xz"
                "tk"
                "libffi"
                "lzma"
                "neofetch"
            )
            ;;
            
        fedora|centos|rhel)
            packages=(
                "gcc"
                "make"
                "openssl-devel"
                "zlib-devel"
                "bzip2-devel"
                "readline-devel"
                "sqlite-devel"
                "ncurses-devel"
                "xz-devel"
                "tk-devel"
                "libffi-devel"
                "lzma-devel"
                "neofetch"
            )
            ;;
            
        macos)
            packages=()  # Handled by Homebrew in modern_tools
            ;;
            
        termux)
            packages=(
                "binutils"
                "clang"
                "coreutils"
                "curl"
                "git"
                "nodejs"
                "python3"
                "rust"
                "zsh"
                "neofetch"
            )
            ;;
            
        windows)
            packages=()  # Handled by winget/choco
            ;;
    esac
    
    # Install packages
    if [[ ${#packages[@]} -gt 0 ]]; then
        log_info "Installing core packages: ${packages[*]}"
        
        case "$PACKAGE_MANAGER" in
            apt)
                apt_get_install "${packages[@]}"
                ;;
            pacman)
                sudo pacman -Syu --noconfirm "${packages[@]}"
                ;;
            dnf)
                sudo dnf install -y "${packages[@]}"
                ;;
            pkg)
                local mapped_packages=()
                local pkg_name
                for pkg_name in "${packages[@]}"; do
                    mapped_packages+=("$(map_termux_package "$pkg_name")")
                done
                pkg install -y "${mapped_packages[@]}"
                ;;
            *)
                log_warn "Core packages installation not implemented for $PACKAGE_MANAGER"
                ;;
        esac
        
        log_success "Core packages installed"
    else
        log_info "No core packages required for this platform"
    fi
}

# Install Neofetch
install_neofetch() {
    log_section "Neofetch Installation"

    if command -v neofetch >/dev/null 2>&1; then
        log_info "Neofetch already installed"
        return 0
    fi

    case "$PACKAGE_MANAGER" in
        apt)
            apt_get_update
            apt_get_install neofetch
            ;;
        pacman)
            sudo pacman -Syu --noconfirm neofetch
            ;;
        dnf)
            sudo dnf install -y neofetch
            ;;
        pkg)
            pkg update
            pkg install -y neofetch
            ;;
        brew)
            if command -v brew >/dev/null 2>&1; then
                brew install neofetch
            else
                log_warn "Homebrew not available. Please install neofetch manually."
                return 0
            fi
            ;;
        *)
            log_warn "Neofetch installation not implemented for $PACKAGE_MANAGER"
            return 0
            ;;
    esac

    if command -v neofetch >/dev/null 2>&1; then
        log_success "Neofetch installed"
    else
        log_warn "Neofetch installation may have failed"
    fi
}

# Function to install modern development tools
install_modern_tools() {
    log_section "Modern Tools Installation"
    
    local tools_to_install=()
    local missing_tools=()
    
    # Check which tools are already installed
    declare -A tools=(
        ["bat"]="bat"          # Better cat
        ["exa"]="exa"          # Better ls
        ["fd"]="fd-find"       # Better find
        ["ripgrep"]="ripgrep"  # Better grep
        ["fzf"]="fzf"          # Fuzzy finder
        ["htop"]="htop"        # Process viewer
        ["jq"]="jq"            # JSON processor
        ["yq"]="yq"            # YAML processor
        ["zoxide"]="zoxide"    # Smarter cd
        ["delta"]="git-delta"  # Better git diff
        ["dust"]="du-dust"     # Better du
        ["procs"]="procs"      # Better ps
        ["sd"]="sd"            # Better sed
        ["tealdeer"]="tealdeer" # Better tldr
        ["bottom"]="bottom"    # Better top
    )
    
    # Platform-specific package names
    declare -A package_names
    case "$PACKAGE_MANAGER" in
        apt)
            package_names=(
                ["bat"]="bat"
                ["exa"]="eza"
                ["fd"]="fd-find"
                ["ripgrep"]="ripgrep"
                ["fzf"]="fzf"
                ["htop"]="htop"
                ["jq"]="jq"
                ["yq"]="yq"
                ["zoxide"]="zoxide"
                ["delta"]="git-delta"
                ["dust"]="du-dust"
                ["procs"]="procs"
                ["sd"]="sd"
                ["tealdeer"]="tealdeer"
                ["bottom"]="btm"
            )
            ;;
        brew)
            package_names=(
                ["bat"]="bat"
                ["exa"]="exa"
                ["fd"]="fd"
                ["ripgrep"]="ripgrep"
                ["fzf"]="fzf"
                ["htop"]="htop"
                ["jq"]="jq"
                ["yq"]="yq"
                ["zoxide"]="zoxide"
                ["delta"]="git-delta"
                ["dust"]="dust"
                ["procs"]="procs"
                ["sd"]="sd"
                ["tealdeer"]="tealdeer"
                ["bottom"]="bottom"
            )
            ;;
        pacman)
            package_names=(
                ["bat"]="bat"
                ["exa"]="exa"
                ["fd"]="fd"
                ["ripgrep"]="ripgrep"
                ["fzf"]="fzf"
                ["htop"]="htop"
                ["jq"]="jq"
                ["yq"]="yq-go"
                ["zoxide"]="zoxide"
                ["delta"]="git-delta"
                ["dust"]="dust"
                ["procs"]="procs"
                ["sd"]="sd"
                ["tealdeer"]="tealdeer"
                ["bottom"]="bottom"
            )
            ;;
        dnf)
            package_names=(
                ["bat"]="bat"
                ["exa"]="exa"
                ["fd"]="fd-find"
                ["ripgrep"]="ripgrep"
                ["fzf"]="fzf"
                ["htop"]="htop"
                ["jq"]="jq"
                ["yq"]="yq"
                ["zoxide"]="zoxide"
                ["delta"]="git-delta"
                ["dust"]="dust"
                ["procs"]="procs"
                ["sd"]="sd"
                ["tealdeer"]="tealdeer"
                ["bottom"]="bottom"
            )
            ;;
        pkg)
            package_names=(
                ["bat"]="bat"
                ["exa"]="exa"
                ["fd"]="fd"
                ["ripgrep"]="ripgrep"
                ["fzf"]="fzf"
                ["htop"]="htop"
                ["jq"]="jq"
                ["yq"]="yq"
                ["zoxide"]="zoxide"
                ["delta"]="git-delta"
                ["dust"]="dust"
                ["procs"]="procs"
                ["sd"]="sd"
                ["tealdeer"]="tealdeer"
                ["bottom"]="bottom"
            )
            ;;
    esac
    
    # Check which tools are missing
    for tool in "${!tools[@]}"; do
        local tool_installed=false
        case "$tool" in
            exa)
                if command -v exa >/dev/null 2>&1 || command -v eza >/dev/null 2>&1; then
                    tool_installed=true
                fi
                ;;
            bottom)
                if command -v bottom >/dev/null 2>&1 || command -v btm >/dev/null 2>&1; then
                    tool_installed=true
                fi
                ;;
            *)
                if command -v "$tool" >/dev/null 2>&1; then
                    tool_installed=true
                fi
                ;;
        esac

        if [[ "$tool_installed" == "false" ]]; then
            if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
                missing_tools+=("$tool")
            else
                if [[ -n "${package_names[$tool]:-}" ]]; then
                    tools_to_install+=("${package_names[$tool]}")
                else
                    tools_to_install+=("$tool")
                fi
            fi
        fi
    done
    
    # Install missing tools
    if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
        if [[ ${#missing_tools[@]} -gt 0 ]]; then
            log_info "Installing modern tools (apt): ${missing_tools[*]}"
            for tool in "${missing_tools[@]}"; do
                local candidates=()
                case "$tool" in
                    exa)
                        candidates=("eza" "exa")
                        ;;
                    bottom)
                        candidates=("btm" "bottom")
                        ;;
                    *)
                        if [[ -n "${package_names[$tool]:-}" ]]; then
                            candidates=("${package_names[$tool]}")
                        else
                            candidates=("$tool")
                        fi
                        ;;
                esac
                apt_install_optional_candidates "$tool" "${candidates[@]}"
            done

            # Special handling for tools that might need different installation methods
            install_rust_tools
            install_go_tools
            install_python_tools

            log_success "Modern tools installation completed"
        else
            log_info "All modern tools are already installed"
        fi
        return
    fi

    if [[ ${#tools_to_install[@]} -gt 0 ]]; then
        log_info "Installing modern tools: ${tools_to_install[*]}"

        case "$PACKAGE_MANAGER" in
            brew)
                brew install "${tools_to_install[@]}"
                ;;
            pacman)
                sudo pacman -Syu --noconfirm "${tools_to_install[@]}"
                ;;
            dnf)
                sudo dnf install -y "${tools_to_install[@]}"
                ;;
            pkg)
                pkg install -y "${tools_to_install[@]}"
                ;;
            winget)
                for tool in "${tools_to_install[@]}"; do
                    winget install --id "$tool" --silent 2>/dev/null || true
                done
                ;;
            chocolatey)
                for tool in "${tools_to_install[@]}"; do
                    choco install "$tool" -y 2>/dev/null || true
                done
                ;;
            *)
                log_warn "Modern tools installation not implemented for $PACKAGE_MANAGER"
                ;;
        esac

        # Special handling for tools that might need different installation methods
        install_rust_tools
        install_go_tools
        install_python_tools

        log_success "Modern tools installed"
    else
        log_info "All modern tools are already installed"
    fi
}

# Install Rust-based tools via cargo if available
install_rust_tools() {
    if command -v cargo >/dev/null 2>&1; then
        log_info "Installing additional Rust tools via cargo..."
        
        local rust_tools=(
            "starship"     # Cross-shell prompt (if not already installed)
            "du-dust"      # Better du
            "git-delta"    # Better git diff
            "zoxide"       # Smarter cd
        )
        
        for tool in "${rust_tools[@]}"; do
            if ! command -v "$tool" >/dev/null 2>&1; then
                cargo install "$tool" 2>/dev/null || true
            fi
        done
    fi
}

# Install Go-based tools
install_go_tools() {
    if command -v go >/dev/null 2>&1; then
        log_info "Installing Go tools..."
        
        # Example Go tools (uncomment if needed)
        # go install github.com/xxx/xxx@latest
        :
    fi
}

# Install Python-based tools
install_python_tools() {
    if command -v pip3 >/dev/null 2>&1; then
        log_info "Installing Python tools..."
        
        local python_tools=(
            "httpie"        # User-friendly curl replacement
            "pygments"      # Syntax highlighting
            "rich"          # Rich text formatting
            "tqdm"          # Progress bars
        )
        
        for tool in "${python_tools[@]}"; do
            pip3 install --user "$tool" 2>/dev/null || true
        done
    fi
}

# Function to install Nerd Fonts
install_fonts() {
    log_section "Font Installation"
    
    local font_dir=""
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/"
    
    # Determine font directory based on platform
    case "$OS_TYPE" in
        linux|debian|ubuntu|arch|fedora)
            font_dir="$HOME/.local/share/fonts"
            if [[ -n "${IS_WSL:-}" ]]; then
                log_info "WSL detected - fonts installed via Windows"
                font_dir="/mnt/c/Windows/Fonts"
            fi
            ;;
        macos)
            font_dir="$HOME/Library/Fonts"
            ;;
        windows)
            font_dir="C:/Windows/Fonts"
            ;;
        termux)
            font_dir="$HOME/.termux/fonts"
            ;;
        *)
            font_dir="$HOME/.local/share/fonts"
            ;;
    esac
    
    # Create font directory
    mkdir -p "$font_dir"
    
    # List of recommended Nerd Fonts
    local fonts=(
        "CascadiaCode"      # Windows Terminal default
        "FiraCode"          # Popular programming font
        "Meslo"             # Powerlevel10k recommended
        "JetBrainsMono"     # IDE-like font
        "Hack"              # Clear and readable
    )
    
    # Check which fonts are already installed
    local fonts_to_install=()
    for font in "${fonts[@]}"; do
        local font_file="${font_dir}/${font}*.ttf"
        if ! ls "$font_file" 2>/dev/null | grep -q "\.ttf$"; then
            fonts_to_install+=("$font")
        fi
    done
    
    if [[ ${#fonts_to_install[@]} -eq 0 ]]; then
        log_info "Nerd Fonts are already installed"
        return 0
    fi
    
    log_info "Installing Nerd Fonts: ${fonts_to_install[*]}"
    
    # Install fonts
    for font in "${fonts_to_install[@]}"; do
        local font_name="${font// /%20}"
        local font_zip="${font_name}.zip"
        local download_url="${font_url}${font_zip}"
        
        log_info "Downloading ${font}..."
        
             if command -v wget >/dev/null 2>&1; then
            wget -q --show-progress -O "/tmp/${font_zip}" "$download_url"
        elif command -v curl >/dev/null 2>&1; then
            curl -L -# -o "/tmp/${font_zip}" "$download_url"
        else
            log_warn "Cannot download font: wget/curl not available"
            continue
        fi
        
        # Extract and install
        if command -v unzip >/dev/null 2>&1; then
            unzip -q -o "/tmp/${font_zip}" -d "$font_dir"
            log_success "Installed ${font}"
        else
            log_warn "Cannot extract font: unzip not available"
        fi
        
        # Cleanup
        rm -f "/tmp/${font_zip}"
    done
    
    # Update font cache (Linux)
    if [[ "$OS_TYPE" == "linux" ]] && [[ -z "${IS_WSL:-}" ]]; then
        if command -v fc-cache >/dev/null 2>&1; then
            fc-cache -fv "$font_dir"
            log_success "Font cache updated"
        fi
    fi
    
    log_success "Fonts installed to ${font_dir}"
}

# Function to deploy all configurations
deploy_configurations() {
    log_section "Configuration Deployment"
    
    # Create all necessary directories
    local dirs_to_create=(
        "$B10K_DIR"
        "$BLUX10K_CONFIG_DIR"
        "$BLUX10K_CACHE_DIR"
        "$BLUX10K_LOG_DIR"
        "$B10K_DATA_DIR"
        "$B10K_DIR/modules"
        "$B10K_DIR/modules/zsh"
        "$B10K_DIR/modules/bash"
        "$B10K_DIR/modules/tools"
        "$B10K_DIR/themes"
        "$B10K_DIR/plugins"
    )
    
    log_info "Creating directory structure..."
    for dir in "${dirs_to_create[@]}"; do
        mkdir -p "$dir"
        log_debug "Created: $dir"
    done
    
    # Deploy repository configuration templates
    deploy_repo_configs
    
    # Deploy main blux10k configuration
    deploy_blux10k_config
    
    # Deploy shell configurations
    deploy_shell_configs
    
    # Deploy tool configurations
    deploy_tool_configs
    
    # Deploy theme configurations
    deploy_theme_configs
    
    log_success "All configurations deployed"
}

# Deploy repo-provided config files
deploy_config_file() {
    local source="$1"
    local destination="$2"
    local mode="${3:-0644}"
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M%S)"

    if [[ ! -f "${source}" ]]; then
        log_debug "Config source missing, skipping: ${source}"
        return 0
    fi

    mkdir -p "$(dirname "${destination}")"

    if [[ -f "${destination}" ]]; then
        local backup_file="${destination}.bak.${timestamp}"
        cp "${destination}" "${backup_file}"
        log_info "Backed up ${destination} to ${backup_file}"
    fi

    if command -v install >/dev/null 2>&1; then
        install -m "${mode}" "${source}" "${destination}"
    else
        cp "${source}" "${destination}"
        chmod "${mode}" "${destination}"
    fi

    log_success "Installed config: ${destination}"
}

deploy_repo_configs() {
    log_info "Deploying repository configs..."
    
    local source=""
    local destination=""
    local mappings=(
        "${BLUX10K_ROOT_DIR}/configs/starship.toml|${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    )
    
    for mapping in "${mappings[@]}"; do
        source="${mapping%%|*}"
        destination="${mapping##*|}"
        deploy_config_file "${source}" "${destination}" "0644"
    done

    deploy_neofetch_config
}

deploy_neofetch_config() {
    local source="${BLUX10K_ROOT_DIR}/configs/b10k.neofetch.conf"
    local destination="${XDG_CONFIG_HOME:-$HOME/.config}/neofetch/config.conf"
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M%S)"

    if [[ ! -f "${source}" ]]; then
        log_debug "Config source missing, skipping: ${source}"
        return 0
    fi

    mkdir -p "$(dirname "${destination}")"

    if [[ -f "${destination}" ]]; then
        local backup_file="${destination}.bak.${timestamp}"
        mv "${destination}" "${backup_file}"
        log_info "Backed up ${destination} to ${backup_file}"
    fi

    cp "${source}" "${destination}"
    chmod 0644 "${destination}"
    log_success "Installed config: ${destination}"
}

# Deploy main blux10k configuration
deploy_blux10k_config() {
    log_info "Deploying BLUX10K core configuration..."
    
    local blux10k_zsh="${B10K_DIR}/blux10k.zsh"
    local blux10k_tmp
    blux10k_tmp="$(mktemp)"

    cat > "$blux10k_tmp" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Main Configuration
# Generated: $(date)

# ===========================================================================
# ENVIRONMENT VARIABLES
# ===========================================================================

export BLUX10K_VERSION="4.0.0"
export BLUX10K_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
export BLUX10K_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"
export BLUX10K_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/blux10k"

# Add BLUX10K binaries to PATH
export PATH="${BLUX10K_ROOT}/bin:${PATH}"

# ===========================================================================
# SOURCE MODULES
# ===========================================================================

# Source utility functions
if [[ -f "${BLUX10K_ROOT}/modules/core/utils.zsh" ]]; then
    source "${BLUX10K_ROOT}/modules/core/utils.zsh"
fi

# Source plugin configuration
if [[ -f "${BLUX10K_ROOT}/modules/zsh/plugins.zsh" ]]; then
    source "${BLUX10K_ROOT}/modules/zsh/plugins.zsh"
fi

# Source aliases
if [[ -f "${BLUX10K_ROOT}/modules/core/aliases.zsh" ]]; then
    source "${BLUX10K_ROOT}/modules/core/aliases.zsh"
fi

# Source functions
if [[ -f "${BLUX10K_ROOT}/modules/core/functions.zsh" ]]; then
    source "${BLUX10K_ROOT}/modules/core/functions.zsh"
fi

# Source completions
if [[ -f "${BLUX10K_ROOT}/modules/zsh/completions.zsh" ]]; then
    source "${BLUX10K_ROOT}/modules/zsh/completions.zsh"
fi

# ===========================================================================
# SHELL OPTIONS
# ===========================================================================

# Setopt options
setopt autocd               # Change directory without cd
setopt extendedglob         # Extended globbing
setopt nomatch              # Error on no matches
setopt notify               # Report job status immediately
setopt histignorealldups    # Ignore duplicates in history
setopt sharehistory         # Share history between sessions
setopt incappendhistory     # Append to history incrementally

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

# ===========================================================================
# KEY BINDINGS
# ===========================================================================

# Use emacs keybindings
bindkey -e

# Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete key
bindkey '^[[3~' delete-char

# History search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ===========================================================================
# COMPLETION SYSTEM
# ===========================================================================

autoload -Uz compinit
compinit

# Completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${BLUX10K_CACHE}/zcompcache"

# Menu selection
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ===========================================================================
# PLUGIN-SPECIFIC CONFIGURATIONS
# ===========================================================================

# ZSH-Autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# ZSH-Syntax-Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
ZSH_HIGHLIGHT_STYLES[alias]=fg=green
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
ZSH_HIGHLIGHT_STYLES[function]=fg=green
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
ZSH_HIGHLIGHT_STYLES[path_prefix]=underline
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=none
ZSH_HIGHLIGHT_STYLES[redirection]=fg=yellow
ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# ===========================================================================
# FINALIZATION
# ===========================================================================

# Load prompt system (will be added by installer)
# Prompt configuration is added separately based on selection

# Clean up
unset -f __blux10k_source_module

# Success message
if [[ -o interactive ]]; then
    echo -e "BLUX10K v${BLUX10K_VERSION} loaded successfully! 🚀"
fi
EOF

    mv "$blux10k_tmp" "$blux10k_zsh"
    # Make it executable
    chmod +x "$blux10k_zsh"
    
    log_success "BLUX10K core configuration created"
}

# Render prompt block for .zshrc
render_prompt_block() {
    local prompt_engine="$1"

    case "$prompt_engine" in
        p10k|powerlevel10k)
            cat << 'EOF'
# BLUX10K Prompt Engine
export BLUX_PROMPT_ENGINE="p10k"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Powerlevel10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k/powerlevel10k.zsh-theme"
fi

if [[ -f "$HOME/.p10k.zsh" ]]; then
  source "$HOME/.p10k.zsh"
fi
EOF
            ;;
        starship)
            cat << 'EOF'
# BLUX10K Prompt Engine
export BLUX_PROMPT_ENGINE="starship"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
EOF
            ;;
        *)
            cat << 'EOF'
# BLUX10K Prompt Engine
export BLUX_PROMPT_ENGINE="p10k"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi
EOF
            ;;
    esac
}

ensure_neofetch_zshrc_block() {
    local zshrc_file="$HOME/.zshrc"
    local start_marker=">>> BLUX10K NEOFETCH >>>"
    local end_marker="<<< BLUX10K NEOFETCH <<<"

    if [[ ! -f "$zshrc_file" ]]; then
        log_warn "Skipping Neofetch activation block; .zshrc not found"
        return 0
    fi

    if grep -qF "$start_marker" "$zshrc_file" || grep -qF "$end_marker" "$zshrc_file"; then
        log_info "Neofetch activation block already present in .zshrc"
        return 0
    fi

    cat >> "$zshrc_file" << 'EOF'

# >>> BLUX10K NEOFETCH >>>
if command -v neofetch >/dev/null 2>&1; then
  neofetch
fi
# <<< BLUX10K NEOFETCH <<<
EOF

    log_success "Added Neofetch activation block to .zshrc"
}

# Deploy shell-specific configurations
deploy_shell_configs() {
    log_info "Deploying shell configurations..."
    
    # ZSH configuration
    local zshrc_file="$HOME/.zshrc"
    local zshrc_backup="${zshrc_file}.bak.$(date +%Y%m%d-%H%M%S)"
    
    # Backup existing .zshrc
    if [[ -f "$zshrc_file" ]]; then
        cp "$zshrc_file" "$zshrc_backup"
        log_info "Backed up existing .zshrc to $zshrc_backup"
    fi

    local prompt_block
    prompt_block="$(render_prompt_block "$SELECTED_PROMPT")"

    if [[ -f "${BLUX10K_ROOT_DIR}/configs/.zshrc" ]]; then
        if ! grep -q "__BLUX_PROMPT_BLOCK__" "${BLUX10K_ROOT_DIR}/configs/.zshrc"; then
            log_error "Prompt block placeholder missing in template"
            return 1
        fi
        local zshrc_tmp
        local prompt_block_file
        zshrc_tmp="$(mktemp)"
        prompt_block_file="$(mktemp)"
        printf '%s\n' "$prompt_block" > "$prompt_block_file"
        awk -v block_file="$prompt_block_file" '
            $0 == "__BLUX_PROMPT_BLOCK__" {
                while ((getline line < block_file) > 0) {
                    print line
                }
                close(block_file)
                next
            }
            { print }
        ' "${BLUX10K_ROOT_DIR}/configs/.zshrc" > "$zshrc_tmp"
        rm -f "$prompt_block_file"
        mv "$zshrc_tmp" "$zshrc_file"
        log_success "Installed .zshrc from repository template"
    else
        local zshrc_tmp
        zshrc_tmp="$(mktemp)"
        # Create new .zshrc
        cat > "$zshrc_tmp" << EOF
#!/usr/bin/env zsh
# BLUX10K Enhanced ZSH Configuration
# Generated: $(date)

# BLUX10K prompt and OMZ setup
${prompt_block}

# Source BLUX10K main configuration
if [[ -f "${B10K_DIR}/blux10k.zsh" ]]; then
    source "${B10K_DIR}/blux10k.zsh"
else
    echo "BLUX10K configuration not found at ${B10K_DIR}/blux10k.zsh"
    echo "Please run the installer again or check your installation."
fi

# User customizations (won't be overwritten)
if [[ -f "\${ZDOTDIR:-\$HOME}/.zshrc.local" ]]; then
    source "\${ZDOTDIR:-\$HOME}/.zshrc.local"
fi

# Platform-specific configurations
case "\$(uname -s)" in
    Darwin*)
        if [[ -f "\${BLUX10K_ROOT}/modules/platform/macos.zsh" ]]; then
            source "\${BLUX10K_ROOT}/modules/platform/macos.zsh"
        fi
        ;;
    Linux*)
        if [[ -f "\${BLUX10K_ROOT}/modules/platform/linux.zsh" ]]; then
            source "\${BLUX10K_ROOT}/modules/platform/linux.zsh"
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        if [[ -f "\${BLUX10K_ROOT}/modules/platform/windows.zsh" ]]; then
            source "\${BLUX10K_ROOT}/modules/platform/windows.zsh"
        fi
        ;;
esac

# Environment-specific configurations
if [[ -n "\${TERMUX_VERSION:-}" && "\${PREFIX:-}" == /data/data/com.termux/files/usr* ]]; then
    if [[ -f "\${BLUX10K_ROOT}/modules/platform/termux.zsh" ]]; then
        source "\${BLUX10K_ROOT}/modules/platform/termux.zsh"
    fi
fi

if [[ -n "\${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
    if [[ -f "\${BLUX10K_ROOT}/modules/platform/wsl.zsh" ]]; then
        source "\${BLUX10K_ROOT}/modules/platform/wsl.zsh"
    fi
fi
EOF
        mv "$zshrc_tmp" "$zshrc_file"
    fi
    
    # Bash configuration (for systems where bash is primary shell)
    local bashrc_file="$HOME/.bashrc"
    if [[ -f "$bashrc_file" ]]; then
        # Add BLUX10K source line if not already present
        if ! grep -q "blux10k" "$bashrc_file"; then
            cat >> "$bashrc_file" << 'EOF'

# BLUX10K Configuration
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/bashrc" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/bashrc"
fi
EOF
        fi
        
        # Create bash-specific configuration
        local blux10k_bash="${B10K_DIR}/bashrc"
        cat > "$blux10k_bash" << 'EOF'
#!/usr/bin/env bash
# BLUX10K Bash Configuration

# Source common aliases and functions
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/modules/core/aliases.sh" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/modules/core/aliases.sh"
fi

if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/modules/core/functions.sh" ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/blux10k/modules/core/functions.sh"
fi

# Bash-specific configurations
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s dotglob
shopt -s extglob

# Enable programmable completion features
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# Starship prompt for bash (if installed)
if command -v starship >/dev/null 2>&1 && [[ "$BLUX_PROMPT_ENGINE" == "starship" ]]; then
    eval "$(starship init bash)"
fi
EOF
    fi
    
    ensure_neofetch_zshrc_block

    log_success "Shell configurations deployed"
}

# Deploy tool configurations
deploy_tool_configs() {
    log_info "Deploying tool configurations..."
    
    # Git configuration
    local git_config="${B10K_DIR}/modules/tools/git.zsh"
    cat > "$git_config" << 'EOF'
#!/usr/bin/env zsh
# Git Configuration

# Aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log'
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias gs='git status'
alias gst='git status'
alias gsw='git switch'

# Functions
gac() {
    git add . && git commit -m "$1"
}

gacp() {
    git add . && git commit -m "$1" && git push
}

gclean() {
    git fetch --prune && git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}

# Git completion
autoload -Uz compinit && compinit
EOF
    
    # Docker configuration
    local docker_config="${B10K_DIR}/modules/tools/docker.zsh"
    cat > "$docker_config" << 'EOF'
#!/usr/bin/env zsh
# Docker Configuration

# Aliases
alias d='docker'
alias dc='docker-compose'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop'
alias dstart='docker start'
alias dlog='docker logs'
alias dexec='docker exec -it'

# Functions
dclean() {
    docker system prune -a -f
}

dstopall() {
    docker stop $(docker ps -q)
}

drmall() {
    docker rm $(docker ps -a -q)
}
EOF
    
    # Kubernetes configuration
    local k8s_config="${B10K_DIR}/modules/tools/kubernetes.zsh"
    cat > "$k8s_config" << 'EOF'
#!/usr/bin/env zsh
# Kubernetes Configuration

# Aliases
alias k='kubectl'
alias ka='kubectl apply'
alias kd='kubectl describe'
alias ke='kubectl edit'
alias kg='kubectl get'
alias klog='kubectl logs'
alias kpf='kubectl port-forward'
alias kx='kubectl exec -it'

# Context and namespace helpers
alias kc='kubectl config use-context'
alias kn='kubectl config set-context --current --namespace'

# Completion
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi
EOF
    
    log_success "Tool configurations deployed"
}

# Deploy theme configurations
deploy_theme_configs() {
    log_info "Deploying theme configurations..."
    
    # Create theme directory
    local themes_dir="${B10K_DIR}/themes"
    mkdir -p "$themes_dir"
    
    # Powerlevel10k configuration
    local p10k_config="${themes_dir}/p10k-config.zsh"
    if [[ ! -f "$HOME/.p10k.zsh" ]]; then
        cat > "$p10k_config" << 'EOF'
#!/usr/bin/env zsh
# Powerlevel10k Configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k
source "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k/powerlevel10k.zsh-theme"

# Default configuration
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%} "

# Left prompt segments
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context
    dir
    vcs
    newline
    prompt_char
)

# Right prompt segments
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    time
)

# Segment configurations
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"

# VCS segment
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="green"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="yellow"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="red"

# Time segment
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S}"
POWERLEVEL9K_TIME_FOREGROUND="white"
POWERLEVEL9K_TIME_BACKGROUND="black"

# Prompt character
POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="green"
POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="red"

# Command execution time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
EOF
        
        # Symlink to home directory
        ln -sf "$p10k_config" "$HOME/.p10k.zsh"
    fi
    
    # Starship configuration already created in configure_starship function
    
    log_success "Theme configurations deployed"
}

# Function for post-installation setup
post_install_setup() {
    log_section "Post-Installation Setup"
    
    # Set default shell to ZSH if available
    if command -v zsh >/dev/null 2>&1 && [[ "$SHELL" != "$(which zsh)" ]]; then
        if [[ "${ENVIRONMENT}" == "termux" || "${ENVIRONMENT}" == "proot" ]]; then
            log_warn "Skipping automatic shell change in ${ENVIRONMENT}. Set manually if desired:"
            log_info "Manual step: chsh -s $(which zsh)"
        else
            log_info "Setting ZSH as default shell..."
            if chsh -s "$(which zsh)" 2>/dev/null; then
                log_success "Default shell changed to ZSH"
            else
                log_warn "Could not change default shell. You may need to run: chsh -s $(which zsh)"
            fi
        fi
    fi
    
    # Create update script
    create_update_script
    
    # Create uninstall script
    create_uninstall_script
    
    # Set permissions
    set_permissions
    
    # Generate report
    generate_installation_report
    
    log_success "Post-installation setup completed"
}

# Create update script
create_update_script() {
    log_info "Creating update script..."
    
    local update_script="${B10K_DIR}/update.sh"
    local update_tmp
    update_tmp="$(mktemp)"

    cat > "$update_tmp" << 'EOF'
#!/usr/bin/env bash
# BLUX10K Update Script

set -euo pipefail

BLUX10K_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
BLUX10K_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"
LOG_FILE="${BLUX10K_CACHE}/logs/update-$(date +%Y%m%d-%H%M%S).log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== BLUX10K Update Started: $(date) ==="

# Update BLUX10K itself
echo "Updating BLUX10K configuration..."
cd "$BLUX10K_ROOT" || exit 1
if [[ -d ".git" ]]; then
    git pull origin main
else
    echo "BLUX10K not installed via git, skipping update"
fi

# Update Zinit plugins
echo "Updating Zinit plugins..."
if command -v zsh >/dev/null 2>&1; then
    zsh -lc 'source ~/.zshrc; zinit self-update; zinit update --all --parallel'
fi

# Update Powerlevel10k
if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k" ]]; then
    echo "Updating Powerlevel10k..."
    git -C "${XDG_DATA_HOME:-$HOME/.local/share}/blux10k/p10k/powerlevel10k" pull --ff-only
fi

# Update system packages
echo "Updating system packages..."
case "$(uname -s)" in
    Linux*)
        if command -v apt-get >/dev/null 2>&1; then
            if command -v sudo >/dev/null 2>&1 && [[ "$EUID" -ne 0 ]]; then
                sudo apt-get update && sudo apt-get upgrade -y
            else
                apt-get update && apt-get upgrade -y
            fi
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Syu --noconfirm
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf upgrade -y
        fi
        ;;
    Darwin*)
        if command -v brew >/dev/null 2>&1; then
            brew update && brew upgrade
        fi
        ;;
esac

# Update Rust toolchain
if command -v rustup >/dev/null 2>&1; then
    echo "Updating Rust toolchain..."
    rustup update
fi

# Update pip packages
if command -v pip3 >/dev/null 2>&1; then
    echo "Updating Python packages..."
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
fi

echo "=== BLUX10K Update Completed: $(date) ==="
echo "Log file: $LOG_FILE"
EOF
    mv "$update_tmp" "$update_script"
    
    chmod +x "$update_script"
    log_success "Update script created: $update_script"
}

# Create uninstall script
create_uninstall_script() {
    log_info "Creating uninstall script..."
    
    local uninstall_script="${B10K_DIR}/uninstall.sh"
    
    cat > "$uninstall_script" << 'EOF'
#!/usr/bin/env bash
# BLUX10K Uninstall Script

set -euo pipefail

echo "=== BLUX10K Uninstaller ==="
echo "This will remove BLUX10K configuration and restore original shell settings."
echo ""
read -rp "Are you sure you want to uninstall BLUX10K? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

BLUX10K_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
BLUX10K_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/blux10k"
BLUX10K_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"

# Restore original .zshrc if backup exists
ZSH_BACKUP_FILES=("$HOME/.zshrc.bak."*)
if [[ ${#ZSH_BACKUP_FILES[@]} -gt 0 ]] && [[ -e "${ZSH_BACKUP_FILES[-1]}" ]]; then
    echo "Restoring original .zshrc..."
    cp "${ZSH_BACKUP_FILES[-1]}" "$HOME/.zshrc"
fi

# Remove BLUX10K directories
echo "Removing BLUX10K directories..."
rm -rf "$BLUX10K_ROOT"
rm -rf "$BLUX10K_DATA"
rm -rf "$BLUX10K_CACHE"

# Remove from .bashrc if added
if [[ -f "$HOME/.bashrc" ]] && grep -q "blux10k" "$HOME/.bashrc"; then
    echo "Removing BLUX10K from .bashrc..."
    sed -i '/blux10k/d' "$HOME/.bashrc"
fi

echo ""
echo "BLUX10K has been uninstalled."
echo "You may want to manually:"
echo "1. Remove any BLUX10K-related lines from your shell configuration files"
echo "2. Remove installed fonts if desired"
echo "3. Remove any additional tools installed by BLUX10K"
echo ""
echo "Thank you for using BLUX10K!"
EOF
    
    chmod +x "$uninstall_script"
    log_success "Uninstall script created: $uninstall_script"
}

# Set correct permissions
set_permissions() {
    log_info "Setting permissions..."
    
    # Set directory permissions
    chmod 755 "$B10K_DIR"
    chmod 755 "$BLUX10K_CACHE_DIR"
    chmod 755 "$B10K_DATA_DIR"
    
    # Set script permissions
    find "$B10K_DIR" -name "*.sh" -type f -exec chmod +x {} \;
    find "$B10K_DIR" -name "*.zsh" -type f -exec chmod +x {} \;
    
    # Set cache directory permissions
    chmod 700 "$BLUX10K_LOG_DIR"
    
    log_success "Permissions set"
}

# Generate installation report
generate_installation_report() {
    log_info "Generating installation report..."
    
    local report_file="${BLUX10K_LOG_DIR}/installation-report-$(date +%Y%m%d-%H%M%S).txt"
    
    cat > "$report_file" << EOF
BLUX10K Installation Report
===========================
Timestamp: $(date)
Version: ${BLUX10K_VERSION}

System Information:
------------------
Platform: ${OS_TYPE}
OS: ${OS_NAME} ${OS_VERSION:-}
Architecture: ${ARCH}
CPU Cores: ${CPU_CORES}
RAM: ${RAM_GB}GB
Package Manager: ${PACKAGE_MANAGER}
Environment: ${ENVIRONMENT}
${IS_WSL:+WSL Version: ${WSL_VERSION}}
${IS_CONTAINER:+Container: ${IS_CONTAINER}}
${IS_CLOUD:+Cloud Environment: ${IS_CLOUD}}

Installation Summary:
--------------------
Prompt System: ${SELECTED_PROMPT}
Plugin Mode: ${PLUGIN_MODE}
Update Mode: ${UPDATE_MODE}
Installation Directory: ${B10K_DIR}
Data Directory: ${B10K_DATA_DIR}
Cache Directory: ${BLUX10K_CACHE_DIR}

Installed Components:
--------------------
1. Package Manager: ${PACKAGE_MANAGER}
2. Core Dependencies: $(command -v git && command -v curl && command -v zsh | wc -l)/3
3. Zinit: $(command -v zinit >/dev/null 2>&1 && echo "Installed" || echo "Not installed")
4. Prompt System: ${SELECTED_PROMPT}
5. Fonts: $(ls ~/.local/share/fonts/*.ttf 2>/dev/null | wc -l) installed
6. Modern Tools: $(command -v bat exa fd rg fzf | wc -l)/5 installed

Configuration Files:
-------------------
- Main Config: ${B10K_DIR}/blux10k.zsh
- Shell Config: $HOME/.zshrc
- Plugin Config: ${B10K_DIR}/modules/zsh/plugins.zsh
- Tool Configs: ${B10K_DIR}/modules/tools/

Utilities:
----------
- Update Script: ${B10K_DIR}/update.sh
- Uninstall Script: ${B10K_DIR}/uninstall.sh

Next Steps:
-----------
1. Restart your terminal or run: exec zsh
2. Configure your prompt: p10k configure (for Powerlevel10k)
3. Customize settings in: ${B10K_DIR}/
4. Update regularly: ${B10K_DIR}/update.sh

Troubleshooting:
---------------
- Check logs: ${BLUX10K_LOG_DIR}
- Report issues: ${BLUX10K_REPO}/issues
- Documentation: ${BLUX10K_DOCS}

Thank you for installing BLUX10K! 🚀
EOF
    
    log_success "Installation report generated: $report_file"
}

# Finalize installation
finalize_installation() {
    log_section "Finalizing Installation"
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    
    # Print summary
    log_header "Installation Complete"
    
    echo -e "${GREEN}${EMOJI_SUCCESS} BLUX10K v${BLUX10K_VERSION} has been successfully installed!${NC}"
    echo ""
    echo -e "${CYAN}Installation Summary:${NC}"
    echo -e "  Duration: ${WHITE}${duration} seconds${NC}"
    echo -e "  Platform: ${WHITE}${OS_NAME} ${OS_VERSION:-} (${OS_TYPE})${NC}"
    echo -e "  Prompt: ${WHITE}${SELECTED_PROMPT}${NC}"
    echo -e "  Plugins: ${WHITE}${PLUGIN_MODE}${NC}"
    echo ""
    
    echo -e "${CYAN}Next Steps:${NC}"
    echo "  1. ${GREEN}Restart your terminal${NC} or run: ${WHITE}exec zsh${NC}"
    
    if [[ "$SELECTED_PROMPT" == "p10k" || "$SELECTED_PROMPT" == "powerlevel10k" ]]; then
        echo "  2. ${GREEN}Configure Powerlevel10k${NC}: ${WHITE}p10k configure${NC}"
    elif [[ "$SELECTED_PROMPT" == "starship" ]]; then
        echo "  2. ${GREEN}Edit Starship config${NC}: ${WHITE}${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml${NC}"
    fi
    
    echo "  3. ${GREEN}Customize your setup${NC}: ${WHITE}${B10K_DIR}/${NC}"
    echo "  4. ${GREEN}Update regularly${NC}: ${WHITE}${B10K_DIR}/update.sh${NC}"
    echo ""
    
    echo -e "${CYAN}Useful Commands:${NC}"
    echo "  • Update BLUX10K: ${WHITE}${B10K_DIR}/update.sh${NC}"
    echo "  • Uninstall: ${WHITE}${B10K_DIR}/uninstall.sh${NC}"
    echo "  • View logs: ${WHITE}${BLUX10K_LOG_DIR}/${NC}"
    echo ""
    
    echo -e "${CYAN}Documentation:${NC}"
    echo "  • Repository: ${BLUE}${BLUX10K_REPO}${NC}"
    echo "  • Docs: ${BLUE}${BLUX10K_DOCS}${NC}"
    echo "  • Issues: ${BLUE}${BLUX10K_REPO}/issues${NC}"
    echo ""
    
    echo -e "${GREEN}${EMOJI_ROCKET} Welcome to BLUX10K! Enjoy your enhanced terminal experience!${NC}"
    echo ""
    
    # Write completion marker
    echo "COMPLETED:$(date -Iseconds)" >> "${BLUX10K_INSTALL_LOG}"
    
    return 0
}

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                safe_exit 0
                ;;
            -v|--verbose)
                BLUX10K_VERBOSE=1
                shift
                ;;
            -s|--silent)
                BLUX10K_SILENT_INSTALL=1
                shift
                ;;
            --force-platform=*)
                BLUX10K_FORCE_PLATFORM="${1#*=}"
                shift
                ;;
            --prompt=*)
                BLUX10K_PROMPT="${1#*=}"
                shift
                ;;
            --plugin-mode=*)
                BLUX10K_PLUGIN_MODE="${1#*=}"
                shift
                ;;
            --update-mode=*)
                BLUX10K_UPDATE_MODE="${1#*=}"
                shift
                ;;
            --debug)
                BLUX10K_DEBUG=1
                shift
                ;;
            --profile)
                BLUX10K_PROFILE=1
                shift
                ;;
            --version)
                echo "BLUX10K Installer v${BLUX10K_VERSION}"
                safe_exit 0
                ;;
            *)
                log_warn "Unknown argument: $1"
                shift
                ;;
        esac
    done
}

# Function to show help message
show_help() {
    cat << EOF
BLUX10K Enhanced Installer v${BLUX10K_VERSION}

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help                Show this help message
  -v, --verbose             Enable verbose output
  -s, --silent              Silent installation (non-interactive)
      --force-platform=PLATFORM Force specific platform (termux, debian, etc.)
      --prompt=PROMPT       Set prompt system (p10k, powerlevel10k, starship)
      --plugin-mode=MODE    Set plugin mode (complete, essential, minimal, custom)
      --update-mode=MODE    Set update mode (full, plugins, none)
      --profile             Print detected environment and exit
      --debug               Enable debug mode
      --version             Show version information

Examples:
  $(basename "$0")                    # Interactive installation
  $(basename "$0") --silent          # Non-interactive with defaults
  $(basename "$0") --prompt=starship --plugin-mode=essential

Platforms Supported:
  • Linux (Debian/Ubuntu, Arch, Fedora, etc.)
  • macOS
  • Windows (WSL, Git Bash, etc.)
  • Termux (Android)
  • Container environments

Documentation: ${BLUX10K_DOCS}
Repository: ${BLUX10K_REPO}
EOF
}

# ===========================================================================
# ERROR HANDLING AND EXIT
# ===========================================================================

# Global error handler
handle_error() {
    local exit_status=$?
    local line_number=$1
    local command_name=$2
    
    log_error "Installation failed at line ${line_number}: ${command_name}"
    log_error "Exit status: ${exit_status}"
    
    # Try to provide helpful error messages
    case $exit_status in
        1)
            log_error "General error occurred"
            ;;
        2)
            log_error "Missing or invalid arguments"
            ;;
        126)
            log_error "Permission denied"
            ;;
        127)
            log_error "Command not found"
            ;;
        130)
            log_error "Script terminated by user (Ctrl+C)"
            ;;
        *)
            log_error "Unknown error occurred"
            ;;
    esac
    
    # Try to clean up if possible
    cleanup_on_error
    
    # Show troubleshooting tips
    show_troubleshooting_tips
    
    safe_exit $exit_status
}

# Cleanup on error
cleanup_on_error() {
    log_info "Attempting cleanup..."
    
    # Remove partially installed files if they exist
    local temp_files=(
        "/tmp/blux10k-*"
        "${BLUX10K_CACHE_DIR}/temp-*"
    )
    
    for pattern in "${temp_files[@]}"; do
        rm -rf $pattern 2>/dev/null || true
    done
    
    log_info "Cleanup completed"
}

# Show troubleshooting tips
show_troubleshooting_tips() {
    echo ""
    echo -e "${YELLOW}Troubleshooting Tips:${NC}"
    echo "1. Check the installation log: ${BLUX10K_INSTALL_LOG}"
    echo "2. Verify your internet connection"
    echo "3. Ensure you have required permissions"
    echo "4. Check if dependencies are installed: git, curl, zsh"
    echo "5. Try running with --verbose flag for more details"
    echo "6. Report issues at: ${BLUX10K_REPO}/issues"
    echo ""
}

# Set up error trap
trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR

# Interrupt handler
trap 'log_warn "Installation interrupted by user"; safe_exit 130' INT TERM

# ===========================================================================
# MAIN EXECUTION
# ===========================================================================

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

## 4) Workflow Inventory (index only)
none

## 5) Search Index (raw results)

subprocess:
none

os.system:
none

exec(:
none

spawn:
none

shell:
./install.sh
./blux10k-manifest.json
./README.md
./SECURITY.md
./ROADMAP.md
./configs/starship.toml
./configs/b10k.neofetch.conf
./docs/TROUBLESHOOTING.md
./docs/INSTALLATION.md
./docs/PLATFORMS.md

child_process:
none

policy:
none

ethic:
none

enforce:
none

guard:
./README.md

receipt:
none

token:
./install.sh
./docs/CUSTOMIZATION.md
./configs/env.zsh.example

signature:
none

verify:
./README.md
./install.sh

capability:
none

key_id:
none

contract:
none

schema:
none

$schema:
none

json-schema:
none

router:
none

orchestr:
none

execute:
./install.sh

command:
./fonts/install-fonts.sh
./install.sh
./configs/starship.toml
./docs/TROUBLESHOOTING.md
./configs/b10k.neofetch.conf
./docs/INSTALLATION.md

## 6) Notes
none
