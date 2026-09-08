# Tube design

## Purpose

The tube is reference geometry used to demonstrate the fit between a project
assembly and the reusable clamp.

The production tube is modeled on local Z. The documentation view rotates a
shorter representative section so its length, outside diameter and bore are
easy to read.

<!-- scad-render-defaults
module: tube_design
vpr: [60, 0, 35]
-->

## Outer diameter

The first design view shows the solid outside diameter.

<!-- scad-render
view: outer
-->

## Bore

The second view highlights the inner bore removed from the outer solid.

<!-- scad-render
view: bore
-->

## Final tube

<!-- scad-render
view: final
-->

## Wall-thickness illustration

This is a documentation-only diagram rather than reusable project geometry, so
an inline illustration is appropriate.

<!-- scad-render
type: inline
view: wall-thickness
vpr: [55, 0, 35]
-->

```openscad
linear_extrude(height=2)
difference() {
    circle(d=20);
    circle(d=16);
}
```
