// This build a support to be installed on a KTM 790 Adventure to replace the
// piece of plastic labelled "Remove for GPS mount". That piece only covers a
// hole without any space to actually install a GPS.

// This version is designed for metallic inserts. It needs six inserts, four
// for the AMPS pattern on top, two to secure the part to the bike.
use <noyau_utils.scad>;

// This is the size of the insert hole for the AMPs pattern on top. Watch out
// for the depth, as anything longer may get accross the part completely.
amps_insert_radius = 2.7;
amps_insert_depth = 6;

// This is the size of the inserts to secure the part to the bike.
screw_hole_radius = amps_insert_radius;
screw_hole_depth = amps_insert_depth;

// Used to nudge the hole a bit to get it in perfect alignment.
screw_shift_down = 2.2;
screw_shift_forward = -1;

// The angle of the piece from the top of the hole. This is tha same angle as
// the original part shipped with the bike.
front_angle = 25;

// The AMPS format is 4 holes, and this defines the distance between the holes.
amps_large = 38; 
amps_small = 30;

// ----------------------------------------------------------------------------
// Base.
// ----------------------------------------------------------------------------
// These constants are defining the part of the piece in contact with the bike.
// the form is complex, it is not a simple square.
//
spline_length = 50.5;
petit_cote = 32.5 / 2;
petit_cote_notch = 1.5;
petit_cote_full = 41.5 / 2;
grand_cote = 49 / 2;
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

// This is the 3D extruded version of the above.
module inner_base(height = 3) {
    translate([0,0,-3])
      linear_extrude(height) inner_base_2D();
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
      
      [grand_cote + outer_side_front, -spline_length / 2 + grand_cote_slip + angle_grind - outer_front],
      [grand_cote + outer_side_front - angle_grind, -spline_length / 2 + grand_cote_slip - outer_front]
    ]);
}

// This is the 3D extruded version of the above.
module outer_base(height = 30) {
  linear_extrude(height) outer_base_2D();
}

// This builds a rounded rectangle, rotate it to be at the right place, to be
// used as an intersection with the big square base to make something that
// looks nice. With a 25º angle on the front.
module shaper(top_radius = 6) {
  cube_l = (grand_cote + outer_side_front) * 2;
  cube_w = spline_length + outer_front + outer_back + 15;
  cube_h = 40;

  translate([0,0, -7])
    rotate([front_angle, 0, 0])
      rotate([90, 0, 90])
        rounded_cube([cube_l, cube_h, cube_w], top_radius);
}

// The full solid form without the bottom attachments.
module top_shape() {
  intersection() {
    shaper();  
  	union() {
	    outer_base(height = 30);
      inner_base();
	  }
  }
}

// ----------------------------------------------------------------------------
// Screw attachment.
// ----------------------------------------------------------------------------

screw_support_width = screw_hole_depth;
screw_support_length = 20;  // Those two are quite arbitrary.
screw_support_height = 23; 

// This is an approximation as I am too lazy to do the math. If the support is
// moved forward or back this will need changing.
distance_from_spline = 22.5789; 

// The best approximation of the side angle.
side_angle = 4.817;

// To nugde the angle doing the rounded corners.
nudge = 10;

// Moves and duplicates a children element at the right place for the screw
// support.
module screw_support_location() {
  rotate([0, 180, 0])
    mirrored([1, 0, 0])
     translate([-(distance_from_spline - screw_support_width/2) , 0, screw_support_height/2 -3])
      rotate([0, 0, -side_angle])
        children();
}

// A cornice to clean up the form by removing extra on the side and rounding
// the bottom.
module cleaning_screw_point() {
  union () {
    // Makes a rouded top.
  	mirrored([0,1,0])
  	  translate([0 , -screw_support_length/2, -screw_support_height + 3])
        rotate([0, 90, 0])
  	      rotate([0,0,90])
  	        rounded_edge(screw_support_length / 2, distance_from_spline * 3, extra = 0);
	
    // makes perfect sides. 
   	mirrored([0,1,0])
  		translate([0 , -screw_support_length/2-1.29, -screw_support_height/2+3])
  	    cube([distance_from_spline *3,3,screw_support_height+.001], center = true);
  }
}

// Build the two screw points, connect them with a big form.
module screw_point() {
	difference() {
		union() {
      screw_support_location() {
        rounded_cube([screw_support_width, screw_support_length, screw_support_height], 3);
      }
			translate([0 , -.2, -screw_support_height/2 +3])
			  rounded_cube([(distance_from_spline - screw_hole_depth)*2 + nudge, screw_support_length, screw_support_height], 3, center = true);
		}
    cleaning_screw_point();
	}
}

// Assembles the fulls shape by hollowing the inside.
module shape() {
  union () {
    difference() {
      top_shape();
      // Make a hole in the main part of the piece
      scale([.7,.7,.7])
        top_shape();
      // Open the bottom a bit 
      translate([0,0,-3])
        scale([.85,.85,.85])
          inner_base(height = 6.7);
    }
    // Add the screw support at the bottom.
    screw_point();
    amps_inserts_location()
      amps_inserts(radius = amps_insert_radius + 2, depth_nudge = -.001);
  }
}

// ----------------------------------------------------------------------------
// From here, this only digs holes for inserts
// ----------------------------------------------------------------------------

// The holes for the inserts on the side.
module screw_holes() {
  screw_support_location() {
    difference () {
  		translate([-(screw_support_width - screw_hole_depth)/2 -0.001, -screw_shift_forward, screw_shift_down])
  		  rotate([0,90,0])
  	      cylinder(screw_hole_depth + .01, screw_hole_radius, screw_hole_radius, center = true, $fn = 50);	
    }
  }
}

// A model of the hole at the back of the piece to allow the cable to go in.
module cable_hole() {
  // Dig a hole for the cable
   translate([0,spline_length/2,0])
      rotate([-45, 0, 0])
       rounded_cube([15, 15, 20], 5);
}

module amps_inserts_location() {
rotate([front_angle, 0, 0])
  translate([0, -3, 20])
    children();
}

// Two set of two inserts separated by the smaller AMPS size.
module amps_inserts(radius = amps_insert_radius, depth_nudge = 0) {
  translate([0, 3, -9.343]) union() {
    translate([0, amps_small/2, 0])
      mirrored([1,0,0])
        translate([amps_large/2, 0, 0])
          cylinder(amps_insert_depth + depth_nudge, radius , radius, center = true, $fn=100);
    translate([0, -amps_small/2, 0])
      mirrored([1,0,0])
        translate([amps_large/2, 0, 0])
          cylinder(amps_insert_depth + depth_nudge, radius, radius,center = true, $fn=100);
      }
}

// Dig the holes in the shape.
module shape_with_holes(back_hole = true) {
  difference() {
    shape();
    amps_inserts_location() {
        amps_inserts();
    }
    // Dig a hole for the cable
    if (back_hole)
      cable_hole();
    screw_holes();
  }
}

// Rotate everything to make it ready to print from bottom to top.
module ready_to_print() {
  translate([0,0,13.655])
  rotate([-25, 180, 0])
  shape_with_holes();
}

ready_to_print();

module test_inner() {
  difference() {
    final_shape();
    translate([0,0,35-.1])
       cube(70, 70, 70, center = true);
    translate([0,0,-35-5])
       cube(70, 70, 70, center = true);
  }
}

module test_outter() {
  difference() {
    final_shape(back_hole = true);
    translate([0,0,37])
       cube(70, 70, 70, center = true);
    translate([0,0,-35-3-.1])
       cube(70, 70, 70, center = true);
  }
}

module test_print() {
  translate([35, 0, 2])
  rotate([0, 180, 0])
    test_outter();
  translate([-35, 0, 0])
    rotate([0, 180, 0])
      test_inner();
}


module screw_test_print() {
  difference() {
    cube([10, 40, 3], center = true);
    rotate([180, 0, 0]) translate([0,0,3.9]){
      translate([0,-15,0])
        screw_hole(height = 11, hex_diameter = 6.2);
      translate([0,-7,0])
        screw_hole(height = 11, hex_diameter = 6.1);
      translate([0,1,0])
        screw_hole(height = 11, hex_diameter = 6.0);
      translate([0,8.5,0])
        screw_hole(height = 11, hex_diameter = 5.9);
      translate([0,16,0])
        screw_hole(height = 11, hex_diameter = 5.8);
    }
  }
}

module splitter() {
  translate([0,0,54]) cube([100, 100, 100], center = true);

}

module final_shape_bottom() {
  difference() {
    final_shape(back_hole = false);
    splitter();
  }
}
//screw_test_print();
//test_print();
//ready_to_print();
//final_shape_bottom();

//outside_shape();

//translate([23,0,12])
//rotate([front_angle, 0,side_angle])
//translate([0,2,1.5])
//#cube([24, 27, 12]);