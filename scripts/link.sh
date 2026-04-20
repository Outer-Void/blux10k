#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$HOME/.config"

[ -f "$REPO/dotfiles/.bashrc" ] && ln -sf "$REPO/dotfiles/.bashrc" "$HOME/.bashrc"
[ -f "$REPO/dotfiles/.profile" ] && ln -sf "$REPO/dotfiles/.profile" "$HOME/.profile"
[ -f "$REPO/dotfiles/.zshrc" ] && ln -sf "$REPO/dotfiles/.zshrc" "$HOME/.zshrc"
[ -f "$REPO/dotfiles/.p10k.zsh" ] && ln -sf "$REPO/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"
[ -f "$REPO/dotfiles/.gitconfig" ] && ln -sf "$REPO/dotfiles/.gitconfig" "$HOME/.gitconfig"

[ -d "$REPO/dotfiles/.config/nvim" ] && ln -sfn "$REPO/dotfiles/.config/nvim" "$HOME/.config/nvim"
[ -d "$REPO/dotfiles/.config/fastfetch" ] && ln -sfn "$REPO/dotfiles/.config/fastfetch" "$HOME/.config/fastfetch"
[ -d "$REPO/dotfiles/.config/ranger" ] && ln -sfn "$REPO/dotfiles/.config/ranger" "$HOME/.config/ranger"

echo "Dotfiles linked."
