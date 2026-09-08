// File: tube_holder_assembly.scad
//   Reference assembly combining project and library geometry.
//
// FileSummary: Mounting plate, reusable clamp and reference tube.

use <../../components/mounting-plate/mounting_plate.scad>
use <../../components/tube/tube.scad>
use <../../components/tube-holder/tube_holder.scad>

// Module: tube_holder_assembly()
// Usage:
//   tube_holder_assembly();
// Description:
//   Builds the reference assembly.
// Arguments:
//   show_tube = Whether the reference tube is included.
module tube_holder_assembly(show_tube = true) {
    color([0.78, 0.70, 0.55])
        mounting_plate();

    translate([0, 0, MOUNTING_PLATE_THICKNESS])
        color([0.82, 0.15, 0.12])
            tube_holder();

    if (show_tube)
        translate([0, 0, MOUNTING_PLATE_THICKNESS + 14])
            rotate([90, 0, 0])
                color([0.65, 0.65, 0.68, 0.65])
                    tube();
}

// Module: tube_holder_assembly_design()
// Usage:
//   tube_holder_assembly_design("plate");
//   tube_holder_assembly_design("clamp");
//   tube_holder_assembly_design("tube");
//   tube_holder_assembly_design("final");
// Description:
//   Progressive documentation views of the reference assembly.
// Arguments:
//   view = Named design-documentation view.
module tube_holder_assembly_design(view = "final") {
    if (view == "plate") {
        color([1, 0, 0, 0.55])
            mounting_plate();
    } else if (view == "clamp") {
        color([0.75, 0.75, 0.75, 0.4])
            mounting_plate();

        translate([0, 0, MOUNTING_PLATE_THICKNESS])
            color([1, 0, 0, 0.55])
                tube_holder();
    } else if (view == "tube") {
        color([0.75, 0.75, 0.75, 0.4])
            tube_holder_assembly(show_tube = false);

        translate([0, 0, MOUNTING_PLATE_THICKNESS + 14])
            rotate([90, 0, 0])
                color([1, 0, 0, 0.55])
                    tube();
    } else {
        tube_holder_assembly();
    }
}
