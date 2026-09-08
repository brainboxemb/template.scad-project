# Tube holder design

## Purpose

This component demonstrates how a normal project consumes an external reusable OpenSCAD library.

The clamp geometry comes from:

```text
dsg/ext/lib.scad.clamps
```

## External API

Only the public object-based clamp API is used:

```scad
clamp = tube_clamp_create(tube_diameter = 20);
tube_clamp_build(clamp);
```

No library source is copied and no scalar compatibility bridge is introduced.

## Design views

### 01 — Library clamp
![Library clamp](img/01-library-clamp.png)

### 02 — Final component
![Final tube holder](img/02-final.png)
