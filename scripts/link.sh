#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$HOME/.config"

[ -f "$REPO/home/.bashrc" ] && ln -sf "$REPO/home/.bashrc" "$HOME/.bashrc"
[ -f "$REPO/home/.profile" ] && ln -sf "$REPO/home/.profile" "$HOME/.profile"
[ -f "$REPO/home/.zshrc" ] && ln -sf "$REPO/home/.zshrc" "$HOME/.zshrc"
[ -f "$REPO/home/.p10k.zsh" ] && ln -sf "$REPO/home/.p10k.zsh" "$HOME/.p10k.zsh"
[ -f "$REPO/home/.gitconfig" ] && ln -sf "$REPO/home/.gitconfig" "$HOME/.gitconfig"

[ -d "$REPO/home/.config/nvim" ] && ln -sfn "$REPO/home/.config/nvim" "$HOME/.config/nvim"
[ -d "$REPO/home/.config/fastfetch" ] && ln -sfn "$REPO/home/.config/fastfetch" "$HOME/.config/fastfetch"
[ -d "$REPO/home/.config/ranger" ] && ln -sfn "$REPO/home/.config/ranger" "$HOME/.config/ranger"

echo "Dotfiles linked."
