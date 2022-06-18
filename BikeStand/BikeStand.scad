include <BOSL2/std.scad>
use <noyau/utils.scad>

// A simple bicycle holder that will hold a bike along a wall. Finicky to install, as it has to be
// at the right height for the size of the tire (when the bike is horizontal) or completely 
// dependent on the size of the bike (for vertical storage). I could not find an existing STL model
// that would fit my bike so I made my own instead of buying the clug™.


//previous: 67/10/95

TIRE_DIA = 67;  // For a MTB fat tire, 2.6"
BUBBLE = 12; // size of the hole and hook.
OPENING_ANGLE = 93; 

// outside_dia = tire_dia * 1.14; // With a .6 nozzle, makes it a perfect 6 lines.
OUTSIDE_DIA = TIRE_DIA + BUBBLE;

// Simple 2d pie slice for a given angle and radius. Aligning the opening with y.
module pieSlice_2d(angle, radius) {
  zrot(90) zrot((360 - angle) / 2) 
    projection() rotate_extrude(angle = angle) square(radius);
}

// Build a 2d arc. Optionaly round the end of the arc.
module arc_2d(outer_dia, inner_dia, angle, rounded = false) {
  difference() {
    pieSlice_2d(angle = angle, radius = outer_dia/2);
    circle(d = inner_dia);
  }
  
  if (rounded) {
    thickness = outer_dia - inner_dia;
    mirror_copy([1, 0, 0]) zrot(angle / 2) fwd(inner_dia/2 + thickness / 4) circle(r = thickness/4);
  }
}

module support2d(bubble, tire_dia, opening_angle, outside_dia, $fn=300) {
  difference() {
    union() {
      // The main clip, to hold the tire
      // The main body around the tire.
      arc_2d(outside_dia, tire_dia, 360 - opening_angle);
  
      // The two entry post, large to slide over the tire.
      hull() {
        small_r = (outside_dia - tire_dia) / 4  / 2 ;
        large_r = bubble / 3 * 2;
        zrot(8) left(tire_dia / 2 + small_r * 3) circle(r = small_r);
        left(bubble - large_r) zrot(opening_angle/2) back(tire_dia / 2 + bubble)
        circle(r = large_r);
      }
  
      a = (360 - opening_angle) / 2;
      // Finishing circle at the end of the clip
      open = 220;
      adjust = (open - 180) /2;
      zrot(a) fwd(tire_dia / 2 + bubble)
        zrot(90 - adjust) arc_2d(bubble*2, bubble, open, rounded = true); 
  
      zrot(-a) fwd(tire_dia / 2 + bubble)
        circle(bubble);

      // Flat support for the wall
      difference() { 
        fwd(tire_dia / 2) square([tire_dia * sin(60), tire_dia/3], center = true);
        circle(d = tire_dia);
      }
    }
    mirror_copy([1, 0, 0]) zrot((360 - opening_angle) / 2) fwd(tire_dia / 2 + bubble)
      circle(bubble/2);
  }
  
}

module bikestand(bubble = 9.5, tire_dia = 67, opening_angle = 93, outside_dia = 67+9.5, height = 25) {
  difference() {
      // Body of the support
      down(height / 2) linear_extrude(height = height)
        support2d(bubble = bubble, 
                  tire_dia = tire_dia,
                  opening_angle = opening_angle, 
                  outside_dia = outside_dia);
      // Screw hole
      mirror_copy([1, 0, 0]) left(18) xrot(90) cyl(d = 7, h = 50, $fn = 100, anchor = DOWN);
      //  Space for screw head
      mirror_copy([1, 0, 0]) left(18) xrot(90) cyl(d = 10, h = 35, $fn = 100, anchor = DOWN);
  }
}

//up(25) bikestand();
orange() bikestand(bubble=11, outside_dia = 67+ 11, opening_angle = 95);

//support2d();

