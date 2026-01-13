#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"

meslo_dir="${repo_root}/fonts/meslolgs-nf"
alternatives_dir="${repo_root}/fonts/alternatives"

usage() {
  cat <<'USAGE'
BLUX10K font installer

Usage:
  ./fonts/install-fonts.sh [--termux-apply] [--help]

Options:
  --termux-apply  In Termux, copy MesloLGS NF Regular.ttf to ~/.termux/font.ttf
  --help          Show this help message

Notes:
  - Linux/proot Debian: installs fonts into $XDG_DATA_HOME/fonts/blux10k (or ~/.local/share/fonts/blux10k)
  - macOS: installs fonts into ~/Library/Fonts/BLUX10K
  - Termux: by default prints guidance and exits without changing system fonts
USAGE
}

is_termux() {
  [[ -n "${TERMUX_VERSION:-}" ]] || [[ "${PREFIX:-}" == "/data/data/com.termux/files/usr" ]]
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

termux_apply=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --termux-apply)
      termux_apply=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if is_termux; then
  if [[ "${termux_apply}" == "true" ]]; then
    termux_font_src="${meslo_dir}/MesloLGS NF Regular.ttf"
    termux_font_dst="${HOME}/.termux/font.ttf"

    if [[ ! -f "${termux_font_src}" ]]; then
      echo "Termux font source not found: ${termux_font_src}" >&2
      exit 1
    fi

    mkdir -p "${HOME}/.termux"
    cp -f "${termux_font_src}" "${termux_font_dst}"
    echo "Installed Termux font to ${termux_font_dst} (overwritten if it existed)."
    echo "Restart Termux for the font change to take effect."
    exit 0
  fi

  cat <<'TERMUX'
Termux detected. This installer does not change system fonts by default.

To apply the bundled MesloLGS font to Termux only:
  ./fonts/install-fonts.sh --termux-apply

This copies the font to ~/.termux/font.ttf and requires a Termux restart.
TERMUX
  exit 0
fi

install_dir=""
if is_macos; then
  install_dir="${HOME}/Library/Fonts/BLUX10K"
else
  install_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/fonts/blux10k"
fi

mkdir -p "${install_dir}"

copy_fonts() {
  local src_dir="$1"
  if compgen -G "${src_dir}/*.ttf" > /dev/null; then
    cp -f "${src_dir}"/*.ttf "${install_dir}/"
  else
    echo "Warning: no .ttf files found in ${src_dir}" >&2
  fi
}

copy_fonts "${meslo_dir}"
copy_fonts "${alternatives_dir}"

echo "Installed BLUX10K fonts to ${install_dir} (overwritten if they existed)."

if ! is_macos; then
  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f
  else
    echo "Warning: fc-cache not available; refresh your font cache manually if needed." >&2
  fi
fi
