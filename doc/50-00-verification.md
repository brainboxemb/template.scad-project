# template.scad-project verification

## Purpose

Verification proves that this repository remains a valid reference consumer of
the shared SCAD stack. It checks generated CAD evidence and stable integration
contracts.

## Verification geometry

Two focused OpenSCAD entrypoints prove independent paths:

- tube-holder bore behavior;
- mounting-plate thickness behavior.

Their images live in Verification output, separate from presentation Build output.

## Policy checks

`scripts/run-verification.sh` checks configured SCAD profile location, semantic
tool ref versus exact gitlink, direct dependency gitlinks, thin `self-ci.yml`
and `self-release.yml` callers, generic `self-pr-cleanup.yml`, canonical
publication namespaces, inherited Moon capability selection, and canonical
managed bootstrap/update launchers.

## Evidence and publication

Generated evidence lives under `vrf/out` and is published to `vrf`. The
snapshot includes this strategy document, the human verification README and
rendered evidence.

A green template run proves this representative configuration integrates
correctly; it does not mean every project should use the same engines or
capabilities.
