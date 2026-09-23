# Changelog

## 2026-09-21 — Migration 008 released dependency stack

- Advance the reference consumer to `tool.git-project v0.2.9` and `tool.scad-project v0.15.2`, preserving exact gitlink identity alongside readable semantic workflow refs.
- Replace root repository update launchers with the canonical Python-free v0.15.2 consumer launchers.
- Qualify normal SCons Build production with the released dependency-provenance owner implementation; no artificial nested dependency is added to the template.
- Align reference-consumer documentation with the v0.6.1 runtime and current released owner stack.


Functional changes to released `template.scad-project` versions.

## Unreleased

### Changed

- Adopt the Migration 011 qualified reference baseline: tool.git-project v0.2.14, tool.scad-project v0.15.11 and lib.scad.clamps v0.1.9; install managed bootstrap/update launchers; move repository entry workflows to self-ci/self-release/self-pr-cleanup; migrate documentation to the shared 10/20/30/40/50 families; strengthen the human-facing specification; and surface generated visual design documents alongside their source authorities.

- Align the reference consumer with Migration 010 documentation/agent guidance: add numbered plan/specification/design/verification/CI authorities, route shared workflow through `brainboxemb.meta`, keep component-local visual detailed design, publish the verification strategy with generated evidence, and replace stale copied tooling/version documentation with config/live-provenance routing. Preserve a representative generated assembly preview in the top-level README.

- Advance Migration 009 to released `tool.scad-project v0.15.7` with exact tool gitlink `bfaac9f6916c09bc6525abddf64c87238fe59103`; this retains production-branch serialization and restores the qualified read-only `update-repo status` contract.
- Qualify the released stack on exact-main source `462534755fef88f393e53c8b7d8a3675ff9a7cce` through production run `35728474360`, with both `prod/bld` and `prod/vrf` provenance on v0.15.6.

## v0.0.6

### Changed

- Align the reference consumer to released `tool.scad-project v0.14.9` with exact tool gitlink `a140b22858ac1899e7f2fa71b679639a70d819c3`.
- Normalize persistent technical Build/Verification publication namespaces to `dev/pr-N/{bld,vrf}`, `prod/{bld,vrf}` and `rel/vX.Y.Z/{bld,vrf}` while retaining human-facing Build/Verification terminology.
- Record exact-main production qualification on `399d28f6ff497efee955a02e781e8166d435b740` through run `35122146935`, with `prod/bld` and `prod/vrf` provenance on the same v0.14.9 baseline.
- Keep the template CAD source, external dependency identities and reference-consumer execution model unchanged; this release closes the Migration-005 namespace correction only.

## v0.0.5

### Changed

- Upgrade the reference consumer to released `tool.scad-project v0.14.8` while keeping the committed tool gitlink on exact source `85781a6b21a0f6a06d37be154fd9eb475ecaa2a4`.
- Use readable semantic `@v0.14.8` refs for Production and Release reusable-workflow callers instead of duplicating the tool commit SHA in workflow YAML.
- Collapse the consumer Release workflow to triggers, permissions, project output paths and one shared `project-release.yml@v0.14.8` call; release-request parsing, validation and cleanup remain in the shared owner workflow.
- Qualify durable coarse workflow timings in generated Build/Verification output, including `orchestration/timings.json`, the generated README timing table and direct raw-log navigation.

### Fixed

- Qualify shallow base-to-head impact evaluation when the `tool.scad-project` gitlink itself changes, avoiding conservative fallback caused by a missing base gitlink object.
- Qualify exact pull-request publication provenance so `publication-info.txt`, run context, materialization records and producer evidence all identify the same assessed source revision rather than GitHub's synthetic pull-request merge SHA.
- Align repository verification and maintainer guidance with the semantic workflow-ref plus exact-gitlink dependency contract.
- Qualify semantic cross-repository Release calls through lightweight `tool.scad-project` release tags, fixing the annotated-tag workflow-resolution blocker exposed by the first v0.0.5 release attempt.

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
- Document the Moon 2.5.4 configuration boundary correctly: capability selection belongs in project-level root `moon.yml`; `.moon/workspace.yml` remains workspace-level configuration.

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
