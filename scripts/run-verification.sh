#!/usr/bin/env bash
set -euo pipefail

EXPECTED_GIT_TOOL_SHA="7c43f37e7b07cfb57638a1d1dad2501de09ba7eb"
EXPECTED_SCAD_TOOL_SHA="5712324ea9e3a7c81ba1b79013f2758f52b219cf"
EXPECTED_SCAD_TOOL_REF="v0.14.2"

OUT="vrf/out"
VERIFY_PNGS=(
  "$OUT/png/tube-holder-bore-check.png"
  "$OUT/png/mounting-plate-thickness-check.png"
)

for file in "${VERIFY_PNGS[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "ERROR: expected non-empty generated output is missing: $file" >&2
    exit 1
  fi
done

if ! grep -Fq 'type: scad' project.yml || ! grep -Fq 'config: project.scad.yml' project.yml; then
  echo "ERROR: project.yml must declare project.scad.yml as the SCAD profile" >&2
  exit 1
fi

if grep -Fq 'name: tool.git-project' project.yml; then
  echo "ERROR: tool.git-project is the bootstrap engine and must not manage itself through project.yml" >&2
  exit 1
fi

TOOL_REF="$(awk '
  $1 == "-" && $2 == "name:" { in_tool = ($3 == "tool.scad-project"); next }
  in_tool && $1 == "ref:" { print $2; exit }
' project.yml)"
if [[ "$TOOL_REF" != "$EXPECTED_SCAD_TOOL_REF" ]]; then
  echo "ERROR: tool.scad-project must use released ref ${EXPECTED_SCAD_TOOL_REF}; got ${TOOL_REF:-<missing>}" >&2
  exit 1
fi

for path in tools/tool.git-project tools/tool.scad-project dsg/openscad/ext/lib.scad.clamps; do
  if ! git ls-files --stage -- "$path" | grep -q '^160000 '; then
    echo "ERROR: expected committed direct gitlink is missing: $path" >&2
    exit 1
  fi
done

GIT_TOOL_SHA="$(git -C tools/tool.git-project rev-parse HEAD)"
TOOL_SHA="$(git -C tools/tool.scad-project rev-parse HEAD)"
if [[ "$GIT_TOOL_SHA" != "$EXPECTED_GIT_TOOL_SHA" ]]; then
  echo "ERROR: tool.git-project must resolve to ${EXPECTED_GIT_TOOL_SHA}; got ${GIT_TOOL_SHA}" >&2
  exit 1
fi
if [[ "$TOOL_SHA" != "$EXPECTED_SCAD_TOOL_SHA" ]]; then
  echo "ERROR: tool.scad-project must resolve to released ${EXPECTED_SCAD_TOOL_REF} commit ${EXPECTED_SCAD_TOOL_SHA}; got ${TOOL_SHA}" >&2
  exit 1
fi

if [[ -e .github/workflows/build.yml || -e .github/workflows/verify.yml ]]; then
  echo "ERROR: standalone Build/Verify callers must not coexist with the shared production lifecycle" >&2
  exit 1
fi

SCAD_WORKFLOW=.github/workflows/scad.yml
REUSABLE_PRODUCTION="brainboxemb/tool.scad-project/.github/workflows/project-production.yml@${EXPECTED_SCAD_TOOL_SHA}"
for required in \
  "$REUSABLE_PRODUCTION" \
  'cache_namespace: template-scad-production-v2'; do
  if ! grep -Fq "$required" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} is missing Migration-005 production caller contract: ${required}" >&2
    exit 1
  fi
done
for removed in \
  'affected_task:' \
  'aggregate_task:' \
  'scad.production-impact' \
  'scad.ci'; do
  if grep -Fq "$removed" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} still exposes removed Migration-004 lifecycle input: ${removed}" >&2
    exit 1
  fi
done

# The consumer caller stays thin; reusable orchestration and publication belong to released tools.
for forbidden in \
  'container:' \
  'fetch-depth:' \
  'brainboxemb/tool.git-project/moon/' \
  'generated-output-publish.sh' \
  'scad-project.sh build' \
  'scad-project.sh verify'; do
  if grep -Fq "$forbidden" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} contains shared implementation detail instead of remaining a thin caller: ${forbidden}" >&2
    exit 1
  fi
done

if ! grep -Fq "project-release.yml@${EXPECTED_SCAD_TOOL_SHA}" .github/workflows/release.yml; then
  echo "ERROR: release.yml is not pinned to released tool.scad-project ${EXPECTED_SCAD_TOOL_SHA}" >&2
  exit 1
fi
if ! grep -Fq 'reusable-pr-preview-cleanup.yml@v0.2.8' .github/workflows/pr-cleanup.yml; then
  echo "ERROR: pr-cleanup.yml must use released generic cleanup workflow v0.2.8" >&2
  exit 1
fi

if ! grep -Fq "extends: '../../tools/tool.scad-project/moon/tasks/scad.yml'" .moon/tasks/scad.yml; then
  echo "ERROR: .moon/tasks/scad.yml must inherit the pinned shared SCAD task policy" >&2
  exit 1
fi
if grep -Fq 'workspace:' .moon/workspace.yml || grep -Fq 'inheritedTasks:' .moon/workspace.yml; then
  echo "ERROR: project-level inherited-task selection belongs in moon.yml, not .moon/workspace.yml" >&2
  exit 1
fi
for required in \
  'workspace:' \
  'inheritedTasks:' \
  '- scad.docs' \
  '- scad.build' \
  '- scad.verify' \
  'tasks:' \
  'scad.docs:' \
  'scad.build:' \
  'scad.verify:'; do
  if ! grep -Fq -- "$required" moon.yml; then
    echo "ERROR: moon.yml is missing Migration-005 capability contract: ${required}" >&2
    exit 1
  fi
done

for removed in \
  'scad.build-index:' \
  'scad.build-provenance:' \
  'scad.verification-provenance:' \
  'scad.production-impact:' \
  'scad.ci:' \
  'command:' \
  'script:' \
  'tools/tool.scad-project/**' \
  'tools/tool.git-project/**'; do
  if grep -Fq "$removed" moon.yml; then
    echo "ERROR: moon.yml still contains removed/copied shared lifecycle detail: ${removed}" >&2
    exit 1
  fi
done

# Do not mirror the concrete Moon input list here. Impact selection is qualified
# behaviorally in CI; this script only checks the stable capability/ownership contract.

if ! grep -Eq '^  pull_request:' "$SCAD_WORKFLOW"; then
  echo "ERROR: ${SCAD_WORKFLOW} must run for pull requests" >&2
  exit 1
fi
if ! grep -Eq '^      - main$' "$SCAD_WORKFLOW"; then
  echo "ERROR: ${SCAD_WORKFLOW} must run for pushes to main" >&2
  exit 1
fi

if ! grep -Fq 'pr_branch_prefix: dev/pr' project.scad.yml; then
  echo "ERROR: project.scad.yml must retain pull-request-scoped SCAD release/publication policy" >&2
  exit 1
fi

if ! cmp -s bootstrap.sh tools/tool.git-project/bootstrap/consumer-bootstrap.sh; then
  echo "ERROR: bootstrap.sh differs from the pinned tool.git-project consumer bootstrap" >&2
  exit 1
fi
if ! cmp -s bootstrap.ps1 tools/tool.git-project/bootstrap/consumer-bootstrap.ps1; then
  echo "ERROR: bootstrap.ps1 differs from the pinned tool.git-project consumer bootstrap" >&2
  exit 1
fi
if ! cmp -s update-repo.sh tools/tool.scad-project/bootstrap/consumer-update.sh; then
  echo "ERROR: update-repo.sh differs from the released tool.scad-project SCAD update wrapper" >&2
  exit 1
fi
if ! cmp -s update-repo.ps1 tools/tool.scad-project/bootstrap/consumer-update.ps1; then
  echo "ERROR: update-repo.ps1 differs from the released tool.scad-project SCAD update wrapper" >&2
  exit 1
fi

mkdir -p "$OUT"
rm -f "$OUT/png/tube-holder-assembly.png"
cp vrf/templates/README.md "$OUT/README.md"

echo "Migration 005 reference-consumer verification: OK"
