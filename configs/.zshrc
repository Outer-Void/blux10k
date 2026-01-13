#!/usr/bin/env bash
# BLUX10K Enhanced Installer v4.1.0
# Universal Cross-Platform Professional Terminal Setup
# Enterprise-Grade | Performance Optimized | Security Hardened

set -euo pipefail
IFS=$'\n\t'

# ===========================================================================
# CONSTANTS & GLOBAL CONFIGURATION
# ===========================================================================

# Version and metadata
readonly BLUX10K_VERSION="4.1.0"
readonly BLUX10K_REPO="https://github.com/Justadudeinspace/blux10k"
readonly BLUX10K_DOCS="https://blux10k.github.io/docs"
readonly B10K_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/blux10k"
readonly BLUX10K_CONFIG_DIR="${B10K_DIR}"
readonly BLUX10K_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/blux10k"
readonly BLUX10K_LOG_DIR="${BLUX10K_CACHE_DIR}/logs"
readonly BLUX10K_INSTALL_LOG="${BLUX10K_LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"
readonly B10K_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/blux10k"
readonly P10K_DIR="${B10K_DATA_DIR}/p10k/powerlevel10k"

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
readonly EMOJI_PLUGIN="🔌"
readonly EMOJI_PROMPT="💻"

# ===========================================================================
# INTERACTIVE MENU SYSTEM
# ===========================================================================

show_interactive_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              BLUX10K Interactive Setup Menu v4.1.0            ║${NC}"
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
║                 BLUX10K ENHANCED INSTALLER v4.1.0             ║
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
# BLUX10K Update Script v4.1.0

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  BLUX10K System Update v4.1.0                 ║${NC}"
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
# BLUX10K Health Check v4.1.0

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
${BLUE}║              BLUX10K INSTALLATION COMPLETE v4.1.0             ║${NC}
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

${GREEN}${EMOJI_ROCKET} BLUX10K v4.1.0 is ready for professional development!${NC}
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
BLUX10K Enhanced Installer v4.1.0

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
