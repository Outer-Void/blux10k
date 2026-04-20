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

if [[ "${BLUX10K_SKIP_P10K_CONFIG_PROMPT:-0}" != "1" ]]; then
  read -r -p 'Run p10k configure now? [y/N]: ' run_p10k_configure
  if [[ "$run_p10k_configure" =~ ^[Yy]$ ]]; then
    if command -v p10k >/dev/null 2>&1; then
      echo "Running p10k configure."
      p10k configure || echo "p10k configure did not complete successfully; continuing."
    elif command -v zsh >/dev/null 2>&1 && [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
      echo "Running p10k configure via zsh."
      zsh -i -c 'source "$HOME/powerlevel10k/powerlevel10k.zsh-theme" && p10k configure' \
        || echo "p10k configure via zsh did not complete successfully; continuing."
    else
      echo "p10k command is not available yet. Open zsh and run: p10k configure"
    fi
  else
    echo "Skipped p10k configure."
  fi
fi

echo "Bootstrap complete."
