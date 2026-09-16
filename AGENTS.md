# Repository agent guidance

Persistent guidance for automated coding agents working in `template.scad-project`.

## Repository role

This repository is the reference consumer for the current SCAD project architecture. Keep generic repository behaviour and reusable SCAD lifecycle mechanics in their owner repositories instead of copying them here.

```text
tool.git-project
    generic bootstrap / dependency gitlinks / Moon affected query

docker.scad-toolchain
    reproducible OpenSCAD-focused and full/dual runtimes

tool.scad-project
    SCAD configuration / inherited capabilities / build / verification / workflows

template.scad-project
    reference consumer configuration and CAD source
```

Before SCAD workflow, publication or release changes, read the pinned `tools/tool.scad-project/AGENTS.md`. Generic Git/dependency behaviour belongs to the pinned `tools/tool.git-project`.

## Sources of truth

Do not duplicate volatile dependency versions in this file. Use:

```text
project.yml                         generic dependency + semantic release policy
project.scad.yml                    SCAD project/runtime/build policy
.gitlinks / .gitmodules             exact resolved dependency pins
.github/workflows/*.yml             released semantic reusable-workflow refs
.moon/workspace.yml                 Moon workspace/project registration
moon.yml                            visible capabilities + project-specific impact rules
scad-toolchain-info                 runtime component evidence
```

`tool.git-project` is the bootstrap special case: its gitlink is the authoritative exact pin and it is not recursively declared in `project.yml`.

For `tool.scad-project`, `project.yml` and reusable workflow callers must use the same configured released semantic ref; the committed gitlink records the exact source commit resolved for that release.

## Visible SCAD capabilities

This reference consumer intentionally exposes all three shared capabilities:

```text
scad.docs    design documentation
scad.build   presentation renders / exports
scad.verify  Verification
```

They are selected in root `moon.yml` through `workspace.inheritedTasks.include`. The shared commands, stable tool inputs, normal output boundaries and Moon cache policy are inherited from:

```text
.moon/tasks/scad.yml
    -> tools/tool.scad-project/moon/tasks/scad.yml
```

Beyond that capability selection, root `moon.yml` contains only project-specific source-impact inputs. Keep `.moon/workspace.yml` limited to Moon workspace-level configuration. Do not reintroduce generic commands, build-index/provenance tasks, synthetic CI roots, or broad `tools/tool.scad-project/**` inputs.

Use maintainable source-family boundaries for capability impact. Adding a normal component or verification case should not require enumerating that individual file in `moon.yml` or duplicating the concrete glob list in verification scripts.

## Runtime and build-engine reference choices

The template deliberately keeps both OpenSCAD and PythonSCAD configuration. Therefore the shared planner selects the full/dual runtime profile. A project with no PythonSCAD configuration may use the OpenSCAD-focused profile.

The template deliberately sets:

```yaml
build_engine:
  engine: scons
```

so it exercises target-level SCons reuse. A project that selects `direct` must not restore/save SCons caches merely because the ecosystem supports SCons elsewhere.

Moon and SCons have different jobs:

```text
Moon     coarse repository capability impact + whole-capability reuse
SCons    individual CAD target reuse inside an executing SCons capability
```

## Affected versus materialized capabilities

Do not confuse source impact with publication completeness.

If `scad.docs` changes while `scad.docs` and `scad.build` both contribute to the complete Build publication tree, the shared lifecycle may hydrate unchanged `scad.build` output through Moon before replacing the Build branch. `scad.build` remains non-affected; it is materialized only so unchanged presentation output is not deleted.

Verification is a separate publication family and is not pulled in merely to complete Build.

## Project structure

```text
project.yml
project.scad.yml
moon.yml
.moon/

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

scripts/
vrf/
```

`tools/` contains tooling only. Generated output belongs under `bld/` and `vrf/out/`, never beside source documentation.

## Build and design conventions

Normal targets are directory-discovered:

```text
dsg/openscad/render/*.scad -> bld/png/*.png
dsg/openscad/export/*.scad -> bld/stl/*.stl
```

Use adjacent `render.yml` / `export.yml` only for profile-specific behaviour. Root `builds:` is for exceptional mappings.

Source design documentation lives beside the owning component/assembly as `design/design.md`. Prefer `scad-render-defaults` and `scad-render`; generated design output belongs under `bld/design`.

Keep the small PythonSCAD example as an end-to-end multi-engine reference. It is not a requirement to duplicate all OpenSCAD components in PythonSCAD.

## Bootstrap and updates

Root bootstrap launchers must remain exact copies of the canonical pinned `tool.git-project` consumer launchers. They initialize the bootstrap gitlink first, then let generic tooling restore dependencies from `project.yml`.

Root update launchers must remain exact copies of the pinned `tool.scad-project` consumer update wrappers. Generic dependency movement is delegated to `tool.git-project`; SCAD tooling then aligns the semantic reusable-workflow refs with the configured `tool.scad-project` release while the committed gitlink retains exact source identity.

Never recursively initialize development dependencies owned by those dependencies.

## CI and publication

Consumer workflows stay thin. Normal Production calls the released `project-production.yml` through the same semantic `tool.scad-project` ref configured in `project.yml` and supplies only consumer-level options such as the cache namespace. Do not reintroduce Migration-004 `affected_task` / `aggregate_task` arguments or copy orchestration shell into this repository.

Release is equally thin: the consumer owns only triggers, permissions and project paths; release-request parsing, validation, Build/Verify orchestration, immutable publication and request-branch cleanup belong to the shared released `project-release.yml` workflow.

Normal production behaviour is:

1. resolve exact source/base;
2. run one Moon affected query on the host;
3. stop before the CAD runtime if no configured SCAD capability changed;
4. let `tool.scad-project` validate capabilities/config and choose runtime/cache policy;
5. execute or hydrate only required capabilities in at most one CAD runtime;
6. add current-run Build/Verification finishing information on the host;
7. publish only changed output families.

Normal CI retains current orchestration evidence with direct navigation to raw Moon/producer logs and durable timing information. Release remains different: separate release jobs need complete Build/Verification trees as an exact-source cross-job hand-off.

Build and Verification publishers remain separate logical outputs and may overlap on the same runner. Publication stays outside the CAD container because it needs current repository credentials/context, not CAD dependencies.

Human-facing lifecycle names are Build and Verification. Persistent technical publication namespaces use the portfolio identifiers `bld` and `vrf` (`prod/bld`, `prod/vrf`, `dev/pr-N/bld`, `dev/pr-N/vrf`, `rel/vX.Y.Z/bld`, `rel/vX.Y.Z/vrf`).

Every generated snapshot must contain `publication-info.txt`.

## OpenSCAD boundaries

`use <file.scad>` imports modules/functions, not file-level variables. Values needed across component boundaries must be exposed through functions or parameters.

Keep reusable library geometry in library-native coordinates. Apply project orientation at the assembly boundary.

Structured `.scad` comments follow `openscad_docsgen` conventions and begin with `File:` or `LibFile:` before structured API blocks. Treat warnings indicating undefined/broken geometry as failures; shared tool policy handles known presentation-only warnings.
