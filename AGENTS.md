# Repository agent guidance

Persistent guidance for automated coding agents working in `template.scad-project`.

## Repository role

This repository is the reference consumer for the current SCAD project
architecture. Generic behavior belongs in `tool.scad-project`; do not duplicate
project workflow logic here.

```text
docker.scad-toolchain
    runtime / capabilities

tool.scad-project
    reusable workflow / conventions

template.scad-project
    reference consumer
```

## Generic workflow policy

Before branch, pull-request, publication or release work, read the pinned
`tools/tool.scad-project/AGENTS.md`. Its pull-request-first change workflow and
publication lifecycle are authoritative for this consumer.

This root file adds template-specific guidance only. It must not contradict the
pinned tool policy or duplicate changing generic branch/publication conventions.

## Sources of truth

Do not duplicate volatile dependency versions in this file.

Use:

```text
project.yml                         dependency policy
.gitlinks / .gitmodules             resolved dependency lock / registration
.github/workflows/*.yml             reusable workflow refs
scad-toolchain-info                 runtime component evidence
```

When updating `tool.scad-project`, keep its `project.yml` ref, gitlink and
reusable workflow refs aligned.

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

`tools/` contains tooling only. Do not place a second copy of the project there.

## Build convention

Normal targets are directory-discovered:

```text
dsg/openscad/render/*.scad -> bld/png/*.png
dsg/openscad/export/*.scad -> bld/stl/*.stl
```

Use adjacent `render.yml` / `export.yml` only for profile-specific behavior.
Keep root `builds:` for exceptional mappings that cannot be represented by the
normal convention.

The template intentionally enables the SCons backend. SCons dependency logic,
cache semantics and changed-target selection belong to `tool.scad-project`.

## Design documentation

Source design documentation lives beside the owning component or assembly as
`design/design.md`.

Prefer:

```text
scad-render-defaults
scad-render
```

and source views over duplicated inline geometry.

Generated design output belongs only under `bld/design`; never commit generated
`design/img/` output beside source documentation.

The template deliberately excludes external design documentation while keeping
external CAD source available to builds.

Keep the small PythonSCAD example as an end-to-end multi-engine design test. It
is not a requirement to duplicate real components in PythonSCAD.

## Dependencies and bootstrap

Direct submodules are the project tool and the example CAD library declared in
`project.yml` / `.gitmodules`.

Normal checkout is direct-only. Do not recursively initialize development
dependencies owned by those repositories.

Root helper scripts must remain exact copies of the canonical files from the
pinned `tool.scad-project` release:

```text
bootstrap.ps1
bootstrap.sh
update-repo.ps1
update-repo.sh
```

Bootstrap remains Python-free and depends only on Git plus PowerShell/bash.
`update-repo` intentionally advances dependency policy and leaves changes
uncommitted for review.

## OpenSCAD boundaries

`use <file.scad>` imports modules/functions, not file-level variables. Values
needed across component boundaries must be exposed through functions or
parameters.

Keep reusable library geometry in library-native coordinates. Apply project
orientation changes at the assembly boundary.

## CI and publication

Consumer workflows must remain thin callers of reusable workflows in
`tool.scad-project`. Do not copy generic lint/design/build/publication shell
logic into this repository.

`scad-project build-index` owns generated build indexes. Branch naming, PR
preview publication, cleanup and release lifecycle are defined by the pinned
tool policy and `project.yml`, not repeated here.

Every generated snapshot must contain `publication-info.txt` provenance.

## Source documentation

Structured `.scad` comments follow `openscad_docsgen` conventions and begin
with `File:` or `LibFile:` before structured API blocks.

Treat OpenSCAD warnings that indicate undefined/broken geometry as failures;
presentation-only camera warnings are handled by shared tool policy.
