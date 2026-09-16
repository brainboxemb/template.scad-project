# Verification

This snapshot contains verification-specific evidence only. Normal build products remain under `bld/` and are not duplicated here.

The reference consumer currently verifies two independent OpenSCAD dependency paths:

- the configured tube holder and nominal tube bore;
- the mounting plate thickness.

These renders are verification evidence rather than presentation output, so they deliberately use the smaller verification-specific image size.

## Verification renders

![Tube-holder bore check](png/tube-holder-bore-check.png)

![Mounting-plate thickness check](png/mounting-plate-thickness-check.png)

The geometry above is built by the dependency-aware verification target engine. `scripts/run-verification.sh` performs the remaining cheap project-policy checks and copies this source template into the generated snapshot.

In the repository Moon graph this template is a verification-only input. Updating verification documentation or verification CAD must invalidate the verification branch without invalidating unrelated normal Build or generated-design tasks.

The exact source commit and runtime/tooling versions are recorded separately in `publication-info.txt` by `tool.scad-project`.

<!-- scad-project-evidence-navigation -->
## Producer execution evidence

These files describe the SCAD producer executions that actually created the retained output.
They remain unchanged when equivalent output is later hydrated from cache.

- [scad-verify execution](evidence/executions/scad-verify/execution.json) — capability, producer source revision, exact owner revision, result and producer timing when available.
  - [scad-verify log](evidence/executions/scad-verify/execution.log) — concise human-readable producer summary.

## Domain evidence

Structured SCAD/SCons reports contain the detailed target-level build and cache decisions.
They are richer domain evidence, not alternate producer logs.

- [last-verification-build.json](evidence/domain/last-verification-build.json)

## Orchestration/materialization evidence

Current-run orchestration evidence explains why capabilities were selected, whether Moon executed or hydrated them, and how long current materialization and snapshot preparation took.
Producer execution evidence above remains the authority for the work that originally created cached output.

- [Workflow phase timings](orchestration/timings.json)
- [Run context and snapshot-preparation timing](orchestration/run-context.json)
- [Moon impact decision](orchestration/impact-decision.json)
- [Affected Moon task ids](orchestration/affected-task-ids.json)
- [SCAD execution/materialization plan](orchestration/scad-ci-plan.json)

### Current workflow timing

| Phase | Duration |
| --- | ---: |
| Preflight + execution plan | 12.811 s |
| Cache restore | 1.659 s |
| Runtime pull | 25.641 s |
| Capability materialization | 13.005 s |
| Cache save | 1.734 s |
| Validation + finishing | 562 ms |
| Snapshot preparation | 2 ms |
| **Total to prepared snapshot** | **55.549 s** |

The table stops when this generated snapshot is ready. The remote branch push happens afterwards; detailed per-capability timings remain in the materialization files below.

- [consumer:scad.build materialization](orchestration/moon-invocations/consumer_scad.build/materialization.json) — current execute/cache/hydrate result and duration.
  - [consumer:scad.build raw Moon/producer log](orchestration/moon-invocations/consumer_scad.build/moon.log)
- [consumer:scad.docs materialization](orchestration/moon-invocations/consumer_scad.docs/materialization.json) — current execute/cache/hydrate result and duration.
  - [consumer:scad.docs raw Moon/producer log](orchestration/moon-invocations/consumer_scad.docs/moon.log)
- [consumer:scad.verify materialization](orchestration/moon-invocations/consumer_scad.verify/materialization.json) — current execute/cache/hydrate result and duration.
  - [consumer:scad.verify raw Moon/producer log](orchestration/moon-invocations/consumer_scad.verify/moon.log)

## Publication context

`publication-info.txt` records generated-branch context plus source, tooling and runtime provenance.
Publication/finalization consumes prepared output and must not rewrite producer execution evidence.
