include <BOSL2/std.scad>
use <noyau/utils.scad>

// A simple bicycle holder that will hold a bike along a wall. Finicky to install , as it has to be
// at the right height for the size of the tire (when the bike is horizontal) or completely 
// dependent on the size of the bike (for vertical storage). I could not find an existing STL model
// that would fit my bike so I made my own instead of buying the clug™.

tire_dia = 67;  // For a MTB fat tire, 2.6"
bubble = 10;
opening_angle = 95;


outside_dia = tire_dia*1.14; // With a .6 nozzle, makes it a perfect 6 lines.

module pieSlice_2d(angle, radius){
  projection() rotate_extrude(angle=angle) square(radius);
}

module support2d($fn=300) {
  // The main clip, to hold the tire
  difference() {
    union() {
      circle(d=outside_dia);
      mirror_copy([1,0,0]) hull() {
        $fn=50;
        smallr = (outside_dia - tire_dia)/4  / 2 ;
        larger = bubble/3*2;
        zrot(8) left(tire_dia/2 + smallr * 3) circle(r = smallr);
        left(bubble-larger) zrot(opening_angle/2) back(tire_dia/2 + bubble) circle(r = larger);
      }
      // #back(outside_dia/4)
      //     square([outside_dia, outside_dia/2], center=true);
    }
    circle(d=tire_dia);
    zrot(-((opening_angle/2) - 90)) 
        pieSlice_2d(opening_angle,outside_dia);
    //#back(tire_dia/2) circle(r=tire_dia/2, $fn=4);;
  }
  // Finishing circle at the end of the clip
  mirror_copy([1,0,0]) zrot((360-opening_angle)/2) fwd(tire_dia/2 + bubble) circle(bubble);
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
//support2d();

