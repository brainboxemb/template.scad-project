// File: tube_holder.scad
//   Project adapter that consumes lib.scad.clamps.
//
// FileSummary: Reusable library clamp as a project component.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

TUBE_HOLDER_TUBE_DIAMETER = 20;

// Module: tube_holder()
// Usage:
//   tube_holder();
// Description:
//   Creates the configured reusable tube clamp.
module tube_holder() {
    clamp = tube_clamp_create(
        tube_diameter = TUBE_HOLDER_TUBE_DIAMETER
    );

    tube_clamp_build(clamp);
}

// Module: tube_holder_design()
// Usage:
//   tube_holder_design("library-clamp");
//   tube_holder_design("final");
// Description:
//   Documentation-oriented views of the consumed library clamp.
// Arguments:
//   view = Named design-documentation view.
module tube_holder_design(view = "final") {
    if (view == "library-clamp")
        color([1, 0, 0, 0.55]) tube_holder();
    else
        tube_holder();
}
