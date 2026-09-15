# Changelog

Functional changes to released `template.scad-project` versions.

## Unreleased

## v0.0.4

### Changed

- Replace file-level Moon impact inputs with maintainable source-family boundaries for components, externals, verification content and scripts.
- Keep capability impact automatic for newly added components and verification cases so routine repository growth does not require editing `moon.yml`.

### Fixed

- Update repository verification to enforce stable source-family boundaries instead of requiring specific component filenames in the Migration 005 capability contract.

## v0.0.3

### Changed

- Migrate the canonical reference consumer to the Migration 005 SCAD capability lifecycle on released `tool.git-project v0.2.8`, `tool.scad-project v0.14.2` and SCAD toolchain v0.5.0 foundations.
- Replace the consumer-authored Migration-004 lifecycle/aggregate Moon graph with the three real inherited capabilities `scad.docs`, `scad.build` and `scad.verify`.
- Select inherited capabilities in root `moon.yml`, keep only project-specific impact inputs there, and inherit shared task implementation through `.moon/tasks/scad.yml`.
- Keep the template deliberately representative of the broad path: OpenSCAD + PythonSCAD select the full/dual runtime, while `build_engine.engine: scons` exercises normal and Verification-SCons reuse where applicable.
- Replace copied production orchestration with the exact-pinned reusable `project-production.yml` lifecycle: one host-side affected query, at most one CAD runtime, publication-safe materialization, lightweight finishing and separate Build/Verification publication.
- Keep normal successful production to compact orchestration evidence instead of retaining duplicate complete Build/Verification trees as Actions artifacts; coordinated releases still use full exact-source cross-job artifacts.
- Scope Verification impact to the project CAD source and verification inputs it actually consumes, preserving independent Build/docs/Verify boundaries.
- Advance the reusable `lib.scad.clamps` dependency from `v0.1.0` to the validated immutable `v0.1.1` release and lock its gitlink to exact source `e2e4c03a743b4c76ebd96f015ca81cc686defbf3`.
- Use isolated `dev/pr-<number>/build` and `dev/pr-<number>/verification` pull-request previews, keep production snapshots on `prod/build` and `prod/verification`, and clean pull-request publication after close.
- Defer generic branch, pull-request, dependency and publication mechanics to the exact-pinned shared tooling instead of duplicating them in the template.

### Fixed

- Align the semantic `tool.scad-project` dependency, tool gitlink and Production/Release workflow callers to exact released v0.14.2 source `5712324ea9e3a7c81ba1b79013f2758f52b219cf` after Step-4 integration exposed and fixed clean planner-install and Moon inherited-capability-location defects in the owner tool.
- Document the Moon 2.5.4 configuration boundary correctly: capability selection belongs in project-level `moon.yml`; `.moon/workspace.yml` remains workspace-level configuration.

### Removed

- Remove local `scad.build-index`, provenance, synthetic production-impact and aggregate CI lifecycle tasks from the consumer Moon graph; these mechanics are now owned by `tool.scad-project`.

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
