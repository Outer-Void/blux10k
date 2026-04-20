#!/usr/bin/env bash
# activate_venv.sh — MUST be sourced
# Purpose: deactivate any active venv, find .venv/ or venv/ in CWD, activate it,
# and VERIFY python/pip resolve from that venv.

# Guard: ensure script is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "[activate-venv] ERROR: this script must be sourced, not executed." >&2
  echo "[activate-venv] Usage: source activate_venv.sh" >&2
  exit 1
fi

# Deactivate any active venv (ignore errors if deactivate not defined)
if [[ -n "${VIRTUAL_ENV-}" ]]; then
  echo "🔻 Deactivating current venv: $VIRTUAL_ENV"
  deactivate >/dev/null 2>&1 || true
fi

# Locate venv in current directory
VENV_PATH=""
if [[ -f ".venv/bin/activate" ]]; then
  VENV_PATH=".venv"
elif [[ -f "venv/bin/activate" ]]; then
  VENV_PATH="venv"
else
  echo "[activate-venv] ERROR: no virtual environment found in: $(pwd)" >&2
  echo "[activate-venv] Expected one of: .venv/ or venv/" >&2
  return 1
fi

echo "🐍 Activating venv: $(pwd)/$VENV_PATH"
# shellcheck disable=SC1090
source "$VENV_PATH/bin/activate"

# Clear shell command hash so `python` doesn't stick to old path
hash -r 2>/dev/null || true
rehash 2>/dev/null || true

# Verify python resolves inside venv
PY_EXE="$(command -v python 2>/dev/null || true)"
PIP_EXE="$(command -v pip 2>/dev/null || true)"
SYS_EXE="$(python -c 'import sys; print(sys.executable)' 2>/dev/null || true)"

if [[ -z "${VIRTUAL_ENV-}" ]]; then
  echo "[activate-venv] ERROR: activation failed; VIRTUAL_ENV not set." >&2
  return 1
fi

# Expect sys.executable under VIRTUAL_ENV
case "$SYS_EXE" in
  "$VIRTUAL_ENV"/*) ;;
  *)
    echo "[activate-venv] ERROR: activation mismatch." >&2
    echo "[activate-venv]   VIRTUAL_ENV    : $VIRTUAL_ENV" >&2
    echo "[activate-venv]   python path    : ${PY_EXE:-<none>}" >&2
    echo "[activate-venv]   sys.executable : ${SYS_EXE:-<none>}" >&2
    echo "[activate-venv]   pip path       : ${PIP_EXE:-<none>}" >&2
    echo "[activate-venv]   Try: deactivate; hash -r; source $VENV_PATH/bin/activate" >&2
    return 1
    ;;
esac

echo "✅ Venv active"
echo "   VIRTUAL_ENV : $VIRTUAL_ENV"
echo "   python      : $SYS_EXE"
echo "   pip         : ${PIP_EXE:-<none>}"
