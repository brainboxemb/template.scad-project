# ChatGPT project handoff

`template.scad-project` is the reference OpenSCAD project structure.

## Core rules

- `dsg/ext/`: external Git submodules.
- `dsg/lib/`: project-local reusable helpers.
- `dsg/components/`: project-specific components.
- `dsg/assemblies/`: project assemblies.
- `dsg/render/`: stable render/export entrypoints.
- `dsg/main.scad`: interactive development entrypoint.
- `bld/`: generated output.
- `vrf/`: verification documentation.

Every meaningful component/assembly should own `design/design.md` and generated `design/img/` views. Source and design docs evolve together.

Render all expected design images before removing stale PNGs.

External libraries must not be copied into the project. Use Git submodules under `dsg/ext/`.

The current example is intentionally simple: mounting plate + external tube clamp + tube.

Verification policy:

- `verification`: mutable latest orphan snapshot.
- `verification/vX.Y.Z`: immutable release snapshot branch.

Keep generated verification output off `main`.

Current toolchain baseline: `ghcr.io/brainboxemb/scad-toolchain:v0.2.0`.
