#!/usr/bin/env bash

# Ubuntu/Debian specific installations for BLUX10K

set -euo pipefail

echo "Installing BLUX10K packages for Ubuntu/Debian..."

apt_has_candidate() {
    local pkg="$1"
    local candidate

    candidate="$(apt-cache policy "$pkg" 2>/dev/null | awk '/Candidate:/ {print $2; exit}')"
    [[ -n "$candidate" && "$candidate" != "(none)" ]]
}

resolve_packages() {
    local packages=("$@")
    local resolved=()

    for pkg in "${packages[@]}"; do
        if apt_has_candidate "$pkg"; then
            resolved+=("$pkg")
            continue
        fi

        if [[ "$pkg" == "unrar" ]]; then
            local fallback="unrar-free"
            if apt_has_candidate "$fallback"; then
                printf 'Warning: "%s" unavailable; using "%s" instead.\n' "$pkg" "$fallback" >&2
                resolved+=("$fallback")
            else
                printf 'Warning: "%s" unavailable; skipping rar tooling.\n' "$pkg" >&2
            fi
            continue
        fi

        printf 'Warning: "%s" has no installation candidate; skipping.\n' "$pkg" >&2
    done

    printf '%s\n' "${resolved[@]}"
}

install_packages() {
    local packages=("$@")
    local resolved=()

    mapfile -t resolved < <(resolve_packages "${packages[@]}")
    if [[ ${#resolved[@]} -eq 0 ]]; then
        printf 'Warning: No installable packages found for "%s".\n' "${packages[*]}" >&2
        return 0
    fi

    sudo apt install -y "${resolved[@]}"
}

# Update system

sudo apt update

# Install critical dependencies

install_packages \
    zsh git gnupg2 openssh-client ca-certificates \
    curl wget lsof iproute2 net-tools \
    file procps awk \
    unzip zip tar gzip bzip2 p7zip-full unrar lzma

# Install modern tools

install_packages \
    neovim fzf fd-find ripgrep jq bat

# Install eza via cargo

if ! command -v eza > /dev/null; then
    install_packages cargo
    cargo install eza --locked
fi

# Install zoxide

curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Language toolchains

install_packages \
    python3 python3-pip python3-venv pipx \
    nodejs npm

sudo corepack enable

# Optional packages

install_packages \
    snapd flatpak fwupd docker.io podman

# Create symlinks for Debian/Ubuntu

mkdir -p ~/.local/bin
[[ -f "/usr/bin/batcat" ]] && ln -sf /usr/bin/batcat ~/.local/bin/bat
[[ -f "/usr/bin/fdfind" ]] && ln -sf /usr/bin/fdfind ~/.local/bin/fd

echo "Ubuntu/Debian packages installed successfully!"
