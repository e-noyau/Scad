include <BOSL2/std.scad>
use <noyau/utils.scad>

// Derived from https://www.thingiverse.com/thing:4128205
module knob() {
    back(265) right(932.7) import("Prusa_Enclosure_Door_Knob_NOGLUE_FrontR__3mm.stl");
}

module original_wall() {
  intersection () {
    knob();
    fwd(7) up(3) cuboid([35, 10, 10], anchor = LEFT + BACK + BOTTOM);
  }
}


module new_knob() {
  difference() {
    knob();
    original_wall();
  };
  fwd(.1) original_wall();
  difference () {
    right(.025) up(3) fwd(10) cyl(l=30, r=2.3, orient = LEFT, anchor=UP, $fn=20);
    up(6) fwd(12.8) cyl(l=30, r=3, orient = LEFT, anchor=UP, $fn=20);
    right(34.6) yrot(57) cuboid([25,50,3], anchor=UP + RIGHT + BACK);
  }
}

//new_knob();
mirror_copy([1,0,0]) left(2) yrot(-90) new_knob();

