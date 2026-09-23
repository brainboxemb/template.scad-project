# template.scad-project design

This document describes the application-level architecture used to realise
[30-00-specification.md](30-00-specification.md).

## Repository structure and ownership

`project.yml` owns generic dependency declarations. `project.scad.yml` owns
SCAD-specific engines, paths, verification commands and publication families.
Committed gitlinks retain exact dependency identity.

Root `moon.yml` selects `scad.docs`, `scad.build` and `scad.verify`; the
pinned tool owns shared implementation.

Project geometry stays deliberately small: mounting plate, tube-holder adapter,
tube, assembly and one independent PythonSCAD example.

## Detailed visual design

Each component/assembly keeps source authority in adjacent `design/design.md`.
Build publication copies the document and generates its images. The generated
version is normally the better human reading surface; source remains the file to
edit.

| Design | Source authority | Generated visual document |
| --- | --- | --- |
| Tube-holder assembly | [source](../dsg/openscad/assemblies/tube-holder-assembly/design/design.md) | [Build](../../../blob/prod/bld/design/project/openscad/assemblies/tube-holder-assembly/design/design.md) |
| Mounting plate | [source](../dsg/openscad/components/mounting-plate/design/design.md) | [Build](../../../blob/prod/bld/design/project/openscad/components/mounting-plate/design/design.md) |
| Tube holder | [source](../dsg/openscad/components/tube-holder/design/design.md) | [Build](../../../blob/prod/bld/design/project/openscad/components/tube-holder/design/design.md) |
| Tube | [source](../dsg/openscad/components/tube/design/design.md) | [Build](../../../blob/prod/bld/design/project/openscad/components/tube/design/design.md) |
| PythonSCAD example | [source](../dsg/pythonscad/components/pythonscad-example/design/design.md) | [Build](../../../blob/prod/bld/design/project/pythonscad/components/pythonscad-example/design/design.md) |

[Generated design index](../../../blob/prod/bld/design/README.md)

## Workflow boundary

Consumer workflows stay thin. Source impact, runtime planning, cache transport,
publication finishing and release orchestration belong to shared tool owners.

See [40-01-ci-orchestration.md](40-01-ci-orchestration.md).
