

use <gps_790_insert.scad>
use <noyau_utils.scad>

rotate([180, 0, 0]) difference() {
  shape_with_holes(back_hole = false, amps_inserts = false);
  translate([-40, -40, .3]) cube([80,80,80]);
  //cube([37,15,35], center = true);
}
