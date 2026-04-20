#!/usr/bin/env bash
set -euo pipefail

if [[ -d "$HOME/.zplug" ]]; then
  if [[ -f "$HOME/.zplug/init.zsh" ]] && command -v zsh >/dev/null 2>&1; then
    echo "Updating zplug plugins..."
    if zsh -c 'source "$HOME/.zplug/init.zsh" && zplug update && zplug install'; then
      echo "zplug update/install complete."
    else
      echo "zplug update/install failed; continuing."
    fi
  else
    echo "~/.zplug exists, but zsh or ~/.zplug/init.zsh is missing; skipping zplug update."
  fi
else
  echo "~/.zplug not found; skipping zplug update."
fi

if [[ -d "$HOME/powerlevel10k/.git" ]]; then
  echo "Updating powerlevel10k..."
  if git -C "$HOME/powerlevel10k" pull --ff-only; then
    echo "powerlevel10k updated."
  else
    echo "powerlevel10k update failed; continuing."
  fi
elif [[ -d "$HOME/powerlevel10k" ]]; then
  echo "~/powerlevel10k exists but is not a git repository; skipping update."
else
  echo "~/powerlevel10k not found; skipping update."
fi
