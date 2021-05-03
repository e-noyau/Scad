include <BOSL2/std.scad>
use <noyau/utils.scad>

LENGTH = 90.4;
WIDTH = 24.37;
DEPTH = 4;
$fn=100;


difference() {
  intersection() {
    cuboid([LENGTH, WIDTH, DEPTH], rounding = 2, edges="Z");
    up(DEPTH)
      cuboid([LENGTH, WIDTH ,DEPTH*3], chamfer=DEPTH/2 , except_edges="Z");
  }
  right(LENGTH/4) down((DEPTH+1)/2) 
    linear_extrude(DEPTH + 1, scale = 1.4)
      right(1.55) text("♥︎", size = 21, spacing=1.2,
           halign = "center",
           valign="center",
           font = "Liberation Sans:style=Bold");
 
}

