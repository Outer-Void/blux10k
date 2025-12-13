#!/usr/bin/env bash

Ubuntu/Debian specific installations for BLUX10K

set -euo pipefail

echo "Installing BLUX10K packages for Ubuntu/Debian..."

Update system

sudo apt update

Install critical dependencies

sudo apt install -y \
zsh git gnupg2 openssh-client ca-certificates \
curl wget lsof iproute2 net-tools \
file procps awk \
unzip zip tar gzip bzip2 p7zip-full unrar lzma

Install modern tools

sudo apt install -y \
neovim fzf fd-find ripgrep jq bat

Install eza via cargo

if ! command -v eza > /dev/null; then
sudo apt install -y cargo
cargo install eza --locked
fi

Install zoxide

curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

Language toolchains

sudo apt install -y \
python3 python3-pip python3-venv pipx \
nodejs npm

sudo corepack enable

Optional packages

sudo apt install -y \
snapd flatpak fwupd docker.io podman

Create symlinks for Debian/Ubuntu

mkdir -p ~/.local/bin
[[ -f "/usr/bin/batcat" ]] && ln -sf /usr/bin/batcat ~/.local/bin/bat
[[ -f "/usr/bin/fdfind" ]] && ln -sf /usr/bin/fdfind ~/.local/bin/fd

echo "Ubuntu/Debian packages installed successfully!"
