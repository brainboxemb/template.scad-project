// File: mounting_plate_thickness_check.scad
// Verification-only view of the reference mounting plate thickness.

use <../../dsg/openscad/components/mounting-plate/mounting_plate.scad>

$fn = 48;

// Keep a narrow center strip so the Z thickness is easy to inspect.
color([0.85, 0.12, 0.12])
    intersection() {
        mounting_plate();
        translate([-70, -7, -1])
            cube([140, 14, mounting_plate_thickness() + 2]);
    }

// Separate reference gauge with exactly the configured plate thickness.
color([0.75, 0.75, 0.75, 0.55])
    translate([66, -7, 0])
        cube([10, 14, mounting_plate_thickness()]);
