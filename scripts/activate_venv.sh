#!/usr/bin/env bash
# activate_venv.sh — MUST be sourced
# Purpose: deactivate any active venv, find .venv/ or venv/ in CWD, activate it,
# and VERIFY python/pip resolve from that venv.

# Guard: ensure script is sourced, not executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "❌ This script must be sourced:"
  echo "   source activate_venv.sh"
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
  echo "❌ No virtual environment found in: $(pwd)"
  echo "Expected one of:"
  echo "  .venv/"
  echo "  venv/"
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
  echo "❌ Activation failed: VIRTUAL_ENV not set"
  return 1
fi

# Expect sys.executable under VIRTUAL_ENV
case "$SYS_EXE" in
  "$VIRTUAL_ENV"/*) ;;
  *)
    echo "❌ Activation mismatch:"
    echo "   VIRTUAL_ENV : $VIRTUAL_ENV"
    echo "   python path : ${PY_EXE:-<none>}"
    echo "   sys.executable: ${SYS_EXE:-<none>}"
    echo "   pip path    : ${PIP_EXE:-<none>}"
    echo ""
    echo "Try: deactivate; hash -r; source $VENV_PATH/bin/activate"
    return 1
    ;;
esac

echo "✅ Venv active"
echo "   VIRTUAL_ENV : $VIRTUAL_ENV"
echo "   python      : $SYS_EXE"
echo "   pip         : ${PIP_EXE:-<none>}"
