# Mounting plate design

## Purpose

The mounting plate is a deliberately simple project-specific component used as the base for the library-backed tube holder.

## Parameters

```text
width      120 mm
height      70 mm
thickness    6 mm
```

## Coordinate system

The plate is centered in X/Y with its bottom face at Z=0.

## Geometry

```scad
translate([-width / 2, -height / 2, 0])
    cube([width, height, thickness]);
```

## Design views

### 01 — Base plate

![Base plate](img/01-base-plate.png)

### 02 — Final

![Final mounting plate](img/02-final.png)
