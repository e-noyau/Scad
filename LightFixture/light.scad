include <BOSL2/std.scad>
use <noyau/utils.scad>

use <../790/GPSSupportInserts/GPS_790_insert.scad>

// Support for the light fixture in the bathroom in Paris, to be able to glue it to the tiles rather
// than drilling…

LENGTH = 70;
WIDTH = 48;
DEPTH = 3;

SCREW_DEPTH = 20;


insert_radius = 5.9 / 2;
insert_depth = 6;


difference() {
  union() {
    left(LENGTH/2) cuboid([LENGTH, WIDTH, DEPTH], rounding = 6, edges = edges("Z"),
                          anchor = BOTTOM);
    left(insert_depth/2) cuboid([insert_depth,WIDTH,19], anchor=BOTTOM);
  }

  up(11) yrot(90) up(.1) insert_holes(insert_depth, insert_radius);
}
