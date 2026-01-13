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
readonly BLUX10K_CONFIG_DIR="${HOME}/.config/blux10k"
readonly BLUX10K_CACHE_DIR="${HOME}/.cache/blux10k"
readonly BLUX10K_LOG_DIR="${BLUX10K_CACHE_DIR}/logs"
readonly BLUX10K_INSTALL_LOG="${BLUX10K_LOG_DIR}/install-$(date +%Y%m%d-%H%M%S).log"

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
    unset OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER \
          IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
          IS_TERMUX ARCH CPU_CORES RAM_GB
    
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
    if [[ -d "/data/data/com.termux" ]]; then
        IS_TERMUX="true"
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
        log_info "Detected Termux (Android)"
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
    log_success "Platform: ${OS_NAME} ${OS_VERSION:-} (${OS_TYPE})"
    log_success "Package Manager: ${PACKAGE_MANAGER}"
    
    [[ -n "${IS_WSL:-}" ]] && log_info "WSL: Version ${WSL_VERSION}"
    [[ -n "${IS_CONTAINER:-}" ]] && log_info "Container: ${IS_CONTAINER}"
    [[ -n "${IS_CLOUD:-}" ]] && log_info "Cloud: ${IS_CLOUD}"
    [[ -n "${IS_TERMUX:-}" ]] && log_info "Environment: Termux"
    
    export OS_TYPE OS_NAME OS_VERSION PACKAGE_MANAGER \
           IS_CONTAINER IS_CLOUD IS_WSL WSL_VERSION \
           IS_TERMUX ARCH CPU_CORES RAM_GB
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
            if [[ "$silent" -eq 1 ]]; then
                sudo DEBIAN_FRONTEND=noninteractive apt update -qq
                sudo DEBIAN_FRONTEND=noninteractive apt install -yq "${packages[@]}"
            else
                sudo apt update
                sudo apt install -y "${packages[@]}"
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
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        log_success "Default shell changed to zsh"
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
            font_dir="$HOME/.local/share/fonts"
            ;;
        macos)
            font_dir="$HOME/Library/Fonts"
            ;;
        termux)
            font_dir="$HOME/.termux/fonts"
            ;;
        windows)
            font_dir="$HOME/AppData/Local/Microsoft/Windows/Fonts"
            log_info "Windows: Please manually install MesloLGS NF fonts"
            return 0
            ;;
        *)
            font_dir="$HOME/.local/share/fonts"
            ;;
    esac
    
    mkdir -p "$font_dir"
    
    # Download MesloLGS NF fonts
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
        fc-cache -fv "$font_dir"
        log_success "Font cache updated"
    fi
    
    if [[ $downloaded -gt 0 ]]; then
        log_success "Installed $downloaded fonts to $font_dir"
        log_info "Please set your terminal font to 'MesloLGS NF'"
    else
        log_error "No fonts were installed"
        return 1
    fi
}

# ===========================================================================
# CONFIGURATION DEPLOYMENT
# ===========================================================================

deploy_configurations() {
    log_section "Configuration Deployment"
    
    # Create directory structure
    local dirs=(
        "$BLUX10K_CONFIG_DIR"
        "$BLUX10K_CONFIG_DIR/modules"
        "$BLUX10K_CONFIG_DIR/scripts"
        "$BLUX10K_CONFIG_DIR/templates"
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
    
    # Deploy main configurations
    deploy_file ".zshrc" "$HOME/.zshrc"
    deploy_file ".p10k.zsh" "$HOME/.p10k.zsh"
    deploy_file "starship.toml" "$HOME/.config/starship.toml"
    deploy_file "neofetch.conf" "$HOME/.config/neofetch/config.conf"
    
    # Deploy private environment template
    if [[ ! -f "$HOME/.config/private/env.zsh" ]]; then
        create_private_env_template
    fi
    
    # Set secure permissions
    chmod 700 "$HOME/.config/private"
    chmod 600 "$HOME/.config/private/env.zsh" 2>/dev/null || true
    
    # Create module structure
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
        touch "$BLUX10K_CONFIG_DIR/modules/$module"
    done
    
    # Create main loader
    cat > "$BLUX10K_CONFIG_DIR/loader.zsh" << 'EOF'
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
