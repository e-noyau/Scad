include <BOSL2/std.scad>
use <noyau/utils.scad>

WIDTH=53;
HEIGHT=25;
LENGTH=80;
WALL=2;
ROUNDING=6;
FUDGE=.01;

module base() {
  difference() {
    cuboid([WIDTH + WALL * 2, HEIGHT + WALL * 2, LENGTH + WALL * 2], 
           anchor=BOTTOM, rounding=ROUNDING);
    up(WALL) cuboid([WIDTH, HEIGHT, LENGTH+FUDGE],
                    anchor=BOTTOM, rounding = ROUNDING, edges=edges("ALL", except=TOP));
    up(LENGTH + WALL - FUDGE) cuboid([WIDTH + WALL * 2, HEIGHT + WALL * 2, WALL*2], anchor=BOTTOM);
  }
}

// difference() {
//   base();
//   down(FUDGE) cuboid([WIDTH * 2, HEIGHT * 2, LENGTH / 1.1], anchor=BOTTOM);
//
// }
base();