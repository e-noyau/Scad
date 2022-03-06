include <BOSL2/std.scad>
use <noyau/utils.scad>

DEPTH = 15;
SCREW_DIA = 4;

module screw_hole(flare, depth) {
  cyl(h=depth * 2, d = SCREW_DIA, circum = true, orient = UP, anchor = UP+DOWN, $fn=10);
  if (flare)
    up(depth/2) zcyl(depth/2+.1, d1=SCREW_DIA, d2=9, anchor = DOWN, $fn=20);
}


xrot(180)


difference() {
  cuboid([105,38,DEPTH], anchor=DOWN);
  up(.1) mirrored([1,0,0]) mirrored([0,1,0]) fwd(11) left(27.5) screw_hole(false, DEPTH);
  down(.1) mirrored([1,0,0]) mirrored([0,1,0]) fwd(11) left(27.5) 
      #cyl(h=DEPTH/3, d = 10, circum = true, orient = UP, anchor = DOWN, $fn=10);

}
