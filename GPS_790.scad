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
// it will be bolted to the side of the hole. This is designed to be drilled on site, as it would
// require quite a bit of support to 3d print flat vertical surfaces with holes.
// Those are also inset a bit to leave space for the metalic clips with captive
// nuts that are installed on the original cover.
module screw_point() {
	rotate([0, 180, 0])
	mirrored([1,0,0])
	translate([-17,0,8])
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
// looks nice. and with a 25º angle on the front.
module connector() {
	cube_l = (grand_cote + outer_side) * 2;
	cube_w = spline_length + outer_front + outer_back + 15;
	cube_h = 40;

	translate([0,0, -8])
	rotate([25, 0, 0])
  rotate([90, 0, 90])
  rounded_cube([cube_l, cube_h, cube_w], 7);
}

module final() {
	difference() {
	translate([0,0,12.8])
	rotate([-25, 180, 0])
	  union() {
	    inner_base();
		  intersection() {
			  connector();
	      outer_base();
		  }
		}
		screw_holes();
		// Dig a hole for the cable
		translate([0,30,20])
		    rotate([80, 0, 0])
		      rounded_cube([15, 15, 60], 5);
		//#cylinder(100, 7, 7, center = true);
  }
	translate([0,0,12.8])
	rotate([-25, 180, 0])
	
	screw_point();
	
}


amps_large = 38; // The AMPS format is 4 holes.
amps_small = 30;

module cylinder_outer(height,radius,fn){
  fudge = 1/cos(180/fn);
  cylinder(h=height,r=radius*fudge,$fn=fn);}

module screw_holes(height = 50, diameter = 5.5) {
	mirrored([1,0,0])
	mirrored([0,1,0])
	translate([amps_large/2, amps_small/2, 0]) {
  cylinder(height, diameter/2, diameter/2, center = true, $fn = 50);
	translate([0,0,7]) rotate([0,0, 39])
    cylinder_outer(height/2, 7.2/2, 6, center = true);
}
}


module test_print() {
	difference() {
	  union() {
	    inner_base();
	    linear_extrude(3) outer_base_2D();
  	}
		translate([0,-5,-3])
	  #screw_holes(20, 5);
	}

}

//test_print();
final();

