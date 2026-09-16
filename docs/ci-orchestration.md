# SCAD CI orchestration

This repository is the reference consumer for the current shared SCAD production lifecycle.

The consumer exposes real project capabilities; shared tooling owns the generic lifecycle around them.

```text
consumer
  capability selection + project-specific impact inputs

Moon
  one base -> source affected query + whole-capability reuse

tool.scad-project
  capability/config validation + runtime/cache plan + finishing

SCons, when configured
  fine-grained target reuse inside an executing capability
```

## Consumer capability model

Root `moon.yml` selects:

```text
scad.docs
scad.build
scad.verify
```

through `workspace.inheritedTasks.include` and adds template-specific source-family inputs for those capabilities. `.moon/workspace.yml` remains limited to Moon workspace/project registration and other workspace-level settings.

`.moon/tasks/scad.yml` inherits the shared definitions from the exact pinned `tool.scad-project` gitlink.

There are no consumer-authored `scad.production-impact`, `scad.ci`, build-index or provenance tasks. Those are lifecycle mechanics, not project capabilities.

## Dependency and reusable-workflow identity

`project.yml` records the released semantic `tool.scad-project` dependency, for example `v0.14.8`. Production and Release callers use that same readable semantic release ref:

```yaml
uses: brainboxemb/tool.scad-project/.github/workflows/project-production.yml@v0.14.8
```

The committed `tools/tool.scad-project` gitlink records the exact source commit resolved for that release. Tooling validation checks the semantic workflow ref and exact checked-out tool identity as separate parts of the same dependency contract.

## 1. Exact source-impact decision on the host

Normal CI first resolves the exact source revision and comparison base and invokes released `tool.git-project v0.2.8` affected logic once.

Conceptually:

```text
base -> source
      |
      v
one Moon affected query
      |
      +--> [] -> finish before CAD runtime
      |
      +--> affected task IDs -> SCAD planner
```

The generic action uses an existing task as query anchor, but the returned affected-task set is repository-wide rather than restricted to that task.

Current `tool.scad-project` also makes the exact base revision of the `tools/tool.scad-project` gitlink available before the Moon query. This allows a shallow base-to-head comparison to remain precise even when the consumer upgrades the SCAD tool gitlink in the same change. Missing or otherwise unusable comparison state still forces conservative execution rather than risking a false skip.

README-only or otherwise unrelated changes therefore require no CAD image pull and no CAD container.

## 2. SCAD execution plan

Only when the affected result requires SCAD work does the reusable workflow install the exact planner from the committed tool gitlink.

The planner validates visible Moon capabilities against `project.scad.yml` and derives one plan containing:

- source-affected capabilities;
- publication-safe materialization capabilities;
- runtime profile/image;
- build engine;
- normal SCons-cache applicability;
- Verification-SCons-cache applicability;
- which publication families changed.

For this template, the intended plan is based on these project facts:

```text
PythonSCAD configured
  -> full/dual docker.scad-toolchain v0.5.0

build_engine: scons
  -> normal SCons transport applicable

verification render targets configured
  -> separate Verification-SCons transport applicable
```

A direct-engine project does not transport SCons caches. An OpenSCAD-only project can select the focused runtime profile.

## 3. Affected capabilities versus materialization

Source impact and publication completeness are separate questions.

`scad.docs` and `scad.build` both contribute to the complete Build publication family. On a fresh runner, a docs-only change can therefore require:

```text
affected
  scad.docs

materialize locally
  scad.docs
  scad.build

publish
  Build
```

The unchanged `scad.build` result is normally hydrated from Moon. If no matching Moon cache entry exists, it can be reproduced. It remains non-affected; the extra work exists only because the generated Build branch is replaced as a complete tree.

Verification is a separate publication family, so Build completeness does not pull Verification into the materialization set.

This distinction remains visible in performance evidence: hydration or reproduction of an unchanged contributor is real correctness work and its cost counts.

## 4. At most one CAD runtime

If materialization is required, normal production acquires the capability-appropriate runtime and starts at most one Docker process.

Within that process, Moon executes or restores each required coarse capability:

```text
Moon scad.docs
  -> whole capability restored, or
  -> scad-project design-build
       -> SCons target reuse when configured

Moon scad.build
  -> whole capability restored, or
  -> scad-project build
       -> SCons target reuse when configured

Moon scad.verify
  -> whole capability restored, or
  -> scad-project verify
       -> verification SCons target reuse when configured
```

Moon cache identity contains stable source/tool/configuration state, not current GitHub run IDs, PR numbers or publication destinations.

## 5. Host finishing and durable timing evidence

After Moon execution or hydration, the CAD runtime exits. Current-run information is then added on the host.

For a changed Build family this includes the current Build index and `publication-info.txt`. For a changed Verification family it includes current Verification publication information. The resolved exact source SHA is carried into host finishing so publication provenance stays aligned with preflight, materialization and producer evidence even for pull requests where `GITHUB_SHA` is a synthetic merge revision.

The published orchestration evidence deliberately separates three time domains:

1. **producer execution** — when source-derived CAD output was actually produced;
2. **current materialization** — when Moon executed or hydrated that capability for this run;
3. **current workflow/snapshot preparation** — where the current production path spent time before the immutable generated-output snapshot was ready.

Released `tool.scad-project v0.14.8` retains the v0.14.6 durable coarse workflow-phase timing across preflight/planning, cache restore, runtime pull, capability materialization, cache save, host finishing and snapshot preparation, and adds exact host publication provenance. Each generated Build/Verification snapshot retains timing as `orchestration/timings.json`, and its README renders a compact timing table from the same data.

Per-capability `materialization.json` remains the detailed capability-level evidence. Raw Moon/producer logs stay directly linked under `orchestration/`. The remote generated-branch push happens only after a snapshot has been prepared, so that final publication phase is retained in compact CI orchestration evidence rather than written retrospectively into the already-prepared generated snapshot.

Keeping current run/ref/publication context outside Moon source identity allows source-derived capability output to be reused without publishing stale current-run metadata.

## 6. Retained evidence and publication

Normal production retains current orchestration evidence such as:

- affected decision and affected-task IDs;
- SCAD execution plan;
- coarse workflow phase timings;
- Moon invocation logs and materialization records;
- producer/domain decision evidence;
- run/snapshot timing context.

It does not also upload complete normal `bld/` and `vrf/out/` trees as duplicate Actions artifacts merely for retention. Those trees are already staged locally for generated-output publication.

Build and Verification publishers use isolated temporary Git repositories and may overlap on the same hosted runner. Publication therefore does not require another CAD runner or another CAD image/runtime.

Only output families with source-affected capabilities are published. Hydrating an unchanged Build contributor for completeness does not independently mark Verification as changed.

## 7. Release remains a separate lifecycle

The template release workflow is intentionally thin. It owns triggers, permissions and project-specific output paths, then calls:

```yaml
uses: brainboxemb/tool.scad-project/.github/workflows/project-release.yml@v0.14.8
```

The shared release workflow owns release-request parsing and validation, coordinated Build/Verify/finalization, immutable publication and release-request cleanup.

Coordinated release still has separate Build, Verify and finalization jobs. Complete Build/Verification artifacts are therefore required as exact-source cross-job hand-off. That is a real data-transfer use case and intentionally differs from normal same-job publication.

## Resource model

Normal production is designed around:

```text
hosted runners for CAD work:     1
maximum CAD runtime processes:   1
Moon affected queries:           1
runtime profile:                 capability/config driven
SCons cache transport:           only when configured/useful
normal full output artifacts:    0 duplicate copies
```

Evaluate both feedback latency and total runner time, image transfer, cache/artifact transfer and duplicated work. Prefer avoiding work or restoring it at the correct layer before adding more hosted parallelism.
