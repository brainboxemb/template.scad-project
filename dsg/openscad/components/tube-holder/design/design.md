# Tube holder design

## Purpose

This component demonstrates consumption of an external reusable OpenSCAD
library without copying its implementation.

The public library API is used directly:

```scad
clamp = tube_clamp_create(
    tube_diameter = 20
);

tube_clamp_build(clamp);
```

## Library-native clamp

The library models the bore on local Z and the flat mounting face at local X=0.

<!-- scad-design
type: source-view
module: tube_holder_design
view: library-clamp
image: 01-library-clamp.png
size: [1400, 900]
vpr: [70, 0, 35]
-->

## Mounted orientation

The project adapter rotates the reusable geometry so the flat face can sit on a
horizontal mounting plate and the tube axis runs horizontally along X.

<!-- scad-design
type: source-view
module: tube_holder_design
view: mounted
image: 02-mounted.png
size: [1400, 900]
vpr: [70, 0, 35]
-->

## Final component

<!-- scad-design
type: source-view
module: tube_holder_design
view: final
image: 03-final.png
size: [1400, 900]
vpr: [70, 0, 35]
-->
