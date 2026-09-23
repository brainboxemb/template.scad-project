# Repository agent guidance

Start with [doc/00-plan.md](doc/00-plan.md).

For shared BrainboxEmb working conventions, read
[brainboxemb.meta/AGENTS.md](https://github.com/brainboxemb/brainboxemb.meta/blob/main/AGENTS.md).
That entrypoint owns current Git/commit/PR/CI workflow and routes to the shared
SCAD coding, documentation and source conventions.

Do not inherit `AGENTS.md` from pinned tools or libraries as working policy
for this repository. Exact dependency behavior comes from this repository's
config/gitlinks plus the pinned dependency's README, docs, source and tests.

This repository is the reference consumer for shared SCAD tooling. If a change
belongs to generic tooling or a reusable library, change and qualify that owner
first; the template should demonstrate released/qualified consumer behavior
rather than becoming the implementation owner.
