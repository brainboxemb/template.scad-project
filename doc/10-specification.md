# template.scad-project specification

## Why the template exists

A shared SCAD toolchain needs one small but realistic consumer that proves the
released pieces work together.

The template exists to answer:

> Can a normal CAD repository declare its intent/configuration, consume pinned
> shared tooling/libraries, build and verify real geometry, generate readable
> design documentation, and publish reproducible evidence without copying the
> shared lifecycle implementation?

## What the reference consumer must demonstrate

The template should demonstrate:

- a clear split between generic dependency policy (`project.yml`) and SCAD
  domain policy (`project.scad.yml`);
- visible project capabilities selected in root `moon.yml`;
- thin reusable-workflow callers;
- exact resolved dependency identity through committed gitlinks;
- OpenSCAD and PythonSCAD coexistence;
- generated design docs from component-local sources;
- presentation Build output and separate Verification evidence;
- an external reusable library consumed through the normal dependency model;
- SCons target reuse without confusing it with Moon capability reuse;
- release/publication behavior through released shared workflows.

## Concrete reference model

The example model is intentionally understandable:

- a project-owned mounting plate;
- a reusable-library-backed tube holder;
- a project-owned reference tube;
- a tube-holder assembly combining those parts;
- a small PythonSCAD component proving the second engine path.

Those pieces are examples, not reusable product standards.

## Non-goals

The template is not:

- the minimum configuration every project must copy;
- the owner of generic Git/bootstrap/SCAD lifecycle logic;
- a second documentation source for every `tool.scad-project` feature;
- proof that every real project needs PythonSCAD, SCons or all three SCAD
  capabilities;
- a catalog of current tool version numbers.
