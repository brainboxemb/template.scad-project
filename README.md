# template.scad-project

Reference consumer for the current BrainboxEmb SCAD project architecture.

## Preview

[![Reference tube-holder assembly](../../raw/prod/bld/png/tube-holder-assembly.png)](../../blob/prod/bld/png/tube-holder-assembly.png)

The image is generated from the current project Build output. It gives a quick
visual anchor for the mounting plate, reusable clamp adapter and reference tube
used throughout the template.

## Start here

- [Documentation index](doc/README.md)
- [Plan](doc/10-00-plan.md) — current role, information sources and future template work.
- [Specification](doc/30-00-specification.md) — why the reference consumer exists and what it must demonstrate.
- [Design](doc/40-00-design.md) — concrete project structure, capabilities and ownership boundaries.
- [Verification](doc/50-00-verification.md) — what the template proves and how current evidence is obtained.
- [CI orchestration](doc/40-01-ci-orchestration.md) — detailed runtime/capability flow.
- [Generated visual design documentation](../../blob/prod/bld/design/README.md)
- [Latest Build](../../tree/prod/bld)
- [Latest Verification](../../tree/prod/vrf)
- [Changelog](CHANGELOG.md)

## What this template demonstrates

The repository deliberately exercises a broad reference path:

- OpenSCAD and PythonSCAD configuration;
- generated component/assembly design documentation;
- presentation renders and STL exports;
- verification renders plus policy checks;
- one external reusable SCAD library;
- Moon capability impact/reuse;
- SCons target-level reuse inside executing capabilities;
- Build/Verification publication and coordinated release composition.

It is a **reference consumer**, not the smallest possible project. A real
project should keep only the capabilities and engines it actually needs.

## Local setup

After cloning:

```powershell
.\bootstrap.ps1
```

Then use the pinned local tool, for example:

```powershell
.\tools\tool.scad-project\scad-project.ps1 build
.\tools\tool.scad-project\scad-project.ps1 verify
```

Open `dsg/openscad/main.scad` for the interactive OpenSCAD entrypoint.

Current dependency/tool/runtime versions are intentionally not copied into this
README. Use `project.yml`, `project.scad.yml`, committed gitlinks, live
Actions and `prod/bld` / `prod/vrf` provenance for exact current state.
