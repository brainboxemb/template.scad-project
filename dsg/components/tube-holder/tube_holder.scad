use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

TUBE_HOLDER_TUBE_DIAMETER = 20;

module tube_holder() {
    clamp = tube_clamp_create(tube_diameter = TUBE_HOLDER_TUBE_DIAMETER);
    tube_clamp_build(clamp);
}

module tube_holder_design(view = "final") {
    if (view == "library-clamp")
        color([1, 0, 0, 0.55]) tube_holder();
    else
        tube_holder();
}
