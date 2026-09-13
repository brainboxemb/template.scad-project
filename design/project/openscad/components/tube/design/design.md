# Tube design

## Purpose

The tube is reference geometry used to demonstrate the fit between a project
assembly and the reusable clamp.

The production tube is modeled on local Z. The documentation view rotates a
shorter representative section so its length, outside diameter and bore are
easy to read.



## Outer diameter

The first design view shows the solid outside diameter.

![Outer](img/01-outer.png)

## Bore

The second view highlights the inner bore removed from the outer solid.

![Bore](img/02-bore.png)

## Final tube

![Final](img/03-final.png)

## Wall-thickness illustration

This is a documentation-only diagram rather than reusable project geometry, so
an inline illustration is appropriate.

![Wall Thickness](img/04-wall-thickness.png)

```openscad
linear_extrude(height=2)
difference() {
    circle(d=20);
    circle(d=16);
}
```
