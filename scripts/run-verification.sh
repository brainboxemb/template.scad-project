#!/usr/bin/env bash
set -euo pipefail

QUALIFICATION_TOOL_SHA="21a3d73c9ef3d3d0262327cfb382420b3d5b6c28"
SOURCE="scripts/run-verification-release.sh"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

sed \
  -e "s/^EXPECTED_SCAD_TOOL_SHA=.*/EXPECTED_SCAD_TOOL_SHA=\"${QUALIFICATION_TOOL_SHA}\"/" \
  -e "s/^EXPECTED_SCAD_TOOL_REF=.*/EXPECTED_SCAD_TOOL_REF=\"${QUALIFICATION_TOOL_SHA}\"/" \
  "$SOURCE" > "$TMP"

bash "$TMP"
