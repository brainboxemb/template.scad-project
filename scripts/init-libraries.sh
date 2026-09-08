#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

LIB_PATH="dsg/ext/lib.scad.clamps"
LIB_URL="https://github.com/brainboxemb/lib.scad.clamps.git"

if [[ -e "$LIB_PATH/.git" || -f "$LIB_PATH/.git" ]]; then
  echo "Library already initialized: $LIB_PATH"
  exit 0
fi

if [[ -d "$LIB_PATH" ]] && [[ -n "$(find "$LIB_PATH" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
  echo "ERROR: $LIB_PATH already contains files." >&2
  exit 1
fi

rm -rf "$LIB_PATH"
git submodule add "$LIB_URL" "$LIB_PATH"
git submodule update --init --recursive

echo "Library initialized. Commit .gitmodules and the submodule entry."
