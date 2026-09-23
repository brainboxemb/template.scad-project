# SCAD CI orchestration

This document explains the concrete CI flow of the reference consumer without
duplicating volatile implementation/version details from shared tools.

## Consumer inputs

The project declares:

- capabilities and project-specific impact families in `moon.yml`;
- engine/runtime intent in `project.scad.yml`;
- semantic dependencies in `project.yml`;
- exact resolved dependencies through gitlinks;
- thin Production/Release workflow callers.

## Normal production flow

Conceptually:

```text
exact source + comparison base
        ↓
one host-side Moon affected query
        ↓
no SCAD capability changed? ── yes ──> finish without CAD runtime
        │
        no
        ↓
tool.scad-project validates config/capabilities
        ↓
select runtime + applicable cache transport
        ↓
execute/hydrate required capabilities
        ↓
validate materialization
        ↓
add current-run provenance/orchestration evidence
        ↓
publish only changed output families
```

The consumer does not copy that orchestration into its own workflow.

## Runtime selection

This template configures both OpenSCAD and PythonSCAD, so the shared planner
selects a runtime capable of both.

An OpenSCAD-only consumer can use the focused runtime profile. The exact current
image/version is runtime provenance, not durable template documentation.

## Build-engine selection

The template deliberately selects SCons to prove target-level reuse.

A direct-engine consumer still uses Moon for capability impact/reuse but does
not transport SCons caches merely because other projects use SCons.

## Publication completeness

Source impact and replacement-branch completeness are distinct.

For example, design docs and presentation output both contribute to the Build
family. If only docs changed, unchanged Build output may be hydrated so replacing
the complete Build publication does not delete unaffected files.

Verification is a separate publication family and is not pulled in merely to
complete Build.

## Evidence

Published snapshots retain exact-source/tool/runtime provenance plus
orchestration/producer evidence.

Use that generated evidence for current-state questions; use this document for
the durable consumer architecture.
