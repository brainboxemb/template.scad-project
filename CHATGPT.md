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
- PNG watermark policy;
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
ghcr.io/brainboxemb/scad-toolchain:v0.4.0
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
- checkout the project's direct pinned submodules;
- invoke the pinned local `tools/tool.scad-project` checkout;
- use its `scad-project` launcher commands;
- upload generated evidence as artifacts.

Do not duplicate generic tool logic in workflow shell blocks.

## PNG watermark reference configuration

The template demonstrates the generic released watermark path:

```yaml
rendering:
  watermark:
    text: "© 2026 brainboxemb"
```

Responsibility remains split:

```text
docker.scad-toolchain
    -> generic scad-image-watermark command

tool.scad-project
    -> build orchestration and configuration

template / consumer
    -> watermark text and whether the policy is enabled
```

Do not add project-local Pillow/image-processing code.


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


## OpenSCAD `use` boundary

`use <file.scad>` imports modules/functions but not top-level variables.

Do not reference constants such as `MOUNTING_PLATE_THICKNESS` from a consumer
that uses the component file. Expose required values through a function, object
API, or explicit assembly parameter.

Current example:

```scad
mounting_plate_thickness()
```

This rule exists because OpenSCAD otherwise returns `undef` while still often
exiting successfully.


## Generated design/build separation

Do not create or commit `design/img/` directories in the source tree.

Source:

```text
dsg/.../*.scad
dsg/.../design/design.md
```

Generated:

```text
bld/design/project/...
bld/design/ext/<external>/...
bld/png/...
bld/stl/...
```

`design-build` materializes both project and compatible external design docs
into `bld/design`.

The mutable orphan `build` branch contains the generated `bld/` snapshot.
`main` remains free of generated binary/document output.

The source `design.md` render declarations are replaced with image references
only in the generated build copy.



## Reference assembly coordinate convention

Do not rotate the tube independently from the clamp bore. `tube_holder()` stays
in library-native orientation. `tube_holder_mounted()` rotates the clamp at the
project boundary, and `assembly_reference_tube()` applies the same axis
rotation. The tube axis is therefore the geometric reference for assembly
placement.


## Design render authoring

Use `scad-render-defaults` once per `design.md` for shared module/camera
metadata and compact `scad-render` blocks for individual views. Let the tooling
generate `NN-<view>.png` names unless a fixed filename is specifically needed.

Project default:

```yaml
openscad:
  design_image_size: [640, 480]
```

Keep normal project render resolution separate via `openscad.image_size`.



## PythonSCAD reference consumer

Keep one small PythonSCAD component in the template as an end-to-end test of
`tool.scad-project` multi-engine design rendering.

It is a tooling demonstration, not a requirement that real projects implement
every component in both OpenSCAD and PythonSCAD.

The project design root is intentionally `dsg`, allowing both
`dsg/openscad/...` and `dsg/pythonscad/...` design documents to be discovered.


## External update convention

Keep bootstrap and dependency advancement separate.

`bootstrap.ps1` / `bootstrap.sh`:
- restore the exact submodule commits pinned by the project.

`update-externals.ps1` / `update-externals.sh`:
- update only CAD/library paths below `dsg/*/ext/`;
- never update `tools/tool.scad-project`;
- require clean external working trees;
- use remote default branch + fast-forward only;
- leave changed gitlinks for review and manual commit.

Tooling updates are intentionally separate because project-tool versions and
CAD-library versions have different release cadence.

## Build branch index

The source file `docs/build-README.md` is copied to `bld/README.md` by CI after
the project build and before artifact/publication.

The resulting root README on the mutable `build` branch is a navigation index
to:
- generated design documentation;
- PNG renders;
- STL exports.

Do not commit generated `bld/README.md` to `main`.

## Versioned dependency reference example

The template intentionally demonstrates per-dependency ref policy:

```text
tool.scad-project
    ref: v0.6.1

lib.scad.clamps
    ref: latest
```

`latest` means the highest stable semantic-version tag and does not mean
`main`.

A project may use `ref: main` explicitly when testing a dependency's current
development branch.

Root dependency-management scripts:
- `bootstrap.ps1`
- `bootstrap.sh`
- `update-repo.ps1`
- `update-repo.sh`

These are copied from `tool.scad-project` v0.4.3. The updater scripts are
Python-free.

The template no longer maintains separate `update-externals.*` scripts; generic
dependency updating belongs to `update-repo.*`.

