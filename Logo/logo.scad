include <BOSL2/std.scad>
use <noyau/utils.scad>


$fa=.1;
$fs=.5;


larger_d = 130;  // Overall diameter of the logo
inner_d = 50;    // Diameter of the center puck
center_d = 64;   // Space left in the center for the puck

empty = (center_d - inner_d) / 2;  // This is the stroke for the logo, makes
                                   //  for the channel dimensions.

//empty = 10;
echo(empty);

module wing2d(inset=empty) {

  module outside_wing() {
    difference () {
      // Let's make a doughnut.
      circle(d=larger_d);
      circle(d=center_d);
      // cut it in three sections.
      zrot_copies(n=3) 
        right(inner_d/2) 
        fwd(larger_d/2) 
        square([(center_d - inner_d) /2, larger_d/2]);
      // And remove two sections away.
      difference() {
        square(larger_d, center=true);
        square(larger_d/2);
        right(center_d/2) 
          fwd(larger_d/2)
          square([larger_d/2-center_d/2, larger_d/2]);
      }
      back(larger_d/2 +1.3)
      rot(30)
      square(larger_d/2, center=true);
    }
  }

  // Round all those accute angles.
  module rounded_wing() {
    minkowski() {
      outside_wing();
      circle(inset/4);
    }
  }

  difference() {
    rounded_wing();
    offset(-inset/2) rounded_wing();
  }

}

module middle2d() {
  difference() {
    circle(d=inner_d);
    circle(d=inner_d - empty);
  }
}

module logo2d() {
  zrot_copies(n=3)
    wing2d();
  middle2d();
}

module ushapeFrom2D(base_height = 1, height = 5, wall_width = 1) {
  linear_extrude(height=base_height) children();
  linear_extrude(height=height)
    difference() {
      offset(delta = wall_width) children();
      children();
    }
}

ushapeFrom2D(wall_width = .4) logo2d();

