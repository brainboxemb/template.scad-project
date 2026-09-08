// File: tube_holder_assembly.scad
//   Reference assembly combining project and library geometry.
//
// FileSummary: Mounting plate, reusable clamp and reference tube.

use <../../components/mounting-plate/mounting_plate.scad>
use <../../components/tube/tube.scad>
use <../../components/tube-holder/tube_holder.scad>

// Module: assembly_reference_tube()
// Usage:
//   assembly_reference_tube();
// Description:
//   Places the locally Z-oriented reference tube on the mounted holder axis.
module assembly_reference_tube() {
    translate([0, 0, mounting_plate_thickness() + tube_holder_axis_height()])
        rotate([0, -90, 0])
            tube();
}

// Module: assembly_mounted_holder()
// Usage:
//   assembly_mounted_holder();
// Description:
//   Seats the holder's mounting face directly on top of the plate.
module assembly_mounted_holder() {
    translate([0, 0, mounting_plate_thickness()])
        tube_holder_mounted();
}

// Module: tube_holder_assembly()
// Usage:
//   tube_holder_assembly();
// Description:
//   Builds the reference assembly with one consistent horizontal tube axis.
// Arguments:
//   show_tube = Whether the reference tube is included.
module tube_holder_assembly(show_tube = true) {
    color([0.78, 0.70, 0.55])
        mounting_plate();

    color([0.82, 0.15, 0.12])
        assembly_mounted_holder();

    if (show_tube)
        color([0.65, 0.65, 0.68, 0.65])
            assembly_reference_tube();
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

        color([1, 0, 0, 0.55])
            assembly_mounted_holder();
    } else if (view == "tube") {
        color([0.75, 0.75, 0.75, 0.4])
            tube_holder_assembly(show_tube = false);

        color([1, 0, 0, 0.55])
            assembly_reference_tube();
    } else {
        tube_holder_assembly();
    }
}
