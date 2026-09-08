MOUNTING_PLATE_WIDTH = 120;
MOUNTING_PLATE_HEIGHT = 70;
MOUNTING_PLATE_THICKNESS = 6;

module mounting_plate(
    width = MOUNTING_PLATE_WIDTH,
    height = MOUNTING_PLATE_HEIGHT,
    thickness = MOUNTING_PLATE_THICKNESS
) {
    translate([-width / 2, -height / 2, 0])
        cube([width, height, thickness]);
}

module mounting_plate_design(view = "final") {
    if (view == "base")
        color([1, 0, 0, 0.55]) mounting_plate();
    else
        mounting_plate();
}
