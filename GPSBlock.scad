// This is a comment

// Same as mirror() but duplicates the children as opposed to just move it.
module mirrored(v) {
	children();
	mirror(v = v) {
	  children();
	} 
}



module non_working_sample() {
	// Import the sample, recenter it and then rotate it to be in the way it is
	// going to be printed.
	rotate([-90,180, 90])
  translate([0,0,36.35])
	import("Montana600Dummy.stl");
}

module source_block(length, width, height) {
	translate([0, 0 , height/2])
  cube([length, width, height], center = true);
}


height = 28;
length = 71;
width = 54;

source_block(length, width, height);


//#non_working_sample();
