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

module tube_design(view = "final") {
    if (view == "outer") {
        color([1, 0, 0, 0.55]) cylinder(d = TUBE_OUTER_DIAMETER, h = TUBE_LENGTH, center = true);
    } else if (view == "bore") {
        color([0.75, 0.75, 0.75, 0.40]) cylinder(d = TUBE_OUTER_DIAMETER, h = TUBE_LENGTH, center = true);
        color([1, 0, 0, 0.55]) cylinder(d = TUBE_OUTER_DIAMETER - 2 * TUBE_WALL_THICKNESS, h = TUBE_LENGTH + 0.2, center = true);
    } else {
        tube();
    }
}
