# Tube design

## Purpose

The tube is a simple reference/component used to demonstrate the fit with the external clamp.

## Parameters

```text
outer diameter   20 mm
wall thickness    2 mm
length          100 mm
```

## Orientation

The source component is modeled along the Z axis. The assembly rotates it into its installed orientation.

## Geometry

```scad
difference() {
    cylinder(d = outer_diameter, h = length, center = true);
    cylinder(d = inner_diameter, h = length + 0.2, center = true);
}
```

## Design views

### 01 — Outer cylinder
![Outer cylinder](img/01-outer.png)

### 02 — Bore
![Tube bore](img/02-bore.png)

### 03 — Final
![Final tube](img/03-final.png)
