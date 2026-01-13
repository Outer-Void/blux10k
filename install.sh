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
        return 1
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
        if ! show_interactive_menu; then
            return 0
        fi
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
    check_permissions || return 1
    
    log_step "3" "Installing package manager..."
    install_package_manager
    
    log_step "4" "Checking dependencies..."
    check_dependencies || return 1
    
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
            sudo apt update -qq
            ;;
            
        brew)
            if ! command -v brew >/dev/null 2>&1; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                if [[ "$OS_TYPE" == "linux" ]]; then
                    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                fi
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
            sudo pacman -Sy --noconfirm
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
            pkg update -y
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
            sudo apt install -y "$dep"
            ;;
        brew)
            brew install "$dep"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$dep"
            ;;
        dnf)
            sudo dnf install -y "$dep"
            ;;
        pkg)
            pkg install -y "$dep"
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
                "python"
                "rust"
                "zsh"
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
                sudo apt install -y "${packages[@]}"
                ;;
            pacman)
                sudo pacman -S --noconfirm "${packages[@]}"
                ;;
            dnf)
                sudo dnf install -y "${packages[@]}"
                ;;
            pkg)
                pkg install -y "${packages[@]}"
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

# Function to install modern development tools
install_modern_tools() {
    log_section "Modern Tools Installation"
    
    local tools_to_install=()
    
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
                ["exa"]="exa"
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
                ["bottom"]="bottom"
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
        if ! command -v "$tool" >/dev/null 2>&1; then
            if [[ -n "${package_names[$tool]:-}" ]]; then
                tools_to_install+=("${package_names[$tool]}")
            else
                tools_to_install+=("$tool")
            fi
        fi
    done
    
    # Install missing tools
    if [[ ${#tools_to_install[@]} -gt 0 ]]; then
        log_info "Installing modern tools: ${tools_to_install[*]}"
        
        case "$PACKAGE_MANAGER" in
            apt)
                sudo apt install -y "${tools_to_install[@]}"
                ;;
            brew)
                brew install "${tools_to_install[@]}"
                ;;
            pacman)
                sudo pacman -S --noconfirm "${tools_to_install[@]}"
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

# Deploy main blux10k configuration
deploy_blux10k_config() {
    log_info "Deploying BLUX10K core configuration..."
    
    local blux10k_zsh="${B10K_DIR}/blux10k.zsh"
    
    cat > "$blux10k_zsh" << 'EOF'
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
    
    # Make it executable
    chmod +x "$blux10k_zsh"
    
    log_success "BLUX10K core configuration created"
}

# Deploy shell-specific configurations
deploy_shell_configs() {
    log_info "Deploying shell configurations..."
    
    # ZSH configuration
    local zshrc_file="$HOME/.zshrc"
    local zshrc_backup="${zshrc_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Backup existing .zshrc
    if [[ -f "$zshrc_file" ]]; then
        cp "$zshrc_file" "$zshrc_backup"
        log_info "Backed up existing .zshrc to $zshrc_backup"
    fi
    
    # Create new .zshrc
    cat > "$zshrc_file" << EOF
#!/usr/bin/env zsh
# BLUX10K Enhanced ZSH Configuration
# Generated: $(date)

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
if command -v starship >/dev/null 2>&1 && [[ "$BLUX10K_PROMPT_SYSTEM" == "starship" ]]; then
    eval "$(starship init bash)"
fi
EOF
    fi
    
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
        log_info "Setting ZSH as default shell..."
        if chsh -s "$(which zsh)" 2>/dev/null; then
            log_success "Default shell changed to ZSH"
        else
            log_warn "Could not change default shell. You may need to run: chsh -s $(which zsh)"
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

    cat > "$update_script" << 'EOF'
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
if command -v zinit >/dev/null 2>&1; then
    zinit update --all --parallel
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
            sudo apt update && sudo apt upgrade -y
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
ZSH_BACKUP_FILES=("$HOME/.zshrc.backup."*)
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
    
    if [[ "$SELECTED_PROMPT" == "powerlevel10k" ]]; then
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
      --prompt=PROMPT       Set prompt system (powerlevel10k, starship, none)
      --plugin-mode=MODE    Set plugin mode (complete, essential, minimal, custom)
      --update-mode=MODE    Set update mode (full, plugins, none)
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
