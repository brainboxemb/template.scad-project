# template.scad-project design

## Concrete repository structure

The reference consumer is organised around real source families:

```text
project.yml
project.scad.yml
moon.yml

dsg/
├── openscad/
│   ├── ext/                         pinned reusable libraries
│   ├── components/
│   │   ├── mounting-plate/
│   │   ├── tube-holder/
│   │   └── tube/
│   ├── assemblies/
│   │   └── tube-holder-assembly/
│   ├── render/
│   ├── export/
│   └── main.scad
└── pythonscad/
    └── components/pythonscad-example/

vrf/
├── openscad/
├── templates/
└── out/
```

Each meaningful component/assembly keeps its detailed visual construction beside
source in `design/design.md`.

## Configuration split

`project.yml` owns generic dependency declarations and semantic release
policy.

`project.scad.yml` owns SCAD-specific intent such as:

- build engine;
- OpenSCAD/PythonSCAD flags;
- render/export/design roots;
- external required files;
- verification roots/commands;
- publication families.

The committed gitlinks provide exact resolved identity for pinned dependencies.

## Capability model

Root `moon.yml` selects the three visible project capabilities:

```text
scad.docs
scad.build
scad.verify
```

The shared task implementation is inherited from the pinned
`tool.scad-project`; the root file adds only project-specific source-impact
families.

## Moon and SCons

They operate at different levels:

```text
Moon
    repository capability impact/reuse

SCons
    individual CAD target reuse inside an executing capability
```

A whole-capability Moon cache hit can avoid starting the SCAD action. If a
capability executes, SCons may still reuse individual targets.

## Example CAD ownership

- `mounting_plate.scad` is project geometry.
- `tube_holder.scad` adapts the pinned reusable clamp library to the reference
  assembly.
- `tube.scad` is a project-owned demonstration tube.
- `tube_holder_assembly.scad` combines the three.
- the PythonSCAD example independently proves multi-engine design rendering.

The generated assembly image shown in the root README is a Build artifact from
this actual model, not a decorative image.

## Workflow boundary

Consumer GitHub workflows remain thin released-workflow callers. Generic source
impact, runtime planning, cache transport, publication finishing and release
orchestration belong to the shared tool owners.

See [40-ci-orchestration.md](40-ci-orchestration.md) for the detailed flow.
