#!/usr/bin/env bash
# BLUX10K Enhanced Installer v4.0.0
# Universal Cross-Platform Professional Terminal Setup
# Enterprise-Grade | Performance Optimized | Security Hardened

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
        exit 0
    fi
    
    echo ""
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
    
    # Detect proot environments
    if grep -qi "proot" /proc/self/status 2>/dev/null \
        || [[ -n "${PROOT_VERSION:-}" ]] \
        || grep -aq "proot" /proc/1/cmdline 2>/dev/null \
        || { command -v proot >/dev/null 2>&1 && [[ -n "${PROOT_TMP_DIR:-}" || -n "${PROOT_ROOTFS:-}" ]]; }; then
        IS_PROOT="true"
        log_info "Detected proot environment"
    fi

    if [[ "${platform_forced}" != "true" ]] && [[ "${OS_TYPE}" == "debian" ]] && command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER="apt"
        apt_locked="true"
    fi

    # Prefer apt in proot if available
    if [[ -n "${IS_PROOT:-}" ]] && command -v apt-get >/dev/null 2>&1 && [[ "${platform_forced}" != "true" ]]; then
        PACKAGE_MANAGER="apt"
    fi

    if [[ "${PREFIX:-}" == *"/data/data/com.termux/files/usr"* ]]; then
        termux_prefix="true"
    fi

    if [[ -n "${TERMUX_VERSION:-}" ]]; then
        termux_version="true"
    fi

    if [[ "$(uname -o 2>/dev/null)" == "Android" ]] || [[ -f "/system/build.prop" ]]; then
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
# ZINIT INSTALLATION & MANAGEMENT
# ===========================================================================

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
    
    # Load zinit in current shell for plugin installation
    if [[ -f "$zinit_home/zinit.zsh" ]]; then
        source "$zinit_home/zinit.zsh"
        log_success "Zinit loaded"
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
    
    cat > "$plugins_file" << EOF
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
    
    log_success "ZSH plugins configuration created"
    
    # Install plugins
    log_info "Installing plugins via Zinit..."
    
    # Source zinit and load plugins
    if [[ -f "$plugins_file" ]]; then
        source "$plugins_file"
        
        # Trigger plugin installation
        zinit update --all --quiet --no-pager
        log_success "Zinit plugins installed/updated"
    else
        log_error "Plugins configuration file not found"
        return 1
    fi
}

update_zinit_plugins() {
    log_section "Updating Zinit Plugins"
    
    if command -v zinit >/dev/null 2>&1; then
        log_info "Updating all Zinit plugins..."
        zinit update --all --parallel
        log_success "Zinit plugins updated"
    else
        log_warn "Zinit not found, skipping plugin update"
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
    echo "export BLUX10K_PROMPT_SYSTEM=\"powerlevel10k\"" >> "${B10K_DIR}/blux10k.zsh"
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
        log_success "Starship configuration created"
    else
        log_info "Starship configuration already exists"
    fi
    
    # Add to blux10k entrypoint
    echo "export BLUX10K_PROMPT_SYSTEM=\"starship\"" >> "${B10K_DIR}/blux10k.zsh"
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

if [[ -f "${BLUX10K_ROOT_DIR}/configs/.zshrc" ]]; then
    # shellcheck source=configs/.zshrc
    source "${BLUX10K_ROOT_DIR}/configs/.zshrc"
fi

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
    log_step "1" "Detecting platform..."
    detect_platform
    
    log_step "2" "Checking permissions..."
    check_permissions || exit 1
    
    log_step "3" "Installing package manager..."
    install_package_manager
    
    log_step "4" "Checking dependencies..."
    check_dependencies || exit 1
    
    log_step "5" "Installing core packages..."
    install_core_packages
    
    log_step "6" "Installing modern tools..."
    install_modern_tools
    
    log_step "7" "Installing Zinit..."
    install_zinit
    
    log_step "8" "Installing ZSH plugins..."
    install_zsh_plugins_via_zinit
    
    log_step "9" "Installing prompt system..."
    install_prompt_system
    
    log_step "10" "Installing fonts..."
    install_fonts
    
    log_step "11" "Deploying configurations..."
    deploy_configurations
    
    log_step "12" "Running updates..."
    run_updates
    
    log_step "13" "Post-installation setup..."
    post_install_setup
    
    log_step "14" "Finalizing installation..."
    finalize_installation
    
    exit 0
}

# ===========================================================================
# REMAINING FUNCTIONS (from original script)
# ===========================================================================

# [Include all the remaining functions from your original script here:
# check_permissions, install_package_manager, check_dependencies,
# install_core_packages, install_modern_tools, install_fonts,
# deploy_configurations, post_install_setup, finalize_installation,
# parse_arguments, show_help, and all supporting functions]

# Note: Due to character limits, I've included the critical new functions.
# You'll need to merge these with your existing functions.
# The key additions are:
# 1. Interactive menu system (show_interactive_menu, select_custom_plugins)
# 2. Zinit installation & management (install_zinit, install_zsh_plugins_via_zinit, update_zinit_plugins)
# 3. Prompt selection system (install_prompt_system, install_powerlevel10k, configure_powerlevel10k, install_starship, configure_starship)
# 4. Update management (run_updates, update_system_packages, update_custom_tools)

# Error handling
trap 'log_error "Installation failed at line $LINENO"; exit 1' ERR

# Run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
