# template.scad-project

Reference consumer for the current SCAD project architecture.

The repository demonstrates the intended separation:

```text
tool.git-project
    generic Git bootstrap, dependency gitlinks, status and update

        ↓

tool.scad-project
    SCAD configuration, build, design, verification and reusable workflows

        ↓

docker.scad-toolchain
    runtime and external capabilities

        ↓

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

## Reference-consumer role

This repository is the first-line reference consumer for the current SCAD stack. A tooling change should be exercised here to prove that generic bootstrap, SCAD configuration, Build, Verify, publication and release composition still work together on a small representative project.

Larger consumers supplement this smoke test when a feature needs a realistic dependency graph or enough independent outputs to demonstrate selective rebuild behaviour. The HUB75 display frame is a better secondary target for that kind of test; this template remains deliberately small.

During Step 0.5 of the ecosystem migration, `project.yml` may temporarily pin an exact pre-release `tool.scad-project` commit so the new ownership boundary can be tested before a release is cut. The files in the repository remain the source of truth for the current pins.

## Configuration split

Repository-level Git/dependency policy is generic and lives in `project.yml`:

```yaml
schema_version: 1

project:
  name: template.scad-project

profiles:
  - type: scad
    config: project.scad.yml

dependencies:
  - name: tool.scad-project
    role: tooling
    type: git-submodule
    url: https://github.com/brainboxemb/tool.scad-project.git
    path: tools/tool.scad-project
    ref: <exact commit, tag or branch policy>

  - name: lib.scad.clamps
    role: external
    type: git-submodule
    url: https://github.com/brainboxemb/lib.scad.clamps.git
    path: dsg/openscad/ext/lib.scad.clamps
    ref: v0.1.1
```

SCAD-only configuration lives in `project.scad.yml`:

```yaml
paths:
  design_root: dsg
  build_root: bld
  render_root: dsg/openscad/render
  export_root: dsg/openscad/export

build_engine:
  engine: scons

externals:
  - name: lib.scad.clamps
    required_file: openscad/tube-clamp/tube_clamp.scad
```

The generic dependency owns the repository URL/path/ref. The SCAD profile adds only SCAD-specific metadata such as `required_file`.

`tools/tool.git-project` is deliberately different: it is the bootstrap engine needed before `project.yml` can be processed, so its parent Git gitlink is the authoritative exact pin. It is not recursively listed as a dependency in `project.yml`.

## Structure

```text
.
├── project.yml
├── project.scad.yml
├── bootstrap.ps1
├── bootstrap.sh
├── update-repo.ps1
├── update-repo.sh
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
│   ├── tool.git-project/
│   └── tool.scad-project/
├── scripts/
├── vrf/
└── .github/workflows/
```

`bld/` is generated output and is not source-of-truth content.

## Configuration-first builds

Normal OpenSCAD outputs are discovered from directories configured in `project.scad.yml`:

```text
dsg/openscad/render/*.scad  -> bld/png/*.png
dsg/openscad/export/*.scad  -> bld/stl/*.stl
```

The reference assembly therefore has two small stable entrypoints with the same basename:

```text
dsg/openscad/render/tube-holder-assembly.scad
dsg/openscad/export/tube-holder-assembly.scad
```

No explicit `builds:` entries are needed for normal targets. Use optional `render.yml` or `export.yml` only when an entrypoint needs special profiles such as multiple sizes or a non-default render size. Explicit `builds:` remain available for exceptional mappings.

The template enables the selective SCons backend. SCons tracks OpenSCAD dependencies and restores unchanged outputs from persistent CI cache. Both `project.yml` and `project.scad.yml` are cache inputs, so a generic dependency-policy or SCAD-profile change invalidates the relevant cache keys.

## Development entrypoint

Open:

```text
dsg/openscad/main.scad
```

The reference assembly contains a mounting plate, a reusable clamp from `lib.scad.clamps`, and a 20 mm reference tube. The reusable clamp keeps its library-native coordinate system; the project adapter performs mounting orientation at the assembly boundary.

## Design documentation

Each meaningful component or assembly owns source documentation under `design/design.md`. Render declarations live in that document rather than in project configuration.

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

Generated design documentation is materialized under `bld/design/` and is never committed beside source `design.md` files.

The template sets `design.include_externals: false` in `project.scad.yml`. External CAD source remains available to the project, but the consumer publishes only its project-owned design documentation.

A small PythonSCAD component under `dsg/pythonscad/` remains as an end-to-end demonstration of the multi-engine design pipeline.

## Bootstrap and dependency updates

Bootstrap and dependency update deliberately have different owners.

The root bootstrap launchers are exact copies of the generic consumer launchers from the pinned `tool.git-project`:

```text
bootstrap.ps1  <- tools/tool.git-project/bootstrap/consumer-bootstrap.ps1
bootstrap.sh   <- tools/tool.git-project/bootstrap/consumer-bootstrap.sh
```

A fresh checkout does not need `--recurse-submodules`. Bootstrap first restores only the directly pinned bootstrap-engine gitlink and then lets `tool.git-project` validate `project.yml` and restore its declared dependencies.

Run:

```powershell
.\bootstrap.ps1
```

or:

```bash
bash ./bootstrap.sh
```

The root update launchers are thin SCAD wrappers from `tool.scad-project`:

```text
update-repo.ps1 <- tools/tool.scad-project/bootstrap/consumer-update.ps1
update-repo.sh  <- tools/tool.scad-project/bootstrap/consumer-update.sh
```

Run:

```powershell
.\update-repo.ps1
```

or:

```bash
bash ./update-repo.sh
```

The SCAD wrapper delegates generic dependency movement to `tool.git-project`, then performs one SCAD-specific follow-up: Build, Verify, Release and PR-cleanup reusable-workflow callers are aligned to the exact checked-out `tool.scad-project` commit.

Neither layer commits changes automatically. Gitlink, policy and workflow-ref changes remain visible for normal review. Direct dependency checkout is intentionally non-recursive.

## Local workflow

After bootstrap, use the pinned local SCAD tool:

```powershell
.\tools\tool.scad-project\scad-project.ps1 config-lint
.\tools\tool.scad-project\scad-project.ps1 externals-check
.\tools\tool.scad-project\scad-project.ps1 docs-lint
.\tools\tool.scad-project\scad-project.ps1 design-lint
.\tools\tool.scad-project\scad-project.ps1 design-build
.\tools\tool.scad-project\scad-project.ps1 build
.\tools\tool.scad-project\scad-project.ps1 verify
.\tools\tool.scad-project\scad-project.ps1 repo-status
```

`config-lint` validates the SCAD profile and, for the split configuration, delegates generic `project.yml` validation to the pinned `tool.git-project`.

## CI

The repository keeps thin workflow callers pinned to the exact checked-out `tool.scad-project` commit:

```yaml
jobs:
  build:
    uses: brainboxemb/tool.scad-project/.github/workflows/project-build.yml@<40-character-tool-sha>
```

The exact SHA intentionally matches the `tools/tool.scad-project` gitlink. `project.yml` records the dependency/update policy; the gitlink and workflow SHA record the exact version used for a particular source commit.

Build owns configuration/external/source/design linting, generated-design cache handling, dependency-selective PNG/STL generation, build indexing, provenance and build publication. Verify owns source/build verification, verification-only dependency targets, project-specific verification commands, provenance and verification publication.

Functional verification also checks the tooling boundary itself: required direct gitlinks exist, the configured `tool.scad-project` ref resolves to its gitlink, all reusable workflow callers match that exact commit, and root bootstrap/update launchers match their respective owner repositories.

## Verification source

Verification-only CAD entrypoints live under `vrf/openscad/`. They generate evidence under `vrf/out/` using the verification-specific selective cache. Normal build PNG/STL output remains under `bld/` and is not duplicated merely to create verification evidence.

`scripts/run-verification.sh` performs cheap policy/integration checks after the verification geometry targets are current.

## Publication and releases

Generated output stays off `main`.

```text
main
    source and project configuration

prod/build
prod/verification
    latest successful production snapshots

dev/pr-<number>/build
dev/pr-<number>/verification
    isolated pull-request previews

rel/vX.Y.Z/build
rel/vX.Y.Z/verification
    immutable browseable release snapshots
```

A coordinated project release is created from an exact current production-branch HEAD only after Build and Verify both succeed. A GitHub Release contains deterministic build/verification/STL bundles plus `SHA256SUMS.txt` and links back to the immutable `rel/*` branches.

Every generated snapshot includes `publication-info.txt` with source commit, tool/toolchain versions, dependency pins and runtime provenance.

## Source/API documentation

Structured OpenSCAD comments use `openscad_docsgen` conventions and start with `// File:` or `// LibFile:` before structured module/function blocks. `scad-project docs-lint` validates this in CI.

The model and documentation were developed with the assistance of ChatGPT.
