# BLUX10K core shell functions

mkcd() {
    if [[ -z "${1:-}" ]]; then
        echo "Usage: mkcd <dir>" >&2
        return 1
    fi
    mkdir -p -- "$1" && cd -- "$1" || return 1
}

killport() {
    if [[ -z "${1:-}" ]]; then
        echo "Usage: killport <port>" >&2
        return 1
    fi

    local port=$1
    local pids

    if command -v lsof >/dev/null 2>&1; then
        pids=$(lsof -ti tcp:"$port")
    elif command -v fuser >/dev/null 2>&1; then
        pids=$(fuser -n tcp "$port" 2>/dev/null || true)
    else
        echo "Neither lsof nor fuser is available to locate processes." >&2
        return 1
    fi

    if [[ -z "$pids" ]]; then
        echo "No process found on port $port" >&2
        return 1
    fi

    echo "Killing process(es) on port $port: $pids"
    kill -9 $pids
}

extract() {
    if [[ -z "${1:-}" ]] || [[ ! -f "$1" ]]; then
        echo "Usage: extract <archive>" >&2
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.tar.xz) tar xJf "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.rar) unrar x "$1" ;;
        *.7z) 7z x "$1" ;;
        *)
            echo "Unsupported archive format: $1" >&2
            return 1
            ;;
    esac
}

rz() {
    source ~/.zshrc
}
