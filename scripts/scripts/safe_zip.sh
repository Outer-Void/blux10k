#!/usr/bin/env bash
set -euo pipefail

if ! command -v zip >/dev/null 2>&1; then
    echo "zip command not found. Install zip and retry." >&2
    exit 1
fi

STAMP="$(date +%Y%m%d)"
OUTPUT="resolver_safe_${STAMP}.zip"

zip -r "${OUTPUT}" . \
    -x ".git/*" \
    -x ".git" \
    -x ".venv/*" \
    -x ".venv" \
    -x "venv/*" \
    -x "venv" \
    -x "*/.venv/*" \
    -x "*/venv/*" \
    -x ".env" \
    -x ".env.*" \
    -x "data/*.sqlite3" \
    -x "data/*.db" \
    -x "*.sqlite3" \
    -x "*.db" \
    -x "logs/*" \
    -x "__pycache__/*" \
    -x "*/__pycache__/*" \
    -x ".pytest_cache/*" \
    -x "*/.pytest_cache/*"

echo "Created ${OUTPUT}"
