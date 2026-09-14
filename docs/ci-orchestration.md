# SCAD CI orchestration

This repository is the reference consumer for the production SCAD orchestration boundary.

Moon owns the visible repository-level task graph, task inputs and outputs, dependencies and high-level cache/hydration decisions. `tool.scad-project` owns the SCAD domain actions used by those tasks. SCons remains the fine-grained authority for target execution and object-cache reuse inside the design, build and verification actions.

The production graph is intentionally visible in `moon.yml`:

```text
scad.docs ───────┐
                 ├──> scad.build-index ──> scad.build-provenance ──┐
scad.build ──────┘                                                   │
     │                                                               ├──> scad.ci
     └──> scad.verify ──> scad.verification-provenance ──────────────┘
```

The stages have distinct responsibilities:

- `scad.docs` generates project-owned design documentation and its design-build decision evidence;
- `scad.build` generates normal PNG/STL output and normal build-decision evidence;
- `scad.build-index` creates navigation/gallery files after both documentation and normal build output are available;
- `scad.build-provenance` records producer/publication provenance for the build snapshot;
- `scad.verify` generates verification-only evidence and runs project verification checks; this template depends on `scad.build` because its project check intentionally inspects normal Build output;
- `scad.verification-provenance` records producer/publication provenance for the verification snapshot;
- `scad.ci` is the non-cacheable repository root used by CI so Moon resolves the complete dependency graph once.

Normal build and verification SCons `CacheDir` state is persisted separately from Moon output-cache state. A Moon task that executes can therefore still report target-level `BUILT`, `CACHE_RESTORED`, `CURRENT` or `ERROR` decisions from SCons. If Moon hydrates the entire task result, the SCAD action and SCons are not run for that task.

Producer provenance and current orchestration materialization are deliberately separate. Cached producer output may retain the source revision that originally produced it, while `orchestration/materialization.json` records the current repository revision that executed or hydrated the Moon graph.

Generated-output publication is a downstream GitHub Actions side effect and is not a Moon task. Released generic `tool.git-project` publication maps successful snapshots to PR-scoped `dev/pr-N/*` branches or production `prod/*` branches without moving SCAD domain semantics into the generic repository layer.
