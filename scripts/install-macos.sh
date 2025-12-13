#!/usr/bin/env bash
# macOS specific installations for BLUX10K

set -euo pipefail

echo "Installing BLUX10K packages for macOS..."

# Ensure Homebrew is installed
if ! command -v brew > /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew
brew update

# Install core packages
brew install \
    zsh git gnupg openssh curl wget coreutils findutils \
    unzip p7zip unrar gnu-tar gnu-sed lsof iproute2mac

# Install modern tools
brew install \
    neovim fzf fd ripgrep jq bat eza zoxide

# Install language toolchains
brew install \
    python node volta rustup-init

# Optional packages
brew install --cask \
    iterm2 visual-studio-code docker

# Setup Rust
rustup-init -y

echo "macOS packages installed successfully!"