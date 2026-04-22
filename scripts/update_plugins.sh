#!/usr/bin/env bash
set -euo pipefail

if [[ -d "$HOME/.zplug" ]]; then
  if [[ -f "$HOME/.zplug/init.zsh" ]] && command -v zsh >/dev/null 2>&1; then
    echo "Updating zplug plugins..."
    set +e
    zplug_output="$(
      zsh -c 'source "$HOME/.zplug/init.zsh" && zplug update && zplug install' 2>&1
    )"
    zplug_status=$?
    set -e
    printf '%s\n' "$zplug_output"

    if [[ "$zplug_status" -eq 0 ]]; then
      if printf '%s' "$zplug_output" | grep -Eqi 'no packages to install|already up(\-| )to(\-| )date'; then
        echo "zplug is already current."
      else
        echo "zplug plugins updated."
      fi
    else
      if printf '%s' "$zplug_output" | grep -Eqi 'no packages to install'; then
        echo "zplug is already current."
      else
        echo "zplug update failed; continuing."
      fi
    fi
  else
    echo "~/.zplug exists, but zsh or ~/.zplug/init.zsh is missing (missing manager); skipping zplug update."
  fi
else
  echo "~/.zplug not found (missing manager); skipping zplug update."
fi

if [[ -d "$HOME/powerlevel10k/.git" ]]; then
  echo "Updating powerlevel10k..."
  set +e
  p10k_output="$(git -C "$HOME/powerlevel10k" pull --ff-only 2>&1)"
  p10k_status=$?
  set -e
  printf '%s\n' "$p10k_output"

  if [[ "$p10k_status" -eq 0 ]]; then
    if printf '%s' "$p10k_output" | grep -Eqi 'already up[ -]to[ -]date'; then
      echo "powerlevel10k is already current."
    else
      echo "powerlevel10k updated."
    fi
  else
    echo "powerlevel10k update failed; continuing."
  fi
elif [[ -d "$HOME/powerlevel10k" ]]; then
  echo "~/powerlevel10k exists but is not a git repository (missing manager); skipping update."
else
  echo "~/powerlevel10k not found (missing manager); skipping update."
fi
