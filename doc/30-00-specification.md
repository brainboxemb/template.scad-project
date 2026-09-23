# template.scad-project specification

This document is primarily for a human reader. It explains why the reference
consumer exists, what questions it answers and why its representative features
are present.

## Why a reference consumer is useful

Shared tools can be individually correct and still fail when a normal repository
combines them. A small integration consumer gives maintainers and project authors
one place where released pieces are exercised together in the shape a real
project uses.

The template answers:

> Can a normal CAD repository declare its own intent, consume pinned shared
> tooling and libraries, build real geometry, verify it, generate readable
> design documentation and publish reproducible evidence without copying the
> shared lifecycle implementation?

This differs from an owner test. Tool owners prove their behavior; the template
proves that released public contracts compose into a usable consumer.

## Who it is for

- project authors wanting a concrete current-generation SCAD example;
- tool/library maintainers needing a final integration consumer after owner qualification;
- automated agents needing a concrete released consumer contract.

Human explanation remains primary. Agent/developer rules live in AGENTS and the
development manual rather than replacing this specification.

## Why the template contains more than the minimum

A minimal repository would hide interactions that only appear when features are
combined. The template stays compact but deliberately broad.

### Generic versus SCAD configuration

`project.yml` declares generic dependency identity; `project.scad.yml`
declares CAD-domain behavior. Keeping these separate shows which choices belong
to repository infrastructure and which only make sense for SCAD.

### Release refs and exact gitlinks

A readable release ref answers "which release do we intend to consume?" A
committed gitlink answers "which exact source revision did this build use?" Both
are retained because semantic intent and reproducible identity solve different
problems.

### OpenSCAD and PythonSCAD

The PythonSCAD example is intentionally small. It exists to prove the dual
runtime path, not to duplicate every OpenSCAD component.

### Moon and SCons

Moon decides coarse repository capability impact/reuse. SCons reuses individual
CAD targets inside a capability that actually executes. Exercising both makes
their different responsibilities concrete.

### Generated visual design documentation

Source-side `design/design.md` keeps explanation beside the owning component.
Build publication renders the referenced views and publishes a readable copy
with images. Source locality serves authors; generated output serves readers and
reviewers.

### Build and Verification

Presentation output and verification evidence answer different questions.
Keeping `bld` and `vrf` separate avoids treating attractive output as
acceptance evidence.

## Concrete reference model

The model is intentionally understandable:

- project-owned mounting plate;
- reusable-library-backed tube holder;
- project-owned reference tube;
- tube-holder assembly;
- small PythonSCAD component.

The geometry is only complex enough to exercise dependencies, generated design
images, renders, exports and focused verification.

## Desired behavior

- managed bootstrap/update launchers come from the accepted generic tool;
- declared refs and committed gitlinks agree with the accepted baseline;
- repository workflows are thin `self-*` callers of released `reusable-*` APIs;
- Build contains presentation artifacts and readable visual design docs;
- Verification contains focused evidence plus repository strategy;
- generic Git/SCAD lifecycle and reusable clamp geometry remain owned elsewhere.

## Non-goals

The template is not the minimum every project must copy, a mandatory feature
checklist, an owner of shared lifecycle logic, a second copy of tool
documentation, proof that every project needs PythonSCAD/SCons/all capabilities,
or the place where new cross-repository conventions are invented.
