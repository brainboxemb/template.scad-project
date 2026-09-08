# Tube design

## Purpose

The tube is reference geometry used to demonstrate the fit between a project
assembly and the reusable clamp.

It is modeled on its local Z axis and rotated by the assembly.

## Outer diameter

The first design view shows the solid outside diameter.

<!-- scad-design
type: source-view
module: tube_design
view: outer
image: 01-outer.png
vpr: [70, 0, 35]
-->

## Bore

The second view highlights the inner bore removed from the outer solid.

<!-- scad-design
type: source-view
module: tube_design
view: bore
image: 02-bore.png
vpr: [70, 0, 35]
-->

## Final tube

<!-- scad-design
type: source-view
module: tube_design
view: final
image: 03-final.png
vpr: [70, 0, 35]
-->

## Wall-thickness illustration

This is a documentation-only diagram rather than reusable project geometry, so
an inline illustration is appropriate.

<!-- scad-design
type: inline
image: 04-wall-thickness-illustration.png
size: [900, 600]
vpr: [0, 0, 0]
-->

```openscad
linear_extrude(height=2)
difference() {
    circle(d=20);
    circle(d=16);
}
```
