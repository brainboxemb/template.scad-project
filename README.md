# template.scad-project

Reference consumer for the current SCAD project architecture.

The repository demonstrates the intended ownership split:

```text
tool.git-project
    generic Git bootstrap, dependency gitlinks and one Moon affected query

        ↓

tool.scad-project
    SCAD configuration, inherited capabilities, runtime/cache planning,
    build, verification and reusable workflows

        ↓

docker.scad-toolchain
    reproducible OpenSCAD-focused and full/dual runtimes

        ↓

template.scad-project
    project configuration, capability selection, CAD source and project docs
```

## Quick links

- [Production build](../../tree/prod/build)
- [Production build overview](../../blob/prod/build/README.md)
- [Production build PNG gallery](../../blob/prod/build/png/README.md)
- [Production build provenance](../../blob/prod/build/publication-info.txt)
- [Production verification](../../tree/prod/verification)
- [Project releases](../../releases)

## Reference-consumer role

This repository is the first integration/reference consumer for shared SCAD tooling. It is deliberately small enough to understand, but it still exercises the important generic paths together:

- OpenSCAD and PythonSCAD configuration;
- Presentation Build output;
- generated design documentation;
- Verification;
- SCons target-level reuse;
- Moon capability-level impact/reuse;
- generated-output publication;
- coordinated release composition.

It is **not** intended to represent every possible project with the smallest possible configuration. The template intentionally exercises the full/dual runtime and SCons path; later canaries separately prove direct-engine and OpenSCAD-focused projects.

## Visible capabilities

The project exposes three maintainer-facing capabilities:

```text
scad.docs    Design documentation
scad.build   Presentation renders / exports
scad.verify  Verification
```

They are selected explicitly in `.moon/workspace.yml`:

```yaml
workspace:
  inheritedTasks:
    include:
      - scad.docs
      - scad.build
      - scad.verify
```

The shared implementation is inherited through one link:

```yaml
# .moon/tasks/scad.yml
extends: '../../tools/tool.scad-project/moon/tasks/scad.yml'
```

That pinned shared policy owns the commands, common stable tool/config inputs, normal output boundaries and Moon cache policy. Root `moon.yml` contains only the project-specific source patterns that affect each capability.

This is the important Migration-005 simplification: the consumer describes **what this project can do and what project source affects it**, rather than copying CI lifecycle tasks such as build indexes, provenance roots or aggregate execution nodes.

## Configuration split

Generic dependency policy lives in `project.yml`:

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
    ref: v0.14.1
```

SCAD-domain intent lives in `project.scad.yml`. In this template that includes:

```yaml
build_engine:
  engine: scons

pythonscad:
  common_flags:
    - --trust-python
```

Those two choices are meaningful:

- because PythonSCAD is configured, the shared planner selects the **full/dual** `docker.scad-toolchain v0.5.0` runtime;
- because `build_engine.engine` is `scons`, normal Build/docs work may use the normal SCons cache;
- because this project also has real verification render targets, Verification may use its separate Verification-SCons cache.

An OpenSCAD-only project omits PythonSCAD configuration and can use the smaller OpenSCAD-focused runtime. A `direct` project keeps Moon capability impact/reuse but does not transport SCons caches.

## Moon versus SCons

Moon and SCons deliberately operate at different levels:

```text
Moon
  Which whole repository capabilities are affected?
  Can a complete source-derived capability result be reused?

SCons, only when configured
  Which individual CAD targets inside an executing capability
  need rebuilding or can be restored?
```

A whole-capability Moon hit can avoid running the SCAD action — and therefore SCons — for that capability entirely. If the capability executes, SCons can still avoid individual target work.

## Source impact versus publication completeness

Source impact answers what actually changed. Publication must additionally guarantee that a complete replacement output tree exists locally.

For this project, design documentation and presentation output both contribute to the complete Build branch. A documentation-only change can therefore look like:

```text
affected capabilities
  scad.docs

materialized for complete Build publication
  scad.docs
  scad.build
```

`scad.build` remains **non-affected**. Its unchanged output is normally hydrated through Moon only so replacing `prod/build` or the PR Build preview does not delete unchanged presentation files.

Verification is a separate publication family and is not materialized merely to complete Build.

## Normal CI

The consumer workflow remains intentionally thin:

```yaml
jobs:
  scad:
    uses: brainboxemb/tool.scad-project/.github/workflows/project-production.yml@<exact-tool-commit>
    with:
      cache_namespace: template-scad-production-v2
```

The exact workflow SHA matches the checked-out `tools/tool.scad-project` gitlink. `project.yml` records the semantic release policy; gitlinks/workflow refs lock the exact source used by a particular repository revision.

The reusable production lifecycle is:

1. resolve exact source and comparison base;
2. run one generic Moon affected query on the host;
3. stop before the CAD image/runtime when no configured SCAD capability changed;
4. install the exact pinned SCAD planner and validate project/capability consistency;
5. select the runtime profile and only applicable cache transport;
6. execute or hydrate required capabilities in at most one CAD runtime;
7. validate materialization;
8. add current-run Build/Verification index/provenance information on the host;
9. publish only output families whose source-affected capabilities changed.

Normal CI retains compact impact/materialization evidence. It does **not** upload another complete copy of normal Build/Verification trees as Actions artifacts merely for retention.

See [SCAD CI orchestration](docs/ci-orchestration.md) for the detailed flow.

## Structure

```text
.
├── project.yml
├── project.scad.yml
├── moon.yml
├── .moon/
│   ├── workspace.yml
│   └── tasks/scad.yml
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

`bld/` and `vrf/out/` are generated output, not source-of-truth content.

## Configuration-first builds

Normal OpenSCAD outputs are discovered from configured directories:

```text
dsg/openscad/render/*.scad  -> bld/png/*.png
dsg/openscad/export/*.scad  -> bld/stl/*.stl
```

The reference assembly therefore uses stable render/export entrypoints with the same basename. Optional adjacent `render.yml` / `export.yml` files are for special profiles such as alternate image sizes. Explicit root `builds:` remain available for exceptional mappings.

## Design documentation

Each meaningful component/assembly owns source documentation under `design/design.md`. Render declarations live in that source document using `scad-render-defaults` and `scad-render`.

Generated design documentation is materialized under `bld/design/` and is never committed beside the source document.

`design.include_externals: false` means the generated documentation covers project-owned design docs only. External CAD source remains available to builds.

A small PythonSCAD component remains deliberately present as an end-to-end multi-engine reference.

## Bootstrap and dependency updates

A fresh checkout does not require recursive submodules.

The root bootstrap launchers are canonical copies from the pinned `tool.git-project`. They initialize the bootstrap gitlink first and then restore dependencies declared by `project.yml`.

Run:

```powershell
.\bootstrap.ps1
```

or:

```bash
bash ./bootstrap.sh
```

The root update launchers are thin wrappers from the pinned `tool.scad-project`. They delegate generic dependency movement to `tool.git-project` and then align SCAD reusable-workflow callers with the exact resulting `tool.scad-project` gitlink.

Neither layer commits updates automatically; dependency and workflow changes remain visible for review.

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
.\tools\tool.scad-project\scad-project.ps1 repo-status
```

## Verification source-impact boundary

Verification-only CAD entrypoints live under `vrf/openscad/` and generate evidence under `vrf/out/`.

The local `scad.verify` Moon override deliberately lists only the project CAD source actually consumed by those verification entrypoints, plus verification scripts/configuration/tooling inputs. Do not broaden it to all of `dsg/**` for convenience. When verification starts consuming another project component, add that dependency explicitly.

## Publication and release

Generated output stays off `main`:

```text
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

Build and Verification publication remain logically separate and can overlap on the same host without another CAD runner.

Release is intentionally different from normal production: separate Build/Verify/finalize jobs require complete artifacts as exact-source cross-job hand-off. The release flow therefore keeps full Build/Verification artifacts even though normal production retains only compact orchestration evidence.

Every published snapshot includes `publication-info.txt` with source, tool/toolchain and runtime provenance.

## Source/API documentation

Structured OpenSCAD comments use `openscad_docsgen` conventions and begin with `// File:` or `// LibFile:` before structured module/function blocks.

The model and documentation were developed with the assistance of ChatGPT.
