// File: tube_holder.scad
//   Project adapter that consumes lib.scad.clamps.
//
// FileSummary: Reusable library clamp as a project component.
// Verification cache probe: comment-only source change; geometry is unchanged.

use <../../ext/lib.scad.clamps/openscad/tube-clamp/tube_clamp.scad>

TUBE_HOLDER_TUBE_DIAMETER = 20;

// The current basic clamp is modeled with its tube bore along local Z and its
// flat mounting face at local X=0.  The project assembly rotates that geometry
// so the mounting face lies on the horizontal plate and the tube runs along X.
// Keep the resulting axis height in this adapter rather than scattering a
// geometry-specific magic number through the assembly.
TUBE_HOLDER_AXIS_HEIGHT = 16;

// Function: tube_holder_axis_height()
// Usage:
//   z = tube_holder_axis_height();
// Description:
//   Returns the tube-axis height above the holder's mounting surface for the
//   configured clamp used by this reference project.
function tube_holder_axis_height() = TUBE_HOLDER_AXIS_HEIGHT;

// Module: tube_holder()
// Usage:
//   tube_holder();
// Description:
//   Creates the configured reusable tube clamp in library-native orientation.
module tube_holder() {
    clamp = tube_clamp_create(
        tube_diameter = TUBE_HOLDER_TUBE_DIAMETER
    );

    tube_clamp_build(clamp);
}

// Module: tube_holder_mounted()
// Usage:
//   tube_holder_mounted();
// Description:
//   Rotates the library-native clamp so its flat back sits on an XY mounting
//   surface and its tube bore runs horizontally along X.
module tube_holder_mounted() {
    rotate([0, -90, 0])
        tube_holder();
}

// Module: tube_holder_design()
// Usage:
//   tube_holder_design("library-clamp");
//   tube_holder_design("mounted");
//   tube_holder_design("final");
// Description:
//   Documentation-oriented views of the consumed library clamp.
// Arguments:
//   view = Named design-documentation view.
module tube_holder_design(view = "final") {
    if (view == "library-clamp")
        color([1, 0, 0, 0.55]) tube_holder();
    else if (view == "mounted")
        color([1, 0, 0, 0.55]) tube_holder_mounted();
    else
        tube_holder_mounted();
}
