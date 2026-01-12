#!/usr/bin/env bash
# BLUX10K Update System
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT_DEFAULT=$(cd "$SCRIPT_DIR/.." && pwd)

# shellcheck disable=SC1091
[[ -f "$SCRIPT_DIR/platform-detector.sh" ]] && source "$SCRIPT_DIR/platform-detector.sh"
# shellcheck disable=SC1091
[[ -f "$REPO_ROOT_DEFAULT/tools/backup-manager.sh" ]] && source "$REPO_ROOT_DEFAULT/tools/backup-manager.sh"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✓${NC} $*"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $*"; }
log_error() { echo -e "${RED}✖${NC} $*"; }
log_phase() { echo -e "${MAGENTA}➜${NC} $*"; }

die() {
    log_error "$*"
    exit 1
}

usage() {
    cat << 'EOF'
BLUX10K update

Usage: b10k update [options]

Options:
  --dry-run           Show actions without applying changes
  --repo <path>       Explicit repository path
  --offline           Skip network fetch/pull steps
  --no-deps           Skip dependency update phase
  --no-config         Skip config sync phase
  --force-config      Overwrite configs after backup (use with care)
  --help              Show this help
EOF
}

resolve_repo_root() {
    local candidate=""

    if [[ -n "${BLUX10K_HOME:-}" ]] && [[ -d "$BLUX10K_HOME/.git" ]]; then
        echo "$BLUX10K_HOME"
        return 0
    fi

    if [[ -n "${BLUX10K_REPO:-}" ]] && [[ -d "$BLUX10K_REPO/.git" ]]; then
        echo "$BLUX10K_REPO"
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

    for candidate in "$HOME/blux10k" "$HOME/.blux10k" "$HOME/Projects/blux10k"; do
        if [[ -d "$candidate/.git" ]]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

run_cmd() {
    if [[ "${DRY_RUN:-0}" == "1" ]]; then
        log_info "[dry-run] $*"
        return 0
    fi

    "$@"
}

run_as_root() {
    if command -v sudo >/dev/null 2>&1; then
        run_cmd sudo "$@"
    else
        run_cmd "$@"
    fi
}

update_git_repo() {
    local repo=$1
    local offline=${OFFLINE:-0}
    local default_branch=""
    local stash_name=""
    local had_stash=0

    if [[ ! -d "$repo/.git" ]]; then
        die "No git repository found at $repo"
    fi

    if [[ -z "${GIT:-}" ]]; then
        GIT="git"
    fi

    if ! command -v "$GIT" >/dev/null 2>&1; then
        die "git is required for update"
    fi

    if ! "$GIT" -C "$repo" remote get-url origin >/dev/null 2>&1; then
        log_warn "No origin remote configured. Skipping fetch/pull."
        return 0
    fi

    default_branch=$($GIT -C "$repo" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)
    default_branch=${default_branch#origin/}
    if [[ -z "$default_branch" ]]; then
        if $GIT -C "$repo" show-ref --verify --quiet refs/remotes/origin/main; then
            default_branch="main"
        elif $GIT -C "$repo" show-ref --verify --quiet refs/remotes/origin/master; then
            default_branch="master"
        else
            default_branch="main"
        fi
    fi

    if ! $GIT -C "$repo" symbolic-ref -q HEAD >/dev/null 2>&1; then
        log_warn "Detached HEAD detected. Switching to $default_branch"
        run_cmd "$GIT" -C "$repo" checkout "$default_branch"
    fi

    if [[ "$offline" == "1" ]]; then
        log_warn "Offline mode enabled; skipping fetch/pull"
        return 0
    fi

    if [[ "${DRY_RUN:-0}" != "1" ]]; then
        if ! $GIT -C "$repo" ls-remote --exit-code origin >/dev/null 2>&1; then
            log_warn "Remote unreachable. Skipping fetch/pull."
            return 0
        fi
    else
        log_info "[dry-run] Skipping remote connectivity check"
    fi

    if $GIT -C "$repo" rev-parse --is-shallow-repository >/dev/null 2>&1; then
        if [[ "$($GIT -C "$repo" rev-parse --is-shallow-repository)" == "true" ]]; then
            log_info "Repository is shallow; fetching full history"
            run_cmd "$GIT" -C "$repo" fetch --unshallow || run_cmd "$GIT" -C "$repo" fetch --depth=1000
        fi
    fi

    if [[ -n "$($GIT -C "$repo" status --porcelain)" ]]; then
        stash_name="blux10k-update-$(date +%Y%m%d_%H%M%S)"
        log_warn "Working tree has local changes; stashing as $stash_name"
        run_cmd "$GIT" -C "$repo" stash push -u -m "$stash_name"
        had_stash=1
    fi

    log_info "Fetching latest changes from origin"
    run_cmd "$GIT" -C "$repo" fetch --tags --prune origin

    log_info "Updating $default_branch"
    if ! run_cmd "$GIT" -C "$repo" merge --ff-only "origin/$default_branch"; then
        log_warn "Fast-forward merge failed; attempting rebase"
        run_cmd "$GIT" -C "$repo" rebase "origin/$default_branch"
    fi

    if [[ "$had_stash" == "1" ]]; then
        log_info "Re-applying local changes"
        if ! run_cmd "$GIT" -C "$repo" stash pop; then
            log_warn "Stash had conflicts. Resolve manually and run git stash list for $stash_name"
        fi
    fi
}

update_packages() {
    detect_platform || true

    local skip_pip=${SYSUPDATE_SKIP_PIP:-0}

    case ${PACKAGE_MANAGER:-} in
        apt)
            run_as_root apt update
            run_as_root apt upgrade -y
            ;;
        pacman)
            run_as_root pacman -Syu --noconfirm
            ;;
        dnf)
            run_as_root dnf upgrade -y
            ;;
        brew)
            run_cmd brew update
            run_cmd brew upgrade
            ;;
        pkg)
            run_cmd pkg update
            run_cmd pkg upgrade -y || run_cmd pkg upgrade
            ;;
        apk)
            run_as_root apk update
            run_as_root apk upgrade
            ;;
        xbps)
            run_as_root xbps-install -Syu
            ;;
        emerge)
            run_as_root emerge --sync
            run_as_root emerge --ask n --update --deep --newuse @world
            ;;
        *)
            log_warn "No supported package manager detected for updates"
            ;;
    esac

    if command -v pipx >/dev/null 2>&1; then
        run_cmd pipx upgrade-all
    fi

    if [[ "$skip_pip" == "0" ]] && command -v pip >/dev/null 2>&1; then
        run_cmd pip install --upgrade pip
    fi

    if command -v npm >/dev/null 2>&1; then
        run_cmd npm update -g
    fi

    if command -v cargo >/dev/null 2>&1; then
        run_cmd cargo install-update -a || log_warn "cargo-install-update not available"
    fi
}

sync_configs() {
    local repo=$1
    local dest_root="$HOME/.config/blux10k"
    local examples_dir="$dest_root/examples"
    local patches_dir="$dest_root/patches"
    local ts

    ts=$(date +%Y%m%d_%H%M%S)
    run_cmd mkdir -p "$examples_dir" "$patches_dir"

    local template_map=(
        "$repo/configs/.zshrc:~/.zshrc"
        "$repo/configs/.p10k.zsh:~/.p10k.zsh"
        "$repo/configs/b10k.neofetch.conf:~/.config/neofetch/b10k.neofetch.conf"
        "$repo/configs/starship.toml:~/.config/starship.toml"
        "$repo/configs/env.zsh.example:~/.config/private/env.zsh"
    )

    for entry in "${template_map[@]}"; do
        local src=${entry%%:*}
        local dest=${entry#*:}
        dest=${dest/#\~/$HOME}

        if [[ ! -f "$src" ]]; then
            continue
        fi

        if [[ -f "$dest" && "${FORCE_CONFIG:-0}" != "1" ]]; then
            local name
            name=$(basename "$src")
            local example_path="$examples_dir/${name}.${ts}.example"
            run_cmd cp "$src" "$example_path"

            if command -v diff >/dev/null 2>&1; then
                local patch_path="$patches_dir/${name}.${ts}.patch"
                if ! diff -u "$dest" "$src" > "$patch_path"; then
                    log_info "Saved diff for $dest to $patch_path"
                else
                    run_cmd rm -f "$patch_path"
                fi
            fi

            log_warn "Preserved existing $dest. Template saved to $example_path"
        else
            run_cmd mkdir -p "$(dirname "$dest")"
            if [[ -f "$dest" ]]; then
                backup_copy "$dest" "${BACKUP_DIR}"
            fi
            run_cmd cp "$src" "$dest"
            log_success "Updated $dest"
        fi
    done
}

validate_update() {
    local repo=$1
    if [[ -x "$repo/scripts/doctor.sh" ]]; then
        run_cmd "$repo/scripts/doctor.sh" --update-check --repo "$repo"
    else
        log_warn "Doctor script missing; skipping validation"
    fi
}

main() {
    DRY_RUN=${BLUX10K_DRY_RUN:-0}
    OFFLINE=${BLUX10K_OFFLINE:-0}
    SKIP_DEPS=0
    SKIP_CONFIG=0
    FORCE_CONFIG=0
    REPO_OVERRIDE=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=1
                ;;
            --offline)
                OFFLINE=1
                ;;
            --no-deps)
                SKIP_DEPS=1
                ;;
            --no-config)
                SKIP_CONFIG=1
                ;;
            --force-config)
                FORCE_CONFIG=1
                ;;
            --repo)
                REPO_OVERRIDE="$2"
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done

    local repo=""
    if [[ -n "$REPO_OVERRIDE" ]]; then
        repo="$REPO_OVERRIDE"
    else
        repo=$(resolve_repo_root) || die "Unable to locate BLUX10K repository"
    fi

    if [[ "${DRY_RUN}" == "1" ]]; then
        BACKUP_DIR="$(backup_root)/$(backup_timestamp)"
    else
        BACKUP_DIR=$(backup_create_dir)
    fi
    export BACKUP_DIR

    log_phase "Preflight"
    log_info "Repo: $repo"

    log_phase "Backup"
    if [[ "${DRY_RUN}" == "1" ]]; then
        log_info "[dry-run] Backup destination: $BACKUP_DIR"
    else
        backup_paths "$BACKUP_DIR" \
            "$HOME/.zshrc" \
            "$HOME/.p10k.zsh" \
            "$HOME/.config/neofetch" \
            "$HOME/.config/starship.toml" \
            "$HOME/.config/private/env.zsh" \
            "$HOME/.config/blux10k"
        log_success "Backup stored at $BACKUP_DIR"
    fi

    log_phase "Fetch/Pull"
    update_git_repo "$repo"

    log_phase "Dependency Sync"
    if [[ "$SKIP_DEPS" == "0" ]]; then
        update_packages
    else
        log_info "Skipping dependency updates"
    fi

    log_phase "Config Sync"
    if [[ "$SKIP_CONFIG" == "0" ]]; then
        sync_configs "$repo"
    else
        log_info "Skipping config sync"
    fi

    log_phase "Validation"
    validate_update "$repo"

    log_success "BLUX10K update complete"
}

main "$@"
