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

through `workspace.inheritedTasks.include` and adds the template-specific impact inputs for those capabilities. `.moon/workspace.yml` remains limited to Moon workspace/project registration and other workspace-level settings.

`.moon/tasks/scad.yml` inherits the shared definitions from the exact pinned `tool.scad-project` gitlink.

There are no consumer-authored `scad.production-impact`, `scad.ci`, build-index or provenance tasks. Those were lifecycle mechanics, not project capabilities.

## 1. Exact source-impact decision on the host

Normal CI first resolves the exact source revision and comparison base and invokes the released `tool.git-project v0.2.8` affected action once.

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

The generic action currently uses `consumer:scad.docs` as an existing query anchor. The complete affected-task list is repository-wide and is not restricted to that anchor.

If comparison state cannot be established safely, the query returns a conservative decision rather than risking a false skip.

README-only or otherwise unrelated changes therefore require no CAD image pull and no CAD container.

## 2. SCAD execution plan

Only when the affected result requires SCAD work does the reusable workflow install the exact pinned `tool.scad-project` planner.

The planner validates the visible Moon capabilities against `project.scad.yml` and derives one plan containing:

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

A direct-engine project would not transport SCons caches. An OpenSCAD-only project can select the focused runtime profile.

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

This distinction must remain visible in performance evidence: hydration/reproduction of an unchanged contributor is real correctness work and its cost counts.

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

## 5. Host finishing

After Moon execution/hydration, the CAD runtime exits. Current-run information is then added on the host.

For a changed Build family this includes the current Build index and `publication-info.txt`. For a changed Verification family it includes current Verification publication information.

Keeping current run/ref/publication context outside Moon source identity allows source-derived capability output to be reused without publishing stale current-run metadata.

## 6. Retained evidence and publication

Normal production retains compact evidence such as:

- affected decision;
- affected-task IDs;
- SCAD execution plan;
- Moon materialization records;
- last domain build/verification decision summaries.

It does not also upload complete normal `bld/` and `vrf/out/` trees as Actions artifacts merely for retention. Those trees are already staged locally for generated-output publication.

Build and Verification publishers use isolated temporary Git repositories and may overlap on the same hosted runner. Publication therefore does not require another CAD runner or another CAD image/runtime.

Only output families with source-affected capabilities are published. Hydrating an unchanged Build contributor for completeness does not independently mark Verification as changed.

## 7. Release remains a separate lifecycle

Coordinated release has separate Build, Verify and finalization jobs. Complete Build/Verification artifacts are therefore still required as exact-source cross-job hand-off.

That is a real data-transfer use case and is intentionally different from normal same-job publication.

The template Release caller is pinned to the same exact `tool.scad-project` source as the normal Production caller and the `tools/tool.scad-project` gitlink.

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

Evaluate both:

- feedback latency;
- total runner time, image transfer, cache/artifact transfer and duplicated work.

Prefer avoiding work or restoring it at the right layer before adding more hosted parallelism.
