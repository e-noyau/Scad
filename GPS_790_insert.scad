// This build a support to be installed on a KTM 790 Adventure to replace the
// piece of plastic labelled "Remove for GPS mount". That piece only covers a
// hole without any space to actually install a GPS.

// This version is designed for metallic inserts. It needs six inserts, four
// for the AMPS pattern on top, two to secure the part to the bike.
use <noyau_utils.scad>;
use <triangles.scad>;

// This is the size of the insert hole for the AMPs pattern on top. Watch out
// for the depth, as anything longer may get accross the part completely.
amps_insert_radius = 5.9 / 2;
amps_insert_depth = 10;

// This is the size of the inserts to secure the part to the bike.
screw_hole_radius = 7 / 2;
screw_hole_depth = 10;

// Used to nudge the hole a bit to get it in perfect alignment.
screw_shift_down = 11; // Distance from the plane
screw_shift_forward = 0;

// The angle of the piece from the top of the hole. This is tha same angle as
// the original part shipped with the bike.
front_angle = 25;

// The AMPS format is 4 holes, and this defines the distance between the holes.
amps_large = 38;
amps_small = 30;

$fs = 1; // default is 2 and makes for squarish arcs.

// ----------------------------------------------------------------------------
// Base.
// ----------------------------------------------------------------------------
// These constants are defining the part of the piece in contact with the bike.
// the form is complex, it is not a simple square.
//
spline_length = 50.5;         // Size front to back, in the middle
petit_cote = 32.5 / 2;        // Width on the narrower side
petit_cote_notch = 1.5;       // Corner notches
petit_cote_full = 41.5 / 2;   // width on the wider side
grand_cote = 49 / 2;          //
grand_cote_slip = 1.5;

angle_grind = 1.5;

outer_front = 3.15;
outer_back = 3;

outer_side_front = 6;
outer_side_back = 9;

// The innerbase is what fits in the hole, snuggly, to hold everything in
// place. This returns the polygon to exactly fits that hole as close as
// possible.
module inner_base_2D() {
  // A polygon do do a side, mirrored for the other side.
  mirrored([1, 0, 0])
    polygon([
      [0, -spline_length / 2],
      [0, spline_length / 2],
      [petit_cote - angle_grind, spline_length / 2],
      [petit_cote, spline_length / 2 - petit_cote_notch],
      [petit_cote_full - angle_grind, spline_length / 2 - petit_cote_notch],
      [petit_cote_full , spline_length / 2 - petit_cote_notch -angle_grind],
      [grand_cote, -spline_length / 2 + grand_cote_slip + angle_grind],
      [grand_cote - angle_grind, -spline_length / 2 + grand_cote_slip]
    ]);
}

// This is the 3D extruded version of the above. With small indent in the back
// to leave space for the windshield plug.
module inner_base(height = 3, back_passage = true) {
  difference() {
    translate([0, 0, -3])
      linear_extrude(height) inner_base_2D();
    if (back_passage) {
      mirrored([1,0,0])
        translate([10.75, 23, -2.8])
          rotate([90,0,0])
            cube([8, 4 , 7], center = true);
    }
    
  }
}

// The outerbase covers the hole and hides the surface on top. It provides
// mechanical assurance that the object won't fall into the hole as well as
// making everything look nice and finished. The polygon returned here should
// exactly match the outside of the hole.
module outer_base_2D() {
  mirrored([1, 0, 0])
    polygon([
      [0, -spline_length / 2 - outer_front],
      [0, spline_length / 2 + outer_back],
      [petit_cote + outer_side_back, spline_length / 2 + outer_back],
      [grand_cote + outer_side_front,
             -spline_length / 2 + grand_cote_slip + angle_grind - outer_front],
      [grand_cote + outer_side_front - angle_grind,
             -spline_length / 2 + grand_cote_slip - outer_front]
    ]);
}

// This is the 3D extruded version of the above.
module outer_base(height = 30) {
  difference() {
    linear_extrude(height) outer_base_2D();
    mirrored([1, 0, 0])
    translate([petit_cote + 4.5, spline_length / 2 + outer_back,  0])
      cube([3, 3, 30], center = true);
  }
}

// This builds a rounded rectangle, rotate it to be at the right place, to be
// used as an intersection with the big square base to make something that
// looks nice. With a 25º angle on the front.
module shaper(top_radius = 6) {
  cube_l = (grand_cote + outer_side_front) * 2;
  cube_w = spline_length + outer_front + outer_back + 15;
  cube_h = 40;

  translate([0, 0, -7])
    rotate([front_angle, 0, 0])
      rotate([90, 0, 90])
        rounded_cube([cube_l, cube_h, cube_w], top_radius);
}

// ----------------------------------------------------------------------------
// Screw attachment.
// ----------------------------------------------------------------------------

screw_support_width = screw_hole_depth;
screw_support_height = 50;  // Something big, it is clipped anyway.

// This is an approximation as I am too lazy to do the math. If the support is
// moved forward or back this will need changing.
distance_from_spline = 22.6289;

// The best approximation of the side angle.
side_angle = 4.817;

// Moves and duplicates a children element at the right place for the screw
// support.
module screw_support_location() {
  rotate([0, 180, 0])
    mirrored([1, 0, 0])
     translate([-distance_from_spline, 
                screw_shift_forward,
                screw_hole_radius - 4 + screw_shift_down])
      rotate([0, 0, -side_angle])
        children();
}
/* Helps mesasure.
screw_support_location()
rotate([-front_angle, 0, 0])
translate([-2.5,21.3,-24.4])
#cube([5,24,9], center =true);
*/

// Assembles the full shape.
module top_shape() {
  intersection() {
    shaper();
    union() {
      outer_base(height = 30);
      inner_base();
    }
  }
}

// The full solid form by hollowing the main shape.
module shape() {
  inside_scale = .735;
  union () {
    difference() {
      top_shape();
      // Make a hole in the main part of the piece
      scale([inside_scale, inside_scale, inside_scale])
        top_shape();
      // Open the bottom a bit
      translate([0, 0, -3])
        scale([.90, .90, .90])
          inner_base(height = 6.7, back_passage = false);
    }
  }
}

// ----------------------------------------------------------------------------
// From here, this installs the inserts
// ----------------------------------------------------------------------------

// A model of the hole at the back of the piece to allow the cable to go in.
module cable_hole() {
  // Dig a hole for the cable
   translate([0, spline_length/2, 0])
      rotate([-45, 0, 0])
       rounded_cube([15, 15, 20], 5);
}

//----------------
// Insert builders
//----------------

// builds the solid shape in which a hole can be drilled for an insert. The
// expansion set the amount of plastic that will be around the hole. Note that
// there is an empty space at the bottom to collect the material that is going
// to melt in during installation.
// The receptacle could be optionaly open, for a through screw.
module insert_receptacle(depth, radius, expand = 1.65, open = false) {
    mirror([0, 0, 1]) union() {
      cylinder(depth, radius * expand , radius * expand);
      if (!open) {
        translate([0, 0, depth])
          sphere(radius * expand);
      }
    }
}

// Same as the above but with a support of support_height size.
module insert_receptacle_with_support(
    depth, radius, support_height, expand = 1.70, open = false) {
  insert_receptacle(depth, radius, expand, open);
  rotate([0,0,-90]) {
    translate([0, 0, -(depth+radius)/2]) rotate([-90, 0, 0])
      translate([0, 0, -support_height])
        linear_extrude(support_height) projection(cut=false)
          translate([0, 0, support_height]) rotate([90, 0, 0])
            translate([0, 0, (depth+radius)/2])
              insert_receptacle(depth, radius, expand, open);
  }
}

// Drill a hole in a receptacle for an insert. The radius is the radius of the
// insert, the reduction percentage controls the amount of plastic that will be
// displaced during install.
module insert_holes(depth, radius, reduction_percentage = .9) {
  inner_radius = radius * reduction_percentage;
  mirror([0, 0, 1]) union() {
    cylinder(depth, inner_radius, inner_radius);
    cylinder(depth * .1, radius * 1.1, radius * 1.1);
    translate([0, 0, depth]) sphere(inner_radius);
  }
}

// Position the AMPS inserts to the face of the piece.
module amps_inserts_location() {
  rotate([front_angle, 0, 0])
    translate([0, 0, 13.66])
      children();
}

// Duplicates the children 4 times in an AMPS pattern.
module amps_positioning(nudge_z = 0) {
  union() {
    translate([0, amps_small/2, 0])
      mirrored([1, 0, 0])
        translate([amps_large/2, 0, nudge_z])
          children();
    translate([0, -amps_small/2, 0])
      mirrored([1, 0, 0])
        translate([amps_large/2, 0, nudge_z])
          children();
    }
}

// Dig the holes in the shape. Note that the shaper is invoked again to clear
// the remnants of recpetacle sticking out.
module shape_with_holes(back_hole = true, amps_inserts = true) {
  difference() {
    intersection() {
      shaper();
      union() {
        shape();
        if (amps_inserts)
          amps_inserts_location()
            amps_positioning()
              insert_receptacle(amps_insert_depth, amps_insert_radius);
        screw_support_location() {
          rotate([0, -90, 0]) {
            insert_receptacle_with_support(
                 screw_hole_depth, screw_hole_radius, 30, open = true);
            translate([-4,0,0])
              rotate([0,180,-90])
                Triangle(25.5, spline_length -9, 34,
                         height = 2.25, centerXYZ = [true, true, false]);
          }
        }
      }
    }
    if (amps_inserts)
      amps_inserts_location()
        amps_positioning()
          insert_holes(amps_insert_depth, amps_insert_radius);
    screw_support_location()
      rotate([0, -90, 0]) translate([0, 0, 0.01])
        insert_holes(screw_hole_depth, screw_hole_radius);

    // Dig a hole for the cable
    if (back_hole)
      cable_hole();
  }
}

// Rotate everything to make it ready to print from bottom to top.
module ready_to_print() {
  translate([0,0,13.655])
  rotate([-25, 180, 0])
  shape_with_holes();
}

ready_to_print();
