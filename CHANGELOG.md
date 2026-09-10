# Changelog

Functional changes to released `template.scad-project` versions.

## Unreleased

### Changed

- Use directory-based OpenSCAD build discovery through `paths.render_root` and `paths.export_root` instead of explicit normal PNG/STL `builds:` entries.
- Keep separate stable render and export entrypoints for the reference assembly while preserving the existing output basenames.
- Align README and ChatGPT handoff documentation with `tool.scad-project` v0.9.1, SCAD toolchain v0.4.1 and the `prod/*` / `dev/*` / immutable `rel/vX.Y.Z/*` publication lifecycle.
- Synchronize root bootstrap/update scripts with the canonical tool release; the v0.9.1 patch does not change those helper scripts.
- Publish the generic generated normal-build PNG gallery at `bld/png/README.md` and link it from the template README.

### Removed

- Remove the accidental nested copy of the template project below `tools/`; only `tools/tool.scad-project` remains there.
- Remove legacy `docs/build-README.md`; `scad-project build-index` now generates the build index directly.

## v0.0.1

### Added

- Validate the versioned SCAD project release lifecycle.
- Publish browseable immutable build and verification snapshots under `rel/v0.0.1/*`.
- Publish deterministic build, verification and STL release bundles with SHA-256 checksums.
- Add a minimal functional verification workflow for the reference project.

### Changed

- Use `prod/build` and `prod/verification` for mutable generated snapshots from `main`.
