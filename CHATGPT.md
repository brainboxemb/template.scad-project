# ChatGPT project handoff

## Repository role

`template.scad-project` is the reference consumer for the SCAD project
architecture.

Keep the layers separate:

```text
docker.scad-toolchain
    runtime/capabilities

tool.scad-project
    reusable workflow and conventions

template.scad-project
    project configuration, source and documentation
```

Do not reintroduce project-specific build/render Python scripts here if the
behavior belongs in `tool.scad-project`.

## Project structure

```text
project.yml

dsg/
└── openscad/
    ├── ext/
    ├── lib/
    ├── components/
    ├── assemblies/
    ├── render/
    └── main.scad

bld/
vrf/
```

## Config-first

Project-specific facts belong in `project.yml`.

This template currently configures:

- design/build roots;
- OpenSCAD flags;
- default image size;
- external libraries;
- build outputs.

Design render declarations belong in each `design.md`, not in `project.yml`.

## Bootstrap / local-tool architecture

The project root contains copied bootstrap launchers:

```text
bootstrap.ps1
bootstrap.sh
```

Their canonical source lives in `tool.scad-project/bootstrap/`.

The bootstrap script is intentionally tiny and is the only code that must work
before the tool submodule exists.

Bootstrap chain:

```text
bootstrap.ps1
    -> tools/tool.scad-project
    -> local scad-project launcher
    -> externals-init
    -> CAD-library externals
```

Do not replace the local pinned tool with a `pip install git+https://...@main`
step in the project workflow.

New project external configuration uses the `externals:` key. `libraries:` is
only a compatibility path in the tool.

The ZIP is a source snapshot and cannot encode Git gitlinks. The user must run
bootstrap once in the actual Git repository and commit `.gitmodules` plus the
tool/library gitlinks.


## Design documentation

Preferred render:

```markdown
<!-- scad-design
type: source-view
module: component_design
view: step-name
image: 01-step.png
-->
```

Source-view is preferred because reusable geometry stays in `.scad`.

Inline OpenSCAD is allowed only for small documentation-only illustrations
where duplicating reusable project geometry is not involved.

## Source documentation

Structured `.scad` comments follow `openscad_docsgen` syntax.

Every structured documented source must declare:

```scad
// File: ...
```

or:

```scad
// LibFile: ...
```

before any structured Module/Function/etc block.

## Dependencies

Runtime:

```text
ghcr.io/brainboxemb/scad-toolchain:v0.3.0
```

Workflow tool:

```text
tools/tool.scad-project
```

This is a Git submodule pinned by the consumer project.

External library:

```text
dsg/openscad/ext/lib.scad.clamps
```

The external library path inside the submodule remains:

```text
openscad/tube-clamp/tube_clamp.scad
```

Do not restructure `lib.scad.clamps` to contain an internal `dsg/`.

## CI

The template should remain a real consumer.

CI should:
- checkout recursive submodules;
- invoke the pinned local `tools/tool.scad-project` checkout;
- use its `scad-project` launcher commands;
- upload generated evidence as artifacts.

Do not duplicate generic tool logic in workflow shell blocks.

## Current scope

Verification orphan-branch publication is intentionally deferred until that
behavior is implemented generically in `tool.scad-project`.

Copyright/watermark behavior is also deferred. It should first be designed as a
generic project-tool capability and only later drive any required toolchain
runtime update.


## Python-free robust bootstrap

The root bootstrap scripts must not invoke Python or `scad-project`.

The template carries `.gitmodules` containing both:
- `tools/tool.scad-project`
- `dsg/openscad/ext/lib.scad.clamps`

Bootstrap reads `.gitmodules` with native Git and repairs/initializes gitlinks.
This is deliberate because source ZIPs cannot encode Git gitlinks.

The bootstrap is expected to be safely repeatable after partial local progress.
Do not fail just because a correct submodule is already registered or already
initialized. Do fail if unrelated non-Git files occupy a configured submodule
path.

After bootstrap, Python is allowed for normal `scad-project` operations.

