#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s <required_version>\n' "$(basename "$0")" >&2
}

parse_semver() {
  local version="$1"
  if [[ ! "$version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    printf 'Invalid semantic version: %s (expected major.minor.patch)\n' "$version" >&2
    return 1
  fi

  printf '%s %s %s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

required_version="$1"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
version_file="$repo_root/VERSION"

if [[ ! -f "$version_file" ]]; then
  printf 'VERSION file not found at %s\n' "$version_file" >&2
  exit 1
fi

installed_version="$(<"$version_file")"

read -r required_major required_minor required_patch < <(parse_semver "$required_version")
read -r installed_major installed_minor installed_patch < <(parse_semver "$installed_version")

if (( installed_major > required_major )) \
  || (( installed_major == required_major && installed_minor > required_minor )) \
  || (( installed_major == required_major && installed_minor == required_minor && installed_patch >= required_patch )); then
  printf 'Version check passed: installed=%s required=%s\n' "$installed_version" "$required_version"
  exit 0
fi

printf 'Version check failed: installed=%s required=%s\n' "$installed_version" "$required_version" >&2
exit 1
