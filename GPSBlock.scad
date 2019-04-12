// This is a comment

// Same as mirror() but duplicates the children as opposed to just move it.
module mirrored(v) {
	children();
	mirror(v = v) {
	  children();
	} 
}

// Import the sample, recenter it and then rotate it to be in the way it is
// going to be printed.
module non_working_sample() {
	rotate([-90,180, 90])
  translate([0,0,36.35])
	import("Montana600Dummy.stl");
}

// This defines the profile of the block that is going to be carved, in 2D,
// viewed from the side. This is the hardest part of the model to get right.
//
// The way it is designed it is an oval mixed with a rectangle. The ratio, from
// 0 to 1 determines the amount of space used by the square, at 0, there is no
// square. at 1 it uses half the height.
module profile(length, height, ratio) {
	square_height = height / 2 * ratio;
	oval_height = height - square_height;
	
	union() {
		translate([0, height/4, 0])
		square([length, square_height], center = true);
	  #resize([length, oval_height])
      circle(100, $fn=100);
	}
}



module source_block(length, width, height) {
	translate([0, 0 , height/2])
    cube([length, width, height], center = true);
}

module clip_holes() {
}



height = 28;
length = 71;
width = 54;

profile(length, height, 1/$t);
//source_block(length, width, height);


//#non_working_sample();
