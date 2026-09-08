#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENTRY="$ROOT/dsg/render/tube-holder-assembly.scad"
LIB="$ROOT/dsg/ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad"

if [[ ! -f "$LIB" ]]; then
  echo "ERROR: external library not initialized: $LIB" >&2
  exit 1
fi

mkdir -p "$ROOT/bld/png" "$ROOT/bld/stl"

xvfb-run -a openscad --enable=object-function --render --imgsize=1600,1000 \
  -o "$ROOT/bld/png/tube-holder-assembly.png" "$ENTRY"

openscad --enable=object-function \
  -o "$ROOT/bld/stl/tube-holder-assembly.stl" "$ENTRY"

test -s "$ROOT/bld/png/tube-holder-assembly.png"
test -s "$ROOT/bld/stl/tube-holder-assembly.stl"

echo "Verification passed."
