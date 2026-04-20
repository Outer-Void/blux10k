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

if [[ "${BLUX10K_SKIP_P10K_CONFIG_PROMPT:-0}" != "1" ]]; then
  read -r -p 'Run p10k configure now? [y/N]: ' run_p10k_configure
  if [[ "$run_p10k_configure" == "y" || "$run_p10k_configure" == "Y" ]]; then
    echo "Running p10k configure."
    if command -v p10k >/dev/null 2>&1; then
      p10k configure || echo "p10k configure did not complete successfully; continuing."
    elif command -v zsh >/dev/null 2>&1 && [[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
      zsh -i -c 'source ~/powerlevel10k/powerlevel10k.zsh-theme && p10k configure' \
        || echo "p10k configure via zsh did not complete successfully; continuing."
    else
      echo "p10k command is not available yet. Open zsh after bootstrap and run: p10k configure"
    fi
  else
    echo "Skipped p10k configure."
  fi
fi

echo "Bootstrap complete."
