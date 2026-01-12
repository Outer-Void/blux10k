# BLUX10K Update Core

blux10k_update() {
    if command -v b10k >/dev/null 2>&1; then
        b10k update "$@"
        return $?
    fi

    if [[ -n "${BLUX10K_HOME:-}" ]] && [[ -x "$BLUX10K_HOME/scripts/update-function.sh" ]]; then
        "$BLUX10K_HOME/scripts/update-function.sh" "$@"
        return $?
    fi

    echo "b10k command not found. Please run installer or add BLUX10K to PATH." >&2
    return 1
}

update() {
    blux10k_update "$@"
}

blux10k_doctor() {
    if command -v b10k >/dev/null 2>&1; then
        b10k doctor "$@"
        return $?
    fi

    if [[ -n "${BLUX10K_HOME:-}" ]] && [[ -x "$BLUX10K_HOME/scripts/doctor.sh" ]]; then
        "$BLUX10K_HOME/scripts/doctor.sh" "$@"
        return $?
    fi

    echo "b10k doctor not available." >&2
    return 1
}
