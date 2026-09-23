# template.scad-project development manual

## Start

1. read [../AGENTS.md](../AGENTS.md);
2. read [10-00-plan.md](10-00-plan.md);
3. use [README.md](README.md) for specification/design/verification routing;
4. inspect affected component-local design before changing geometry.

## Repository entrypoints

Use the managed root launchers:

```text
bootstrap.ps1 / bootstrap.sh
update.ps1 / update.sh
```

Repository-owned workflows are `self-ci.yml`, `self-release.yml` and
`self-pr-cleanup.yml`. Shared orchestration stays in released reusable
workflows.

## Dependencies

`project.yml` declares semantic released dependencies. Committed gitlinks carry
exact revisions. `tool.git-project` is the bootstrap exception: its gitlink is
authoritative and it is not recursively declared in `project.yml`.

Do not edit pinned dependency source in place. Update declared refs and gitlinks
together, then use the managed update launcher.

## Build, verification and visual design

Open `dsg/openscad/main.scad` for interactive OpenSCAD. Normal render/export
entrypoints live under `dsg/openscad/render/` and `dsg/openscad/export/`.

Detailed component construction stays beside source as `design/design.md`.
Build publication copies those documents and generates the referenced images
under `prod/bld/design/...`. Use generated output for visual review and source
files for editing/authority.

## Release

Release only an exact qualified main commit through `self-release.yml`. Inspect
live Actions plus production Build/Verification provenance first.
