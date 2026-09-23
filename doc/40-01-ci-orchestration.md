# SCAD CI orchestration

This detail page explains the concrete reference-consumer flow without copying
volatile shared-tool implementation.

## Consumer inputs

The project declares capability/impact input in `moon.yml`, engine/runtime
intent in `project.scad.yml`, semantic dependencies in `project.yml`, exact
dependencies through gitlinks, and thin self-entry workflows.

## Normal CI flow

```text
exact source + comparison base
        ↓
one host-side Moon affected query
        ↓
no SCAD capability changed? ── yes ──> finish without CAD runtime
        │
        no
        ↓
validate config/capabilities
        ↓
select runtime + applicable cache transport
        ↓
execute/hydrate required capabilities
        ↓
validate materialization
        ↓
add current-run evidence
        ↓
publish changed output families
```

The consumer does not copy this orchestration into its own workflow.

## Runtime, SCons and publication

OpenSCAD + PythonSCAD select a runtime capable of both. SCons provides target
reuse inside executing capabilities; Moon remains the coarse capability layer.

Source impact and replacement-branch completeness are different. Unchanged Build
contributors may be hydrated to keep a complete replacement publication.
Verification remains a separate publication family.

Use generated provenance/orchestration evidence for current-state questions.
