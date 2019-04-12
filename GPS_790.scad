
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

module inner_base_2D() {
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
module inner_base() {
	translate([0,0,-3]) linear_extrude(3) inner_base_2D();
}

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
module outer_base() {
	linear_extrude(23) outer_base_2D();
}

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
	translate([0,0,12.8])
	rotate([-25, 180, 0])
  union() {
    inner_base();
		screw_point();
	  intersection() {
		  connector();
      outer_base();
	  }
  }
}

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


final();

