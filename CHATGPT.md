# ChatGPT project handoff

## Repository role

`template.scad-project` is the reference consumer for the current SCAD project architecture. Keep generic behavior in `tool.scad-project`; do not reintroduce project-specific build/render orchestration here.

```text
docker.scad-toolchain
    runtime/capabilities

tool.scad-project
    reusable workflow and conventions

template.scad-project
    project configuration, source and documentation
```

## Current baseline

```text
tool.scad-project   v0.9.1
SCAD toolchain      v0.4.1
SCons               4.11.1
```

The tool release is declared in `project.yml`, pinned by the `tools/tool.scad-project` gitlink, and matched by all reusable workflow refs.

## Project structure

```text
project.yml

dsg/
├── openscad/
│   ├── ext/
│   ├── lib/
│   ├── components/
│   ├── assemblies/
│   ├── render/
│   ├── export/
│   └── main.scad
└── pythonscad/

tools/
└── tool.scad-project/

vrf/
```

Do not add a second copy of the project under `tools/`. That directory contains only the pinned tool submodule.

## Directory-based build convention

Normal build targets are discovered from configured roots:

```yaml
paths:
  design_root: dsg
  build_root: bld
  render_root: dsg/openscad/render
  export_root: dsg/openscad/export
```

```text
render/*.scad -> bld/png/*.png
export/*.scad -> bld/stl/*.stl
```

Do not list normal render/export files under root `builds:`. Keep explicit `builds:` only for exceptional mappings that cannot be represented by directory discovery. Use `render.yml` / `export.yml` for profile-specific behavior such as multiple sizes.

The template enables:

```yaml
build_engine:
  engine: scons
```

SCons dependency selection and cache semantics belong to `tool.scad-project`, not the template.

## Design documentation

Source design documentation lives beside the owning component/assembly as `design/design.md`. Prefer `scad-render-defaults` plus compact `scad-render` steps and source views rather than duplicating geometry in Markdown.

Generated design material belongs only under `bld/design`; never commit `design/img/` output beside source docs.

The template deliberately uses:

```yaml
design:
  include_externals: false
```

External CAD source remains available, but this consumer publishes only project-owned design documentation.

Keep the small PythonSCAD example as an end-to-end multi-engine design test; it is not a requirement to duplicate real components in PythonSCAD.

## Dependencies and bootstrap

Direct submodules are:

```text
tools/tool.scad-project
dsg/openscad/ext/lib.scad.clamps
```

Checkout is intentionally direct/non-recursive. A consumer does not initialize nested development dependencies of its libraries.

Root helper scripts:

```text
bootstrap.ps1
bootstrap.sh
update-repo.ps1
update-repo.sh
```

must stay exact copies of the canonical versions from the pinned `tool.scad-project` release. Bootstrap remains Python-free and uses Git plus PowerShell/bash only. `update-repo` resolves dependency policy from `project.yml`, updates gitlinks/workflow refs and leaves changes uncommitted for review.

## OpenSCAD boundaries

`use <file.scad>` imports modules/functions, not top-level variables. Values required across component boundaries must be exposed through functions/parameters rather than directly reading constants that would become `undef`.

The reference assembly keeps the reusable clamp in library-native coordinates. Project mounting adapters apply the rotation at the assembly boundary; the tube follows the clamp bore axis.

## CI

The template is a real consumer and keeps thin callers only:

```text
.github/workflows/build.yml
    -> project-build.yml@v0.9.1

.github/workflows/verify.yml
    -> project-verify.yml@v0.9.1

.github/workflows/release.yml
    -> project-release.yml@v0.9.1
```

Do not duplicate generic tool logic in workflow shell blocks.

`scad-project build-index` generates both `bld/README.md` and the normal build PNG gallery at `bld/png/README.md`. There is no source `docs/build-README.md` template anymore.

## Publication lifecycle

```text
main
    source only

prod/build
prod/verification
    mutable latest successful production snapshots

dev/build
dev/verification
    mutable latest development snapshots

rel/vX.Y.Z/build
rel/vX.Y.Z/verification
    immutable browseable release snapshots
```

Pull requests are artifact-only. A versioned release must use the exact current production-branch HEAD, pass coordinated Build + Verify, then create immutable `rel/*` branches, an annotated source tag and GitHub Release bundles/checksums.

Every generated snapshot contains `publication-info.txt` with source, tool/toolchain, submodule and runtime provenance.

## Source documentation

Structured `.scad` comments follow `openscad_docsgen` conventions. A structured source starts with `// File:` or `// LibFile:` before Module/Function/etc blocks. Treat OpenSCAD warnings indicating `undef`/undefined geometry as failures; presentation-only camera warnings remain allowed by the shared tool policy.
