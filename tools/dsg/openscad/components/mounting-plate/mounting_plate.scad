// File: mounting_plate.scad
//   Project-specific mounting plate used by the reference assembly.
//
// FileSummary: Simple rectangular mounting surface.
//
// Module: mounting_plate()
// Usage:
//   mounting_plate();
// Description:
//   Creates the mounting plate centered in X/Y with its base at Z=0.
// Arguments:
//   width = Overall X dimension.
//   height = Overall Y dimension.
//   thickness = Plate thickness.
MOUNTING_PLATE_WIDTH = 120;
MOUNTING_PLATE_HEIGHT = 70;
MOUNTING_PLATE_THICKNESS = 6;


// Function: mounting_plate_thickness()
// Usage:
//   thickness = mounting_plate_thickness();
// Description:
//   Returns the default mounting plate thickness for consumers that import
//   this file with `use`.
function mounting_plate_thickness() = MOUNTING_PLATE_THICKNESS;

module mounting_plate(
    width = MOUNTING_PLATE_WIDTH,
    height = MOUNTING_PLATE_HEIGHT,
    thickness = MOUNTING_PLATE_THICKNESS
) {
    translate([-width / 2, -height / 2, 0])
        cube([width, height, thickness]);
}

// Module: mounting_plate_design()
// Usage:
//   mounting_plate_design("base");
//   mounting_plate_design("final");
// Description:
//   Documentation-oriented views for the mounting plate.
// Arguments:
//   view = Named design-documentation view.
module mounting_plate_design(view = "final") {
    if (view == "base")
        color([1, 0, 0, 0.55]) mounting_plate();
    else
        mounting_plate();
}
