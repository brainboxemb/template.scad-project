# Repository agent guidance

Persistent guidance for automated coding agents working in `template.scad-project`.

## Repository role

This repository is the reference consumer for the current SCAD project
architecture. Do not duplicate generic Git/bootstrap behavior or reusable SCAD
build/workflow logic here.

```text
tool.git-project
    generic bootstrap / dependency gitlinks / repository update

docker.scad-toolchain
    runtime / capabilities

tool.scad-project
    SCAD configuration / build / design / verification / reusable workflows

template.scad-project
    reference consumer
```

## Generic workflow policy

Before SCAD branch, pull-request, publication or release work, read the pinned
`tools/tool.scad-project/AGENTS.md`. Its SCAD project change workflow and
publication lifecycle are authoritative for this consumer.

Generic bootstrap, dependency registration/status/update and Git-submodule ref
resolution belong to the pinned `tools/tool.git-project`. Do not reimplement
those operations in this repository or in `tool.scad-project`.

This root file adds template-specific guidance only. It must not contradict the
pinned tooling policies or duplicate changing generic conventions.

## Sources of truth

Do not duplicate volatile dependency versions in this file.

Use:

```text
project.yml                         generic project/profile/dependency policy
project.scad.yml                    SCAD-specific project/build policy
.gitlinks / .gitmodules             resolved dependency lock / registration
.github/workflows/*.yml             exact reusable SCAD workflow refs
scad-toolchain-info                 runtime component evidence
```

`tools/tool.git-project` is a bootstrap special case: its parent gitlink is the
authoritative exact pin and it must not recursively list itself in `project.yml`.

`tool.scad-project` is a normal managed dependency in `project.yml`. When it is
updated, keep its generic dependency ref, gitlink and Build/Verify/Release/
PR-cleanup workflow refs aligned to the same exact commit.

## Project structure

```text
project.yml
project.scad.yml

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
├── tool.git-project/
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
Keep root `builds:` in `project.scad.yml` for exceptional mappings that cannot
be represented by the normal convention.

The template intentionally enables the SCons backend. SCons dependency logic,
cache semantics and changed-target selection belong to `tool.scad-project`.
Both `project.yml` and `project.scad.yml` are build/cache inputs.

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

The template has three direct gitlinks:

```text
tools/tool.git-project                    bootstrap engine, directly pinned
tools/tool.scad-project                   managed SCAD tooling dependency
dsg/openscad/ext/lib.scad.clamps          managed external dependency
```

Normal checkout is direct-only. Do not recursively initialize development
dependencies owned by those repositories.

Root bootstrap launchers must remain exact copies of the canonical generic
consumer files from the pinned `tool.git-project`:

```text
bootstrap.ps1  <- tools/tool.git-project/bootstrap/consumer-bootstrap.ps1
bootstrap.sh   <- tools/tool.git-project/bootstrap/consumer-bootstrap.sh
```

They initialize only the bootstrap-engine gitlink first; `tool.git-project`
then restores the dependencies declared by `project.yml`.

Root update launchers must remain exact copies of the thin SCAD consumer
wrappers from the pinned `tool.scad-project`:

```text
update-repo.ps1 <- tools/tool.scad-project/bootstrap/consumer-update.ps1
update-repo.sh  <- tools/tool.scad-project/bootstrap/consumer-update.sh
```

Those wrappers call `scad-project repo-update`. Generic dependency movement is
then delegated to `tool.git-project`; `tool.scad-project` only performs the
SCAD-specific follow-up that aligns reusable workflow callers to the resulting
exact tool gitlink.

Bootstrap remains Python-free and depends only on Git plus PowerShell/bash.
`update-repo` intentionally leaves dependency/gitlink/workflow changes
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
SCAD tool policy and `project.scad.yml`, not repeated here.

Every generated snapshot must contain `publication-info.txt` provenance.

## Source documentation

Structured `.scad` comments follow `openscad_docsgen` conventions and begin
with `File:` or `LibFile:` before structured API blocks.

Treat OpenSCAD warnings that indicate undefined/broken geometry as failures;
presentation-only camera warnings are handled by shared tool policy.
