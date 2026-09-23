# template.scad-project verification

## Purpose

Verification proves that this repository remains a valid reference consumer of
the shared SCAD stack.

It checks both generated CAD evidence and project-policy integration contracts.

## Verification geometry

Two focused OpenSCAD verification entrypoints currently prove independent source
paths:

- tube-holder bore behavior;
- mounting-plate thickness behavior.

Their generated images live only in Verification output and are intentionally
separate from normal presentation Build output.

## Policy checks

`scripts/run-verification.sh` additionally verifies the project/tooling
contract, including:

- configured SCAD profile location;
- semantic tool ref versus exact checked-out gitlink;
- expected direct gitlinks;
- thin Production and Release reusable-workflow callers;
- canonical `bld` / `vrf` publication namespaces;
- inherited Moon task policy plus project capability selection;
- canonical bootstrap/update wrappers;
- project-specific source-impact boundaries.

These checks belong here because the repository is deliberately the reference
consumer for those released contracts.

## Acceptance boundary

A green template run proves that this reference configuration works. It does not
mean every project should use the same engines/capabilities.

Tool/library behavior is qualified in its owning repository first; the template
then proves consumer integration.

## Evidence and publication

Generated verification evidence lives under `vrf/out` and is published to the
technical `vrf` namespace.

The generated snapshot includes a copy of this document plus the human
verification README and rendered evidence.

For current runtime/tool versions and exact source identity, inspect live
Actions and `publication-info.txt` rather than freezing those values here.
