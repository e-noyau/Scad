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

outer_side_front = 6;
outer_side_back = 9;

front_angle = 25;

amps_large = 38; // The AMPS format is 4 holes.
amps_small = 30;

support_width = 10;
support_length = 20;
support_height = 15;
distance_from_spline = 16.5;
side_angle = 5;

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
  union() {
    screw_point();
    difference() {
      translate([0,0,-3])
        linear_extrude(3) inner_base_2D();
      screw_point_hole();
    }
  }
}

// A complex way to buid the two attachements at the bottom of the piece where
// it will be bolted to the side of the hole. This is designed to be drilled on
// site, as it would require quite a bit of support to 3d print flat vertical
// surfaces with holes.  Those are also inset a bit to leave space for the
// metalic clips with captive nuts that are installed on the original cover.
module screw_point() {
  rotate([0, 180, 0])
    mirrored([1, 0, 0])
     translate([-distance_from_spline, 0, support_height/2])
      rotate([0, 0, -side_angle])
        difference () {
          rounded_cube([support_width, support_length, support_height], 3);
          rounded_cube([support_width - 2.5, support_length - 3, support_height + 1], 3);
          translate([5,0,0])
            cube([support_width - 3, support_length - 3,support_height + 1], center = true);
   translate([0,0,11])
     rotate([0,-45,0])
       cube([support_width - 2, 22, 25], center = true);
  }  
}

module screw_point_hole() {
  rotate([0, 180, 0])
    mirrored([1, 0, 0])
     translate([-distance_from_spline -4, 0, support_height/2 - 4])
      rotate([0, 0, -side_angle])
        difference () {
          cube([10, support_length-4, support_height], 3, center = true);
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
      
      [grand_cote + outer_side_front, -spline_length / 2 + grand_cote_slip + angle_grind - outer_front],
      [grand_cote + outer_side_front - angle_grind, -spline_length / 2 + grand_cote_slip - outer_front]
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
  cube_l = (grand_cote + outer_side_front) * 2;
  cube_w = spline_length + outer_front + outer_back + 15;
  cube_h = 40;

  translate([0,0, -7])
    rotate([front_angle, 0, 0])
      rotate([90, 0, 90])
        rounded_cube([cube_l, cube_h, cube_w], top_radius);
}

module KTM_2D() {
  polygon([
		[0, 36.1],
		[11.79, 8.31],
		[27.85, 8.33],
		[23.33, 19.11],
		[36.8, 8.3],
		[47.8, 8.3],
		[34.65, 19.29],
		[42.26, 29.28],
		[51.89, 5.06],
		[29.02, 5.06],
		[30.86, 0],
		[92.8, 0],
		[91.35, 5.06],
		[68.27, 5.06],
		[61.76, 23.86],
		[77.28, 8.31],
		[91.51, 8.31],
		[89.25, 18.93],
		[101.21, 8.33],
		[116.05, 8.33],
		[109.9, 36.13],
		[95.15, 36.13],
		[96.69, 26.15],
		[85.42, 36.1],
		[71.73, 36.13],
		[73.52, 26.04],
		[62.72, 36.11],
		[27.78, 36.1],
		[20.28, 26.15],
		[16.21, 36.1],
		[0, 36.1],
  ]);
}

module KTM_3D() {
	translate([-23, 0, 14.2])
	rotate([-25, 0, 180]) 
	scale(.4)
	mirror()
  linear_extrude(2) KTM_2D();
}

// This assemble the whole shape, without any holes.
module outside_shape(logo) {
	difference() {
  union() {
    inner_base();
    intersection() {
      shaper();
      outer_base();
    }
  }
	if(logo)
		KTM_3D();
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
module screw_hole(height, diameter = 3.4, hex_diameter = 5.85, rotation = 0) {
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
module four_amps_screws(insert = true) {
  if (insert) {
    insert_radius = 2.7;
    insert_depth = 6;
    translate([0, 3, -9.343]) union() {
      translate([0, amps_small/2, 0])
        mirrored([1,0,0])
          translate([amps_large/2, 0, 0])
            cylinder(insert_depth, insert_radius , insert_radius, center = true, $fn=30);
      translate([0, -amps_small/2, 0])
        mirrored([1,0,0])
          translate([amps_large/2, 0, 0])
            cylinder(insert_depth, insert_radius, insert_radius,center = true, $fn=30);
        }
    } else {
    translate([0, amps_small/2, 0])
      two_screws_amps(separation = amps_large, height = 70, rotation = 36);
    translate([0, -amps_small/2, 0])
      two_screws_amps(separation = amps_large, height = 50, rotation = 36);
  }
}

// Dig the holes in the shape.
module shape_with_holes(logo, back_hole) {
  difference() {
    outside_shape(logo);
    rotate([front_angle, 0, 0])
      translate([0, -3, 20])
        four_amps_screws();
    // Dig a hole for the cable
    if (back_hole)
      cable_hole();
  }
}

// Adds the two attachments points to the final shape.
module final_shape(logo, back_hole = true) {
  shape_with_holes(logo, back_hole);
  screw_point();
}


// Rotate everything to make it ready to print from bottom to top.
module ready_to_print(logo = true) {
  translate([0,0,13.655])
  rotate([-25, 180, 0])
  final_shape(logo);
}

module test_inner() {
  difference() {
    final_shape(logo = false);
    translate([0,0,35-.1])
       cube(70, 70, 70, center = true);
    translate([0,0,-35-5])
       cube(70, 70, 70, center = true);
  }
}

module test_outter() {
  difference() {
    final_shape(logo = false, back_hole = true);
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
  translate([0,0,33]) cube([100, 100, 50], center = true);

}

module final_shape_bottom() {
  difference() {
    final_shape(back_hole = false);
    splitter();
  }
}
//screw_test_print();
//test_print();
//ready_to_print(logo = false);
final_shape_bottom();

