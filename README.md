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

- [scad-verify execution](evidence/executions/scad-verify/execution.json) — capability, producer source revision, exact owner revision and result.
  - [scad-verify log](evidence/executions/scad-verify/execution.log) — concise human-readable producer summary.

## Domain evidence

Structured SCAD/SCons reports contain the detailed target-level build and cache decisions.
They are richer domain evidence, not alternate producer logs.

- [last-verification-build.json](evidence/domain/last-verification-build.json)

## Orchestration/materialization evidence

The publication layer may add `orchestration/materialization.json` for the current source revision/context and `orchestration/moon.log` for Moon's execute/cache/hydrate decision.
After cache hydration, that current materialization revision may intentionally differ from the producer `source_revision` above.

## Publication context

`publication-info.txt` records generated-branch context plus source, tooling and runtime provenance.
Publication/finalization consumes prepared output and must not rewrite producer execution evidence.
