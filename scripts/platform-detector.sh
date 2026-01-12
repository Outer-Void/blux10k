#!/usr/bin/env bash
set -euo pipefail

log_platform() {
    if [[ "${BLUX10K_PLATFORM_SILENT:-0}" != "1" ]]; then
        echo "$@"
    fi
}

detect_platform() {
    OS_TYPE=""
    PACKAGE_MANAGER=""
    WSL_VERSION=""

    if [[ "$(uname -s)" == "MINGW"* ]] || [[ "$(uname -s)" == "CYGWIN"* ]]; then
        OS_TYPE="windows-native"
        if command -v winget >/dev/null 2>&1; then
            PACKAGE_MANAGER="winget"
        elif command -v choco >/dev/null 2>&1; then
            PACKAGE_MANAGER="chocolatey"
        else
            PACKAGE_MANAGER="winget"
        fi
    elif [[ -d "/data/data/com.termux" ]]; then
        OS_TYPE="termux"
        PACKAGE_MANAGER="pkg"
    elif grep -qi "microsoft" /proc/version 2>/dev/null || [[ -d "/mnt/c/Windows" ]]; then
        OS_TYPE="wsl"
        if grep -qi "WSL2" /proc/version 2>/dev/null; then
            WSL_VERSION="2"
        else
            WSL_VERSION="1"
        fi
        if [[ -f "/etc/os-release" ]]; then
            # shellcheck disable=SC1091
            source /etc/os-release
            case ${ID:-} in
                debian|ubuntu|linuxmint|pop|zorin|elementary)
                    PACKAGE_MANAGER="apt"
                    ;;
                arch|manjaro|endeavouros|garuda)
                    PACKAGE_MANAGER="pacman"
                    ;;
                fedora|rhel|centos|almalinux|rocky)
                    PACKAGE_MANAGER="dnf"
                    ;;
                *)
                    PACKAGE_MANAGER="apt"
                    ;;
            esac
        else
            PACKAGE_MANAGER="apt"
        fi
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        OS_TYPE="macos"
        PACKAGE_MANAGER="brew"
    elif [[ "$(uname -s)" == "FreeBSD" ]]; then
        OS_TYPE="freebsd"
        PACKAGE_MANAGER="pkg"
    elif [[ "$(uname -s)" == "OpenBSD" ]]; then
        OS_TYPE="openbsd"
        PACKAGE_MANAGER="pkg_add"
    elif [[ -f "/etc/os-release" ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        case ${ID:-} in
            debian|ubuntu|linuxmint|pop|zorin|elementary)
                OS_TYPE="debian"
                PACKAGE_MANAGER="apt"
                ;;
            arch|manjaro|endeavouros|garuda)
                OS_TYPE="arch"
                PACKAGE_MANAGER="pacman"
                ;;
            fedora|rhel|centos|almalinux|rocky)
                OS_TYPE="fedora"
                PACKAGE_MANAGER="dnf"
                ;;
            alpine)
                OS_TYPE="alpine"
                PACKAGE_MANAGER="apk"
                ;;
            void)
                OS_TYPE="void"
                PACKAGE_MANAGER="xbps"
                ;;
            gentoo)
                OS_TYPE="gentoo"
                PACKAGE_MANAGER="emerge"
                ;;
            *)
                OS_TYPE="linux"
                PACKAGE_MANAGER="apt"
                ;;
        esac
    else
        OS_TYPE="linux"
        PACKAGE_MANAGER="apt"
    fi

    export OS_TYPE PACKAGE_MANAGER WSL_VERSION
}

platform_summary() {
    detect_platform
    log_platform "OS_TYPE=$OS_TYPE"
    log_platform "PACKAGE_MANAGER=$PACKAGE_MANAGER"
    if [[ -n "${WSL_VERSION:-}" ]]; then
        log_platform "WSL_VERSION=$WSL_VERSION"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    platform_summary
fi
