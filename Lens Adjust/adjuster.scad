include <BOSL2/std.scad>
use <noyau/utils.scad>

// The original screwdriver used to capture the right sizes is xoming from 
// https://www.thingiverse.com/thing:4063479
module empreinte(height = 4) {
  linear_extrude(height)
    projection(cut = true)
      down(168) import("screwdriver_focus_adjustment_tool_v0_1_0.stl", center = true);
}


module nut() {
  handle_dia = 15;
  handle_height = .90;

  difference () {
    cyl(d = handle_dia, h = handle_height, anchor = UP);
    cyl(d = 7, h = handle_height * 3);
    zrot_copies(n=24) back(handle_dia/2) cyl(h = handle_height * 3, d = 1.5, $fn=12);
  };
  down(handle_height) empreinte(height = handle_height + 6);
}


nut();