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

# ===========================================================================
# LOGGING SYSTEM WITH MULTI-OUTPUT SUPPORT
# ===========================================================================

# Initialize logging
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
    
    # Detect Termux (Android)
    if [[ -d "/data/data/com.termux" ]] && command -v pkg >/dev/null 2>&1; then
        IS_TERMUX="true"
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
        log_info "Detected Termux (Android)"
    fi

    # Detect proot environments
    if grep -qi "proot" /proc/self/status 2>/dev/null \
        || [[ -n "${PROOT_VERSION:-}" ]] \
        || grep -aq "proot" /proc/1/cmdline 2>/dev/null \
        || { command -v proot >/dev/null 2>&1 && [[ -n "${PROOT_TMP_DIR:-}" || -n "${PROOT_ROOTFS:-}" ]]; }; then
        IS_PROOT="true"
        log_info "Detected proot environment"
    fi

    # Prefer apt in proot if available
    if [[ -n "${IS_PROOT:-}" ]] && command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER="apt"
    fi

    # Ensure package manager is available; fallback between apt and pkg
    if [[ "${PACKAGE_MANAGER}" == "pkg" ]] && ! command -v pkg >/dev/null 2>&1; then
        if command -v apt-get >/dev/null 2>&1; then
            log_warn "pkg not found, falling back to apt"
            PACKAGE_MANAGER="apt"
        else
            log_error "pkg not found and apt-get unavailable. Please install a supported package manager."
            return 1
        fi
    fi

    if [[ "${PACKAGE_MANAGER}" == "apt" ]] && ! command -v apt-get >/dev/null 2>&1; then
        if command -v pkg >/dev/null 2>&1; then
            log_warn "apt-get not found, falling back to pkg"
            PACKAGE_MANAGER="pkg"
        else
            log_error "apt-get not found and pkg unavailable. Please install a supported package manager."
            return 1
        fi
    fi
    
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
                "python3" "python3-pip" "python3-venv" "pipx" "jq" "yq"
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
# SHELL & PROMPT SETUP
# ===========================================================================

install_zsh_plugins() {
    log_section "ZSH Plugin System"
    
    # Skip on Windows (use PowerShell)
    if [[ "$OS_TYPE" == "windows" ]]; then
        log_info "Windows detected, using PowerShell plugins instead"
        return 0
    fi
    
    # Install Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    fi
    
    # Install zinit (fast alternative to zplug)
    if [[ ! -d "$HOME/.local/share/zinit" ]]; then
        log_info "Installing zinit..."
        bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
        log_success "zinit installed"
    fi
    
    # Set zsh as default shell
    local zsh_path
    zsh_path=$(command -v zsh || true)
    if [[ -n "$zsh_path" ]] && [[ "$SHELL" != "$zsh_path" ]]; then
        log_info "Setting zsh as default shell..."
        if chsh -s "$zsh_path" 2>/dev/null; then
            log_success "Default shell changed to zsh"
        else
            log_warn "Could not change default shell. Run manually: chsh -s $zsh_path"
        fi
    fi
}

install_powerlevel10k() {
    log_section "Powerlevel10k"

    if [[ "$OS_TYPE" == "windows" ]]; then
        log_info "Windows detected, skipping Powerlevel10k install"
        return 0
    fi

    mkdir -p "$(dirname "$P10K_DIR")"

    if [[ -d "$P10K_DIR/.git" ]]; then
        log_info "Updating Powerlevel10k..."
        if git -C "$P10K_DIR" pull --ff-only; then
            log_success "Powerlevel10k updated"
        else
            log_warn "Powerlevel10k update failed; continuing"
        fi
    else
        log_info "Installing Powerlevel10k..."
        if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"; then
            log_success "Powerlevel10k installed"
        else
            log_warn "Powerlevel10k install failed; continuing"
        fi
    fi
}

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

    local copied=0
    if [[ -d "fonts/meslolgs-nf" ]]; then
        cp -a "fonts/meslolgs-nf"/. "$font_dir"/
        copied=$((copied + 1))
        log_success "Copied MesloLGS NF fonts to $font_dir"
    fi

    if [[ -d "fonts/alternatives" ]]; then
        cp -a "fonts/alternatives"/. "$font_dir"/
        copied=$((copied + 1))
        log_success "Copied alternative fonts to $font_dir"
    fi

    if [[ $copied -eq 0 ]]; then
        # Fallback to download MesloLGS NF fonts
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

        copied=$downloaded
    fi

    # Update font cache
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$font_dir"
        log_success "Font cache updated"
    fi

    if [[ $copied -gt 0 ]]; then
        log_success "Installed fonts to $font_dir"
        log_info "Please set your terminal font to 'MesloLGS NF'"
    else
        log_error "No fonts were installed"
        return 1
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

    cat > "$entrypoint" << EOF
#!/usr/bin/env zsh
# BLUX10K Entrypoint (generated by install.sh)

export XDG_CONFIG_HOME="\${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="\${XDG_DATA_HOME:-$HOME/.local/share}"
export B10K_DIR="\${XDG_CONFIG_HOME}/blux10k"
export BLUX10K_CONFIG_DIR="\${B10K_DIR}"
export P10K_DIR="\${XDG_DATA_HOME}/blux10k/p10k/powerlevel10k"

b10k_source() {
    local file="\$1"
    if [[ -f "\$file" ]]; then
        source "\$file"
    else
        echo "⚠️  BLUX10K: missing \${file}" >&2
    fi
}

b10k_source "\${B10K_DIR}/modules/zsh/plugins.zsh"
b10k_source "\${B10K_DIR}/modules/zsh/aliases.zsh"
b10k_source "\${B10K_DIR}/modules/zsh/functions.zsh"
b10k_source "\${B10K_DIR}/modules/zsh/keybindings.zsh"

platform="generic"
case "\$(uname -s)" in
    Linux*)
        if [[ -n "\${TERMUX_VERSION:-}" ]] || [[ "\${PREFIX:-}" == *"com.termux"* ]]; then
            platform="termux"
        elif [[ -n "\${WSL_DISTRO_NAME:-}" ]]; then
            platform="wsl"
        else
            platform="linux"
        fi
        ;;
    Darwin*)
        platform="macos"
        ;;
esac

for platform_file in "\${B10K_DIR}/modules/zsh/platform/\${platform}.zsh" "\${B10K_DIR}/modules/zsh/platform/\${platform}-"*.zsh(N); do
    [[ -f "\${platform_file}" ]] && b10k_source "\${platform_file}"
done

b10k_source "\${B10K_DIR}/modules/update/update-core.zsh"

if [[ -f "\${P10K_DIR}/powerlevel10k.zsh-theme" ]]; then
    source "\${P10K_DIR}/powerlevel10k.zsh-theme"
else
    echo "⚠️  BLUX10K: Powerlevel10k not found at \${P10K_DIR}" >&2
fi

if [[ "\${BLUX10K_USE_STARSHIP:-0}" == "1" ]]; then
    if command -v starship >/dev/null 2>&1; then
        eval "\$(starship init zsh)"
    else
        echo "⚠️  BLUX10K: Starship requested but not installed" >&2
    fi
fi
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
    if [[ -d "ci" ]]; then
        sync_repo_dir "ci" "$B10K_DIR/ci"
    fi
    if [[ -d "tests" ]]; then
        sync_repo_dir "tests" "$B10K_DIR/tests"
    fi

    # Starship configuration handling
    local starship_src="configs/starship.toml"
    local starship_dst="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    BLUX10K_STARSHIP_STATUS="not-installed"
    if [[ -f "$starship_src" ]]; then
        if [[ ! -f "$starship_dst" ]]; then
            mkdir -p "$(dirname "$starship_dst")"
            cp "$starship_src" "$starship_dst"
            BLUX10K_STARSHIP_STATUS="installed"
            log_success "Installed starship.toml to $starship_dst"
        else
            BLUX10K_STARSHIP_STATUS="preserved"
            log_info "Preserved existing starship.toml at $starship_dst"
        fi
    fi

    # Deploy neofetch config if present
    deploy_file "b10k.neofetch.conf" "$HOME/.config/neofetch/config.conf"

    # Create BLUX10K entrypoint and ensure zshrc block
    create_blux10k_entrypoint
    ensure_blux10k_block "$HOME/.zshrc"
    
    # Deploy private environment template
    if [[ ! -f "$HOME/.config/private/env.zsh" ]]; then
        create_private_env_template
    fi
    
    # Set secure permissions
    chmod 700 "$HOME/.config/private"
    chmod 600 "$HOME/.config/private/env.zsh" 2>/dev/null || true
    
    # Create module structure (legacy scaffold if no modules present)
    create_module_structure
    
    log_success "Configuration deployment completed"
}

deploy_file() {
    local src_file="$1"
    local dst_file="$2"
    
    if [[ -f "configs/$src_file" ]]; then
        cp "configs/$src_file" "$dst_file"
        log_success "Deployed: $(basename "$dst_file")"
    else
        log_warn "Configuration file not found: $src_file"
    fi
}

create_module_structure() {
    if [[ -d "$B10K_DIR/modules" ]] && ls -1 "$B10K_DIR/modules"/*.zsh >/dev/null 2>&1; then
        log_info "Module files already present; skipping legacy module scaffold"
        return 0
    fi

    local modules=(
        "01-environment.zsh"
        "02-path.zsh"
        "03-options.zsh"
        "04-plugins.zsh"
        "05-completion.zsh"
        "06-aliases.zsh"
        "07-functions.zsh"
        "08-keybindings.zsh"
        "09-tools.zsh"
        "10-theme.zsh"
    )
    
    for module in "${modules[@]}"; do
        touch "$B10K_DIR/modules/$module"
    done
    
    # Create main loader
    cat > "$B10K_DIR/loader.zsh" << 'EOF'
#!/usr/bin/env zsh
# BLUX10K Module Loader v4.0.0

ZMODULES_DIR="${BLUX10K_CONFIG_DIR:-$HOME/.config/blux10k}/modules"

# Load modules in order
for module_file in "$ZMODULES_DIR"/*.zsh(N); do
    if [[ -f "$module_file" ]]; then
        source "$module_file"
    fi
done

# Load user overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
[[ -f "$HOME/.config/private/env.zsh" ]] && source "$HOME/.config/private/env.zsh"
EOF
    
    log_success "Module structure created"
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
# POST-INSTALLATION SETUP
# ===========================================================================

post_install_setup() {
    log_section "Post-Installation Setup"
    
    # Initialize plugin manager
    if [[ "$OS_TYPE" != "windows" ]] && [[ -d "$HOME/.local/share/zinit" ]]; then
        log_info "Initializing zinit..."
        zsh -ic "zinit self-update && zinit update --all" 2>/dev/null || true
    fi
    
    # Create update script
    create_update_script
    
    # Set up health check
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

source "${BLUX10K_CONFIG_DIR}/scripts/colors.sh"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  BLUX10K System Update v4.0.0                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

# Update package manager
case "$(uname -s)" in
    Linux*)
        if command -v apt >/dev/null; then
            sudo apt update && sudo apt upgrade -y
        elif command -v pacman >/dev/null; then
            sudo pacman -Syu
        elif command -v dnf >/dev/null; then
            sudo dnf upgrade -y
        fi
        ;;
    Darwin*)
        brew update && brew upgrade
        ;;
esac

# Update plugins
if [[ -d "$HOME/.local/share/zinit" ]] && command -v zsh >/dev/null 2>&1; then
    zsh -ic "zinit self-update && zinit update --all" >/dev/null 2>&1 || true
fi

# Update configuration
git -C "$BLUX10K_CONFIG_DIR" pull origin main 2>/dev/null || true

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

    if [[ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]]; then
        log_success "Powerlevel10k theme present"
    else
        log_warn "Powerlevel10k theme missing"
    fi

    case "${BLUX10K_STARSHIP_STATUS:-unknown}" in
        installed)
            log_success "Starship config installed"
            ;;
        preserved)
            log_info "Starship config preserved"
            ;;
        not-installed)
            log_info "Starship config not installed"
            ;;
        *)
            log_warn "Starship config status unknown"
            ;;
    esac
}

finalize_installation() {
    log_section "Finalizing Installation"
    
    # Record installation completion
    echo "BLUX10K v${BLUX10K_VERSION} installed $(date -Iseconds)" > "$BLUX10K_CACHE_DIR/installed"
    
    # Set up default shell (skip Windows)
    if [[ "$OS_TYPE" != "windows" ]] && [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Setting zsh as default shell..."
        if chsh -s "$(which zsh)"; then
            log_success "Default shell set to zsh"
        else
            log_warn "Could not change default shell. Run manually: chsh -s $(which zsh)"
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
  • Security: ${BLUX10K_SECURITY_MODE:-standard}
  • Performance: ${BLUX10K_PERF_MODE:-optimized}

${CYAN}🚀 Next Steps:${NC}
  1. ${WHITE}Restart your terminal or run: ${GREEN}exec zsh${NC}
  2. ${WHITE}Configure Powerlevel10k: ${GREEN}p10k configure${NC}
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
    install_zsh_plugins
    install_powerlevel10k
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

Examples:
  ./install.sh                    # Standard installation
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
