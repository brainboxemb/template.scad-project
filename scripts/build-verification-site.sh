#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE="$ROOT/bld/verification-site"

rm -rf "$SITE"
mkdir -p "$SITE/build"
cp -R "$ROOT/dsg" "$SITE/dsg"
cp -R "$ROOT/bld/png" "$SITE/build/png"
cp -R "$ROOT/bld/stl" "$SITE/build/stl"

cat > "$SITE/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>SCAD project verification</title>
  <style>
    body { font-family: system-ui,sans-serif; max-width: 980px; margin: 2rem auto; padding: 0 1rem; }
    img { max-width: 100%; border: 1px solid #ddd; }
    code { background: #f3f3f3; padding: .1rem .3rem; }
  </style>
</head>
<body>
  <h1>SCAD project verification</h1>
  <p>Generated verification snapshot.</p>
  <h2>Assembly render</h2>
  <img src="build/png/tube-holder-assembly.png" alt="Tube holder assembly">
  <h2>Build output</h2>
  <p><a href="build/stl/tube-holder-assembly.stl">Assembly STL</a></p>
  <h2>Design documentation</h2>
  <p>The snapshot also contains the generated <code>dsg/**/design/img</code> image sets.</p>
</body>
</html>
HTML

echo "Verification site built in $SITE"
