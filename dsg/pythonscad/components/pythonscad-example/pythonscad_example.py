"""Small PythonSCAD component used to verify multi-engine design rendering."""

from pythonscad import *

design_view = globals().get("design_view", "final")

if design_view == "block":
    show(cube([24, 16, 8]))
elif design_view == "bore":
    outer = cylinder(h=12, d=24, fn=72)
    inner = cylinder(h=14, d=12, fn=72).translate([0, 0, -1])
    show(outer - inner)
else:
    model = cylinder(h=12, d=24, fn=72) - cylinder(
        h=14,
        d=12,
        fn=72,
    ).translate([0, 0, -1])
    show(model)
