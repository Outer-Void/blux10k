#!/bin/sh
# py_venv.sh — MUST be sourced: . ./py_venv.sh  (or: source ./py_venv.sh)
# Purpose: ensure repo-local .venv exists, activate it, and VERIFY interpreter is from .venv.

VENV_DIR=".venv"

_is_sourced() {
  if [ -n "${ZSH_VERSION-}" ]; then
    case ${ZSH_EVAL_CONTEXT-} in *:file:*) return 0;; esac
  elif [ -n "${BASH_VERSION-}" ]; then
    [ "${BASH_SOURCE[0]}" != "$0" ] && return 0 || return 1
  else
    (return 0 2>/dev/null) && return 0 || return 1
  fi
}

if ! _is_sourced; then
  cat >&2 << 'EOF'
[py-venv] ERROR: This script must be SOURCED, not executed.
Correct usage:
  . ./py_venv.sh
  source ./py_venv.sh
EOF
  exit 1
fi

# Require python3 to exist
if ! command -v python3 >/dev/null 2>&1; then
  echo "[py-venv] ERROR: python3 not found in PATH" >&2
  return 1 2>/dev/null || exit 1
fi

# Create venv if missing
if [ ! -d "$VENV_DIR" ]; then
  echo "[py-venv] Creating virtual environment ($VENV_DIR)"
  if ! python3 -m venv "$VENV_DIR"; then
    echo "[py-venv] ERROR: Failed to create virtual environment" >&2
    return 1 2>/dev/null || exit 1
  fi
fi

# Activation script must exist
if [ ! -f "$VENV_DIR/bin/activate" ]; then
  echo "[py-venv] ERROR: Activation script not found: $VENV_DIR/bin/activate" >&2
  return 1 2>/dev/null || exit 1
fi

# Always activate repo venv (don’t rely on VIRTUAL_ENV being truthful)
# shellcheck disable=SC1090
. "$VENV_DIR/bin/activate" >/dev/null 2>&1 || . "$VENV_DIR/bin/activate"

# Clear command hash (best-effort; harmless in sh)
hash -r 2>/dev/null || true
rehash 2>/dev/null || true

# Verify interpreter really is from this venv
EXEC_PY="$(python -c 'import sys; print(sys.executable)' 2>/dev/null || true)"
PWD_ABS="$(pwd -P 2>/dev/null || pwd)"
VENV_ABS="$PWD_ABS/$VENV_DIR"

case "$EXEC_PY" in
  "$VENV_ABS"/*) ;;
  *)
    # Retry once in case PATH/hash was stale
    . "$VENV_DIR/bin/activate" >/dev/null 2>&1 || . "$VENV_DIR/bin/activate"
    hash -r 2>/dev/null || true
    rehash 2>/dev/null || true
    EXEC_PY="$(python -c 'import sys; print(sys.executable)' 2>/dev/null || true)"
    case "$EXEC_PY" in
      "$VENV_ABS"/*) ;;
      *)
        echo "[py-venv] ERROR: Venv activation mismatch" >&2
        echo "[py-venv]   Expected: $VENV_ABS/bin/python" >&2
        echo "[py-venv]   Got     : ${EXEC_PY:-<none>}" >&2
        echo "[py-venv]   Hint: a shell alias/function may be shadowing python/pip." >&2
        return 1 2>/dev/null || exit 1
        ;;
    esac
    ;;
esac

echo "[py-venv] ✓ Virtual environment active"
echo "[py-venv]   Path: $VIRTUAL_ENV"
echo "[py-venv]   Python: $EXEC_PY"
