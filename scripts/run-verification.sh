#!/usr/bin/env bash
set -euo pipefail

# Temporary Migration 004 Step 3 qualification contract.
# This branch deliberately tests an unreleased exact tool.scad-project revision.
# The normal template main/release policy remains release-tag based.
EXPECTED_GIT_TOOL_SHA="fcfe97fd468d2c5f03e0c11637a62db8fafc1751"
EXPECTED_SCAD_TOOL_SHA="f71590631fdc1d278f2bcecbee46fdcc696b7429"

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
if [[ "$TOOL_REF" != "$EXPECTED_SCAD_TOOL_SHA" ]]; then
  echo "ERROR: qualification project.yml must pin exact tool.scad-project ${EXPECTED_SCAD_TOOL_SHA}; got ${TOOL_REF:-<missing>}" >&2
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
  echo "ERROR: tool.git-project gitlink must resolve to ${EXPECTED_GIT_TOOL_SHA}; got ${GIT_TOOL_SHA}" >&2
  exit 1
fi
if [[ "$TOOL_SHA" != "$EXPECTED_SCAD_TOOL_SHA" ]]; then
  echo "ERROR: tool.scad-project gitlink must resolve to ${EXPECTED_SCAD_TOOL_SHA}; got ${TOOL_SHA}" >&2
  exit 1
fi

if [[ -e .github/workflows/build.yml || -e .github/workflows/verify.yml ]]; then
  echo "ERROR: standalone Build/Verify callers must not coexist with the production Moon graph" >&2
  exit 1
fi

SCAD_WORKFLOW=.github/workflows/scad.yml
REUSABLE_PRODUCTION="brainboxemb/tool.scad-project/.github/workflows/project-production.yml@${EXPECTED_SCAD_TOOL_SHA}"
for required in \
  "$REUSABLE_PRODUCTION" \
  'affected_task: consumer:scad.production-impact' \
  'aggregate_task: consumer:scad.ci' \
  'cache_namespace: template-scad-production-m004-step3-v1'; do
  if ! grep -Fq "$required" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} is missing Step 3 reusable-production caller contract: ${required}" >&2
    exit 1
  fi
done

# The consumer caller must stay thin: orchestration, container and publication live in tool.scad-project/tool.git-project.
for forbidden in \
  'container:' \
  'brainboxemb/tool.git-project/moon@' \
  'reusable-generated-output-publish.yml@' \
  'scad-project.sh build' \
  'scad-project.sh verify'; do
  if grep -Fq "$forbidden" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} contains owner implementation detail instead of remaining a thin reusable-workflow caller: ${forbidden}" >&2
    exit 1
  fi
done

if ! grep -Fq "project-release.yml@${EXPECTED_SCAD_TOOL_SHA}" .github/workflows/release.yml; then
  echo "ERROR: release.yml is not aligned to qualification tool.scad-project ${EXPECTED_SCAD_TOOL_SHA}" >&2
  exit 1
fi

for required in \
  'scad.docs:' \
  'scad-project.sh design-build' \
  'bld/evidence/executions/scad-docs/**' \
  'bld/evidence/domain/last-design-build.json' \
  'scad.build:' \
  'scad-project.sh build' \
  'bld/evidence/executions/scad-build/**' \
  'bld/evidence/domain/last-build.json' \
  'scad.build-index:' \
  'scad-project.sh build-index' \
  'scad.build-provenance:' \
  'scad-project.sh publication-info-build' \
  'scad.verify:' \
  'scad-project.sh verify' \
  'vrf/out/evidence/executions/scad-verify/**' \
  'vrf/out/evidence/domain/last-verification-build.json' \
  'scad.verification-provenance:' \
  'scad-project.sh publication-info-verification' \
  'scad.production-impact:' \
  'scad.ci:'; do
  if ! grep -Fq "$required" moon.yml; then
    echo "ERROR: moon.yml is missing explicit SCAD production/evidence stage contract: ${required}" >&2
    exit 1
  fi
done

for coarse in produce-build produce-verification; do
  if grep -Fq "$coarse" moon.yml; then
    echo "ERROR: moon.yml must expose meaningful production stages instead of coarse ${coarse}" >&2
    exit 1
  fi
done

if awk '
  /^  scad\.verify:/ { in_verify = 1 }
  /^  scad\.verification-provenance:/ { in_verify = 0 }
  in_verify { print }
' moon.yml | grep -Fq -- "- 'scad.build'"; then
  echo "ERROR: scad.verify must remain logically independent from normal scad.build output" >&2
  exit 1
fi

IMPACT_BLOCK="$(awk '
  /^  scad\.production-impact:/ { in_impact = 1 }
  /^  scad\.ci:/ { in_impact = 0 }
  in_impact { print }
' moon.yml)"
for dependency in "- 'scad.docs'" "- 'scad.build'" "- 'scad.verify'"; do
  if ! grep -Fq -- "$dependency" <<< "$IMPACT_BLOCK"; then
    echo "ERROR: scad.production-impact is missing producer dependency: ${dependency}" >&2
    exit 1
  fi
done
for forbidden in "scad.build-index" "scad.build-provenance" "scad.verification-provenance" '$GITHUB_EVENT_NAME' '$SCAD_PROJECT_PR_NUMBER'; do
  if grep -Fq -- "$forbidden" <<< "$IMPACT_BLOCK"; then
    echo "ERROR: scad.production-impact must remain source-impact only, not publication-context sensitive: ${forbidden}" >&2
    exit 1
  fi
done

if ! grep -Fq -- "- 'scad.build-provenance'" moon.yml || \
   ! grep -Fq -- "- 'scad.verification-provenance'" moon.yml; then
  echo "ERROR: scad.ci must resolve both build and verification publication-ready branches" >&2
  exit 1
fi

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
  echo "ERROR: update-repo.sh differs from the qualification tool.scad-project SCAD update wrapper" >&2
  exit 1
fi
if ! cmp -s update-repo.ps1 tools/tool.scad-project/bootstrap/consumer-update.ps1; then
  echo "ERROR: update-repo.ps1 differs from the qualification tool.scad-project SCAD update wrapper" >&2
  exit 1
fi

mkdir -p "$OUT"
rm -f "$OUT/png/tube-holder-assembly.png"
cp vrf/templates/README.md "$OUT/README.md"

echo "Migration 004 Step 3 reusable-production qualification verification: OK"
