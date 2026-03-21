#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y \
  git curl wget zsh tmux vim nano neovim \
  fastfetch htop tree unzip zip ripgrep fd-find \
  bat fzf jq ranger xclip build-essential

if [ ! -d "$HOME/.zplug" ]; then
  git clone https://github.com/zplug/zplug "$HOME/.zplug"
fi

if [ ! -d "$HOME/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi

echo "Bootstrap complete."
