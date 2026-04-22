#!/usr/bin/env bash
set -euo pipefail

if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  if [[ "${ID:-}" != "debian" && "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *"debian"* ]]; then
    echo "This bootstrap script targets Debian/Ubuntu systems."
    echo "Detected: ${PRETTY_NAME:-unknown}."
    exit 1
  fi
else
  echo "Cannot determine OS (missing /etc/os-release)."
  exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
  echo "apt not found. This script requires Debian/Ubuntu package management."
  exit 1
fi

apt_runner=()
if [[ "$(id -u)" -eq 0 ]]; then
  apt_runner=()
elif command -v sudo >/dev/null 2>&1; then
  apt_runner=(sudo)
else
  echo "sudo not found and current user is not root. Install sudo or run as root."
  exit 1
fi

echo "Installing Debian/Ubuntu bootstrap packages..."
"${apt_runner[@]}" apt update
"${apt_runner[@]}" apt install -y \
  git curl wget zsh tmux vim nano neovim \
  htop tree unzip zip ripgrep fd-find \
  bat fzf jq ranger xclip build-essential


if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  echo "Aliased batcat -> $HOME/.local/bin/bat"
fi

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  echo "Aliased fdfind -> $HOME/.local/bin/fd"
fi

if apt-cache show fastfetch >/dev/null 2>&1; then
  "${apt_runner[@]}" apt install -y fastfetch
else
  echo "fastfetch not available in this repo; skipping."
fi
if [[ ! -d "$HOME/.zplug" ]]; then
  git clone https://github.com/zplug/zplug "$HOME/.zplug"
fi

if [[ ! -d "$HOME/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi

echo "Bootstrap complete."
echo "Run this manually from an interactive zsh session:"
echo "  p10k configure"
