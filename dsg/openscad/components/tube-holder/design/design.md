# Tube holder design

## Purpose

This component demonstrates consumption of an external reusable OpenSCAD
library without copying or wrapping its implementation.

The public library API is used directly:

```scad
clamp = tube_clamp_create(
    tube_diameter = 20
);

tube_clamp_build(clamp);
```

## Library clamp

<!-- scad-design
type: source-view
module: tube_holder_design
view: library-clamp
image: 01-library-clamp.png
vpr: [70, 0, 35]
-->

## Final component

<!-- scad-design
type: source-view
module: tube_holder_design
view: final
image: 02-final.png
vpr: [70, 0, 35]
-->
