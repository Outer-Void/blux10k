#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT_DEFAULT=$(cd "$SCRIPT_DIR/.." && pwd)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_ok() { echo -e "${GREEN}✓${NC} $*"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $*"; }
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_fail() { echo -e "${RED}✖${NC} $*"; }

usage() {
    cat << 'DOC'
BLUX10K doctor

Usage: b10k doctor [options]

Options:
  --repo <path>       Explicit repository path
  --update-check      Run update dry-run validation
  --quiet             Reduce output
  --help              Show this help
DOC
}

resolve_repo_root() {
    local candidate=""

    if [[ -n "${BLUX10K_HOME:-}" ]] && [[ -d "$BLUX10K_HOME/.git" ]]; then
        echo "$BLUX10K_HOME"
        return 0
    fi

    if [[ -f "$HOME/.config/blux10k/install.conf" ]]; then
        candidate=$(grep -E '^BLUX10K_HOME=' "$HOME/.config/blux10k/install.conf" | tail -n 1 || true)
        candidate=${candidate#BLUX10K_HOME=}
        candidate=${candidate%\"}
        candidate=${candidate#\"}
        if [[ -n "$candidate" ]] && [[ -d "$candidate/.git" ]]; then
            echo "$candidate"
            return 0
        fi
    fi

    if git -C "$REPO_ROOT_DEFAULT" rev-parse --show-toplevel >/dev/null 2>&1; then
        echo "$REPO_ROOT_DEFAULT"
        return 0
    fi

    return 1
}

check_command() {
    local name=$1
    if command -v "$name" >/dev/null 2>&1; then
        log_ok "$name is installed"
        return 0
    fi
    log_warn "$name not found"
    return 1
}

check_fonts() {
    local found=0
    local font_paths=(
        "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf"
        "$HOME/.local/share/fonts/MesloLGS NF Bold.ttf"
        "$HOME/.local/share/fonts/MesloLGS NF Italic.ttf"
        "$HOME/.local/share/fonts/MesloLGS NF Bold Italic.ttf"
        "$HOME/Library/Fonts/MesloLGS NF Regular.ttf"
        "$HOME/.termux/font.ttf"
    )

    for font in "${font_paths[@]}"; do
        if [[ -f "$font" ]]; then
            found=1
            break
        fi
    done

    if [[ "$found" == "1" ]]; then
        log_ok "MesloLGS NF font detected"
    else
        log_warn "MesloLGS NF fonts not detected. Install fonts or update terminal settings."
    fi
}

check_shell_init() {
    local zshrc="$HOME/.zshrc"
    if [[ -f "$zshrc" ]]; then
        if command -v rg >/dev/null 2>&1; then
            if rg -n "source .*\.zshrc" "$zshrc" >/dev/null 2>&1; then
                log_warn "~/.zshrc sources itself (possible recursion)"
            else
                log_ok "~/.zshrc recursion check passed"
            fi
        elif command -v grep >/dev/null 2>&1; then
            if grep -nE "source .*\\.zshrc" "$zshrc" >/dev/null 2>&1; then
                log_warn "~/.zshrc sources itself (possible recursion)"
            else
                log_ok "~/.zshrc recursion check passed"
            fi
        else
            log_warn "No grep/rg available to validate ~/.zshrc recursion"
        fi
    else
        log_warn "~/.zshrc not found"
    fi
}

check_b10k_command() {
    if command -v b10k >/dev/null 2>&1; then
        log_ok "b10k command available"
        return
    fi
    if [[ -x "$REPO_ROOT_DEFAULT/scripts/b10k" ]]; then
        log_warn "b10k not in PATH; run install or add $REPO_ROOT_DEFAULT/scripts to PATH"
    else
        log_warn "b10k command not found"
    fi
}

check_permissions() {
    local repo=$1
    local scripts=("$repo/scripts/b10k" "$repo/scripts/update-function.sh" "$repo/scripts/doctor.sh")
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            if [[ -x "$script" ]]; then
                log_ok "Executable: $script"
            else
                log_warn "Not executable: $script"
            fi
        fi
    done
}

run_update_check() {
    local repo=$1
    if [[ -x "$repo/scripts/update-function.sh" ]]; then
        log_info "Running update dry-run"
        "$repo/scripts/update-function.sh" --dry-run --repo "$repo" --no-deps --no-config || log_warn "Update dry-run reported issues"
    else
        log_warn "Update script missing; cannot validate update"
    fi
}

main() {
    local repo_override=""
    local update_check=0
    local quiet=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --repo)
                repo_override="$2"
                shift
                ;;
            --update-check)
                update_check=1
                ;;
            --quiet)
                quiet=1
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                log_fail "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done

    if [[ "$quiet" == "1" ]]; then
        export BLUX10K_PLATFORM_SILENT=1
    fi

    local repo=""
    if [[ -n "$repo_override" ]]; then
        repo="$repo_override"
    else
        repo=$(resolve_repo_root || true)
    fi

    log_info "BLUX10K Doctor starting"

    check_command zsh
    check_command git
    check_command curl
    check_command neofetch || check_command fastfetch || true

    if [[ -n "$repo" ]]; then
        check_permissions "$repo"
    else
        log_warn "Could not locate repository; some checks skipped"
    fi

    if [[ -f "$HOME/.zplug/init.zsh" ]]; then
        log_ok "zplug detected"
    else
        log_warn "zplug not installed (expected at ~/.zplug/init.zsh)"
    fi

    if [[ -f "$HOME/.p10k.zsh" ]]; then
        log_ok "Powerlevel10k config detected"
    else
        log_warn "Powerlevel10k config missing (~/.p10k.zsh)"
    fi

    check_fonts
    check_shell_init
    check_b10k_command

    if [[ "$update_check" == "1" && -n "$repo" ]]; then
        run_update_check "$repo"
    fi

    log_ok "Doctor checks completed"
}

main "$@"
