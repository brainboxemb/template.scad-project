// File: tube_holder_bore_check.scad
// Verification-only view of the configured tube holder and nominal tube bore.

use <../../dsg/openscad/components/tube-holder/tube_holder.scad>

$fn = 72;

color([0.85, 0.12, 0.12])
    tube_holder_mounted();

// Reference tube through the configured horizontal bore.
color([0.75, 0.75, 0.75, 0.45])
    translate([0, 0, tube_holder_axis_height()])
        rotate([0, 90, 0])
            cylinder(d = 20, h = 70, center = true);
