# template.scad-project plan

## Purpose

This repository is the qualified reference consumer for the current shared SCAD
project architecture.

It should demonstrate how a normal project consumes released shared tooling and
reusable libraries without becoming the owner of those mechanisms.

## Current position

The reference consumer currently exercises:

- `scad.docs`, `scad.build` and `scad.verify`;
- OpenSCAD + PythonSCAD, selecting the full/dual runtime profile;
- SCons as the configured fine-grained build engine;
- one reusable external library (`lib.scad.clamps`);
- generated design documentation;
- normal Build/Verification publication;
- coordinated release composition.

There is no active template feature issue or pull request after the old
qualification draft was closed as superseded.

## Working method

1. inspect current config, open issues/PRs, live CI and publication provenance;
2. determine whether the proposed behavior belongs in a shared owner first;
3. qualify owner changes before updating the reference consumer;
4. keep the template representative but understandable;
5. avoid copying volatile shared-tool implementation details into template docs;
6. preserve a small concrete model and real verification cases so the template
   remains an executable example, not only configuration.

## Information sources

| Question | Authority |
| --- | --- |
| Current/future template work | this plan |
| Shared working conventions | `brainboxemb.meta/AGENTS.md` |
| Why the template exists | [10-specification.md](10-specification.md) |
| Project/reference architecture | [20-design.md](20-design.md) |
| Detailed component construction | component-local `design/design.md` |
| Verification strategy/status | [30-verification.md](30-verification.md) |
| CI/runtime flow | [40-ci-orchestration.md](40-ci-orchestration.md) |
| Exact tool/dependency pins | `project.yml`, gitlinks and workflow callers |
| Exact pinned dependency behavior | pinned dependency README/docs/source/tests |
| Current automation/runtime health | live Actions plus `prod/bld` / `prod/vrf` provenance |
| Completed history | [../CHANGELOG.md](../CHANGELOG.md) |

## Template evolution

The template is updated **after** a convention/tooling model has been qualified
on real repositories. It should record the proven consumer pattern rather than
participating in inventing the pattern.

Do not add a capability, runtime, library or document merely because the
ecosystem supports it. The reference remains useful only while each included
piece demonstrates a real, intentional path.
