# template.scad-project

Reference consumer for the current SCAD project architecture built around `tool.scad-project`.

The repository demonstrates the intended separation:

```text
docker.scad-toolchain
    runtime and external capabilities

tool.scad-project
    reusable project workflow and conventions

template.scad-project
    project configuration, CAD source and project documentation
```

## Quick links

- [Production build](../../tree/prod/build)
- [Production build overview](../../blob/prod/build/README.md)
- [Production build PNG gallery](../../blob/prod/build/png/README.md)
- [Production build provenance](../../blob/prod/build/publication-info.txt)
- [Production verification](../../tree/prod/verification)
- [Project releases](../../releases)

## Current baseline

```text
tool.scad-project   v0.9.5
SCAD toolchain      v0.4.1
SCons               4.11.1
```

The tool is pinned twice: semantically in `project.yml` and technically by the Git submodule gitlink at `tools/tool.scad-project`.

## Reference-consumer role

This repository is the canonical minimal consumer for `tool.scad-project`. A tool release should be exercised here to prove that the documented project structure, bootstrap/update flow and thin Build/Verify/Release callers still work together on a small representative project.

The template is intentionally not the only integration test. Larger consumers can supplement it when a feature needs a realistic dependency graph or enough independent outputs to demonstrate selective rebuild behaviour. In particular, dependency-selective cache tests are more informative in a project such as the HUB75 display frame, while this repository remains the first-line reference/smoke consumer.

## Structure

```text
.
├── project.yml
├── dsg/
│   ├── openscad/
│   │   ├── ext/
│   │   ├── lib/
│   │   ├── components/
│   │   ├── assemblies/
│   │   ├── render/
│   │   ├── export/
│   │   └── main.scad
│   └── pythonscad/
├── tools/
│   └── tool.scad-project/
├── scripts/
├── vrf/
└── .github/workflows/
```

`bld/` is generated output and is not source-of-truth content.

## Configuration-first builds

Normal OpenSCAD outputs are discovered from directories configured in `project.yml`:

```yaml
paths:
  design_root: dsg
  build_root: bld
  render_root: dsg/openscad/render
  export_root: dsg/openscad/export
```

The default mapping is:

```text
dsg/openscad/render/*.scad  -> bld/png/*.png
dsg/openscad/export/*.scad  -> bld/stl/*.stl
```

The reference assembly therefore has two small stable entrypoints with the same basename:

```text
dsg/openscad/render/tube-holder-assembly.scad
dsg/openscad/export/tube-holder-assembly.scad
```

No explicit `builds:` entries are needed for these normal targets. Use optional `render.yml` or `export.yml` only when an entrypoint needs special profiles such as multiple sizes or a non-default render size. Explicit `builds:` remain available for exceptional mappings, but they are not the preferred normal template pattern.

The template enables the selective build backend:

```yaml
build_engine:
  engine: scons
```

SCons tracks OpenSCAD dependencies and restores unchanged outputs from the persistent CI cache. The generated design tree is also restored from cache when its complete input set is unchanged.

`tool.scad-project v0.9.5` generates `bld/png/README.md` as a browseable, deterministically ordered gallery whenever PNG build output is present. The generated `bld/README.md` links directly to that gallery.

## Development entrypoint

Open:

```text
dsg/openscad/main.scad
```

The reference assembly contains a mounting plate, a reusable clamp from `lib.scad.clamps`, and a 20 mm reference tube. The reusable clamp keeps its library-native coordinate system; the project adapter performs the mounting rotation at the assembly boundary.

## Design documentation

Each meaningful component or assembly owns source documentation under `design/design.md`. Render declarations live in that document rather than in `project.yml`.

Example:

```markdown
<!-- scad-render-defaults
module: tube_design
vpr: [60, 0, 35]
-->

<!-- scad-render
view: outer
-->
```

The project default design image size is `640x480`. Generated design documentation is materialized under `bld/design/` and is never committed beside source `design.md` files.

The template deliberately sets:

```yaml
design:
  include_externals: false
```

External CAD source remains available to the project, but the consumer publishes only its project-owned design documentation.

A small PythonSCAD component under `dsg/pythonscad/` remains as an end-to-end demonstration of the multi-engine design pipeline.

## Bootstrap and dependency updates

The root bootstrap and update scripts are exact copies of the canonical scripts from the pinned tool release:

```text
bootstrap.ps1
bootstrap.sh
update-repo.ps1
update-repo.sh
```

Bootstrap deliberately needs only Git plus PowerShell/bash. It restores the direct submodules declared in `.gitmodules`:

```text
tools/tool.scad-project
dsg/openscad/ext/lib.scad.clamps
```

Normal dependency policy lives in `project.yml`. To advance configured dependencies intentionally, run:

```powershell
.\update-repo.ps1
```

or:

```bash
bash ./update-repo.sh
```

The updater leaves gitlink/workflow changes uncommitted for normal review. Direct dependency checkout is intentionally non-recursive; a consumer does not initialize development dependencies nested inside its libraries.

## Local workflow

After bootstrap, use the pinned local tool:

```powershell
.\tools\tool.scad-project\scad-project.ps1 config-lint
.\tools\tool.scad-project\scad-project.ps1 externals-check
.\tools\tool.scad-project\scad-project.ps1 docs-lint
.\tools\tool.scad-project\scad-project.ps1 design-lint
.\tools\tool.scad-project\scad-project.ps1 design-build
.\tools\tool.scad-project\scad-project.ps1 build
.\tools\tool.scad-project\scad-project.ps1 verify
```

## CI

The repository keeps thin workflow callers pinned to the same immutable tool release:

```yaml
jobs:
  build:
    uses: brainboxemb/tool.scad-project/.github/workflows/project-build.yml@v0.9.5
```

Build owns configuration/external/source/design linting, generated-design cache handling, dependency-selective PNG/STL generation, build indexing, provenance and publication. Verify owns generic build/source verification, project-specific verification commands, provenance and verification publication.

## Publication and releases

Generated output stays off `main`.

```text
main
    source and project configuration

prod/build
prod/verification
    latest successful generated production snapshots

dev/build
dev/verification
    latest successful generated development snapshots

rel/vX.Y.Z/build
rel/vX.Y.Z/verification
    immutable browseable project-release snapshots
```

Pull requests remain artifact-only. A coordinated project release is created from the exact current production-branch HEAD only after Build and Verify both succeed. A GitHub Release then contains deterministic build/verification/STL bundles plus `SHA256SUMS.txt` and links back to the immutable browseable `rel/*` branches.

Every generated snapshot includes `publication-info.txt` with source commit, tool/toolchain versions, submodule pins and runtime provenance.

## Source/API documentation

Structured OpenSCAD comments use `openscad_docsgen` conventions and start with `// File:` or `// LibFile:` before structured module/function blocks. `scad-project docs-lint` validates this in CI.

The model and documentation were developed with the assistance of ChatGPT.
