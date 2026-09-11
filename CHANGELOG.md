# Changelog

Functional changes to released `template.scad-project` versions.

## Unreleased

### Changed

- Advance the reusable `lib.scad.clamps` dependency from `v0.1.0` to the newly validated immutable `v0.1.1` release.
- Lock the `dsg/openscad/ext/lib.scad.clamps` gitlink to the exact source commit behind `v0.1.1` (`e2e4c03a743b4c76ebd96f015ca81cc686defbf3`).
- Upgrade the canonical reference consumer from `tool.scad-project` v0.9.8 through v0.9.10 and v0.9.11 to v0.9.12.
- Align the semantic tool ref, `tools/tool.scad-project` gitlink, and Build/Verify/Release/PR-cleanup reusable workflow callers to the exact v0.9.12 source commit.
- Replace shared `dev/build` and `dev/verification` snapshots with isolated `dev/pr-<number>/build` and `dev/pr-<number>/verification` pull-request previews.
- Run Build and Verify for pull requests and pushes to `main` instead of also running a duplicate build for every feature-branch push.
- Add pull-request cleanup that removes generated PR preview branches after close and deletes merged same-repository feature branches.
- Keep production publication on mutable `prod/build` and `prod/verification` snapshots.
- Defer generic branch, pull-request and publication-agent guidance to the pinned `tools/tool.scad-project/AGENTS.md` policy instead of duplicating changing workflow rules in the template root guidance.

## v0.0.2

### Changed

- Upgrade the canonical reference consumer to `tool.scad-project` v0.9.8 and SCAD toolchain v0.4.1.
- Keep the tool dependency semantic in `project.yml` while pinning Build, Verify and Release callers to the exact commit behind v0.9.8.
- Pin the `tools/tool.scad-project` gitlink to the same v0.9.8 commit used by the reusable workflow callers.
- Use directory-based OpenSCAD build discovery through `paths.render_root` and `paths.export_root` instead of explicit normal PNG/STL `builds:` entries.
- Keep separate stable render and export entrypoints for the reference assembly while preserving the existing output basenames.
- Enable the SCons selective build backend and exercise cold-cache and exact-hit behaviour in the template CI.
- Publish the generic generated normal-build PNG gallery at `bld/png/README.md` and link it from the template README.
- Define `template.scad-project` explicitly as the canonical minimal/reference smoke consumer, complemented by larger integration consumers for dependency-selective tests.
- Synchronize the root bootstrap/update scripts with the canonical v0.9.8 tool release.

### Fixed

- Keep repository upgrades from leaving the Release workflow on an older tool ref: v0.9.6 updates Build, Verify and Release callers together.
- Extend template functional verification to require the semantic tool ref to resolve to the checked-out gitlink and all three workflow callers to use that exact tool commit SHA.
- Use explicit same-revision self-references for nested Build and Verify in the reusable release workflow.
- Avoid GitHub's annotated-tag validation failure for nested cross-repository reusable workflows by using the exact v0.9.8 commit SHA in consumer workflow callers.

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
