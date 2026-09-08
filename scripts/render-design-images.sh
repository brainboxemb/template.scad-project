#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp --suffix=.scad)"
trap 'rm -f "$TMP"' EXIT

expected=()

render_view() {
  local source="$1"
  local invocation="$2"
  local output="$3"

  cat > "$TMP" <<SCAD
use <$source>
\$fn = 120;
$invocation
SCAD

  mkdir -p "$(dirname "$output")"
  xvfb-run -a openscad \
    --enable=object-function \
    --render \
    --imgsize=1400,900 \
    -o "$output" \
    "$TMP"

  expected+=("$output")
}

render_view "$ROOT/dsg/components/mounting-plate/mounting_plate.scad" 'mounting_plate_design("base");' "$ROOT/dsg/components/mounting-plate/design/img/01-base-plate.png"
render_view "$ROOT/dsg/components/mounting-plate/mounting_plate.scad" 'mounting_plate_design("final");' "$ROOT/dsg/components/mounting-plate/design/img/02-final.png"

render_view "$ROOT/dsg/components/tube/tube.scad" 'tube_design("outer");' "$ROOT/dsg/components/tube/design/img/01-outer.png"
render_view "$ROOT/dsg/components/tube/tube.scad" 'tube_design("bore");' "$ROOT/dsg/components/tube/design/img/02-bore.png"
render_view "$ROOT/dsg/components/tube/tube.scad" 'tube_design("final");' "$ROOT/dsg/components/tube/design/img/03-final.png"

render_view "$ROOT/dsg/components/tube-holder/tube_holder.scad" 'tube_holder_design("library-clamp");' "$ROOT/dsg/components/tube-holder/design/img/01-library-clamp.png"
render_view "$ROOT/dsg/components/tube-holder/tube_holder.scad" 'tube_holder_design("final");' "$ROOT/dsg/components/tube-holder/design/img/02-final.png"

render_view "$ROOT/dsg/assemblies/tube-holder-assembly/tube_holder_assembly.scad" 'tube_holder_assembly_design("plate");' "$ROOT/dsg/assemblies/tube-holder-assembly/design/img/01-plate.png"
render_view "$ROOT/dsg/assemblies/tube-holder-assembly/tube_holder_assembly.scad" 'tube_holder_assembly_design("clamp");' "$ROOT/dsg/assemblies/tube-holder-assembly/design/img/02-clamp.png"
render_view "$ROOT/dsg/assemblies/tube-holder-assembly/tube_holder_assembly.scad" 'tube_holder_assembly_design("tube");' "$ROOT/dsg/assemblies/tube-holder-assembly/design/img/03-tube.png"
render_view "$ROOT/dsg/assemblies/tube-holder-assembly/tube_holder_assembly.scad" 'tube_holder_assembly_design("final");' "$ROOT/dsg/assemblies/tube-holder-assembly/design/img/04-final.png"

is_expected() {
  local candidate="$1"
  local item
  for item in "${expected[@]}"; do
    [[ "$candidate" == "$item" ]] && return 0
  done
  return 1
}

while IFS= read -r -d '' png; do
  if ! is_expected "$png"; then
    echo "Removing stale design image: ${png#$ROOT/}"
    rm -f "$png"
  fi
done < <(find "$ROOT/dsg" -path '*/design/img/*.png' -type f -print0)

echo "Design images rendered successfully."
