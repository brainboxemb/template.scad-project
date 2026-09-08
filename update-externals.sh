#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .gitmodules ]]; then
    echo "ERROR: .gitmodules not found." >&2
    exit 1
fi

git submodule sync --recursive
git submodule update --init --recursive

declare -a summary=()
found=0

while read -r key path; do
    # Tooling is pinned separately. Only update CAD/library externals.
    case "$path" in
        dsg/*/ext/*) ;;
        *) continue ;;
    esac

    found=1
    name="${key#submodule.}"
    name="${name%.path}"

    if [[ -n "$(git -C "$path" status --porcelain)" ]]; then
        echo "ERROR: external '$path' has local changes." >&2
        echo "Commit, stash or discard them before updating." >&2
        exit 1
    fi

    old_commit="$(git -C "$path" rev-parse HEAD)"

    git -C "$path" fetch --prune --tags origin

    remote_head="$(git -C "$path" symbolic-ref --quiet --short refs/remotes/origin/HEAD || true)"
    if [[ -z "$remote_head" ]]; then
        echo "ERROR: cannot determine origin default branch for '$path'." >&2
        exit 1
    fi

    branch="${remote_head#origin/}"

    if git -C "$path" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$path" checkout "$branch"
    else
        git -C "$path" checkout -b "$branch" --track "origin/$branch"
    fi

    git -C "$path" pull --ff-only origin "$branch"

    new_commit="$(git -C "$path" rev-parse HEAD)"

    if [[ "$old_commit" == "$new_commit" ]]; then
        summary+=("$name|$path|$branch|$old_commit|$new_commit|unchanged")
    else
        summary+=("$name|$path|$branch|$old_commit|$new_commit|changed")
    fi
done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$')

if [[ "$found" -eq 0 ]]; then
    echo "No CAD/library externals found below dsg/*/ext/."
    exit 0
fi

echo
echo "External update summary"
echo "======================="

for row in "${summary[@]}"; do
    IFS='|' read -r name path branch old_commit new_commit state <<< "$row"
    echo

    if [[ "$state" == "changed" ]]; then
        echo "$name"
        echo "  path   : $path"
        echo "  branch : $branch"
        echo "  old    : $old_commit"
        echo "  new    : $new_commit"
    else
        echo "$name - unchanged ($new_commit)"
    fi
done

echo
echo "Parent repository status:"
git status --short
echo
echo "Review the changed external gitlinks before committing them."
echo "Tooling under tools/ is intentionally not updated by this script."
