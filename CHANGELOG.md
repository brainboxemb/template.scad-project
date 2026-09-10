# Changelog

Functional changes to released `template.scad-project` versions.

## Unreleased

## v0.0.2

### Changed

- Upgrade the canonical reference consumer to `tool.scad-project` v0.9.6 and SCAD toolchain v0.4.1.
- Pin Build, Verify and Release callers plus the `tools/tool.scad-project` gitlink to the same immutable tool release.
- Use directory-based OpenSCAD build discovery through `paths.render_root` and `paths.export_root` instead of explicit normal PNG/STL `builds:` entries.
- Keep separate stable render and export entrypoints for the reference assembly while preserving the existing output basenames.
- Enable the SCons selective build backend and exercise cold-cache and exact-hit behaviour in the template CI.
- Publish the generic generated normal-build PNG gallery at `bld/png/README.md` and link it from the template README.
- Define `template.scad-project` explicitly as the canonical minimal/reference smoke consumer, complemented by larger integration consumers for dependency-selective tests.
- Synchronize the root bootstrap/update scripts with the canonical v0.9.6 tool release.

### Fixed

- Keep repository upgrades from leaving the Release workflow on an older tool ref: v0.9.6 updates Build, Verify and Release callers together.
- Extend template functional verification to require `project.yml`, Build, Verify and Release to use the same immutable tool ref and to require root bootstrap/update scripts to match the pinned tool release.

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
