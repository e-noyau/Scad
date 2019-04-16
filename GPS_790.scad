// This build a support to be installed on a KTM 790 Adventure to replace the
// piece of plastic labelled "Remove for GPS mount". That piece only covers a
// hole without any space to actually install a GPS.


spline_length = 50.5;
petit_cote = 32.5 / 2;
petit_cote_notch = 1.5;
petit_cote_full = 41.5 / 2;
grand_cote = 49 / 2;
grand_cote_slip = 1.5;

angle_grind = 1.5;

outer_front = 3.15;
outer_back = 3;
outer_side = 6;

front_angle = 25;

amps_large = 38; // The AMPS format is 4 holes.
amps_small = 30;

// Same as mirror() but duplicates the children as opposed to just move it.
module mirrored(v) {
  union() {
    children();
    mirror(v = v)
      children();
  } 
}

// Build a negative rounded corner to soften a square angle.
module rounded_edge(radius, height) {
  translate([radius / 2, radius / 2, 0])
  difference() {
    cube([radius+.01, radius+.01, height + .01], center = true);
    translate([radius / 2, radius /2, 0])
      cylinder(r = radius, h = height + .02, center = true, $fn = 100);
  }
}

// Build a cube with the corners in the z plane softened.
module rounded_cube(v, radius) {
  difference() {
    cube(v, center=true);
    mirrored([0, 1, 0]) mirrored([1, 0, 0])
      translate([-v[0]/2,-v[1]/2,0])
        rounded_edge(radius, v[2]);
  }
}

module cylinder_outer(height,radius,fn){
  fudge = 1/cos(180/fn);
  cylinder(h = height,r = radius*fudge, $fn=fn, center = true);
}

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

// The innerbase is what fits in the hole, snuggly, to hold everything in
// place. This is the 3D extruded version.
module inner_base() {
  translate([0,0,-3]) linear_extrude(3) inner_base_2D();
}

// A complex way to buid the two attachements at the bottom of the piece where
// it will be bolted to the side of the hole. This is designed to be drilled on
// site, as it would require quite a bit of support to 3d print flat vertical
// surfaces with holes.  Those are also inset a bit to leave space for the
// metalic clips with captive nuts that are installed on the original cover.
module screw_point() {
  rotate([0, 180, 0])
  mirrored([1,0,0])
  translate([-16,0,8])
  rotate([0,0,-5])
  difference () {
   rounded_cube([10,20,16], 3);
   rounded_cube([8,18,16+1], 3);
   translate([5,0,0])
     cube([8.5,18,16+1], center = true);
   translate([0,0,11])
   rotate([0,-45,0])
     cube([8.5,22,25], center = true);
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
      [petit_cote + outer_side, spline_length / 2 + outer_back],
      
      [grand_cote + outer_side, -spline_length / 2 + grand_cote_slip + angle_grind - outer_front],
      [grand_cote + outer_side - angle_grind, -spline_length / 2 + grand_cote_slip - outer_front]
    ]);
}

// Just a square extrusion of the above.
module outer_base() {
  linear_extrude(23) outer_base_2D();
}

// This builds a rounded rectangle, rotate it to be at the right place, to be
// used as an intersection with the big square base to make something that
// looks nice. With a 25º angle on the front.
module shaper(top_radius = 6) {
  cube_l = (grand_cote + outer_side) * 2;
  cube_w = spline_length + outer_front + outer_back + 15;
  cube_h = 40;

  translate([0,0, -7])
    rotate([front_angle, 0, 0])
      rotate([90, 0, 90])
        rounded_cube([cube_l, cube_h, cube_w], top_radius);
}

// This assemble the whole shape, without any holes.
module outside_shape() {
  union() {
    inner_base();
    intersection() {
      shaper();
      outer_base();
    }
  }
}

// A model of the hole at the back of the piece to allow the cable to go in.
module cable_hole() {
  // Dig a hole for the cable
   translate([0,spline_length/2,0])
 	   rotate([-45, 0, 0])
       rounded_cube([15, 15, 60], 5);
}

// A simple screw hole, by design for 4mm screws with space for the bolt.
module screw_hole(height, diameter = 4.1, hex_diameter = 5.85, rotation = 0) {
  cylinder(height, diameter/2, diameter/2, center = true, $fn = 50);
  translate([0, 0, -height/4 - height/8]) rotate([0, 0, rotation])
    cylinder_outer(height = height/4, radius = hex_diameter/2, fn = 6);
}

// Two symetrical screws separated by the larger AMPS size.
module two_screws_amps(separation, height, rotation) {
  mirrored([1,0,0])
	translate([separation/2, 0, 0])
    screw_hole(height = height, rotation = rotation);
}

// Two set of two screws separated by the smaller AMPS size.
module four_amps_screws() {
	translate([0, amps_small/2, 0])
    two_screws_amps(separation = amps_large, height = 70, rotation = 36);
	translate([0, -amps_small/2, 0])
    two_screws_amps(separation = amps_large, height = 50, rotation = 36);
}

// Dig the holes in the shape.
module shape_with_holes() {
  difference() {
    outside_shape();
	  rotate([front_angle, 0, 0])
		  translate([0, -3, 20])
		    four_amps_screws();
    // Dig a hole for the cable
    cable_hole();
  }
}

// Adds the two attachments points to the final shape.
module final_shape() {
	shape_with_holes();
  screw_point();
}


// Rotate everything to make it ready to print from bottom to top.
module ready_to_print () {
  translate([0,0,12.8])
  rotate([-25, 180, 0])
	final_shape();
}

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
		final_shape();
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

/***
translate([0, 0, 1.5])
  screw_test_print();
***/
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

//screw_test_print();
//test_print();
ready_to_print();




