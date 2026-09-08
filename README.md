# template.scad-project

Template OpenSCAD project with reusable libraries, design documentation, automated renders and verification.

This repository demonstrates the full SCAD workflow:

- `dsg/` for design source and per-component/assembly design documentation;
- `bld/` for generated output;
- `vrf/` for verification documentation;
- external libraries under `dsg/ext/` as Git submodules;
- generated design images under each `design/img/`;
- one `dsg/main.scad` development entrypoint;
- stable CI render/export entrypoints;
- verification snapshots outside `main`.

## Example assembly

The example is deliberately simple:

```text
mounting plate + tube clamp from lib.scad.clamps + 20 mm tube
```

## Structure

```text
dsg/
├── ext/
├── lib/
├── components/
│   ├── mounting-plate/
│   │   ├── mounting_plate.scad
│   │   └── design/design.md
│   ├── tube/
│   │   ├── tube.scad
│   │   └── design/design.md
│   └── tube-holder/
│       ├── tube_holder.scad
│       └── design/design.md
├── assemblies/
│   └── tube-holder-assembly/
│       ├── tube_holder_assembly.scad
│       └── design/design.md
├── render/
└── main.scad
bld/
vrf/
scripts/
```

## External library

The example expects `lib.scad.clamps` at:

```text
dsg/ext/lib.scad.clamps
```

Initialize it with:

```powershell
./scripts/init-libraries.ps1
```

or:

```bash
bash scripts/init-libraries.sh
```

## Design documentation

Every meaningful component and assembly owns:

```text
<item>/
├── <item>.scad
└── design/
    ├── design.md
    └── img/
```

Generate all design images with:

```bash
bash scripts/render-design-images.sh
```

The script renders the complete expected image set first and only then removes stale PNG files.

## Verification branches

- `verification`: mutable orphan snapshot with the latest successful verification output.
- `verification/vX.Y.Z`: immutable orphan snapshot associated with tag `vX.Y.Z`.

A versioned verification branch is never overwritten.

## Toolchain

CI uses:

```text
ghcr.io/brainboxemb/scad-toolchain:v0.2.0
```

The clamp library uses the OpenSCAD object API, so OpenSCAD is invoked with `--enable=object-function`.

The model, code and documentation were developed with the assistance of ChatGPT.
