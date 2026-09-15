// File: tube-holder-assembly.scad
//   Stable CI/build entrypoint for the reference assembly.
//   Migration 004 Step 4 build-side-only affected-state proof marker.

use <../assemblies/tube-holder-assembly/tube_holder_assembly.scad>

$fn = 120;

tube_holder_assembly();
