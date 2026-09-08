# Verification

This template verifies both normal project output and external-library integration.

## Checks

1. `lib.scad.clamps` is initialized as a submodule.
2. The public object-based clamp API is consumable.
3. The complete assembly renders to PNG.
4. The complete assembly exports to STL.
5. Design-image entrypoints render successfully.
6. Generated verification evidence remains off `main`.

## Branch policy

- `verification`: mutable latest orphan snapshot.
- `verification/vX.Y.Z`: immutable orphan snapshot for release tag `vX.Y.Z`.

A versioned verification branch must never be overwritten.
