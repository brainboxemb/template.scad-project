#!/usr/bin/env bash
set -euo pipefail

EXPECTED_GIT_TOOL_SHA="fcfe97fd468d2c5f03e0c11637a62db8fafc1751"
EXPECTED_SCAD_TOOL_SHA="68301267273ea21c4b82ff3b26e1c8a30ff7b065"
EXPECTED_SCAD_TOOL_REF="v0.12.0"

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
  echo "ERROR: tool.scad-project must resolve to ${EXPECTED_SCAD_TOOL_SHA}; got ${TOOL_SHA}" >&2
  exit 1
fi

if [[ -e .github/workflows/build.yml || -e .github/workflows/verify.yml ]]; then
  echo "ERROR: standalone Build/Verify callers must not coexist with the production Moon graph" >&2
  exit 1
fi

SCAD_WORKFLOW=.github/workflows/scad.yml
for required in \
  'brainboxemb/tool.git-project/moon@v0.2.3' \
  'brainboxemb/tool.git-project/.github/workflows/reusable-generated-output-publish.yml@v0.2.3' \
  'task: consumer:scad.ci' \
  'cache-namespace: template-scad-production-t6-v1' \
  'SCAD_PROJECT_SOURCE_SHA:' \
  'bld/evidence/executions/scad-docs/execution.json' \
  'bld/evidence/executions/scad-build/execution.json' \
  'vrf/out/evidence/executions/scad-verify/execution.json'; do
  if ! grep -Fq "$required" "$SCAD_WORKFLOW"; then
    echo "ERROR: ${SCAD_WORKFLOW} is missing production orchestration contract: ${required}" >&2
    exit 1
  fi
done

if grep -Fq 'task: consumer:scad.build' "$SCAD_WORKFLOW" || \
   grep -Fq 'moon-project.sh run consumer:scad.verify' "$SCAD_WORKFLOW"; then
  echo "ERROR: workflow must invoke one SCAD Moon graph instead of separate build/verify roots" >&2
  exit 1
fi

if grep -Fq 'cp .cache/scad-project/state/last-build.json "$staging/evidence/domain/last-build.json"' "$SCAD_WORKFLOW" || \
   grep -Fq 'cp .cache/scad-project/state/last-design-build.json "$staging/evidence/domain/last-design-build.json"' "$SCAD_WORKFLOW" || \
   grep -Fq 'cp .cache/scad-project/verification-state/last-verification-build.json "$staging/evidence/domain/last-verification-build.json"' "$SCAD_WORKFLOW"; then
  echo "ERROR: publication staging must consume producer-owned domain evidence, not synthesize it from cache state" >&2
  exit 1
fi

if ! grep -Fq "project-release.yml@${EXPECTED_SCAD_TOOL_SHA}" .github/workflows/release.yml; then
  echo "ERROR: release.yml is not pinned to released tool.scad-project ${EXPECTED_SCAD_TOOL_SHA}" >&2
  exit 1
fi
if ! grep -Fq 'reusable-pr-preview-cleanup.yml@v0.2.3' .github/workflows/pr-cleanup.yml; then
  echo "ERROR: pr-cleanup.yml must use released generic cleanup" >&2
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
  echo "ERROR: update-repo.sh differs from the pinned tool.scad-project SCAD update wrapper" >&2
  exit 1
fi
if ! cmp -s update-repo.ps1 tools/tool.scad-project/bootstrap/consumer-update.ps1; then
  echo "ERROR: update-repo.ps1 differs from the pinned tool.scad-project SCAD update wrapper" >&2
  exit 1
fi

mkdir -p "$OUT"
rm -f "$OUT/png/tube-holder-assembly.png"
cp vrf/templates/README.md "$OUT/README.md"

echo "Template T6 SCAD execution-evidence verification: OK"
