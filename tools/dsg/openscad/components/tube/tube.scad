// File: tube.scad
//   Reference tube for demonstrating the reusable clamp.
//
// FileSummary: Hollow 20 mm reference tube.
//
// Module: tube()
// Usage:
//   tube();
// Description:
//   Creates a hollow tube along the local Z axis.
// Arguments:
//   outer_diameter = Outside tube diameter.
//   wall_thickness = Tube wall thickness.
//   length = Tube length.
TUBE_OUTER_DIAMETER = 20;
TUBE_WALL_THICKNESS = 2;
TUBE_LENGTH = 100;

module tube(
    outer_diameter = TUBE_OUTER_DIAMETER,
    wall_thickness = TUBE_WALL_THICKNESS,
    length = TUBE_LENGTH
) {
    inner_diameter = outer_diameter - 2 * wall_thickness;

    difference() {
        cylinder(d = outer_diameter, h = length, center = true);
        cylinder(d = inner_diameter, h = length + 0.2, center = true);
    }
}

// Module: tube_design()
// Usage:
//   tube_design("outer");
//   tube_design("bore");
//   tube_design("final");
// Description:
//   Documentation-oriented construction views. A shorter tube section is
//   rotated onto X so length and circular cross-section remain visible.
// Arguments:
//   view = Named design-documentation view.
module tube_design(view = "final") {
    design_length = 60;

    rotate([0, 90, 0]) {
        if (view == "outer") {
            color([1, 0, 0, 0.55])
                cylinder(
                    d = TUBE_OUTER_DIAMETER,
                    h = design_length,
                    center = true
                );
        } else if (view == "bore") {
            color([0.75, 0.75, 0.75, 0.4])
                cylinder(
                    d = TUBE_OUTER_DIAMETER,
                    h = design_length,
                    center = true
                );

            color([1, 0, 0, 0.55])
                cylinder(
                    d = TUBE_OUTER_DIAMETER - 2 * TUBE_WALL_THICKNESS,
                    h = design_length + 0.2,
                    center = true
                );
        } else {
            tube(length = design_length);
        }
    }
}
