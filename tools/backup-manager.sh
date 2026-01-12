#!/usr/bin/env bash
set -euo pipefail

backup_timestamp() {
    date +%Y%m%d_%H%M%S
}

backup_root() {
    local base="${BLUX10K_BACKUP_ROOT:-$HOME/.config/blux10k/backups}"
    echo "$base"
}

backup_create_dir() {
    local ts
    ts="$(backup_timestamp)"
    local dest
    dest="$(backup_root)/$ts"
    mkdir -p "$dest"
    echo "$dest"
}

backup_copy() {
    local src=$1
    local dest_root=$2

    if [[ ! -e "$src" ]]; then
        return 0
    fi

    local dest="$dest_root$src"
    mkdir -p "$(dirname "$dest")"

    if [[ -d "$src" ]]; then
        cp -a "$src" "$dest" 2>/dev/null || cp -R "$src" "$dest"
    else
        cp -p "$src" "$dest"
    fi
}

backup_paths() {
    local dest_root=$1
    shift

    for path in "$@"; do
        backup_copy "$path" "$dest_root"
    done
}
