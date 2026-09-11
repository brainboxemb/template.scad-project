# Verification

Verification source is intentionally separate from normal build output.

```text
vrf/
├── openscad/     verification-only OpenSCAD entrypoints
├── templates/    source templates for generated verification documentation
└── out/          generated verification snapshot (CI/local output)
```

`tool.scad-project` owns dependency-aware rendering and its separate verification cache. A normal `bld/` PNG/STL is not copied into `vrf/out`; verification evidence should exist only when it adds a distinct check.

Project-specific policy checks remain in `scripts/run-verification.sh` and run after the verification geometry targets are current.
