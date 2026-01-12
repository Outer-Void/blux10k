#!/usr/bin/env bash
# BLUX10K Installer - Professional Developer Terminal Setup
# Universal Cross-Platform Edition

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ ${NC}$1"; }
log_success() { echo -e "${GREEN}✓ ${NC}$1"; }
log_warn() { echo -e "${YELLOW}⚠ ${NC}$1"; }
log_error() { echo -e "${RED}✖ ${NC}$1"; }
log_debug() { echo -e "${CYAN}🐛 ${NC}$1"; }
log_step() { echo -e "${MAGENTA}➜ ${NC}$1"; }

backup_file() {
    local target=$1
    if [[ -f "$target" ]]; then
        local backup_name="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$target" "$backup_name"
        log_success "Backed up $target to $backup_name"
    fi
}

# Print banner
print_banner() {
    cat << 'EOF'
    
╔════════════════════════════════════════════════════════════════╗
║                       BLUX10K INSTALLER                        ║
║          Universal Cross-Platform Terminal Setup v2.0          ║
╚════════════════════════════════════════════════════════════════╝

EOF
}

# Universal platform detection
detect_platform() {
    log_info "Detecting platform with universal support..."
    
    # Reset environment variables
    unset OS_TYPE PACKAGE_MANAGER CONTAINER CLOUD_ENV WSL_VERSION
    
    # Windows detection (native and WSL)
    if [[ "$(uname -s)" == "MINGW"* ]] || [[ "$(uname -s)" == "CYGWIN"* ]]; then
        OS_TYPE="windows-native"
        if command -v winget >/dev/null 2>&1; then
            PACKAGE_MANAGER="winget"
        elif command -v choco >/dev/null 2>&1; then
            PACKAGE_MANAGER="chocolatey"
        else
            PACKAGE_MANAGER="winget"
        fi
        log_success "Detected Windows Native with $PACKAGE_MANAGER"
        
    elif [[ -d "/data/data/com.termux" ]]; then
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
        log_success "Detected Termux"
        
    elif grep -qi "microsoft" /proc/version 2>/dev/null || [[ -d "/mnt/c/Windows" ]]; then
        OS_TYPE="wsl"
        # Detect WSL version
        if grep -qi "WSL2" /proc/version 2>/dev/null; then
            WSL_VERSION="2"
        else
            WSL_VERSION="1"
        fi
        
        # Determine package manager based on distro
        if [[ -f "/etc/os-release" ]]; then
            source /etc/os-release
            case $ID in
                debian|ubuntu|linuxmint)
                    PACKAGE_MANAGER="apt"
                    ;;
                arch|manjaro)
                    PACKAGE_MANAGER="pacman"
                    ;;
                fedora|rhel|centos)
                    PACKAGE_MANAGER="dnf"
                    ;;
                *)
                    PACKAGE_MANAGER="apt"
                    ;;
            esac
        else
            PACKAGE_MANAGER="apt"
        fi
        log_success "Detected WSL $WSL_VERSION with $PACKAGE_MANAGER"
        
    elif [[ "$(uname)" == "Darwin" ]]; then
        OS_TYPE="macos"
        if command -v brew >/dev/null 2>&1; then
            PACKAGE_MANAGER="brew"
        else
            PACKAGE_MANAGER="brew"
            log_warn "Homebrew not installed, will attempt installation"
        fi
        log_success "Detected macOS with Homebrew"
        
    elif [[ "$(uname)" == "FreeBSD" ]]; then
        OS_TYPE="freebsd"
        PACKAGE_MANAGER="pkg"
        log_success "Detected FreeBSD"
        
    elif [[ "$(uname)" == "OpenBSD" ]]; then
        OS_TYPE="openbsd"
        PACKAGE_MANAGER="pkg_add"
        log_success "Detected OpenBSD"
        
    elif [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        case $ID in
            debian|ubuntu|linuxmint|pop|zorin|elementary)
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
        log_success "Detected $PRETTY_NAME ($OS_TYPE)"
        
    elif [[ -f "/etc/chromeos-config" ]] || [[ -d "/mnt/stateful_partition/etc/chromeos-config" ]]; then
        OS_TYPE="chromeos"
        PACKAGE_MANAGER="apt"
        log_success "Detected ChromeOS"
        
    else
        log_warn "Unknown platform, attempting generic Linux setup"
        OS_TYPE="linux"
        PACKAGE_MANAGER="apt"
    fi
    
    # Detect container environments
    if [[ -f "/.dockerenv" ]] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        CONTAINER="docker"
        log_info "Running in Docker container"
    elif [[ -f "/run/.containerenv" ]]; then
        CONTAINER="podman"
        log_info "Running in Podman container"
    fi
    
    # Detect cloud shells
    if [[ -n "${CLOUD_SHELL:-}" ]] || [[ -d "/google" ]]; then
        CLOUD_ENV="google-cloud-shell"
        log_info "Detected Google Cloud Shell"
    elif [[ -n "${CODESPACES:-}" ]]; then
        CLOUD_ENV="github-codespaces"
        log_info "Detected GitHub Codespaces"
    elif [[ -n "${GITPOD_WORKSPACE_ID:-}" ]]; then
        CLOUD_ENV="gitpod"
        log_info "Detected Gitpod"
    fi
    
    # Detect Android via Termux (double-check)
    if [[ -d "/system" ]] && [[ -d "/data/data/com.termux" ]]; then
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
    fi
    
    export OS_TYPE PACKAGE_MANAGER CONTAINER CLOUD_ENV WSL_VERSION
}

# Universal package installer
install_packages() {
    local packages=("$@")
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        log_warn "No packages specified for installation"
        return 0
    fi
    
    log_step "Installing packages: ${packages[*]}"
    
    case $PACKAGE_MANAGER in
        apt)
            sudo apt update || log_warn "apt update failed, continuing..."
            sudo apt install -y "${packages[@]}" || {
                log_error "Failed to install packages with apt"
                return 1
            }
            ;;
        brew)
            brew install "${packages[@]}" || {
                log_warn "Some packages failed to install with brew"
                return 1
            }
            ;;
        pacman)
            sudo pacman -Syu --noconfirm "${packages[@]}" || {
                log_error "Failed to install packages with pacman"
                return 1
            }
            ;;
        dnf|yum)
            sudo dnf upgrade -y || log_warn "dnf upgrade failed, continuing..."
            sudo dnf install -y "${packages[@]}" || {
                log_error "Failed to install packages with dnf"
                return 1
            }
            ;;
        pkg)  # Termux/FreeBSD
            pkg update || log_warn "pkg update failed, continuing..."
            pkg install -y "${packages[@]}" || {
                log_error "Failed to install packages with pkg"
                return 1
            }
            ;;
        winget)
            for pkg in "${packages[@]}"; do
                winget install --id "$pkg" --silent --accept-package-agreements --accept-source-agreements || {
                    log_warn "Failed to install $pkg with winget"
                }
            done
            ;;
        chocolatey)
            for pkg in "${packages[@]}"; do
                choco install "$pkg" -y --no-progress || {
                    log_warn "Failed to install $pkg with chocolatey"
                }
            done
            ;;
        apk)  # Alpine
            sudo apk update || log_warn "apk update failed, continuing..."
            sudo apk add "${packages[@]}" || {
                log_error "Failed to install packages with apk"
                return 1
            }
            ;;
        pkg_add)  # OpenBSD
            doas pkg_add "${packages[@]}" || {
                log_error "Failed to install packages with pkg_add"
                return 1
            }
            ;;
        xbps)  # Void Linux
            sudo xbps-install -Syu "${packages[@]}" || {
                log_error "Failed to install packages with xbps"
                return 1
            }
            ;;
        emerge)  # Gentoo
            sudo emerge --ask n "${packages[@]}" || {
                log_error "Failed to install packages with emerge"
                return 1
            }
            ;;
        *)
            log_error "Unsupported package manager: $PACKAGE_MANAGER"
            return 1
            ;;
    esac
    
    log_success "Packages installed successfully"
    return 0
}

# Dependency checking
check_dependencies() {
    log_info "Checking core dependencies..."
    
    local missing=()
    local critical_deps=("git" "curl")
    
    for cmd in "${critical_deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warn "Missing critical dependencies: ${missing[*]}"
        log_info "Attempting to install missing dependencies..."
        
        case $PACKAGE_MANAGER in
            apt) install_packages "git" "curl" ;;
            brew) install_packages "git" "curl" ;;
            pacman) install_packages "git" "curl" ;;
            dnf) install_packages "git" "curl" ;;
            pkg) install_packages "git" "curl" ;;
            winget) install_packages "Git.Git" "cURL.cURL" ;;
            chocolatey) install_packages "git" "curl" ;;
            *) log_error "Cannot auto-install dependencies on $PACKAGE_MANAGER" ;;
        esac
    fi
    
    # Check for zsh (not critical as we'll install it)
    if ! command -v zsh &> /dev/null; then
        log_info "Zsh not found, will install during setup"
    else
        log_success "Zsh is available"
    fi
    
    log_success "Dependency check completed"
}

# Install base packages
install_base_packages() {
    log_info "Installing base packages for $OS_TYPE..."
    
    case $OS_TYPE in
        debian|ubuntu|wsl)
            install_packages "zsh" "git" "gnupg2" "openssh-client" "curl" "wget" "ca-certificates" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz-utils" "p7zip-full" "unrar" "lsof" \
                "iproute2" "net-tools" "file" "procps" "awk" "sed" "grep"
            ;;
        arch)
            install_packages "zsh" "git" "gnupg" "openssh" "curl" "wget" "ca-certificates" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" \
                "iproute2" "net-tools" "file" "procps-ng" "awk" "sed" "grep"
            ;;
        fedora)
            install_packages "zsh" "git" "gnupg2" "openssh-clients" "curl" "wget" "ca-certificates" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "p7zip-plugins" "unrar" "lsof" \
                "iproute" "net-tools" "file" "procps-ng" "awk" "sed" "grep"
            ;;
        macos)
            # Install Homebrew if not available
            if ! command -v brew >/dev/null 2>&1; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            install_packages "zsh" "git" "gnupg" "openssh" "curl" "wget" "coreutils" "findutils" \
                "unzip" "p7zip" "unrar" "gnu-tar" "gnu-sed" "lsof" "iproute2mac"
            ;;
        termux)
            install_packages "zsh" "git" "gnupg" "openssh" "curl" "wget" "coreutils" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" "procps"
            ;;
        windows-native)
            log_info "Windows native: Base packages handled by package manager"
            ;;
        freebsd)
            install_packages "zsh" "git" "gnupg" "openssh" "curl" "wget" "ca_root_nss" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" \
                "net-tools" "file" "procps" "awk" "gsed" "ggrep"
            ;;
        openbsd)
            install_packages "zsh" "git" "gnupg" "openssh" "curl" "wget" \
                "unzip" "zip" "gtar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" \
                "net-tools" "file" "procps" "awk" "gnused" "gnugrep"
            ;;
        alpine)
            install_packages "zsh" "git" "gnupg" "openssh-client" "curl" "wget" "ca-certificates" \
                "unzip" "zip" "tar" "gzip" "bzip2" "xz" "p7zip" "unrar" "lsof" \
                "iproute2" "net-tools" "file" "procps" "awk" "sed" "grep"
            ;;
        *)
            log_warn "Unknown OS type $OS_TYPE, attempting generic package installation"
            install_packages "zsh" "git" "curl" "wget" "unzip" "tar" "gzip"
            ;;
    esac
    
    log_success "Base packages installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    # Skip on Windows Native (use Oh My Posh instead)
    if [[ "$OS_TYPE" == "windows-native" ]]; then
        log_info "Skipping Oh My Zsh on Windows Native (using Oh My Posh)"
        return 0
    fi
    
    log_info "Installing Oh My Zsh..."
    
    # Backup existing .zshrc if it exists
    if [[ -f ~/.zshrc ]]; then
        local backup_name=".zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        cp ~/.zshrc ~/"$backup_name"
        log_success "Backed up existing .zshrc to $backup_name"
    fi
    
    # Install Oh My Zsh
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        log_success "Oh My Zsh installed successfully"
    else
        log_error "Oh My Zsh installation failed"
        return 1
    fi
}

# Install zplug
install_zplug() {
    # Skip on Windows Native
    if [[ "$OS_TYPE" == "windows-native" ]]; then
        log_info "Skipping zplug on Windows Native"
        return 0
    fi
    
    log_info "Installing zplug..."
    
    if curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh; then
        log_success "zplug installed successfully"
    else
        log_error "zplug installation failed"
        return 1
    fi
}

# Universal font installation
install_fonts_universal() {
    log_info "Installing MesloLGS NF fonts..."
    
    local font_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
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
        windows-native)
            font_dir="$HOME/AppData/Local/Microsoft/Windows/Fonts"
            log_info "Windows: Please manually install MesloLGS NF fonts"
            return 0
            ;;
        freebsd|openbsd)
            font_dir="$HOME/.local/share/fonts"
            ;;
        *)
            font_dir="$HOME/.local/share/fonts"
            ;;
    esac
    
    mkdir -p "$font_dir"
    
    local fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )
    
    local success_count=0
    for font in "${fonts[@]}"; do
        local font_file="${font//%20/ }"
        if curl -fSL "$font_url/$font" -o "$font_dir/$font_file"; then
            log_success "Downloaded $font_file"
            ((success_count++))
        else
            log_warn "Failed to download $font_file"
        fi
    done
    
    # Update font cache on Linux/BSD systems
    if command -v fc-cache &> /dev/null; then
        fc-cache -fv "$font_dir"
        log_success "Font cache updated"
    fi
    
    if [[ $success_count -gt 0 ]]; then
        log_success "$success_count fonts installed - please set your terminal font to MesloLGS NF"
    else
        log_error "No fonts were installed successfully"
        return 1
    fi
}

# Modern tools installer with fallbacks
install_modern_tools_universal() {
    log_info "Installing modern development tools..."
    
    local base_tools=("neovim" "fzf" "ripgrep" "jq" "bat" "git" "curl" "wget")
    local platform_specific=()
    local universal_tools=()
    
    case $OS_TYPE in
        windows-native)
            platform_specific=("eza" "zoxide" "fd" "gh")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        debian|ubuntu|wsl)
            platform_specific=("fd-find" "python3" "python3-pip" "pipx" "nodejs" "npm")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            
            # Install tools that might not be in package manager
            install_via_cargo "eza" "zoxide"
            create_debian_symlinks
            ;;
        macos)
            platform_specific=("eza" "zoxide" "fd" "python" "node" "gh")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        termux)
            platform_specific=("eza" "zoxide" "fd" "python" "nodejs")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        arch)
            platform_specific=("eza" "zoxide" "fd" "python" "nodejs" "npm" "github-cli")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        fedora)
            platform_specific=("eza" "zoxide" "fd-find" "python3" "nodejs" "npm" "gh")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        freebsd)
            platform_specific=("eza" "zoxide" "fd" "python3" "node" "npm")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        openbsd)
            platform_specific=("eza" "zoxide" "fd" "python3" "node")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        alpine)
            platform_specific=("eza" "zoxide" "fd" "python3" "nodejs" "npm")
            install_packages "${base_tools[@]}" "${platform_specific[@]}"
            ;;
        *)
            log_warn "Using generic tool installation for $OS_TYPE"
            install_packages "${base_tools[@]}"
            install_via_cargo "eza" "zoxide"
            ;;
    esac
    
    # Install additional universal tools via cargo if available
    if command -v cargo >/dev/null 2>&1; then
        install_via_cargo "bat" "fd" "ripgrep" "eza" "zoxide"
    fi
    
    log_success "Modern tools installation completed"
}

# Helper function to install tools via cargo
install_via_cargo() {
    local tools=("$@")
    
    if ! command -v cargo >/dev/null 2>&1; then
        log_info "Cargo not available, skipping cargo installations"
        return 0
    fi
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            log_info "Installing $tool via cargo..."
            cargo install "$tool" --locked 2>/dev/null && log_success "Installed $tool" || log_warn "Failed to install $tool"
        fi
    done
}

# Helper function for Debian/Ubuntu symlinks
create_debian_symlinks() {
    mkdir -p ~/.local/bin
    [[ -f "/usr/bin/batcat" ]] && ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
    [[ -f "/usr/bin/fdfind" ]] && ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true
}

# Deploy configuration files
deploy_configs() {
    log_info "Deploying configuration files..."
    
    # Create necessary directories
    mkdir -p ~/.config/neofetch ~/.config/private ~/.config/blux10k ~/.local/{bin,share,state} ~/.cache
    
    # Windows Native uses different config approach
    if [[ "$OS_TYPE" == "windows-native" ]]; then
        deploy_windows_configs
        return 0
    fi
    
    # Deploy .zshrc
    if [[ -f "$REPO_ROOT/configs/.zshrc" ]]; then
        backup_file ~/.zshrc
        cp "$REPO_ROOT/configs/.zshrc" ~/.zshrc
        log_success "Deployed custom .zshrc"
    else
        log_warn "Custom .zshrc not found, using template"
        create_zshrc_template
    fi
    
    # Deploy p10k config
    if [[ -f "$REPO_ROOT/configs/.p10k.zsh" ]]; then
        backup_file ~/.p10k.zsh
        cp "$REPO_ROOT/configs/.p10k.zsh" ~/.p10k.zsh
        log_success "Deployed p10k configuration"
    else
        create_p10k_template
    fi
    
    # Deploy neofetch config
    if [[ -f "$REPO_ROOT/configs/b10k.neofetch.conf" ]]; then
        backup_file ~/.config/neofetch/config.conf
        cp "$REPO_ROOT/configs/b10k.neofetch.conf" ~/.config/neofetch/config.conf
        cp "$REPO_ROOT/configs/b10k.neofetch.conf" ~/.config/neofetch/b10k.neofetch.conf
        log_success "Deployed neofetch configuration"
    else
        create_neofetch_template
    fi
    
    # Deploy starship config if available
    if [[ -f "$REPO_ROOT/configs/starship.toml" ]]; then
        mkdir -p ~/.config
        backup_file ~/.config/starship.toml
        cp "$REPO_ROOT/configs/starship.toml" ~/.config/starship.toml
        log_success "Deployed starship configuration"
    fi
    
    # Create private env template
    if [[ ! -f ~/.config/private/env.zsh ]]; then
        create_private_env_template
    fi
    
    log_success "Configuration files deployed"
}

record_install_location() {
    local config_dir=\"$HOME/.config/blux10k\"
    mkdir -p \"$config_dir\"
    cat > \"$config_dir/install.conf\" << EOF
# BLUX10K install location
BLUX10K_HOME=\"$REPO_ROOT\"
EOF
    log_success \"Recorded install location in $config_dir/install.conf\"
}

install_cli() {
    local bin_dir=\"$HOME/.local/bin\"
    mkdir -p \"$bin_dir\"
    if [[ -x \"$REPO_ROOT/scripts/b10k\" ]]; then
        cp \"$REPO_ROOT/scripts/b10k\" \"$bin_dir/b10k\"
        chmod +x \"$bin_dir/b10k\"
        log_success \"Installed b10k command to $bin_dir/b10k\"
    else
        log_warn \"b10k script not found or not executable\"
    fi
}

# Windows-specific configuration deployment
deploy_windows_configs() {
    log_info "Deploying Windows-specific configurations..."
    
    # Create PowerShell profile if it doesn't exist
    local ps_profile="$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    mkdir -p "$(dirname "$ps_profile")"
    
    if [[ ! -f "$ps_profile" ]]; then
        cat > "$ps_profile" << 'EOF'
# BLUX10K Windows PowerShell Profile
# Universal Cross-Platform Development Environment

# Import Oh My Posh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
}

# Aliases for Unix-like experience
function which { Get-Command $args }
function grep { Select-String $args }
function touch { New-Item $args }

# Environment variables
$env:EDITOR = "nvim"

Write-Host "BLUX10K Windows Environment Loaded" -ForegroundColor Green
EOF
        log_success "Created PowerShell profile"
    fi
    
    # Create basic git config if none exists
    if ! git config --global user.name >/dev/null 2>&1; then
        git config --global user.name "BLUX10K User"
        git config --global user.email "user@blux10k.local"
        log_info "Set default git config"
    fi
}

# Set zsh as default shell
setup_zsh_default() {
    # Skip on Windows Native
    if [[ "$OS_TYPE" == "windows-native" ]]; then
        log_info "Windows Native: PowerShell remains default shell"
        return 0
    fi
    
    log_info "Setting zsh as default shell..."
    
    local zsh_path
    zsh_path=$(which zsh 2>/dev/null || echo "/bin/zsh")
    
    if [[ ! -x "$zsh_path" ]]; then
        log_error "Zsh not found at $zsh_path"
        return 1
    fi
    
    if [[ "$SHELL" != "$zsh_path" ]]; then
        if chsh -s "$zsh_path" 2>/dev/null; then
            log_success "Zsh set as default shell"
        else
            log_warn "Could not change default shell (may require manual intervention)"
            log_info "You can manually set default shell with: chsh -s $(which zsh)"
        fi
    else
        log_success "Zsh is already the default shell"
    fi
}

# Initialize plugins
initialize_plugins() {
    # Skip on Windows Native
    if [[ "$OS_TYPE" == "windows-native" ]]; then
        log_info "Windows Native: Plugin initialization not required"
        return 0
    fi
    
    log_info "Initializing plugins..."
    
    # Source zsh to initialize plugins
    if zsh -ic "zplug install" 2>/dev/null; then
        log_success "Plugins installed and initialized"
    else
        log_warn "Plugin installation had issues, may need manual intervention"
    fi
}

# Final message with platform-specific notes
final_message() {
    case $OS_TYPE in
        windows-native)
            cat << 'EOF'

╔════════════════════════════════════════════════════════════════╗
║                 WINDOWS INSTALLATION COMPLETE                 ║
╚════════════════════════════════════════════════════════════════╝

Next steps for Windows:
1. Install MesloLGS NF fonts manually from:
   https://github.com/romkatv/powerlevel10k-media/raw/master
2. Set your Windows Terminal font to "MesloLGS NF"
3. Restart PowerShell or Windows Terminal
4. Configure Oh My Posh: oh-my-posh init pwsh | Invoke-Expression
5. Edit your PowerShell profile for customizations

EOF
            ;;
        termux)
            cat << 'EOF'

╔════════════════════════════════════════════════════════════════╗
║                   TERMUX INSTALLATION COMPLETE                ║
╚════════════════════════════════════════════════════════════════╝

Next steps for Termux:
1. Set Termux font to MesloLGS NF in Termux settings
2. Restart Termux or run: exec zsh
3. Run 'p10k configure' to customize your prompt
4. Edit ~/.config/private/env.zsh with your API keys
5. Consider installing Termux:API for enhanced functionality

EOF
            ;;
        *)
            cat << 'EOF'

╔════════════════════════════════════════════════════════════════╗
║                     INSTALLATION COMPLETE                     ║
╚════════════════════════════════════════════════════════════════╝

Next steps:
1. Set your terminal font to "MesloLGS NF"
2. Restart your terminal or run: exec zsh
3. Run 'p10k configure' to customize your prompt
4. Edit ~/.config/private/env.zsh with your API keys
5. Generate SSH keys if needed: ssh-keygen -t ed25519
6. Configure git: git config --global user.name "Your Name"

EOF
            ;;
    esac
    
    cat << EOF
BLUX10K supports the following platforms:
✓ Windows Native (PowerShell + Oh My Posh)
✓ Windows Subsystem for Linux (WSL1/WSL2)  
✓ macOS (Homebrew)
✓ Linux (Debian, Ubuntu, Arch, Fedora, Alpine, etc.)
✓ BSD (FreeBSD, OpenBSD)
✓ Termux (Android)
✓ ChromeOS (Linux container)
✓ Cloud Shells (Google Cloud, GitHub Codespaces, Gitpod)

Enjoy your universal development environment!

EOF
}

# Template creation functions
create_zshrc_template() {
    cat > ~/.zshrc << 'EOF'
# BLUX10K - Professional Developer Terminal Setup
# https://github.com/Justadudeinspace/blux10k

# Load install config if available
if [[ -f "$HOME/.config/blux10k/install.conf" ]]; then
    source "$HOME/.config/blux10k/install.conf"
fi

export BLUX10K_HOME="${BLUX10K_HOME:-$HOME/Projects/blux10k}"
export PATH="$HOME/.local/bin:$PATH"

# Zplug setup
if [[ -f "$HOME/.zplug/init.zsh" ]]; then
    source "$HOME/.zplug/init.zsh"

    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"
    zplug "agkozak/zsh-z"
    zplug "romkatv/powerlevel10k", as:theme, depth:1

    if ! zplug check; then
        zplug install
    fi

    zplug load
fi

# Private environment
[[ -f "$HOME/.config/private/env.zsh" ]] && source "$HOME/.config/private/env.zsh"

# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh"

HISTFILE="${XDG_STATE_HOME}/zsh/history-$(date +%Y-%m)"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# BLUX10K modules
if [[ -d "$BLUX10K_HOME/modules" ]]; then
    for module in "$BLUX10K_HOME/modules/zsh/aliases.zsh" \
                  "$BLUX10K_HOME/modules/zsh/functions.zsh" \
                  "$BLUX10K_HOME/modules/update/update-core.zsh"; do
        [[ -f "$module" ]] && source "$module"
    done
fi

# Load additional configurations
for config_file in "$HOME/.config/zsh"/*.zsh(N); do
    [[ -f "$config_file" ]] && source "$config_file"
done

EOF
    log_success "Created .zshrc template"
}

create_p10k_template() {
    cat > ~/.p10k.zsh << 'EOF'
# Config for Powerlevel10k with lean style
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Simple prompt configuration
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_SHOW_RULER=false

# Directory truncation
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=..
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

# Colors
typeset -g POWERLEVEL9K_DIR_FOREGROUND=4
typeset -g POWERLEVEL9K_DIR_BACKGROUND=0
EOF
    log_success "Created p10k template"
}

create_neofetch_template() {
    cat > ~/.config/neofetch/config.conf << 'EOF'
print_info() {
    info title
    info underline
    info "User" "$(whoami)"
    info "OS" "BLUX10K Universal Terminal"
    info "Shell" "$SHELL"
    info "Terminal" "$TERM"
    info "Platform" "$(uname -s)"
    info underline
}

ascii_distro="arch"
colors=(4 7 1 3 6)
EOF
    log_success "Created neofetch template"
}

create_private_env_template() {
    cat > ~/.config/private/env.zsh << 'EOF'
# Private environment variables
# Add your API keys, tokens, and sensitive data here
# This file is not tracked by git and has 0600 permissions

# Example:
# export OPENAI_API_KEY='your-key-here'
# export GITHUB_TOKEN='your-token-here'
# export SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

# BLUX Ecosystem Integration
# export BLUX_HOME="$HOME/.blux"
# export DATSCAN_HOME="$HOME/dev/dat-scan"

echo "Private environment loaded"
EOF
    chmod 0600 ~/.config/private/env.zsh
    log_success "Created private environment template"
}

# Help function
show_help() {
    cat << 'EOF'
BLUX10K Universal Installer - Cross-Platform Developer Terminal Setup

Usage: ./install.sh [OPTIONS]

Options:
  --help, -h          Show this help message
  --windows           Run Windows Native installation (PowerShell)
  --platform-only     Detect and show platform information only
  --skip-deps         Skip dependency checks
  --skip-fonts        Skip font installation
  --minimal           Minimal installation (core components only)

Supported Platforms:
  • Windows Native (PowerShell + Winget/Chocolatey)
  • Windows Subsystem for Linux (WSL1/WSL2)
  • macOS (Homebrew)
  • Linux (Debian, Ubuntu, Arch, Fedora, Alpine, Void, Gentoo)
  • BSD (FreeBSD, OpenBSD)
  • Termux (Android)
  • ChromeOS (Linux container)
  • Cloud Shells (Google Cloud, GitHub Codespaces, Gitpod)

Environment Variables:
  BLUX10K_MINIMAL=1    Minimal installation
  BLUX10K_SKIP_FONTS=1 Skip font installation

Examples:
  ./install.sh                    # Auto-detect and install
  ./install.sh --windows          # Windows Native installation
  ./install.sh --platform-only    # Show detected platform info
  BLUX10K_MINIMAL=1 ./install.sh  # Minimal installation

EOF
}

# Main installation flow
main() {
    print_banner
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --windows)
                if [[ "$(uname -s)" != "MINGW"* ]] && [[ "$(uname -s)" != "CYGWIN"* ]]; then
                    log_error "Windows Native installation requested but not on Windows"
                    exit 1
                fi
                ;;
            --platform-only)
                detect_platform
                echo "Platform: $OS_TYPE"
                echo "Package Manager: $PACKAGE_MANAGER"
                [[ -n "${CONTAINER:-}" ]] && echo "Container: $CONTAINER"
                [[ -n "${CLOUD_ENV:-}" ]] && echo "Cloud Environment: $CLOUD_ENV"
                [[ -n "${WSL_VERSION:-}" ]] && echo "WSL Version: $WSL_VERSION"
                exit 0
                ;;
            --skip-deps)
                SKIP_DEPS=1
                ;;
            --skip-fonts)
                SKIP_FONTS=1
                ;;
            --minimal)
                MINIMAL_INSTALL=1
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
    
    log_info "Starting universal BLUX10K installation..."
    
    # Platform detection
    detect_platform
    
    # Installation steps
    if [[ -z "${SKIP_DEPS:-}" ]]; then
        check_dependencies
    else
        log_info "Skipping dependency checks"
    fi
    
    install_base_packages
    
    if [[ -z "${MINIMAL_INSTALL:-}" ]]; then
        install_oh_my_zsh
        install_zplug
        
        if [[ -z "${SKIP_FONTS:-}" ]]; then
            install_fonts_universal
        else
            log_info "Skipping font installation"
        fi
        
        install_modern_tools_universal
    else
        log_info "Minimal installation - skipping additional components"
    fi
    
    deploy_configs
    record_install_location
    install_cli
    setup_zsh_default
    
    if [[ -z "${MINIMAL_INSTALL:-}" ]]; then
        initialize_plugins
    fi
    
    final_message
}

# Error handling
trap 'log_error "Installation failed at line $LINENO"; exit 1' ERR

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
