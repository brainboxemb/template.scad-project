#!/usr/bin/env bash
set -euo pipefail

BUILD_PNG="bld/png/tube-holder-assembly.png"
BUILD_STL="bld/stl/tube-holder-assembly.stl"
OUT="vrf/out"
VERIFY_PNGS=(
  "$OUT/png/tube-holder-bore-check.png"
  "$OUT/png/mounting-plate-thickness-check.png"
)

for file in "$BUILD_PNG" "$BUILD_STL" "${VERIFY_PNGS[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "ERROR: expected non-empty generated output is missing: $file" >&2
    exit 1
  fi
done

TOOL_REF="$(awk '$1 == "ref:" { print $2; exit }' project.yml)"
if [[ -z "$TOOL_REF" ]]; then
  echo "ERROR: unable to resolve tool.scad-project ref from project.yml" >&2
  exit 1
fi

TOOL_SHA="$(git -C tools/tool.scad-project rev-parse HEAD)"
if [[ ! "$TOOL_SHA" =~ ^[0-9a-f]{40}$ ]]; then
  echo "ERROR: unable to resolve exact tool.scad-project gitlink commit" >&2
  exit 1
fi

RESOLVED_REF_SHA="$(git -C tools/tool.scad-project rev-parse "${TOOL_REF}^{commit}" 2>/dev/null || true)"
if [[ "$RESOLVED_REF_SHA" != "$TOOL_SHA" ]]; then
  echo "ERROR: tooling ref ${TOOL_REF} resolves to ${RESOLVED_REF_SHA:-<missing>} instead of gitlink ${TOOL_SHA}" >&2
  exit 1
fi

for mapping in \
  "build.yml:project-build" \
  "verify.yml:project-verify" \
  "release.yml:project-release" \
  "pr-cleanup.yml:project-pr-cleanup"; do
  caller="${mapping%%:*}"
  reusable="${mapping#*:}"
  expected="brainboxemb/tool.scad-project/.github/workflows/${reusable}.yml@${TOOL_SHA}"
  if ! grep -Fq "$expected" ".github/workflows/${caller}"; then
    echo "ERROR: .github/workflows/${caller} is not pinned to exact tooling commit ${TOOL_SHA}" >&2
    exit 1
  fi
done

for caller in build.yml verify.yml; do
  path=".github/workflows/${caller}"
  if ! grep -Eq '^  pull_request:' "$path"; then
    echo "ERROR: ${path} must run for pull requests" >&2
    exit 1
  fi
  if ! grep -Eq '^      - main$' "$path"; then
    echo "ERROR: ${path} must run for pushes to main" >&2
    exit 1
  fi
  if grep -Fq -- '- "**"' "$path"; then
    echo "ERROR: ${path} must not run for every feature-branch push" >&2
    exit 1
  fi
done

if ! grep -Fq 'pr_branch_prefix: dev/pr' project.yml; then
  echo "ERROR: project.yml must use pull-request-scoped development publication" >&2
  exit 1
fi

for script in bootstrap.ps1 bootstrap.sh update-repo.ps1 update-repo.sh; do
  canonical="tools/tool.scad-project/bootstrap/${script}"
  if ! cmp -s "$script" "$canonical"; then
    echo "ERROR: ${script} differs from canonical ${canonical}" >&2
    exit 1
  fi
done

mkdir -p "$OUT"
rm -f "$OUT/png/tube-holder-assembly.png"
cp vrf/templates/README.md "$OUT/README.md"

echo "Template functional verification: OK"
