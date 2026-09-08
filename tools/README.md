# template.scad-project

Reference OpenSCAD project using the reusable `tool.scad-project` workflow.

The project demonstrates the intended separation:

```text
docker.scad-toolchain
    runtime and external capabilities

tool.scad-project
    reusable project workflow

template.scad-project
    project configuration + CAD source + documentation
```

## Quick links

- [Generated build branch](../../tree/build)
- [Build overview](../../blob/build/README.md)
- [Generated design documentation](../../blob/build/design/README.md)
- [PNG renders](../../tree/build/png)
- [STL exports](../../tree/build/stl)

## Structure

```text
.
├── project.yml
├── dsg/
│   └── openscad/
│       ├── ext/
│       ├── lib/
│       ├── components/
│       ├── assemblies/
│       ├── render/
│       └── main.scad
├── bld/
├── vrf/
└── .github/workflows/
```

There are deliberately no project-specific build/render Python scripts in this
repository.

## Runtime

The CI runtime is:

```text
ghcr.io/brainboxemb/scad-toolchain:v0.3.0
```

The reusable workflow CLI comes from:

```text
tool.scad-project
```

The reusable project tool is not downloaded by CI on every run. It is pinned
inside the project as a Git submodule:

```text
tools/tool.scad-project
```

The parent repository therefore records the exact tool commit alongside the
exact commits of its CAD-library externals.

## Bootstrap and externals

A fresh project contains:

```text
bootstrap.ps1
bootstrap.sh
.gitmodules
```

Bootstrap deliberately requires **no Python**.

On Windows the only prerequisites are PowerShell and Git:

```powershell
.\bootstrap.ps1
```

`.gitmodules` is the technical bootstrap manifest. For this template it declares:

```text
tools/tool.scad-project
dsg/openscad/ext/lib.scad.clamps
```

The script is safe to run repeatedly. It detects and preserves already-correct
submodules, initializes registered-but-empty submodules, and can repair the
common ZIP/new-repository state where `.gitmodules` exists but the parent Git
repository does not yet contain the gitlink.

This is specifically intended to handle partially completed local setup.

After bootstrap:

```powershell
git status
```

will show any newly established submodule gitlinks that still need to be
committed. A typical first commit is:

```powershell
git add .gitmodules tools/tool.scad-project dsg/openscad/ext/lib.scad.clamps
git commit -m "Add project tooling and external libraries"
git push
```

The semantic dependency declaration remains in `project.yml`:

```yaml
externals:
  - name: lib.scad.clamps
    type: git-submodule
    url: https://github.com/brainboxemb/lib.scad.clamps.git
    path: dsg/openscad/ext/lib.scad.clamps
    required_file: openscad/tube-clamp/tube_clamp.scad
```

`.gitmodules` exists because Git needs the technical URL/path information before
the Python project tool itself is available. Later linting can check that
`project.yml` and `.gitmodules` agree.

Once bootstrapped, use the pinned local tool:

```powershell
.\tools\tool.scad-project\scad-project.ps1 externals-status
.\tools\tool.scad-project\scad-project.ps1 design-lint
.\tools\tool.scad-project\scad-project.ps1 design-build
.\tools\tool.scad-project\scad-project.ps1 build
.\tools\tool.scad-project\scad-project.ps1 verify
```

## Direct dependency checkout

The template initializes only its own direct dependencies:

```text
tools/tool.scad-project
dsg/openscad/ext/lib.scad.clamps
```

It deliberately does not recursively initialize submodules owned by
`lib.scad.clamps`. The library's `tools/tool.scad-project` checkout is relevant
when the library is developed standalone, not when it is merely consumed as CAD
source by this project.

This keeps the consumer dependency tree shallow in normal use.

## Versioned dependencies

`project.yml` is the dependency-policy source.

The template deliberately demonstrates two different policies:

```yaml
tooling:
  tool_scad_project:
    type: git-submodule
    url: https://github.com/brainboxemb/tool.scad-project.git
    path: tools/tool.scad-project
    ref: v0.4.4

externals:
  - name: lib.scad.clamps
    type: git-submodule
    url: https://github.com/brainboxemb/lib.scad.clamps.git
    path: dsg/openscad/ext/lib.scad.clamps
    ref: main
    required_file: openscad/tube-clamp/tube_clamp.scad
```

This demonstrates:

```text
tool.scad-project
    exact released tooling version

lib.scad.clamps
    latest stable semantic-version tag
```

A project can also use a branch ref such as:

```yaml
ref: main
```

when it intentionally wants to test against current development.

After bootstrap, update all configured dependencies with:

```powershell
.\update-repo.ps1
```

or:

```bash
bash ./update-repo.sh
```

The updater is Python-free. It resolves each dependency independently, updates
the corresponding gitlink, aligns reusable workflow refs for the project
tooling, and leaves all changes uncommitted for review.

To restore the commits already locked by the parent repository, use:

```powershell
.\tools\tool.scad-project\scad-project.ps1 repo-sync
```

## Development entrypoint

Open:

```text
dsg/openscad/main.scad
```

The example assembly contains:

```text
mounting plate
+
reusable tube clamp
+
20 mm reference tube
```

## Design documentation

Design renders use a compact defaults + step syntax:

```markdown
<!-- scad-render-defaults
module: tube_design
vpr: [60, 0, 35]
-->

<!-- scad-render
view: outer
-->
```

The image name is generated from declaration order (`01-outer.png`,
`02-bore.png`, ...). The default design image size is `640x480`; individual
steps can override it with `size:`.


`design.md` files are source documentation. Generated images are not committed
beside them on `main`.

Source example:

```text
dsg/openscad/components/tube/
├── tube.scad
└── design/
    └── design.md
```

The source document declares views:

```markdown
<!-- scad-render
type: source-view
module: tube_design
view: bore
image: 02-bore.png
alt: Tube bore
-->
```

Run:

```powershell
.\tools\tool.scad-project\scad-project.ps1 design-build
```

Generated output is generated under:

```text
bld/design/
├── project/
│   └── components/tube/design/
│       ├── design.md
│       └── img/
└── ext/
    └── lib.scad.clamps/
        └── ...
```

The external library's design documentation is included automatically when the
library contains compatible `design/design.md` sources.

This means the library's generated images do not need to be committed to its
source checkout just to make its design documentation visible to a consuming
project.


## PythonSCAD design-render example

The reference project includes a small PythonSCAD component under:

```text
dsg/pythonscad/components/pythonscad-example/
```

Its `design.md` uses the same render declarations as OpenSCAD components:

```markdown
<!-- scad-render-defaults
engine: pythonscad
source: pythonscad_example.py
vpr: [65, 0, 35]
-->

<!-- scad-render
view: final
-->
```

This example is intentionally small. Its purpose is to verify the generic
multi-engine design pipeline rather than introduce a second implementation of
the main tube-holder assembly.

## Source/API documentation

Structured `.scad` comments use `openscad_docsgen` conventions.

For example:

```scad
// File: tube.scad
//
// Module: tube()
// ...
```

`scad-project docs-lint` validates these comments using the docsgen tooling from
the runtime image.

## Local workflow

After bootstrap, use the project-pinned local tool:

```powershell
.\tools\tool.scad-project\scad-project.ps1 config-lint
.\tools\tool.scad-project\scad-project.ps1 externals-check
.\tools\tool.scad-project\scad-project.ps1 docs-lint
.\tools\tool.scad-project\scad-project.ps1 design-lint
.\tools\tool.scad-project\scad-project.ps1 design-build
.\tools\tool.scad-project\scad-project.ps1 build
.\tools\tool.scad-project\scad-project.ps1 verify
```

`design-render` renders the complete expected design image set before removing
stale images.

## CI

The repository keeps a thin GitHub Actions caller:

```yaml
jobs:
  build:
    uses: brainboxemb/tool.scad-project/.github/workflows/project-build.yml@v0.4.4
```

The reusable workflow owns the common SCAD project build sequence:

1. restore pinned submodules;
2. validate tooling alignment;
3. lint configuration, externals, source docs and design docs;
4. generate OpenSCAD and PythonSCAD design documentation;
5. build configured PNG/STL outputs;
6. create the build index;
7. upload `bld/` as an artifact;
8. publish successful non-PR output to the mutable `build` branch.

Generated output stays out of `main`.

## OpenSCAD module boundaries

The example deliberately uses `use <...>` between project components.
`use` imports modules and functions, but not top-level variables.

Values needed across component boundaries are therefore exposed through
functions rather than by directly reading another file's constants. For
example:

```scad
function mounting_plate_thickness() = MOUNTING_PLATE_THICKNESS;
```

The assembly calls `mounting_plate_thickness()` instead of referencing
`MOUNTING_PLATE_THICKNESS` directly.


## Generated build branch

The source branch deliberately does not contain generated design images,
renders or STL files.

Local/CI output goes to:

```text
bld/
├── design/
├── png/
└── stl/
```

On successful non-PR CI runs, the current `bld/` contents are published as the
mutable orphan branch:

```text
build
```

So the repository roles are:

```text
main
    source .scad
    source design.md
    project.yml
    bootstrap/configuration

build
    generated design docs
    generated PNG
    generated STL
```


The `build` branch also has a generated root `README.md` that acts as an index
to the design documentation, PNG renders and STL exports.

A user can also run `design-build` locally to inspect the same generated design
documentation without modifying the source tree.



### Reference assembly orientation

The reusable clamp keeps its library-native coordinate system. The project
adapter rotates it only at the mounting boundary: the compact flat face rests
on the mounting plate and the reference tube follows the resulting horizontal
X-axis bore.

Design declarations use explicit image sizes but only `vpr` where possible;
`scad-project` then keeps the requested orientation and auto-fits the model.
