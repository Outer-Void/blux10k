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
        echo "zplug: already current (nothing to install)."
      else
        echo "zplug: updated successfully."
      fi
    else
      echo "zplug: update command failed."
    fi
  else
    echo "zplug: manager missing (need ~/.zplug/init.zsh and zsh); skipping."
  fi
else
  echo "zplug: manager missing (~/.zplug not found); skipping."
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
      echo "powerlevel10k: already current."
    else
      echo "powerlevel10k: updated successfully."
    fi
  else
    echo "powerlevel10k: update command failed."
  fi
elif [[ -d "$HOME/powerlevel10k" ]]; then
  echo "powerlevel10k: repo missing (.git not found); skipping."
else
  echo "powerlevel10k: repo missing (~/powerlevel10k not found); skipping."
fi
