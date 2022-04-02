include <BOSL2/std.scad>
use <noyau/utils.scad>

// A simple bicycle holder that will hold a bike along a wall. Finicky, as it has to be at the 
// right height for the size of the tire (when the bike is horizontal) or completely dependent on
// the size of the bike (for vertical storage). I could not find a model that would fit my bike so
// I made my own instead of buying the clug™.

tire_dia = 67;  // For a MTB fat tire, 26""
outside_dia = tire_dia*1.14; // With a .6 nozzle, makes it a perfect 6 lines.

module support2d($fn=300) {
  // The main clip, to hold the tire
  difference() {
    circle(d=outside_dia);
    circle(d=tire_dia);
    back(tire_dia/2) circle(r=tire_dia/2, $fn=4);;
  }
  // Finishing circle at the end of the clip
  back(26.2) mirror_copy([1,0,0]) translate([tire_dia/2 - 6.68, 0, 0]) circle(4);
  // Flat support for the wall
  difference() { 
    fwd(tire_dia/2) square([60, 20], center=true);
    circle(d=tire_dia);
  }
}

module bikestand() {
  difference() {
    height = 25;
      // Body of the support
      down(height/2) linear_extrude(height = height) support2d();
      // Screw hole
      mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=7, h=50, $fn=100, anchor = DOWN);
      //  Space for screw head
      mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=10, h=35, $fn=100, anchor = DOWN);
  }
}

bikestand();