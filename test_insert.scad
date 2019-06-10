

use <gps_790_insert.scad>
use <noyau_utils.scad>

rotate([180, 0, 0]) difference() {
  union() {
    shape_with_holes(back_hole = false, amps_inserts = false);
    translate([-24, -25, .2]) cube([48,50,5]);
  }
  translate([-40, -40, 1]) cube([80,80,80]);
  //cube([37,15,35], center = true);
}
