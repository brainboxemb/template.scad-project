# SCAD CI orchestration

This repository is the reference consumer for the production SCAD orchestration boundary.

Moon owns the visible repository-level task graph, task inputs and outputs, dependencies and high-level cache/hydration decisions. `tool.scad-project` owns the reusable SCAD production workflow and the SCAD domain actions used by those tasks. SCons remains the fine-grained authority for target execution and object-cache reuse inside the design, build and verification actions.

## Pre-container source-impact gate

Normal CI first evaluates a lightweight source-impact target on the host, before the SCAD toolchain container exists:

```text
scad.docs ───┐
scad.build ──┼──> scad.production-impact
scad.verify ─┘
```

`scad.production-impact` contains only producer-domain dependencies. It deliberately excludes publication/index tasks and their GitHub event-context inputs. This keeps the affected decision about whether SCAD production is needed, rather than whether publication metadata would differ.

The released `tool.scad-project` production workflow checks out only the exact PR/push head for preflight and fetches only the exact comparison base needed for Moon's explicit `base -> head` query. README-only or otherwise unrelated changes therefore complete at preflight without starting the SCAD container. Uncertain or unavailable comparison state fails conservative and runs production.

The template's verification inputs are scoped to the CAD source actually consumed by its verification entrypoints (`mounting-plate`, `tube-holder` and the clamp dependency), plus verification/configuration/tooling inputs. They do not use the whole `dsg/**` tree. This allows a Build-side source change to remain Build-side while still making every real verification dependency explicit.

## Production graph

When preflight reports affected work, normal CI executes the publication-ready aggregate graph in exactly one SCAD container:

```text
scad.docs ───────┐
                 ├──> scad.build-index ──> scad.build-provenance ──┐
scad.build ──────┘                                                   │
                                                                     ├──> scad.ci
scad.verify ─────────────> scad.verification-provenance ─────────────┘
```

The stages have distinct responsibilities:

- `scad.docs` generates project-owned design documentation and its design-build decision evidence;
- `scad.build` generates normal PNG/STL output and normal build-decision evidence;
- `scad.build-index` creates navigation/gallery files after both documentation and normal build output are available;
- `scad.build-provenance` records producer/publication provenance for the build snapshot;
- `scad.verify` generates verification-only evidence and runs project verification checks independently from normal Build output;
- `scad.verification-provenance` records producer/publication provenance for the verification snapshot;
- `scad.ci` is the non-cacheable execution root used after an affected decision so Moon resolves both publication-ready branches.

Build and Verify are separate logical domains even when normal CI requests both through `scad.ci`. A verification task must not gain an implicit dependency on normal Build output merely because both happen in the same production job. Aggregate CI is responsible for requiring both branches when a complete production snapshot is requested.

Normal build and verification SCons `CacheDir` state is persisted separately from Moon output-cache state. A Moon task that executes can therefore still report target-level `BUILT`, `CACHE_RESTORED`, `CURRENT` or `ERROR` decisions from SCons. If Moon hydrates the entire task result, the SCAD action and SCons are not run for that task.

Producer provenance and current orchestration materialization are deliberately separate. Cached producer output may retain the source revision that originally produced it, while `orchestration/materialization.json` records the current repository revision that executed or hydrated the Moon graph.

## Publication

Build and Verification publication are lightweight downstream jobs outside the SCAD container. The shared workflow stages and uploads publication trees in the heavy job; released generic `tool.git-project` publication then maps successful snapshots to PR-scoped `dev/pr-N/*` branches or production `prod/*` branches without moving SCAD domain semantics into the generic repository layer.
