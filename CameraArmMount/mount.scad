include <BOSL2/std.scad>
use <noyau/utils.scad>

// Frame model from Prusa web site.
module frame() {
  metal() down(359.9) xrot(90) import("../Models/MK3_frame.stl");
}

// Just keep the part where the rest of the arm attaches
module head() {
  difference() {
    left(9) import("2020_std_ribbonSlot.STL");
    fwd(2) down(2) cuboid([10,42,25], anchor = RIGHT+DOWN+FRONT);
  }
}

// To get the proper sizes, use the corner of the frame as template. I had to
// fudge things a bit to make the holes a little larger. 
module link() {
  difference() {
    xrot(-90) linear_extrude(5) projection() xrot(90) back(6) intersection () {
      frame();
      cuboid([40,8,20.19], anchor = LEFT+BACK, rounding = 3, edges = BOTTOM);
    }
    xcopies(spacing=20, n=2, l=20, sp=10) cyl(d=3.5, h=12, orient= BACK, $fn=20);
  }
}

difference() {
  union() {
    link();
    down(10) right(40) zrot(90) head();
  }
  right(11.5) cuboid([17,1.2,20.19], anchor = LEFT+FRONT);
}