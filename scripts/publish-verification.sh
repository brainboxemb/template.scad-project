#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE="$ROOT/bld/verification-site"

[[ -f "$SITE/index.html" ]] || { echo "ERROR: verification site missing." >&2; exit 1; }

SOURCE_TYPE="${GITHUB_REF_TYPE:-branch}"
SOURCE_NAME="${GITHUB_REF_NAME:-main}"

if [[ "$SOURCE_TYPE" == "tag" ]]; then
  TARGET="verification/$SOURCE_NAME"
  if git ls-remote --exit-code --heads origin "$TARGET" >/dev/null 2>&1; then
    echo "ERROR: immutable verification branch already exists: $TARGET" >&2
    exit 1
  fi
  FORCE=""
else
  TARGET="verification"
  FORCE="--force"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -R "$SITE/." "$TMP/"

git -C "$TMP" init -q
git -C "$TMP" checkout --orphan snapshot >/dev/null 2>&1
git -C "$TMP" config user.name "github-actions[bot]"
git -C "$TMP" config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git -C "$TMP" add .
git -C "$TMP" commit -q -m "Verification snapshot for ${SOURCE_NAME}"
git -C "$TMP" remote add origin "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git"
git -C "$TMP" push $FORCE origin HEAD:"$TARGET"

echo "Published verification snapshot to $TARGET"
